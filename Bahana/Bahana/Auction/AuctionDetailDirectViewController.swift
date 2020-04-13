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
    @IBOutlet weak var investmentTitleLabel: UILabel!
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var bilyetTitleLabel: UILabel!
    @IBOutlet weak var bilyetLabel: UILabel!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var messageTitleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var revisionRateStackView: UIStackView!
    @IBOutlet weak var revisionRateTitleLabel: UILabel!
    @IBOutlet weak var revisionRateTextField: UITextField!
    @IBOutlet weak var revisedButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var footerLabel: UILabel!
    
    var presenter: AuctionDetailDirectPresenter!
    
    var id = Int()
    var data: AuctionDetailDirect!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let titleFont = UIFont.systemFont(ofSize: 11)
        let contentFont = UIFont.boldSystemFont(ofSize: 12)
        
        titleLabel.text = localize("direct_auction").uppercased()
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
        interestRateTitleLabel.font = titleFont
        interestRateTitleLabel.text = localize("interest_rate")
        interestRateLabel.font = contentFont
        investmentTitleLabel.font = titleFont
        investmentTitleLabel.text = localize("investment")
        investmentLabel.font = contentFont
        bilyetTitleLabel.font = titleFont
        bilyetTitleLabel.text = localize("bilyet")
        bilyetLabel.font = contentFont
        noteTitleLabel.textColor = primaryColor
        noteTitleLabel.text = localize("notes").uppercased()
        messageTitleLabel.textColor = primaryColor
        messageTitleLabel.text = localize("message").uppercased()
        revisionRateTitleLabel.textColor = primaryColor
        revisionRateTitleLabel.text = localize("revision_rate")
        revisionRateTextField.keyboardType = .numbersAndPunctuation
        revisedButton.setTitle(localize("revised").uppercased(), for: .normal)
        revisedButton.backgroundColor = primaryColor
        confirmButton.setTitle(localize("confirm").uppercased(), for: .normal)
        confirmButton.backgroundColor = UIColorFromHex(rgbValue: 0x2a91ff)
        
        view.isHidden = true
        
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
            auctionEndLabel.text = "\(localize("ends_bid_in")): \(hour) \(minute)"
            
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
        custodianBankLabel.text = data.custodian_bank != nil ? data.custodian_bank : "-"
        picCustodianLabel.text = data.pic_custodian != nil ? data.pic_custodian : "-"
        
        // Detail
        tenorLabel.text = data.period
        var interestRate = "-"
        
        if data.revision_rate_rm != nil {
            interestRate = "\(checkPercentage(Double(data.revision_rate_rm!)!)) %"
        } else {
            interestRate = "\(checkPercentage(data.interest_rate)) %"
        }
        interestRateLabel.text = interestRate
        investmentLabel.text = "IDR \(toIdrBio(data.investment_range_start))"
        var bilyet = """
        """
        for bilyetArr in data.bilyet {
            bilyet += "\u{2022} IDR \(toIdrBio(bilyetArr.quantity)) [\(convertDateToString(convertStringToDatetime(bilyetArr.issue_date)!)!) - \(convertDateToString(convertStringToDatetime(bilyetArr.maturity_date)!)!)]\n"
        }
        
        bilyetLabel.text = bilyet
        noteLabel.text = data.notes
        messageLabel.text = data.message
        
        // Action
        if data.view == 0 {
            revisionRateStackView.isHidden = true
        } else if data.view == 1 {
            //
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
    
    func validateForm() -> Bool {
        if revisionRateTextField.text != nil && Double(revisionRateTextField.text!) == nil ||
        Double(revisionRateTextField.text!) != nil && Double(revisionRateTextField.text!)! < 0.0 || Double(revisionRateTextField.text!)! > 99.9 {
            showAlert("The revision rate field is required")
            return false
        } else {
            return true
        }
        
        return false
    }
    
    func showAlert(_ message: String) {
        NotificationCenter.default.post(name: Notification.Name("AuctionDetailAlert"), object: nil, userInfo: ["message": message])
    }
    
    @IBAction func reviseButtonPressed(_ sender: Any) {
        if validateForm() {
            let rate = revisionRateTextField.text != nil ? Double(revisionRateTextField.text!)! : nil
            
            let param: [String: String] = [
                "type": "revise_rate",
                "revisionRate": rate != nil ? "\(rate)" : ""
            ]
            
            NotificationCenter.default.post(name: Notification.Name("AuctionDetailConfirmation"), object: nil, userInfo: ["data": param])
        }
    }
    
    @IBAction func confirmationButtonPressed(_ sender: Any) {
        let param: [String: String] = [
            "type": "choosen_winner"
        ]
        
        NotificationCenter.default.post(name: Notification.Name("AuctionDetailConfirmation"), object: nil, userInfo: ["data": param])
    }
    
}

extension AuctionDetailDirectViewController: AuctionDetailDirectDelegate {
    func setData(_ data: AuctionDetailDirect) {
        self.data = data
        view.isHidden = false
        showLoading(false)
        setContent()
    }
    
    func isPosted(_ isSuccess: Bool, _ message: String) {
        //presenter.getAuction(id)
        showAlert(message)
        navigationController?.popViewController(animated: true)
    }
}
