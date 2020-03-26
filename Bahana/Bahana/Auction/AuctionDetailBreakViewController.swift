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
    
    var loadingView = UIView()
    
    var presenter: AuctionDetailBreakPresenter!
    
    var id = Int()
    var data: AuctionDetailBreak!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Set loading view
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
        
        titleLabel.text = localize("break").uppercased()
        titleLabel.textColor = primaryColor
        auctionEndLabel.textColor = primaryColor
        statusView.layer.cornerRadius = 10
        let cardBackgroundColor = UIColorFromHex(rgbValue: 0xffe0e0)
        portfolioView.backgroundColor = cardBackgroundColor
        portfolioView.layer.cornerRadius = 5
        portfolioView.layer.shadowColor = UIColor.gray.cgColor
        portfolioView.layer.shadowOffset = CGSize(width: 0, height: 0)
        portfolioView.layer.shadowRadius = 4
        portfolioView.layer.shadowOpacity = 0.5
        fundNameTitleLabel.text = localize("fund_name")
        custodianBankTitleLabel.text = localize("custodian_bank")
        picCustodianTitleLabel.text = localize("pic_custodian")
        detailView.backgroundColor = cardBackgroundColor
        detailView.layer.cornerRadius = 5
        detailView.layer.shadowColor = UIColor.gray.cgColor
        detailView.layer.shadowOffset = CGSize(width: 0, height: 0)
        detailView.layer.shadowRadius = 4
        detailView.layer.shadowOpacity = 0.5
        tenorTitleLabel.text = localize("tenor")
        interestRateTitleLabel.text = localize("interest_rate")
        breakRateTitleLabel.text = localize("break_rate")
        investmentTitleLabel.text = localize("investment")
        periodTitleLabel.text = localize("period")
        breakDateTitleLabel.text = localize("break_date")
        policyTitleLabel.text = localize("policy").uppercased()
        policyView.backgroundColor = cardBackgroundColor
        policyView.layer.cornerRadius = 5
        policyView.layer.shadowColor = UIColor.gray.cgColor
        policyView.layer.shadowOffset = CGSize(width: 0, height: 0)
        policyView.layer.shadowRadius = 4
        policyView.layer.shadowOpacity = 0.5
        breakablePolicyTitleLabel.text = localize("breakable_policy")
        policyNoteTitleLabel.text = localize("policy_notes")
        breakRateTitle2Label.text = localize("break_rate").uppercased()
        submitButton.setTitle(localize("submit").uppercased(), for: .normal)
        submitButton.backgroundColor = primaryColor
        confirmButton.setTitle(localize("confirm"), for: .normal)
        confirmButton.backgroundColor = UIColorFromHex(rgbValue: 0x2a91ff)
        
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
        if show {
            loadingView.isHidden = false
        } else {
            loadingView.isHidden = true
        }
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
        /*
        if convertStringToDatetime(data.end_date)! > Date() {
            let countdown = calculateDateDifference(Date(), convertStringToDatetime(data.end_date)!)
            
            let hour = countdown["hour"]! > 1 ? "\(countdown["hour"]!) hours" : "\(countdown["hour"]!) hour"
            let minute = countdown["minute"]! > 1 ? "\(countdown["minute"]!) minutes" : "\(countdown["minute"]!) minute"
            auctionEndLabel.text = "\(localize("ends_in")): \(hour) \(minute)"
            
            if countdown["hour"]! < 1 {
                auctionEndLabel.textColor = primaryColor
            } else {
                auctionEndLabel.textColor = .black
            }
        } else {
            auctionEndLabel.isHidden = true
        }*/
        auctionEndLabel.isHidden = true
        
        // Portfolio
        fundNameLabel.text = data.portfolio
        custodianBankLabel.text = data.custodian_bank != nil ? data.custodian_bank : "-"
        picCustodianLabel.text = data.pic_custodian != nil ? data.pic_custodian : "-"
        
        // Detail
        tenorLabel.text = data.period
        interestRateLabel.text = "\(data.previous_interest_rate) %"
        breakRateLabel.text = data.last_bid_rate! != nil ? "\(data.last_bid_rate!) %" : "-"
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
        footerLabel.text = """
        \(localize("auction_detail_footer"))
        Ref Code : BR.\(data.portfolio_short).
        """
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        //presenter.saveAuction(id)
    }
    
    @IBAction func confirmationButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("AuctionDetailConfirmation"), object: nil, userInfo: ["date": ""])
    }
}

extension AuctionDetailBreakViewController: AuctionDetailBreakDelegate {
    func setData(_ data: AuctionDetailBreak) {
        self.data = data
        showLoading(false)
        setContent()
    }
}
