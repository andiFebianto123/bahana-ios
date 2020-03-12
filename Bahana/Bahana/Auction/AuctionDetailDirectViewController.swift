//
//  AuctionDetailDirectViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/25.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionDetailDirectViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var auctionEndLabel: UILabel!
    @IBOutlet weak var portfolioView: UIView!
    @IBOutlet weak var fundNameLabel: UILabel!
    @IBOutlet weak var custodianBankLabel: UILabel!
    @IBOutlet weak var picCustodianLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var tenorLabel: UILabel!
    @IBOutlet weak var interestRateLabel: UILabel!
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var bilyetLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var revisionRateStackView: UIStackView!
    @IBOutlet weak var revisionRateTitleLabel: UILabel!
    @IBOutlet weak var revisionRateTextField: UITextField!
    @IBOutlet weak var revisedButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var presenter: AuctionDetailDirectPresenter!
    
    var id = Int()
    var data: AuctionDetailDirect!
    
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
        revisedButton.backgroundColor = primaryColor
        confirmButton.backgroundColor = UIColorFromHex(rgbValue: 0x2a91ff)
        
        presenter = AuctionDetailDirectPresenter(delegate: self)
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
        custodianBankLabel.text = data.custodian_bank
        picCustodianLabel.text = data.pic_custodian
        
        // Detail
        //tenorLabel.text = data.
        //interestRateLabel.text = data.interest_rate
        //investmentLabel.text = data
        var bilyet = """
        """
        for bilyetArr in data.bilyet {
            bilyet += "- \(bilyetArr.quantity) [\(bilyetArr.issue_date) - \(bilyetArr.maturity_date)]\n"
        }
        bilyetLabel.text = bilyet
        noteLabel.text = data.notes
        
        // Action
        if data.view == 0 {
            revisionRateStackView.isHidden = true
        } else if data.view == 1 {
            revisionRateTitleLabel.isHidden = true
            revisionRateTextField.isHidden = true
            revisedButton.isHidden = true
        } else if data.view == 2 {
            confirmButton.isHidden = true
        }
    }
    
    func setCountDownTimer() {
        
    }
    
    @IBAction func reviseButtonPressed(_ sender: Any) {
        //presenter.reviseAuction(id)
    }
    
    @IBAction func confirmationButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("AuctionDetailConfirmation"), object: nil, userInfo: ["date": data.end_date])
    }
    
}

extension AuctionDetailDirectViewController: AuctionDetailDirectDelegate {
    func setData(_ data: AuctionDetailDirect) {
        self.data = data
        setContent()
    }
}
