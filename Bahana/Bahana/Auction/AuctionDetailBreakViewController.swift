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
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusViewWidth: NSLayoutConstraint!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var portfolioView: UIView!
    @IBOutlet weak var fundNameTitleLabel: UILabel!
    @IBOutlet weak var fundNameLabel: UILabel!
    @IBOutlet weak var custodianBankTitleLabel: UILabel!
    @IBOutlet weak var custodianBankLabel: UILabel!
    @IBOutlet weak var picCustodianTitleLabel: UILabel!
    @IBOutlet weak var picCustodianLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var tenorTitleLabel: UILabel!
    @IBOutlet weak var tenorLabel: UILabel!
    @IBOutlet weak var interestRateTitleLabel: UILabel!
    @IBOutlet weak var interestRateLabel: UILabel!
    @IBOutlet weak var breakRateTitleLabel: UILabel!
    @IBOutlet weak var breakRateLabel: UILabel!
    @IBOutlet weak var investmentTitleLabel: UILabel!
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var periodTitleLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var breakDateTitleLabel: UILabel!
    @IBOutlet weak var breakDateLabel: UILabel!
    @IBOutlet weak var policyView: UIView!
    @IBOutlet weak var policyTitleLabel: UILabel!
    @IBOutlet weak var breakablePolicyTitleLabel: UILabel!
    @IBOutlet weak var breakablePolicyLabel: UILabel!
    @IBOutlet weak var policyNoteTitleLabel: UILabel!
    @IBOutlet weak var policyNoteLabel: UILabel!
    @IBOutlet weak var breakRateStackView: UIStackView!
    @IBOutlet weak var breakRateTitle2Label: UILabel!
    @IBOutlet weak var breakRateTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var footerLabel: UILabel!
    
    var presenter: AuctionDetailBreakPresenter!
    
    var id = Int()
    var data: AuctionDetailBreak!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let titleFont = UIFont.systemFont(ofSize: 11)
        let contentFont = UIFont.boldSystemFont(ofSize: 12)
        
        titleLabel.text = localize("break").uppercased()
        titleLabel.textColor = primaryColor
        //auctionEndLabel.font = UIFont.boldSystemFont(ofSize: 14)
        statusView.layer.cornerRadius = 10
        let cardBackgroundColor = lightRedColor
        portfolioView.backgroundColor = cardBackgroundColor
        portfolioView.layer.cornerRadius = 5
        portfolioView.layer.shadowColor = UIColor.gray.cgColor
        portfolioView.layer.shadowOffset = CGSize(width: 0, height: 0)
        portfolioView.layer.shadowRadius = 4
        portfolioView.layer.shadowOpacity = 0.5
        fundNameTitleLabel.font = titleFont
        fundNameTitleLabel.textColor = titleLabelColor
        fundNameTitleLabel.text = localize("fund_name")
        fundNameLabel.font = contentFont
        custodianBankTitleLabel.font = titleFont
        custodianBankTitleLabel.textColor = titleLabelColor
        custodianBankTitleLabel.text = localize("custodian_bank")
        custodianBankLabel.font = contentFont
        picCustodianTitleLabel.font = titleFont
        picCustodianTitleLabel.textColor = titleLabelColor
        picCustodianTitleLabel.text = localize("pic_custodian")
        picCustodianLabel.font = contentFont
        detailTitleLabel.textColor = primaryColor
        detailView.backgroundColor = cardBackgroundColor
        detailView.layer.cornerRadius = 5
        detailView.layer.shadowColor = UIColor.gray.cgColor
        detailView.layer.shadowOffset = CGSize(width: 0, height: 0)
        detailView.layer.shadowRadius = 4
        detailView.layer.shadowOpacity = 0.5
        tenorTitleLabel.font = titleFont
        tenorTitleLabel.textColor = titleLabelColor
        tenorTitleLabel.text = localize("tenor")
        tenorLabel.font = contentFont
        interestRateTitleLabel.font = titleFont
        interestRateTitleLabel.textColor = titleLabelColor
        interestRateTitleLabel.text = localize("interest_rate")
        interestRateLabel.font = contentFont
        breakRateTitleLabel.font = titleFont
        breakRateTitleLabel.textColor = titleLabelColor
        breakRateTitleLabel.text = localize("break_rate")
        breakRateLabel.font = contentFont
        investmentTitleLabel.font = titleFont
        investmentTitleLabel.textColor = titleLabelColor
        investmentTitleLabel.text = localize("investment")
        investmentLabel.font = contentFont
        periodTitleLabel.font = titleFont
        periodTitleLabel.textColor = titleLabelColor
        periodTitleLabel.text = localize("period")
        periodLabel.font = contentFont
        breakDateTitleLabel.font = titleFont
        breakDateTitleLabel.textColor = titleLabelColor
        breakDateTitleLabel.text = localize("break_date")
        breakDateLabel.font = contentFont
        policyTitleLabel.textColor = primaryColor
        policyTitleLabel.text = localize("policy").uppercased()
        policyView.backgroundColor = cardBackgroundColor
        policyView.layer.cornerRadius = 5
        policyView.layer.shadowColor = UIColor.gray.cgColor
        policyView.layer.shadowOffset = CGSize(width: 0, height: 0)
        policyView.layer.shadowRadius = 4
        policyView.layer.shadowOpacity = 0.5
        breakablePolicyTitleLabel.font = titleFont
        breakablePolicyTitleLabel.textColor = titleLabelColor
        breakablePolicyTitleLabel.text = localize("breakable_policy")
        breakablePolicyLabel.font = contentFont
        policyNoteTitleLabel.font = titleFont
        policyNoteTitleLabel.textColor = titleLabelColor
        policyNoteTitleLabel.text = localize("policy_notes")
        policyNoteLabel.font = contentFont
        breakRateTitle2Label.textColor = primaryColor
        breakRateTitle2Label.text = localize("break_rate").uppercased()
        breakRateTextField.placeholder = localize("break_rate")
        breakRateTextField.keyboardType = .numbersAndPunctuation
        submitButton.setTitle(localize("submit").uppercased(), for: .normal)
        submitButton.backgroundColor = primaryColor
        submitButton.layer.cornerRadius = 3
        confirmButton.setTitle(localize("confirm"), for: .normal)
        confirmButton.backgroundColor = blueColor
        confirmButton.layer.cornerRadius = 3
        
        view.isHidden = true
        
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

    func showLoading(_ show: Bool) {
        NotificationCenter.default.post(name: Notification.Name("AuctionDetailLoading"), object: nil, userInfo: ["isShow": show])
    }
    
    func setContent() {
        // Check status
        if data.status == "-" {
            statusView.isHidden = true
        } else {
            statusView.backgroundColor = primaryColor
            statusLabel.text = data.status
            statusViewWidth.constant = statusLabel.intrinsicContentSize.width + 20
        }
        
        countdown()
        
        // Portfolio
        fundNameLabel.text = data.portfolio
        custodianBankLabel.text = data.custodian_bank != nil ? data.custodian_bank : "-"
        picCustodianLabel.text = data.pic_custodian != nil ? data.pic_custodian : "-"
        
        // Detail
        tenorLabel.text = data.period
        interestRateLabel.text = "\(checkPercentage(data.previous_interest_rate)) %"
        breakRateLabel.text = data.last_bid_rate! != nil ? "\(checkPercentage(data.last_bid_rate!)) %" : "-"
        investmentLabel.text = "IDR \(toIdrBio(data.investment_range_start))"
        periodLabel.text = "\(convertDateToString(convertStringToDatetime(data.previous_issue_date)!)!) - \(convertDateToString(convertStringToDatetime(data.previous_maturity_date)!)!)"
        breakDateLabel.text = convertDateToString(convertStringToDatetime(data.break_maturity_date)!)
        
        // Policy
        breakablePolicyLabel.text = data.breakable_policy
        policyNoteLabel.text = data.policy_notes != nil ? data.policy_notes : "-"
        
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
        
        // Footer
        let mutableAttributedString = NSMutableAttributedString()
        
        let topTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let bottomTextAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 8), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        
        let topText = NSAttributedString(string: localize("auction_detail_footer"), attributes: topTextAttribute)
        mutableAttributedString.append(topText)
        let bottomText = NSAttributedString(string: "\nRef Code : \(data.auction_name)", attributes: bottomTextAttribute)
        mutableAttributedString.append(bottomText)
        
        footerLabel.attributedText = mutableAttributedString
    }
    
    func countdown() {
        /*if convertStringToDatetime(data.end_date)! > Date() {
            let endBid = calculateDateDifference(Date(), convertStringToDatetime(data.end_bidding_rm)!)
            
            if endBid["hour"]! > 0 || endBid["minute"]! > 0 {
                let hour = endBid["hour"]! > 1 ? "\(endBid["hour"]!) hours" : "\(endBid["hour"]!) hour"
                let minute = endBid["minute"]! > 1 ? "\(endBid["minute"]!) mins" : "\(endBid["minute"]!) minute"
                
                auctionEndLabel.text = "\(localize("ends_bid_in")): \(hour) \(minute)"
                
                if endBid["hour"]! < 1 {
                    auctionEndLabel.textColor = primaryColor
                } else {
                    auctionEndLabel.textColor = .black
                }
            } else {
                let endAuction = calculateDateDifference(Date(), convertStringToDatetime(data.end_date)!)
                
                let hour = endAuction["hour"]! > 1 ? "\(endAuction["hour"]!) hours" : "\(endAuction["hour"]!) hour"
                let minute = endAuction["minute"]! > 1 ? "\(endAuction["minute"]!) mins" : "\(endAuction["minute"]!) minute"
                
                auctionEndLabel.text = "\(localize("ends_auction_in")): \(hour) \(minute)"
                
                if endAuction["hour"]! < 1 {
                    auctionEndLabel.textColor = primaryColor
                } else {
                    auctionEndLabel.textColor = .black
                }
            }
        } else {
            auctionEndLabel.isHidden = true
        }*/
        auctionEndLabel.isHidden = true
    }
    
    func validateForm() -> Bool {
        if breakRateTextField.text! == nil ||
            breakRateTextField.text! != nil && Double(breakRateTextField.text!) == nil ||
        Double(breakRateTextField.text!) != nil && Double(breakRateTextField.text!)! < 0.0 || Double(breakRateTextField.text!)! > 99.9 {
            showAlert("Rate not valid")
            return false
        } else {
            return true
        }
        
        return false
    }
    
    func showAlert(_ message: String, _ isBackToList: Bool = false) {
        let param: [String: String] = [
            "message": message,
            "isBackToList": isBackToList ? "true" : "false"
        ]
        
        NotificationCenter.default.post(name: Notification.Name("AuctionDetailAlert"), object: nil, userInfo: ["data": param])
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if validateForm() {
            let rate = Double(breakRateTextField.text!)!
            presenter.saveAuction(id, rate)
        }
    }
    
    @IBAction func confirmationButtonPressed(_ sender: Any) {
        let param: [String: String] = [
            "type": "choosen_bidder",
        ]
        
        NotificationCenter.default.post(name: Notification.Name("AuctionDetailConfirmation"), object: nil, userInfo: ["data": param])
    }
}

extension AuctionDetailBreakViewController: AuctionDetailBreakDelegate {
    func setData(_ data: AuctionDetailBreak) {
        self.data = data
        view.isHidden = false
        showLoading(false)
        setContent()
    }
    
    func isPosted(_ isSuccess: Bool, _ message: String) {
        //presenter.getAuction(id)
        showAlert(message, isSuccess)
    }
    
    func openLoginPage() {
        NotificationCenter.default.post(name: Notification.Name("AuctionDetailLogin"), object: nil, userInfo: nil)
    }
}
