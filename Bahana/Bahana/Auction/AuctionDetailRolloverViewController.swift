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
    @IBOutlet weak var previousInterestRateTitleLabel: UILabel!
    @IBOutlet weak var previousInterestRateLabel: UILabel!
    @IBOutlet weak var newInterestRateTitleLabel: UILabel!
    @IBOutlet weak var newInterestRateLabel: UILabel!
    @IBOutlet weak var investmentTitleLabel: UILabel!
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var previousPeriodTitleLabel: UILabel!
    @IBOutlet weak var previousPeriodLabel: UILabel!
    @IBOutlet weak var newPeriodTitleLabel: UILabel!
    @IBOutlet weak var newPeriodLabel: UILabel!
    @IBOutlet weak var interestRateStackView: UIStackView!
    @IBOutlet weak var interestRateTitleLabel: UILabel!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var footerLabel: UILabel!
    
    var presenter: AuctionDetailRolloverPresenter!
    
    var id = Int()
    var data: AuctionDetailRollover!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let titleFont = UIFont.systemFont(ofSize: 11)
        let contentFont = UIFont.boldSystemFont(ofSize: 12)
        
        titleLabel.text = localize("rollover").uppercased()
        titleLabel.textColor = primaryColor
        auctionEndLabel.font = UIFont.boldSystemFont(ofSize: 14)
        statusView.layer.cornerRadius = 10
        let cardBackgroundColor = UIColorFromHex(rgbValue: 0xffe0e0)
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
        tenorTitleLabel.text = localize("tenor")
        tenorLabel.font = contentFont
        previousInterestRateTitleLabel.font = titleFont
        previousInterestRateTitleLabel.text = localize("previous_interest_rate")
        previousInterestRateLabel.font = contentFont
        newInterestRateTitleLabel.font = titleFont
        newInterestRateTitleLabel.text = localize("new_interest_rate")
        newInterestRateLabel.font = contentFont
        investmentTitleLabel.font = titleFont
        investmentTitleLabel.text = localize("investment")
        investmentLabel.font = contentFont
        previousPeriodTitleLabel.font = titleFont
        previousPeriodTitleLabel.text = localize("previous_period")
        previousPeriodLabel.font = contentFont
        newPeriodTitleLabel.font = titleFont
        newPeriodTitleLabel.text = localize("new_period")
        newPeriodLabel.font = contentFont
        interestRateTitleLabel.textColor = primaryColor
        interestRateTitleLabel.text = localize("interest_rate").uppercased()
        interestRateTextField.placeholder = localize("interest_rate").uppercased()
        submitButton.setTitle(localize("submit").uppercased(), for: .normal)
        submitButton.backgroundColor = primaryColor
        confirmButton.setTitle(localize("confirm").uppercased(), for: .normal)
        confirmButton.backgroundColor = UIColorFromHex(rgbValue: 0x2a91ff)
        
        presenter = AuctionDetailRolloverPresenter(delegate: self)
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
        
        if convertStringToDatetime(data.end_date)! > Date() {
            let countdown = calculateDateDifference(Date(), convertStringToDatetime(data.end_bidding_rm)!)
            
            let hour = countdown["hour"]! > 1 ? "\(countdown["hour"]!) hours" : "\(countdown["hour"]!) hour"
            let minute = countdown["minute"]! > 1 ? "\(countdown["minute"]!) mins" : "\(countdown["minute"]!) minute"
            auctionEndLabel.text = "\(localize("ends_in")): \(hour) \(minute)"
            
            if countdown["hour"]! < 1 {
                auctionEndLabel.textColor = primaryColor
            } else {
                auctionEndLabel.textColor = .black
            }
        } else {
            auctionEndLabel.isHidden = true
        }
        
        // Portfolio
        fundNameLabel.text = data.portfolio
        custodianBankLabel.text = data.custodian_bank
        picCustodianLabel.text = data.pic_custodian
        
        // Detail
        tenorLabel.text = data.period
        previousInterestRateLabel.text = "\(checkPercentage(data.previous_interest_rate)) %"
        newInterestRateLabel.text = data.last_bid_rate != nil ? "\(checkPercentage(data.last_bid_rate!)) %" : "-"
        investmentLabel.text = "IDR \(toIdrBio(data.investment_range_start))"
        previousPeriodLabel.text = "\(convertDateToString(convertStringToDatetime(data.previous_issue_date)!)!) - \(convertDateToString(convertStringToDatetime(data.issue_date)!)!)"
        newPeriodLabel.text = "\(convertDateToString(convertStringToDatetime(data.issue_date)!)!) - \(convertDateToString(convertStringToDatetime(data.maturity_date)!)!)"
        
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
        
        let footerDate = convertDateToString(convertStringToDatetime(data.start_date)!, format: "ddMMyy")!
        
        footerLabel.text = """
        \(localize("auction_detail_footer"))
        Ref Code : RO.\(data.portfolio_short).\(footerDate).\(data.id)
        """
    }
    
    func validateForm() -> Bool {
        if interestRateTextField.text! == nil ||
            interestRateTextField.text! != nil && Double(interestRateTextField.text!) == nil ||
        Double(interestRateTextField.text!) != nil && Double(interestRateTextField.text!)! < 0.0 || Double(interestRateTextField.text!)! > 99.9 {
            showAlert("Rate not valid")
            return false
        } else {
            return true
        }
        
        return false
    }
    
    func showAlert(_ message: String) {
        NotificationCenter.default.post(name: Notification.Name("AuctionDetailAlert"), object: nil, userInfo: ["message": message])
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if validateForm() {
            let rate = Double(interestRateTextField.text!)!
            presenter.saveAuction(id, rate)
        }
    }
    
    @IBAction func confirmationButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("AuctionDetailConfirmation"), object: nil, userInfo: ["date": data.previous_maturity_date])
    }
    
}

extension AuctionDetailRolloverViewController: AuctionDetailRolloverDelegate {
    func setData(_ data: AuctionDetailRollover) {
        self.data = data
        showLoading(false)
        setContent()
    }
    
    func isPosted(_ isSuccess: Bool, _ message: String) {
        showAlert(message)
    }
}
