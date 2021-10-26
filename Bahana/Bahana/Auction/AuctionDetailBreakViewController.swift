//
//  AuctionDetailBreakViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/25.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AuctionDetailBreakViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationBackView: UIView!
    @IBOutlet weak var navigationBackImageView: UIImageView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainStackView: UIStackView!
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
    
    
    /*TAMBAHAN by ANDI*/
    @IBOutlet weak var panelPreviousDetail: UIStackView!
    @IBOutlet weak var PreviousDetailLabel: UILabel! // title
    @IBOutlet weak var PreviousDetailView: UIView!
    
    // label untuk previous detail
    @IBOutlet weak var tenorPreviousDetailTitle: UILabel!
    @IBOutlet weak var interestRatePreviousDetailTitle: UILabel!
    @IBOutlet weak var principalPreviousDetailTitle: UILabel!
    @IBOutlet weak var periodPreviousDetailTitle: UILabel!
    
    @IBOutlet weak var tenorPreviousDetail: UILabel!
    @IBOutlet weak var interestRatePreviousDetail: UILabel!
    @IBOutlet weak var principalPreviousDetail: UILabel!
    @IBOutlet weak var periodPreviousDetail: UILabel!
    // END
    
    // label untuk break detail
    @IBOutlet weak var breakDateBreakDetailTitle: UILabel!
    @IBOutlet weak var requestRateBreakBreakDetailTitle: UILabel!
    @IBOutlet weak var approvedRateBreakTitle: UILabel!
    
    
    @IBOutlet weak var breakDateBreakDetail: UILabel!
    @IBOutlet weak var requestRateBreakDetail: UILabel!
    @IBOutlet weak var rateBreakFieldText: UITextField!
    //END
    
    @IBOutlet weak var panelDetail: UIStackView!
    
    @IBOutlet weak var panelBreakDetail: UIStackView!
    @IBOutlet weak var BreakDetailLabel: UILabel! // title
    @IBOutlet weak var BreakDetailLabel2: UILabel! // title
    
    @IBOutlet weak var BreakDetailView: UIView!
    /*TAMBAHAN by ANDI*/
    
    // untuk NOTES
    @IBOutlet weak var notesTitle: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    // tambahan untuk view custom
    @IBOutlet weak var PanelCustom: UIStackView!
    @IBOutlet weak var customPanelView: AuctionPanelView!
    
    @IBOutlet weak var principalBreakDetailView: UIView!
    @IBOutlet weak var periodBreakDetailView: UIView!
    @IBOutlet weak var principalBreakDetailTitle: UILabel!
    @IBOutlet weak var periodBreakDetailTitle: UILabel!
    @IBOutlet weak var constraintHeightPrincipalBreakDetailView: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightPeriodBreakDetailView: NSLayoutConstraint!
    @IBOutlet weak var changeStatus: UILabel!
    
    
    var loadingView = UIView()
    
    var presenter: AuctionDetailBreakPresenter!
    
    var id = Int()
    var data: AuctionDetailBreak!
    var serverHourDifference = Int()
    
    var revisionRate: String?
    var confirmationType: String!
    
    var needRefresh: Bool = false
    
    var backToRoot = false
    
    var pageType = ""

    
    /*TAMBAHAN by ANDI*/
    func hiddenPanelBreakAndPrevious(){
        
        /*
        ini adalah method digunakan untuk menghilangkan
        panel break detail dan previoud detail
        */
        panelBreakDetail.isHidden = true
        panelPreviousDetail.isHidden = true
    }
    func setTitlePreviousAndBreakDetail(){
        tenorPreviousDetailTitle.text = localize("tenor")
        interestRatePreviousDetail.text = localize("interest_rate")
        principalPreviousDetailTitle.text = localize("principal_bio")
        periodPreviousDetailTitle.text = localize("period")
        
        breakDateBreakDetailTitle.text = localize("break_date")
        requestRateBreakBreakDetailTitle.text = localize("request_rate_break")
        approvedRateBreakTitle.text = localize("approved_rate_break")
    }
    func checkUSDorIDR() -> Int {
        if data.fund_type == "USD" {
            return 1
        }
        return 2
    }
    func settingPanel(){
        // method ini digunakan untuk menampilkan data server
        // ke panel previous detail dan break detail
        // !!! method ini boleh dirubah !!!
        panelDetail.isHidden = true
        self.setTitlePreviousAndBreakDetail()
        tenorPreviousDetail.text = data.period
        interestRatePreviousDetail.text = "\(checkPercentage(data.previous_interest_rate)) %"
        principalPreviousDetail.text = (checkUSDorIDR() == 1) ? "USD \(data.investment_range_start)" : "IDR \(toIdrBio(data.investment_range_start))"
        periodPreviousDetail.text = "\(convertDateToString(convertStringToDatetime(data.previous_issue_date)!)!) - \(convertDateToString(convertStringToDatetime(data.previous_maturity_date)!)!)"
        breakDateBreakDetail.text = convertDateToString(convertStringToDatetime(data.break_maturity_date)!)
        requestRateBreakDetail.text = data.last_bid_rate != nil ? "\(checkPercentage(data.last_bid_rate!)) %" : "-"
        breakRateTextField.isHidden = true
    }
    
    /*TAMBAHAN by ANDI*/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setNavigationItems()
        
        setupToHideKeyboardOnTapOnView()
        
        view.backgroundColor = backgroundColor
        scrollView.backgroundColor = backgroundColor
        scrollView.alwaysBounceHorizontal = false
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0)
        ])
        
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
            loadingView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinner.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
        
        let titleFont = UIFont.systemFont(ofSize: 11)
        let contentFont = UIFont.boldSystemFont(ofSize: 12)
        
        titleLabel.text = localize("break").uppercased()
        titleLabel.textColor = primaryColor
        auctionEndLabel.font = UIFont.boldSystemFont(ofSize: 14)
        statusView.layer.cornerRadius = 10
        statusLabel.font = contentFont
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
        
        /*TAMBAHAN by ANDI*/
        PreviousDetailLabel.textColor = primaryColor
        PreviousDetailView.backgroundColor = cardBackgroundColor
        PreviousDetailView.layer.cornerRadius = 5
        PreviousDetailView.layer.shadowColor = UIColor.gray.cgColor
        PreviousDetailView.layer.shadowOffset = CGSize(width:0, height:0)
        PreviousDetailView.layer.shadowRadius = 4
        PreviousDetailView.layer.shadowOpacity = 0.5
        PreviousDetailLabel.text = localize("previous_detail") // updateA
        
        BreakDetailLabel.textColor = primaryColor
        BreakDetailView.backgroundColor = cardBackgroundColor
        BreakDetailView.layer.cornerRadius = 5
        BreakDetailView.layer.shadowColor = UIColor.gray.cgColor
        BreakDetailView.layer.shadowOffset = CGSize(width:0, height:0)
        BreakDetailView.layer.shadowRadius = 4
        BreakDetailView.layer.shadowOpacity = 0.5
        BreakDetailLabel.text = localize("break_detail") // updateA
        
        
        principalBreakDetailTitle.text = localize("principal_bio")
        periodBreakDetailTitle.text = localize("period")
        principalBreakDetailView.isHidden = true
        periodBreakDetailView.isHidden = true
        constraintHeightPeriodBreakDetailView.constant = 0.0 // -> 24.0
        constraintHeightPrincipalBreakDetailView.constant = 0.0 // -> 24.0
        
        /*TAMBAHAN by ANDI*/
        notesTitle.textColor = primaryColor
        notesTitle.text = localize("notes").uppercased()
        
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
        
        presenter = AuctionDetailBreakPresenter(delegate: self)
        rateBreakFieldText.delegate = self
        rateBreakFieldText.keyboardType = .decimalPad
        breakRateTextField.delegate = self
        breakRateTextField.keyboardType = .decimalPad
        refresh()
        // Refresh page
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .refreshAuctionDetail, object: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showConfirmation" {
            if let destinationVC = segue.destination as? AuctionDetailConfirmationViewController {
                destinationVC.auctionID = id
                destinationVC.auctionType = "break"
                destinationVC.confirmationType = confirmationType
                destinationVC.revisionRate = revisionRate
            }
        }
    }
    
    
    
    func setNavigationItems() {
        //navigationBar.barTintColor = UIColor.red
        //navigationController?.navigationBar.barTintColor = primaryColor
        navigationView.backgroundColor = primaryColor
        navigationViewHeight.constant = getNavigationHeight()
        navigationTitle.text = localize("auction_detail").uppercased()
        // let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backButtonPressed))
        navigationBackImageView.image = UIImage(named: "icon_left")
        navigationBackView.addGestureRecognizer(backTap)
    }

    @objc func backButtonPressed() {
        if backToRoot {
            self.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: nil)
        } else {
            if pageType == "auction" {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshTableListAuction"), object: nil, userInfo: nil)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc func refresh() {
        scrollView.isHidden = true
        showLoading(true)
        presenter.getAuction(id)
    }
    
    func showLoading(_ show: Bool) {
        loadingView.isHidden = !show
    }
    
    func setContent() {
        // Check status
        if data.status == "-" {
            statusView.isHidden = true
        } else {
            statusView.isHidden = false
            statusView.backgroundColor = primaryColor
            statusLabel.text = data.status
            statusViewWidth.constant = statusLabel.intrinsicContentSize.width + 20
        }
        
        countdown()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        
        // Portfolio
        fundNameLabel.text = data.portfolio
        custodianBankLabel.text = data.custodian_bank != nil ? data.custodian_bank : "-"
        picCustodianLabel.text = data.pic_custodian != nil ? data.pic_custodian : "-"
        
        // Detail
        tenorLabel.text = data.period
        interestRateLabel.text = "\(checkPercentage(data.previous_interest_rate)) %"
        breakRateLabel.text = data.last_bid_rate != nil ? "\(checkPercentage(data.last_bid_rate!)) %" : "-"
        investmentLabel.text = (checkUSDorIDR() == 1) ? "USD \(data.investment_range_start)" : "IDR \(toIdrBio(data.investment_range_start))"
        periodLabel.text = "\(convertDateToString(convertStringToDatetime(data.previous_issue_date)!)!) - \(convertDateToString(convertStringToDatetime(data.previous_maturity_date)!)!)"
        breakDateLabel.text = convertDateToString(convertStringToDatetime(data.break_maturity_date)!)
        
        // Policy
        breakablePolicyLabel.text = data.breakable_policy
        policyNoteLabel.text = data.policy_notes != nil ? data.policy_notes : "-"
        
        notesLabel.text = data.notes != "" ? data.notes : "-"
        
        print("===EDIT===")
        print("saya di : \(data.view)")
        print("===EDIT===")
        
        // Action
        if data.view == 0 {
            breakRateStackView.isHidden = true
            breakRateTitle2Label.isHidden = false
            breakRateTextField.isHidden = false
            submitButton.isHidden = false
            confirmButton.isHidden = false
            self.hiddenPanelBreakAndPrevious()
        } else if data.view == 1 {
            breakRateStackView.isHidden = false
            breakRateTitle2Label.isHidden = true
            breakRateTextField.isHidden = true
            submitButton.isHidden = true
            confirmButton.isHidden = false
            self.hiddenPanelBreakAndPrevious()
        } else if data.view == 2 {
            breakRateStackView.isHidden = false
            breakRateTitle2Label.isHidden = true
            breakRateTextField.isHidden = false
            submitButton.isHidden = false
            confirmButton.isHidden = true
            self.settingPanel()
        }
        
        // Footer
        let mutableAttributedString = NSMutableAttributedString()
        
        let topTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let bottomTextAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 8), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        
        let topText = NSAttributedString(string: localize("auction_detail_footer"), attributes: topTextAttribute)
        mutableAttributedString.append(topText)
        let bottomText = NSAttributedString(string: "\n\(localize("ref_code"))\(data.auction_name)", attributes: bottomTextAttribute)
        mutableAttributedString.append(bottomText)
        
        footerLabel.attributedText = mutableAttributedString
    }
    
    @objc func countdown() {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .hour, value: -serverHourDifference, to: Date())!
        
        if convertStringToDatetime(data.end_date)! > date {
            var endBid: [String: Int] = [
                "hour": 0,
                "minute": 0
            ]
            if data.end_bidding_rm != nil {
                endBid = calculateDateDifference(date, convertStringToDatetime(data.end_bidding_rm)!)
            }
            
            if endBid["hour"]! > 0 || endBid["minute"]! > 0 {
                let hour = endBid["hour"]! > 1 ? String.localizedStringWithFormat(localize("hours"), "\(endBid["hour"]!)") : String.localizedStringWithFormat(localize("hour"), "\(endBid["hour"]!)")
                let minute = endBid["minute"]! > 1 ? String.localizedStringWithFormat(localize("minutes"), "\(endBid["minute"]!)") : String.localizedStringWithFormat(localize("minute"), "\(endBid["minute"]!)")
                
                auctionEndLabel.text = "\(localize("ends_bid_in")): \(hour) \(minute)"
                
                if endBid["hour"]! < 1 {
                    auctionEndLabel.textColor = primaryColor
                } else {
                    auctionEndLabel.textColor = .black
                }
            } else {
                let endAuction = calculateDateDifference(date, convertStringToDatetime(data.end_date)!)
                
                let hour = endAuction["hour"]! > 1 ? String.localizedStringWithFormat(localize("hours"), "\(endAuction["hour"]!)") : String.localizedStringWithFormat(localize("hour"), "\(endAuction["hour"]!)")
                let minute = endAuction["minute"]! > 1 ? String.localizedStringWithFormat(localize("minutes"), "\(endAuction["minute"]!)") : String.localizedStringWithFormat(localize("minute"), "\(endAuction["minute"]!)")
                
                auctionEndLabel.text = "\(localize("ends_auction_in")): \(hour) \(minute)"
                
                if endAuction["hour"]! < 1 {
                    auctionEndLabel.textColor = primaryColor
                } else if endAuction["hour"]! >= 1 {
                    auctionEndLabel.textColor = .black
                } else if endAuction["hour"]! == 0 && endAuction["minute"]! == 0 {
                    auctionEndLabel.isHidden = true
                }
            }
        } else {
            auctionEndLabel.isHidden = true
        }
    }
    
    func validateForm() -> Bool {
        /*
        if breakRateTextField.text! == nil ||
            breakRateTextField.text! != nil && Double(breakRateTextField.text!) == nil ||
        Double(breakRateTextField.text!) != nil && Double(breakRateTextField.text!)! < 0.0 || Double(breakRateTextField.text!)! > 99.9 {
            showAlert("Rate not valid", false)
            return false
        } else {
            return true
        }
        */
        // [REVISI WARNING]
//        let text: String = rateBreakFieldText.text!
//
//        if text == nil ||
//            text != nil && Double(text) == nil ||
//        Double(text) != nil && Double(text)! < 0.0 || Double(text)! > 99.9 {
//            showAlert("Rate not valid", false)
//            return false
//        } else {
//            return true
//        }
//        return false
        let text: String? = rateBreakFieldText.text
        if text == nil ||
            text != nil && Double(text!) == nil ||
            Double(text!) != nil && Double(text!)! < 0.0 || Double(text!)! > 99.9 {
            showAlert("Rate not valid", false)
            return false
        } else {
            return true
        }
    }
    
    func showAlert(_ message: String, _ isBackToList: Bool) {
        let alert = UIAlertController(title: localize("information"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: { action in
            if isBackToList {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshTableListAuction"), object: nil, userInfo: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if validateForm() {
            showLoading(true)
            let rate = Double(rateBreakFieldText.text!)!
            presenter.saveAuction(id, rate)
        }
    }
    
    @IBAction func confirmationButtonPressed(_ sender: Any) {
        confirmationType = "chosen_bidder"
        // self.performSegue(withIdentifier: "showConfirmation", sender: self)
        confirmButton.isEnabled = false
        confirmButton.setTitle("Loading...", for: .normal)
        showLoading(true)
        let send: Kirim = Kirim(view: self)
        send.confirm(id, "break", true, nil, id)
        
    }
    
    func setDataFail() {
        // digunakan sebagai pemberitauan apabila gagal terhubung dengan server
        showLoading(false)
        let alert = UIAlertController(title: localize("information"), message: localize("cannot_connect_to_server"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert_2(title: String, message: String, _ isReturnToDetail: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: { action in
            if isReturnToDetail {
                // jika dalam kondisi benar setelah confirmasi selesai
                self.refresh()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func konfirmasi(_ confirm: Bool, _ message:String){
        showLoading(false)
        showAlert_2(title: localize("information"), message:message, confirm)
    }
    
}

extension AuctionDetailBreakViewController: AuctionDetailBreakDelegate {
    func setData(_ data: AuctionDetailBreak) {
        self.data = data
        setContent()
        scrollView.isHidden = false
        showLoading(false)
    }
    
    func getDataFail(_ message: String?) {
        showLoading(false)
        var msg = localize("cannot_connect_to_server")
        if message != nil {
            msg = message!
        }
        showAlert(msg, false)
    }
    
    func setDate(_ date: Date) {
        let diff = calculateDateDifference(Date(), date)
        
        serverHourDifference = diff["hour"]!
        
        if diff["minute"]! > 0 {
            if serverHourDifference < 0 {
                serverHourDifference -= 1
            } else {
                serverHourDifference += 1
            }
        }
    }
    
    func isPosted(_ isSuccess: Bool, _ message: String) {
        //presenter.getAuction(id)
        showLoading(false)
        showAlert(message, isSuccess)
    }
    
    func openLoginPage() {
        let authStoryboard : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginViewController : UIViewController = authStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
}

struct Kirim {
    
    var action:AuctionDetailBreakViewController
    
    init(view:AuctionDetailBreakViewController){
        self.action = view
    }
    
    func confirm(_ id: Int, _ type: String, _ isAccepted: Bool, _ maturityDate: String?, _ bidId: Int?) {
        var url = "api/v1/"
        let parameters: Parameters = [
            "is_accepted": isAccepted ? "yes" : "no",
            "request_maturity_date": maturityDate != nil ? maturityDate! : ""
        ]
        switch type {
            case "auction":
                url += "auction/\(id)/confirm/\(bidId!)"
            case "direct-auction":
                url += "direct-auction/\(id)/confirm"
            case "break":
                url += "break/\(id)/confirm"
            case "rollover":
                url += "rollover/\(id)/confirm"
            default:
                break
        }
        
        // Lang
        var lang = String()
        switch getLocalData(key: "language") {
        case "language_id":
            lang = "in"
        case "language_en":
            lang = "en"
        default:
            break
        }
        url += "?lang=\(lang)"
        print(url)
        
        Alamofire.request(WEB_API_URL + url, method: .post, parameters: parameters, headers: getHeaders(auth: true)).responseString { response in
            if response.response?.mimeType == "application/json" {
                let result = JSON.init(parseJSON: response.result.value!)
                //print(result)
                if response.response?.statusCode == 200 {
                    self.action.konfirmasi(true, result["message"].stringValue)
                    // jika respon benar
                } else {
                    self.action.konfirmasi(false, result["message"].stringValue)
                    // jika respon salah
                    self.action.confirmButton.isEnabled = true
                    self.action.confirmButton.setTitle(localize("confirm"), for: .normal)
                }
            } else {
                print(response)
                self.action.setDataFail()
            }
        } // end alamofire
    
        
    }
}
