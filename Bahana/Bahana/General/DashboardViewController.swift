//
//  DashboardViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/05.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationItems()
        
        view.backgroundColor = backgroundColor
        
        titleLabel.text = "SUMMARY AUCTION"
        
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
        
        completedAuctionTitleLabel.text = "COMPLETED AUCTION"
        completedAuctionLabel.textColor = redColor
        completedAuctionUnitLabel.textColor = redColor
        ongoingAuctionTitleLabel.text = "ONGOING AUCTION"
        ongoingAuctionLabel.textColor = redColor
        ongoingAuctionUnitLabel.textColor = redColor
        needConfirmationTitleLabel.text = "NEED CONFIRMATION"
        needConfirmationLabel.textColor = redColor
        needConfirmationUnitLabel.textColor = redColor
        
        let screenWidth = UIScreen.main.bounds.width
        ongoingAuctionWidth.constant = (screenWidth / 2) - 30
        needConfirmationWidth.constant = (screenWidth / 2) - 30
        
        setContent()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setNavigationItems() {
        //self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = primaryColor
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let label = UILabel()
        label.text = "HOME"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        navigationItem.title = "aa"
        let titleBar = UIBarButtonItem.init(customView: label)
        self.navigationController?.navigationItem.title = "HOME"
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.setLeftBarButton(titleBar, animated: true)
        
        let notificationButton = UIButton(type: UIButton.ButtonType.custom)
        //closeButton.setImage(UIImage(named: "icon_back_white"), for: .normal)
        notificationButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //closeButton.frame = buttonFrame
        //closeButton.addTarget(self, action: #selector(showAlertExit), for: .touchUpInside)
        let notificationBarButton = UIBarButtonItem(customView: notificationButton)
        //navigationItem.setHidesBackButton(true, animated: false)
        
        //navigationItem.rightBarButtonItem = notificationBarButton
    }

    func setContent() {
        completedAuctionLabel.text = "46"
        completedAuctionUnitLabel.text = "Auctions"
        ongoingAuctionLabel.text = "1"
        ongoingAuctionUnitLabel.text = "Auction"
        needConfirmationLabel.text = "0"
        needConfirmationUnitLabel.text = "Auction"
    }
}
