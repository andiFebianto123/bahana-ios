//
//  DashboardViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/05.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var completedAuctionView: UIView!
    @IBOutlet weak var completedAuctionTitleLabel: UILabel!
    @IBOutlet weak var completedAuctionLabel: UILabel!
    @IBOutlet weak var completedAuctionUnitLabel: UILabel!
    @IBOutlet weak var ongoingAuctionView: UIView!
    @IBOutlet weak var ongoingAuctionWidth: NSLayoutConstraint!
    @IBOutlet weak var ongoingAuctionTitleLabel: UILabel!
    @IBOutlet weak var ongoingAuctionLabel: UILabel!
    @IBOutlet weak var ongoingAuctionUnitLabel: UILabel!
    @IBOutlet weak var needConfirmationView: UIView!
    @IBOutlet weak var needConfirmationWidth: NSLayoutConstraint!
    @IBOutlet weak var needConfirmationTitleLabel: UILabel!
    @IBOutlet weak var needConfirmationLabel: UILabel!
    @IBOutlet weak var needConfirmationUnitLabel: UILabel!
    @IBOutlet weak var informationTitle: UILabel!
    @IBOutlet weak var informationContentView: UIView!
    @IBOutlet weak var informationContent: UILabel!
    
    var loadingView = UIView()
    
    var presenter: DashboardPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationItems()
        setViewText()
        
        view.backgroundColor = backgroundColor
        
        // Set loading view
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
        
        let spinner = UIActivityIndicatorView()
        spinner.color = .black
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinner.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
        
        completedAuctionView.layer.cornerRadius = 5
        completedAuctionView.layer.shadowColor = UIColor.gray.cgColor
        completedAuctionView.layer.shadowOffset = CGSize(width: 0, height: 0)
        completedAuctionView.layer.shadowRadius = 4
        completedAuctionView.layer.shadowOpacity = 0.5
        
        ongoingAuctionView.backgroundColor = UIColorFromHex(rgbValue: 0xfee2e1)
        ongoingAuctionView.layer.cornerRadius = 5
        ongoingAuctionView.layer.shadowColor = UIColor.gray.cgColor
        ongoingAuctionView.layer.shadowOffset = CGSize(width: 0, height: 0)
        ongoingAuctionView.layer.shadowRadius = 4
        ongoingAuctionView.layer.shadowOpacity = 0.5
        
        needConfirmationView.backgroundColor = UIColorFromHex(rgbValue: 0xfee2e1)
        needConfirmationView.layer.cornerRadius = 5
        needConfirmationView.layer.shadowColor = UIColor.gray.cgColor
        needConfirmationView.layer.shadowOffset = CGSize(width: 0, height: 0)
        needConfirmationView.layer.shadowRadius = 4
        needConfirmationView.layer.shadowOpacity = 0.5
        
        let redColor = UIColor.red
        
        completedAuctionLabel.textColor = redColor
        completedAuctionUnitLabel.textColor = redColor
        ongoingAuctionLabel.textColor = redColor
        ongoingAuctionUnitLabel.textColor = redColor
        needConfirmationLabel.textColor = redColor
        needConfirmationUnitLabel.textColor = redColor
        
        let screenWidth = UIScreen.main.bounds.width
        ongoingAuctionWidth.constant = (screenWidth / 2) - 30
        needConfirmationWidth.constant = (screenWidth / 2) - 30
        
        informationTitle.textColor = primaryColor
        
        presenter = DashboardPresenter(delegate: self)
        presenter.getData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: Notification.Name("LanguageChanged"), object: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showBestRate" {
            if let navigation = segue.destination as? UINavigationController {
                if let destinationVC = navigation.topViewController as? RegisterViewController {
                    destinationVC.viewTo = "best_rate"
                }
            }
        }
    }
    
    func setNavigationItems() {
        navigationView.backgroundColor = primaryColor
        navigationViewHeight.constant = getNavigationHeight()
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        navigationTitle.textColor = .white
        navigationTitle.font = UIFont.systemFont(ofSize: 16)
        navigationTitle.text = localize("home").uppercased()
        
        // Set badge notification
        let badgeView = UIView()
        badgeView.backgroundColor = .lightGray
        badgeView.layer.cornerRadius = 6
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        notificationView.addSubview(badgeView)
        
        let badgeLabel = UILabel()
        getUnreadNotificationCount() { count in
            if count > 99 {
                badgeLabel.text = "99+"
            } else {
                badgeLabel.text = "\(count)"
            }
        }
        badgeLabel.font = UIFont.systemFont(ofSize: 8)
        badgeLabel.textColor = .white
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeView.addSubview(badgeLabel)
        
        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(equalTo: notificationView.topAnchor, constant: 0),
            badgeView.trailingAnchor.constraint(equalTo: notificationView.trailingAnchor, constant: -2),
            badgeView.heightAnchor.constraint(equalToConstant: 14),
            badgeView.widthAnchor.constraint(equalToConstant: 22),
            badgeLabel.centerXAnchor.constraint(equalTo: badgeView.centerXAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor),
        ])
        
        notificationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showNotification)))
    }
    
    func setViewText() {
        titleLabel.text = localize("summary_auction")
        completedAuctionTitleLabel.text = localize("completed_auction")
        ongoingAuctionTitleLabel.text = localize("ongoing_auction")
        needConfirmationTitleLabel.text = localize("need_confirmation")
        informationTitle.text = localize("information")
    }
    
    func showLoading(_ show: Bool) {
        if show {
            loadingView.isHidden = false
        } else {
            loadingView.isHidden = true
        }
    }
    
    @objc func showNotification() {
        performSegue(withIdentifier: "showNotification", sender: self)
    }
    
    @objc func showBestRate() {
        performSegue(withIdentifier: "showBestRate", sender: self)
    }
    
    @objc func languageChanged() {
        setNavigationItems()
        setViewText()
    }
}

extension DashboardViewController: DashboardDelegate {
    func setData(_ data: [String : Any?]) {
        showLoading(false)
        completedAuctionLabel.text = "\(data["completed"]! as! Int)"
        if data["completed"]! as! Int > 1 {
            completedAuctionUnitLabel.text = "Auctions"
        } else {
            completedAuctionUnitLabel.text = "Auction"
        }
        ongoingAuctionLabel.text = "\(data["ongoing"]! as! Int)"
        if data["ongoing"]! as! Int > 1 {
            ongoingAuctionUnitLabel.text = "Auctions"
        } else {
            ongoingAuctionUnitLabel.text = "Auction"
        }
        needConfirmationLabel.text = "\(data["confirmation"]! as! Int)"
        if data["confirmation"]! as! Int > 1 {
            needConfirmationUnitLabel.text = "Auctions"
        } else {
            needConfirmationUnitLabel.text = "Auction"
        }
        
        let info = data["info_base_placement"]! as! Bool
        if info {
            informationContentView.backgroundColor = UIColor.white
            informationContent.text = localize("please_update_best_rate")
            informationContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showBestRate)))
        } else {
            informationContentView.backgroundColor = backgroundColor
            informationContent.text = localize("no_information_at_the_moment")
        }
    }
}
