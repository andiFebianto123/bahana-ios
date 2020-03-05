//
//  AuctionDetailBreakViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/25.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionDetailBreakViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var auctionEndLabel: UILabel!
    @IBOutlet weak var portfolioView: UIView!
    @IBOutlet weak var fundNameLabel: UILabel!
    @IBOutlet weak var custodianBankLabel: UILabel!
    @IBOutlet weak var picCustodianLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var tenorLabel: UILabel!
    @IBOutlet weak var interestRateLabel: UILabel!
    @IBOutlet weak var breakRateLabel: UILabel!
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var breakDateLabel: UILabel!
    @IBOutlet weak var policyView: UIView!
    @IBOutlet weak var breakablePolicyLabel: UILabel!
    @IBOutlet weak var policyNoteLabel: UILabel!
    @IBOutlet weak var breakRateStackView: UIStackView!
    @IBOutlet weak var breakRateTitleLabel: UILabel!
    @IBOutlet weak var breakRateTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var presenter: AuctionDetailBreakPresenter!
    
    var id = Int()
    var data: AuctionDetailBreak!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.textColor = primaryColor
        auctionEndLabel.textColor = primaryColor
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
        policyView.backgroundColor = cardBackgroundColor
        policyView.layer.cornerRadius = 5
        policyView.layer.shadowColor = UIColor.gray.cgColor
        policyView.layer.shadowOffset = CGSize(width: 0, height: 0)
        policyView.layer.shadowRadius = 4
        policyView.layer.shadowOpacity = 0.5
        submitButton.backgroundColor = primaryColor
        
        presenter = AuctionDetailBreakPresenter(delegate: self)
        presenter.getAuction(id)
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
        fundNameLabel.text = data.portfolio
        custodianBankLabel.text = data.custodian_bank != nil ? data.custodian_bank : "-"
        picCustodianLabel.text = data.pic_custodian != nil ? data.pic_custodian : "-"
        
        // Detail
        tenorLabel.text = data.period
        //interestRateLabel.text = data.interest_rate
        //breakRateLabel.text = data
        //investmentLabel.text
        
        // Policy
        breakablePolicyLabel.text = data.breakable_policy
        policyNoteLabel.text = data.policy_notes
        
        // Action
        if data.view == 0 {
            breakRateStackView.isHidden = true
        } else if data.view == 1 {
            breakRateTitleLabel.isHidden = true
            breakRateTextField.isHidden = true
            submitButton.isHidden = true
        } else if data.view == 2 {
            confirmButton.isHidden = true
        }
    }
}

extension AuctionDetailBreakViewController: AuctionDetailBreakDelegate {
    func setData(_ data: AuctionDetailBreak) {
        self.data = data
        setContent()
    }
}
