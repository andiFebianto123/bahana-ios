//
//  AuctionDetailViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/05.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionDetailViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationBackView: UIView!
    @IBOutlet weak var navigationBackImageView: UIImageView!
    @IBOutlet weak var navigationTitle: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    var loadingView = UIView()
    
    var presenter: AuctionDetailPresenter!
    
    var auctionID: Int!
    var auctionType: String!
    var auctionRequestMaturityDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationItems()
        
        view.backgroundColor = backgroundColor
        
        let auctionStoryboard : UIStoryboard = UIStoryboard(name: "Auction", bundle: nil)
        switch auctionType {
        case "auction":
            let viewController = auctionStoryboard.instantiateViewController(withIdentifier: "AuctionDetailNormal") as! AuctionDetailNormalViewController
            viewController.id = self.auctionID
            containerViewHeight.constant = 1000
            viewController.currentHeight = containerViewHeight.constant
            containerView.addSubview(viewController.view)
            viewController.view.frame = containerView.bounds
        case "direct-auction":
            let viewController = auctionStoryboard.instantiateViewController(withIdentifier: "AuctionDetailDirect") as! AuctionDetailDirectViewController
            viewController.id = self.auctionID
            containerView.addSubview(viewController.view)
            viewController.view.frame = containerView.bounds
        case "break":
            let viewController = auctionStoryboard.instantiateViewController(withIdentifier: "AuctionDetailBreak") as! AuctionDetailBreakViewController
            viewController.id = self.auctionID
            containerView.addSubview(viewController.view)
            viewController.view.frame = containerView.bounds
        case "rollover":
            let viewController = auctionStoryboard.instantiateViewController(withIdentifier: "AuctionDetailRollover") as! AuctionDetailRolloverViewController
            viewController.id = self.auctionID
            containerView.addSubview(viewController.view)
            viewController.view.frame = containerView.bounds
        case "mature":
            let viewController = auctionStoryboard.instantiateViewController(withIdentifier: "AuctionDetailMature") as! AuctionDetailMatureViewController
            viewController.id = self.auctionID
            containerView.addSubview(viewController.view)
            viewController.view.frame = containerView.bounds
        default:
            break
        }
        
        // Set loading view
        //loadingView.isHidden = true
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
        
        presenter = AuctionDetailPresenter(delegate: self)
        
        setupToHideKeyboardOnTapOnView()
        
        // Show/hide loading
        NotificationCenter.default.addObserver(self, selector: #selector(showLoading(notification:)), name: Notification.Name("AuctionDetailLoading"), object: nil)
        
        // View height
        NotificationCenter.default.addObserver(self, selector: #selector(setHeight(notification:)), name: Notification.Name("AuctionDetailHeight"), object: nil)
        
        // Validation alert
        NotificationCenter.default.addObserver(self, selector: #selector(showValidationAlert(notification:)), name: Notification.Name("AuctionDetailAlert"), object: nil)
        
        // Confirmation button pressed
        NotificationCenter.default.addObserver(self, selector: #selector(showConfimation(notification:)), name: Notification.Name("AuctionDetailConfirmation"), object: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showConfirmation" {
            if let destinationVC = segue.destination as? AuctionDetailConfirmationViewController {
                destinationVC.auctionID = auctionID
                destinationVC.auctionType = auctionType
                destinationVC.auctionRequestMaturityDate = auctionRequestMaturityDate
            }
        }
    }
    
    func setNavigationItems() {
        //navigationBar.barTintColor = UIColor.red
        //navigationController?.navigationBar.barTintColor = primaryColor
        navigationView.backgroundColor = primaryColor
        navigationViewHeight.constant = getNavigationHeight()
        navigationTitle.text = localize("auction_detail").uppercased()
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backButtonPressed))
        navigationBackImageView.image = UIImage(named: "icon_left")
        navigationBackView.addGestureRecognizer(backTap)
    }

    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
        //
    }
    
    @objc func showLoading(notification: Notification) {
        if let data = notification.userInfo as? [String: Bool] {
            let isShow = data["isShow"]!
            loadingView.isHidden = !isShow
        }
    }
    
    @objc func setHeight(notification: Notification) {
        if let data = notification.userInfo as? [String: CGFloat] {
            let height = data["height"]!
            containerViewHeight.constant = height
            view.layoutIfNeeded()
        }
    }
    
    @objc func showConfimation(notification: Notification) {
        if let data = notification.userInfo as? [String: String] {
            let date = data["date"]
            if date != "" {
                auctionRequestMaturityDate = date
            }
            
            self.performSegue(withIdentifier: "showConfirmation", sender: self)
        }
    }
    
    @objc func showValidationAlert(notification: Notification) {
        if let data = notification.userInfo as? [String: String] {
            let message = data["message"]!
            showAlert(title: localize("information"), message: message)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AuctionDetailViewController: AuctionDetailDelegate {
    //
}
