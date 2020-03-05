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
    @IBOutlet weak var navigationTitle: UILabel!
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
    @IBOutlet weak var informationTitle: UILabel!
    @IBOutlet weak var informationContent: UILabel!
    
    var presenter: DashboardPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationItems()
        
        view.backgroundColor = backgroundColor
        
        titleLabel.text = localize("summary_auction")
        
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
        
        completedAuctionTitleLabel.text = localize("completed_auction")
        completedAuctionLabel.textColor = redColor
        completedAuctionUnitLabel.textColor = redColor
        ongoingAuctionTitleLabel.text = localize("ongoing_auction")
        ongoingAuctionLabel.textColor = redColor
        ongoingAuctionUnitLabel.textColor = redColor
        needConfirmationTitleLabel.text = localize("need_confirmation")
        needConfirmationLabel.textColor = redColor
        needConfirmationUnitLabel.textColor = redColor
        
        let screenWidth = UIScreen.main.bounds.width
        ongoingAuctionWidth.constant = (screenWidth / 2) - 30
        needConfirmationWidth.constant = (screenWidth / 2) - 30
        
        informationTitle.textColor = primaryColor
        
        presenter = DashboardPresenter(delegate: self)
        presenter.getData()
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
        navigationView.backgroundColor = primaryColor
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        navigationTitle.textColor = .white
        navigationTitle.font = UIFont.systemFont(ofSize: 16)
        navigationTitle.text = localize("home").uppercased()
        
        let notificationButton = UIButton(type: UIButton.ButtonType.custom)
        notificationButton.setImage(UIImage(named: "notification"), for: .normal)
        notificationButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //notificationButton.frame = buttonFrame
        //notificationButton.addTarget(self, action: #selector(showNotification), for: .touchUpInside)
    }
}

extension DashboardViewController: DashboardDelegate {
    func setData(_ data: [String : Any?]) {
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
            informationContent.text = localize("please_update_best_rate")
        } else {
            informationContent.text = localize("no_information_at_the_moment")
        }
    }
}
