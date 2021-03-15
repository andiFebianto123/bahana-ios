//
//  AuctionCashMovementViewController.swift
//  Bahana
//
//  Created by RECTmedia MD102 on 30/11/20.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionCashMovementViewController: UIViewController {
    
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var statusViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationBackImageView: UIImageView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var navigationBackView: UIView!
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var auctionEndLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    /*object panel view*/
    @IBOutlet weak var panelView1: UIView!
    @IBOutlet weak var panelView2: UIStackView! // Mature dan Previous Detail 1
    @IBOutlet weak var panelView3: UIStackView! // Break Detail 1
    @IBOutlet weak var panelView4: UIStackView! // New Palcement no cash Movement
    @IBOutlet weak var panelView5: UIStackView! // Previous Detail 2
    @IBOutlet weak var panelView6: UIStackView! // Break Detail 2
    @IBOutlet weak var panelView7: UIStackView! // custom view
    @IBOutlet weak var panelView8: UIStackView! // Notes
    @IBOutlet weak var panelView9: UIStackView! // Detail
    @IBOutlet weak var panelView10: UIStackView! // button submit and confirm
    
    // object text untuk panelView 1
    @IBOutlet weak var fundNameTitleLabelpanelView1: UILabel!
    @IBOutlet weak var custodianBankTitleLabelpanelView1: UILabel!
    @IBOutlet weak var picCustodianTitleLabelpanelView1: UILabel!
    @IBOutlet weak var fundNameLabelpanelView1: UILabel!
    @IBOutlet weak var custodianBankLabelpanelView1: UILabel!
    @IBOutlet weak var picCustodianLabelpanelView1: UILabel!
    
    // object view untuk panelView 2
    @IBOutlet weak var contentViewpanelView2: UIView!
    @IBOutlet weak var TitleLabelpanelView2: UILabel!
    @IBOutlet weak var tenorTitlepanelView2: UILabel!
    @IBOutlet weak var tenorLabelpanelView2: UILabel!
    @IBOutlet weak var interestRateTitlepanelView2: UILabel!
    @IBOutlet weak var interestRateLabelpanelView2: UILabel!
    @IBOutlet weak var principalBioTitlepanelView2: UILabel!
    @IBOutlet weak var principalBioLabelpanelView2: UILabel!
    @IBOutlet weak var periodTitlepanelView2: UILabel!
    @IBOutlet weak var periodLabelpanelView2: UILabel!
    
    
    // object view untuk panelView 3
    @IBOutlet weak var contentViewpanelView3: UIView!
    
    // object view untuk panelView 4
    @IBOutlet weak var contentViewpanelView4: UIView!
    
    // object view untuk panelView 5
    @IBOutlet weak var contentViewpanelView5: UIView!
    @IBOutlet weak var titleLabelpanelView5: UILabel!
    @IBOutlet weak var tenorTitlepanelView5: UILabel!
    @IBOutlet weak var tenorLabelpanelView5: UILabel!
    @IBOutlet weak var interestRateTitlepanelView5: UILabel!
    @IBOutlet weak var interestRateLabelpanelView5: UILabel!
    @IBOutlet weak var principalBioTitlepanelView5: UILabel!
    @IBOutlet weak var principalBioLabelpanelView5: UILabel!
    @IBOutlet weak var periodTitlepanelView5: UILabel!
    @IBOutlet weak var periodLabelpanelView5: UILabel!
    
    // object view untuk panelView 8
    @IBOutlet weak var notesTitlepanelView8: UILabel!
    @IBOutlet weak var notesLabelpanelView8: UILabel!
    
    
    // object view untuk panelView 6
    @IBOutlet weak var contentViewpanelView6: UIView!
    @IBOutlet weak var titleLabelpanelView6: UILabel!
    @IBOutlet weak var breakDateTitlepanelView6: UILabel!
    @IBOutlet weak var breakDateLabelpanelView6: UILabel!
    @IBOutlet weak var requestRateBreakTitlepanelView6: UILabel!
    @IBOutlet weak var requestRateBreakLabelpanelView6: UILabel!
    @IBOutlet weak var approvedRateBreakTitlepanelView6: UILabel!
    @IBOutlet weak var fieldRateBreakpanelView6: UITextField!
    @IBOutlet weak var heightViewApprovedRateBreakpanelView6: NSLayoutConstraint!
    
    // object view untuk panelView 7
    @IBOutlet weak var viewCustompanelView7: AuctionPanelView!
    
    // object view untuk panelView 9
    @IBOutlet weak var contentViewpanelView9: UIView!
    
    // object view untuk panelView 10
    @IBOutlet weak var revisedButtonpanelView10: UIButton!
    @IBOutlet weak var confirmButtonpanelView10: UIButton!
    @IBOutlet weak var matureDateTitleLabel: UILabel!
    @IBOutlet weak var matureDateField: UITextField!
    
    
    
    var loadingView = UIView()
    
    var presenter: AuctionDetailNoCashMovementPresenter!
    
    var id = Int()
    var data: AuctionDetailNoCashMovement!
    var serverHourDifference = Int()
    
    var revisionRate: String?
    var revisionRateBreak: String?
    var confirmationType: String!
    
    var contentType:String?
    
    var backToRoot = false
    var datePicker = UIDatePicker()
    
    func setStylePanelViewToNCMAUCTION(){
        let titleFont = UIFont.systemFont(ofSize: 11)
        let contentFont = UIFont.boldSystemFont(ofSize: 12)
        
        let cardBackgroundColor = lightRedColor
        
        // set style content mature
        TitleLabelpanelView2.text = localize("mature").uppercased()
        TitleLabelpanelView2.textColor = primaryColor
        contentViewpanelView2.backgroundColor = cardBackgroundColor
        contentViewpanelView2.layer.cornerRadius = 5
        contentViewpanelView2.layer.shadowColor = UIColor.gray.cgColor
        contentViewpanelView2.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentViewpanelView2.layer.shadowRadius = 4
        contentViewpanelView2.layer.shadowOpacity = 0.5
        // memberi data pada title label mature
        tenorTitlepanelView2.font = titleFont
        tenorTitlepanelView2.text = localize("tenor")
        interestRateTitlepanelView2.font = titleFont
        interestRateTitlepanelView2.text = localize("interest_rate")
        principalBioTitlepanelView2.font = titleFont
        principalBioTitlepanelView2.text = localize("principal_bio")
        periodTitlepanelView2.font = titleFont
        periodTitlepanelView2.text = localize("period")

        
        // set style previous detail
        titleLabelpanelView5.text = localize("previous_detail").uppercased()
        titleLabelpanelView5.textColor = primaryColor
        contentViewpanelView5.backgroundColor = cardBackgroundColor
        contentViewpanelView5.layer.cornerRadius = 5
        contentViewpanelView5.layer.shadowColor = UIColor.gray.cgColor
        contentViewpanelView5.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentViewpanelView5.layer.shadowRadius = 4
        contentViewpanelView5.layer.shadowOpacity = 0.5
        // memberi data pada title label previous detail
        tenorTitlepanelView5.font = titleFont
        tenorTitlepanelView5.text = localize("tenor")
        interestRateTitlepanelView5.font = titleFont
        interestRateTitlepanelView5.text = localize("interest_rate")
        principalBioTitlepanelView5.font = titleFont
        principalBioTitlepanelView5.text = localize("principal_bio")
        periodTitlepanelView5.font = titleFont
        periodTitlepanelView5.text = localize("period")
        
        if contentType == "break"{
            // set style break detail
            titleLabelpanelView6.textColor = primaryColor
            contentViewpanelView6.backgroundColor = cardBackgroundColor
            contentViewpanelView6.layer.cornerRadius = 5
            contentViewpanelView6.layer.shadowColor = UIColor.gray.cgColor
            contentViewpanelView6.layer.shadowOffset = CGSize(width: 0, height: 0)
            contentViewpanelView6.layer.shadowRadius = 4
            contentViewpanelView6.layer.shadowOpacity = 0.5
            // memberi data pada title label break detail
            breakDateTitlepanelView6.font = titleFont
            breakDateTitlepanelView6.text = localize("break_date")
            requestRateBreakTitlepanelView6.font = titleFont
            requestRateBreakTitlepanelView6.text = localize("request_rate_break")
            approvedRateBreakTitlepanelView6.font = titleFont
            approvedRateBreakTitlepanelView6.text = localize("approved_rate_break")
        }
        
        
        // set style new placement, no cash movement
        viewCustompanelView7.viewBody.backgroundColor = cardBackgroundColor
        viewCustompanelView7.viewBody.layer.cornerRadius = 5
        viewCustompanelView7.viewBody.layer.shadowColor = UIColor.gray.cgColor
        viewCustompanelView7.viewBody.layer.shadowOffset = CGSize(width:0, height:0)
        viewCustompanelView7.viewBody.layer.shadowRadius = 4
        viewCustompanelView7.viewBody.layer.shadowOpacity = 0.5
        viewCustompanelView7.totalApproveView.isHidden = true
        viewCustompanelView7.totalDecilineView.isHidden = true
        // memberi data pada title label new placement
        viewCustompanelView7.panelTitle.textColor = primaryColor
        viewCustompanelView7.panelTItle2.textColor = primaryColor
        // viewCustompanelView7.panelTItle2.text = " \(localize("no_cash_movement").uppercased())"
        viewCustompanelView7.panelTItle2.text = ""
        viewCustompanelView7.tenorTitle.text = localize("tenor")
        viewCustompanelView7.requestInterestRateTitle.text = localize("request_interest_rate")
        viewCustompanelView7.approvedInterestRateTitle.text = localize("approved_interest_rate")
        viewCustompanelView7.principalTitle.text = localize("principal_bio")
        viewCustompanelView7.transferTitle.text = "Transfer"
        viewCustompanelView7.newPlacementTitle.text = localize("new_placement")
        viewCustompanelView7.periodTitle.text = localize("period")
        viewCustompanelView7.statusTenorChanged.text = localize("(changed)") // untuk memberi status pada tenor
        viewCustompanelView7.matureTitle.text = localize("Mature")
        viewCustompanelView7.noCashMovementTitle.text = "(\(localize("no_cash_movement")))"
        matureDateTitleLabel.textColor = primaryColor
        
    }
    
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
        
        let cardBackgroundColor = lightRedColor
        panelView1.backgroundColor = cardBackgroundColor
        panelView1.layer.cornerRadius = 5
        panelView1.layer.shadowColor = UIColor.gray.cgColor
        panelView1.layer.shadowOffset = CGSize(width: 0, height: 0)
        panelView1.layer.shadowRadius = 4
        panelView1.layer.shadowOpacity = 0.5
        
        statusView.layer.cornerRadius = 10
        statusLabel.font = contentFont
        
        titleLabel.text = localize("no_cash_movement").uppercased()
        titleLabel.textColor = primaryColor
        
        auctionEndLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        fundNameTitleLabelpanelView1.font = titleFont
        fundNameTitleLabelpanelView1.textColor = titleLabelColor
        fundNameTitleLabelpanelView1.text = localize("fund_name")
        fundNameLabelpanelView1.font = contentFont
        
        custodianBankTitleLabelpanelView1.font = titleFont
        custodianBankTitleLabelpanelView1.textColor = titleLabelColor
        custodianBankTitleLabelpanelView1.text = localize("custodian_bank")
        custodianBankLabelpanelView1.font = contentFont
        
        picCustodianTitleLabelpanelView1.font = titleFont
        picCustodianTitleLabelpanelView1.textColor = titleLabelColor
        picCustodianTitleLabelpanelView1.text = localize("pic_custodian")
        picCustodianLabelpanelView1.font = contentFont
        
        viewCustompanelView7.listPrincipalBio.isHidden = true // sembunyikan list mature dan transfer pada principal (bio)
        viewCustompanelView7.statusTenorChanged.isHidden = true // sembunyikan status changed pada tenor
        
        presenter = AuctionDetailNoCashMovementPresenter(delegate:self)
        refresh()
        
        // Refresh page
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .refreshAuctionDetail, object: nil)
        // batas function
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showConfirmation" {
            if let destinationVC = segue.destination as? AuctionDetailConfirmationViewController {
                destinationVC.auctionID = id
                destinationVC.auctionType = "ncm-auction"
                destinationVC.ncmType = contentType
                destinationVC.confirmationType = confirmationType
                destinationVC.revisionRate = revisionRate
                destinationVC.revisionRateBreak = revisionRateBreak
            }
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
    
    func setNavigationItems() {
        //navigationBar.barTintColor = UIColor.red
        //navigationController?.navigationBar.barTintColor = primaryColor
        navigationView.backgroundColor = primaryColor
        navigationViewHeight.constant = getNavigationHeight()
        navigationTitle.text = localize("auction_detail").uppercased()
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backButtonPressed))
        navigationBackImageView.image = UIImage(named: "icon_left")
        navigationBackView.addGestureRecognizer(backTap)
    }
    
    @objc func backButtonPressed() {
        if backToRoot {
        self.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    let Formatter = DateFormatter()
    func getDateToChangeMatureField() -> String{
        let dateString = "\(convertDateToString(convertStringToDatetime(data.break_maturity_date)!)!)"
        let datePicker = UIDatePicker()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd MMM yy"
        let tanggal = formatter.date(from:dateString) ?? Date()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.setDate(tanggal, animated: false)
        //
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: datePicker.date)
    }
    func createDatePicker(){
        let dateString = self.getDateToChangeMatureField()
        // matureDateField.text = dateString
        
        // var dateFormater = DateFormatter()
        Formatter.dateFormat = "dd MMMM yyyy"
        let tanggal = Formatter.date(from: dateString) ?? Date()
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.setDate(tanggal, animated: false)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: true)
        matureDateField.inputAccessoryView = toolbar
        matureDateField.inputView = datePicker
    }
    @objc func donePressed(){
        // let Formatter = DateFormatter()
        Formatter.dateStyle = DateFormatter.Style.medium
        Formatter.timeStyle = DateFormatter.Style.none
        Formatter.dateFormat = "Y-M-dd"
        matureDateField.text = Formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func countdown() {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .hour, value: -serverHourDifference, to: Date())!
        
        if convertStringToDatetime(data.end_date)! > date {
            let endAuction = calculateDateDifference(date, convertStringToDatetime(data.end_date)!)
            
            if endAuction["hour"]! > 0 || endAuction["minute"]! > 0 {
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
            } else {
                auctionEndLabel.isHidden = true
            }
        } else {
            auctionEndLabel.isHidden = true
        }
    }
    
    func showAlert(_ message: String, _ isBackToList: Bool) {
        let alert = UIAlertController(title: localize("information"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: { action in
            if isBackToList {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    // function to check IDR or USD
    func checkUSDorIDR() -> Int {
        if data.fund_type == "USD" {
            return 1
        }
        return 2
    }

    
    func setContent(){
        print("Tipe konten : \(contentType!)")
        print("ID : \(data.id)")
        
        // mengatur nilai status
        createDatePicker()
        if data.status == "-" {
            statusView.isHidden = true
        } else {
            statusView.isHidden = false
            statusView.backgroundColor = primaryColor
            statusLabel.text = data.status
            statusViewWidth.constant = statusLabel.intrinsicContentSize.width + 20
        }
        
        // memberi text ke panelView1
        fundNameLabelpanelView1.text = data.portfolio
        custodianBankLabelpanelView1.text = data.custodian_bank
        picCustodianLabelpanelView1.text = data.pic_custodian
        
        // memberi countdown
        countdown()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        
        // memberi notes
        notesTitlepanelView8.textColor = primaryColor
        notesTitlepanelView8.text = localize("notes").uppercased()
        notesLabelpanelView8.text = "\(data.notes)"
        
        
        tenorLabelpanelView5.text = "\(data.previous_transaction.period)"
        interestRateLabelpanelView5.text = "\(checkPercentage(data.previous_transaction.coupon_rate)) %"
        principalBioLabelpanelView5.text = (checkUSDorIDR() == 1) ? "USD \(data.previous_transaction.quantity)": "IDR \(toIdrBio(data.previous_transaction.quantity))"
        periodLabelpanelView5.text = "\(convertDateToString(convertStringToDatetime(data.previous_transaction.issue_date)!)!) - \(convertDateToString(convertStringToDatetime(data.previous_transaction.maturity_date)!)!)"
        
         setStylePanelViewToNCMAUCTION() // get ready setting style
        // mengatur konten
        if contentType == "mature" {
            // jika tipe content no cash movement
            panelView6.isHidden = true
            titleLabel.text = localize("mature").uppercased()
            
            tenorLabelpanelView2.text = "\(data.previous_transaction.period)"
            interestRateLabelpanelView2.text = "\(checkPercentage(data.previous_transaction.coupon_rate)) %"
            principalBioLabelpanelView2.text = (checkUSDorIDR() == 1) ? "USD \(data.previous_transaction.quantity)": "IDR \(toIdrBio(data.previous_transaction.quantity))"
            
            periodLabelpanelView2.text = "\(convertDateToString(convertStringToDatetime(data.previous_transaction.issue_date)!)!) - \(convertDateToString(convertStringToDatetime(data.previous_transaction.maturity_date)!)!)"
            
            
            viewCustompanelView7.tenorLabel.text = "\(data.period)"
            if data.revision_rate_rm != nil {
                viewCustompanelView7.requestInterestRateLabel.text = "\(checkPercentage(data.revision_rate_rm!)) %"
            }else{
                viewCustompanelView7.requestInterestRateLabel.text = "\(checkPercentage(data.interest_rate)) %"
            }
            viewCustompanelView7.periodLabel.text = "\(convertDateToString(convertStringToDatetime(data.bilyet.issue_date)!)!) - \(convertDateToString(convertStringToDatetime(data.bilyet.maturity_date)!)!)"
            
            
            
        }else{
            // jika ncm-auction break
            panelView2.isHidden = true
            titleLabel.text = localize("break").uppercased()
            breakDateLabelpanelView6.text = "\(convertDateToString(convertStringToDatetime(data.break_maturity_date)!)!)"
            requestRateBreakLabelpanelView6.text = "\(checkPercentage(data.break_target_rate!)) %"
            viewCustompanelView7.tenorLabel.text = "\(data.period)"
            if data.revision_rate_rm != nil {
                viewCustompanelView7.requestInterestRateLabel.text = "\(checkPercentage(data.revision_rate_rm!)) %"
            }else{
                viewCustompanelView7.requestInterestRateLabel.text = "\(checkPercentage(data.interest_rate)) %"
            }
            viewCustompanelView7.periodLabel.text = "\(convertDateToString(convertStringToDatetime(data.bilyet.issue_date)!)!) - \(convertDateToString(convertStringToDatetime(data.bilyet.maturity_date)!)!)"
            
        }
        
        // membaca logic customView7 berdasarkan ncm_change_status
        if data.ncm_change_status == "change placement"{
            viewCustompanelView7.panelTitle.text = "\(localize("new_detail").uppercased())"
            viewCustompanelView7.listPrincipalBio.isHidden = false
            viewCustompanelView7.statusTenorChanged.isHidden = true
            viewCustompanelView7.principalLabel.isHidden = true
            viewCustompanelView7.transferLabel.text = (checkUSDorIDR() == 1) ? "USD \(data.previous_transaction.transfer_ammount)": "IDR \(toIdrBio(data.previous_transaction.transfer_ammount))"
            viewCustompanelView7.newPlacementLabel.text = (checkUSDorIDR() == 1) ? "USD \(data.investment_range_start)": "IDR \(toIdrBio(data.investment_range_start))"
        }else if data.ncm_change_status == "change placement and tenor change" {
            viewCustompanelView7.listPrincipalBio.isHidden = false
            viewCustompanelView7.statusTenorChanged.isHidden = false
            viewCustompanelView7.principalLabel.isHidden = true
            viewCustompanelView7.transferLabel.text = (checkUSDorIDR() == 1) ? "USD \(data.previous_transaction.transfer_ammount)": "IDR \(toIdrBio(data.previous_transaction.transfer_ammount))"
            viewCustompanelView7.newPlacementLabel.text = (checkUSDorIDR() == 1) ? "USD \(data.investment_range_start)": "IDR \(toIdrBio(data.investment_range_start))"
        }else{
            // kemungkinan change tenor
            viewCustompanelView7.panelTItle2.text = " \(localize("no_cash_movement").uppercased())"
            viewCustompanelView7.statusTenorChanged.isHidden = false
            viewCustompanelView7.principalLabel.text = (checkUSDorIDR() == 1) ? "USD \(data.investment_range_start)": "IDR \(toIdrBio(data.investment_range_start))"
        }
        
        // set content with status view
        if data.view == 0 {
            panelView10.isHidden = true
            viewCustompanelView7.approvedInterestRateView.isHidden = true
            if contentType == "break"{
                approvedRateBreakTitlepanelView6.isHidden = true
                fieldRateBreakpanelView6.isHidden = true
                heightViewApprovedRateBreakpanelView6.constant = 0.0
            }
        }else if data.view == 1 {
            panelView10.isHidden = false
        }else if data.view == 2 {
            panelView10.isHidden = false
            confirmButtonpanelView10.isHidden = true
        }
        
    }
    
    func validateForm() -> Bool {
        let text: String = viewCustompanelView7.fieldApprovedInterestRate.text!
        if text == nil ||
            text != nil && Double(text) == nil ||
        Double(text) != nil && Double(text)! < 0.0 || Double(text)! > 99.9 {
            showAlert("Rate not valid", false)
            return false
        } else {
            return true
        }
        if self.contentType == "break" {
            let text_: String = fieldRateBreakpanelView6.text!
            if text_ == nil ||
                text_ != nil && Double(text_) == nil ||
            Double(text_) != nil && Double(text_)! < 0.0 || Double(text_)! > 99.9 {
                showAlert("Rate not valid", false)
                return false
            } else {
                return true
            }
        }
        return false
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        confirmationType = "chosen_bidder"
        self.performSegue(withIdentifier: "showConfirmation", sender: self)
    }
    
    @IBAction func revisePressed(_ sender: Any) {
        if validateForm() {
           confirmationType = "revise_rate"
            revisionRate = viewCustompanelView7.fieldApprovedInterestRate.text!
            revisionRateBreak = fieldRateBreakpanelView6.text!
            viewCustompanelView7.fieldApprovedInterestRate.text = ""
            fieldRateBreakpanelView6.text = ""
            self.performSegue(withIdentifier: "showConfirmation", sender: self)
        }
    }
    
    
}

extension AuctionCashMovementViewController: AuctionDetailNoCashMovementDelegate{
    func setDataBETA(){
        setContent()
        scrollView.isHidden = false
        showLoading(false)
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
    
    func setData(_ data: AuctionDetailNoCashMovement) {
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
    
    func openLoginPage() {
        let authStoryboard : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginViewController : UIViewController = authStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    
}

