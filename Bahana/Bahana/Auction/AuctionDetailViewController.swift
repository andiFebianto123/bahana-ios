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
    var revisionRate: String?
    var confirmationType: String!
    var confirmationID: Int!
    
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
            loadingView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
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
        NotificationCenter.default.addObserver(self, selector: #selector(showConfirmation(notification:)), name: Notification.Name("AuctionDetailConfirmation"), object: nil)
        
        // Open login page
        NotificationCenter.default.addObserver(self, selector: #selector(openLoginPage), name: Notification.Name("AuctionDetailLogin"), object: nil)
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
                destinationVC.confirmationType = confirmationType
                destinationVC.revisionRate = revisionRate
                destinationVC.id = confirmationID
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
    
    @objc func showConfirmation(notification: Notification) {
        if let userInfo = notification.userInfo as? [String: [String: String]] {
            let data = userInfo["data"]
            if data!["type"] != nil {
                confirmationType = data!["type"]!
                if data!["revisionRate"] != nil {
                    revisionRate = data!["revisionRate"]!
                }
                if data!["id"] != nil {
                    confirmationID = Int(data!["id"]!)
                }
                
                self.performSegue(withIdentifier: "showConfirmation", sender: self)
            }
        }
    }
    
    @IBAction func unwindToDetail( _ seg: UIStoryboardSegue) {
        NotificationCenter.default.post(name: Notification.Name("AuctionDetailRefresh"), object: nil, userInfo: nil)
    }
    
    @objc func showValidationAlert(notification: Notification) {
        if let userInfo = notification.userInfo as? [String: [String: String]] {
            let data = userInfo["data"]
            let message = data!["message"]!
            var isBackToList: Bool = false
            if data!["isBackToList"] != nil && data!["isBackToList"] == "true" {
                isBackToList = true
            }
            showAlert(title: localize("information"), message: message, isBackToList)
        }
    }
    
    @objc func openLoginPage() {
        let authStoryboard : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginViewController : UIViewController = authStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, _ isBackToList: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: { action in
            if isBackToList {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AuctionDetailViewController: AuctionDetailDelegate {
    //
}
