//
//  AuctionDetailRolloverViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/25.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionDetailRolloverViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var auctionEndLabel: UILabel!
    @IBOutlet weak var portfolioView: UIView!
    @IBOutlet weak var fundNameLabel: UILabel!
    @IBOutlet weak var custodianBankLabel: UILabel!
    @IBOutlet weak var picCustodianLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var tenorLabel: UILabel!
    @IBOutlet weak var previousInterestRateLabel: UILabel!
    @IBOutlet weak var newInterestRateLabel: UILabel!
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var previousPeriodLabel: UILabel!
    @IBOutlet weak var newPeriodLabel: UILabel!
    @IBOutlet weak var interestRateStackView: UIStackView!
    @IBOutlet weak var interestRateTitleLabel: UILabel!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var presenter: AuctionDetailRolloverPresenter!
    
    var id = Int()
    var data: AuctionDetailRollover!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.textColor = primaryColor
        let cardBackgroundColor = UIColorFromHex(rgbValue: 0xffe0e0)
        portfolioView.backgroundColor = cardBackgroundColor
        portfolioView.layer.cornerRadius = 5
        portfolioView.layer.shadowColor = UIColor.gray.cgColor
        portfolioView.layer.shadowOffset = CGSize(width: 0, height: 0)
        portfolioView.layer.shadowRadius = 4
        portfolioView.layer.shadowOpacity = 0.5
        detailView.backgroundColor = cardBackgroundColor
        detailView.layer.cornerRadius = 5
        detailView.layer.shadowColor = UIColor.gray.cgColor
        detailView.layer.shadowOffset = CGSize(width: 0, height: 0)
        detailView.layer.shadowRadius = 4
        detailView.layer.shadowOpacity = 0.5
        submitButton.backgroundColor = primaryColor
        
        presenter = AuctionDetailRolloverPresenter(delegate: self)
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

    func setContent() {
        // Check status
        if data.status == "-" {
            
        }
        
        if convertStringToDatetime(data.end_date)! > Date() {
            auctionEndLabel.text = "Ends in: \(calculateDateDifference(Date(), convertStringToDatetime(data.end_date)!))"
        } else {
            auctionEndLabel.isHidden = true
        }
        
        // Portfolio
        /*fundNameLabel.text = data.portfolio
        custodianBankLabel.text = data.custodian_bank
        picCustodianLabel.text = data.pic_custodian*/
        
        // Detail
        //tenorLabel.text = data.
        //interestRateLabel.text = data.interest_rate
        //breakRateLabel.text = data
        //investmentLabel.text
        
        // Action
        if data.view == 0 {
            interestRateStackView.isHidden = true
        } else if data.view == 1 {
            interestRateTitleLabel.isHidden = true
            interestRateTextField.isHidden = true
            submitButton.isHidden = true
        } else if data.view == 2 {
            confirmButton.isHidden = true
        }
    }
}

extension AuctionDetailRolloverViewController: AuctionDetailRolloverDelegate {
    func setData(_ data: AuctionDetailRollover) {
        self.data = data
        setContent()
    }
}
