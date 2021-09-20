//
//  AuctionDetailRolloverViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/25.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionDetailRolloverViewController: UIViewController {

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
    
    /*TAMBAHAN ANDI*/
    @IBOutlet weak var detailStack: UIStackView!
    
    @IBOutlet weak var changeMatureDateStack: UIStackView!
    @IBOutlet weak var changeMatureTitle: UILabel!
    @IBOutlet weak var changeMatureDateField: UITextField!
    @IBOutlet weak var changeMatureDateButton: UIButton!
    
    
    // label judul untuk previous detail
    @IBOutlet weak var previousDetailviewStack: UIStackView!
    @IBOutlet weak var previousDetailTitle: UILabel!
    @IBOutlet weak var tenorPreviousDetailTitle: UILabel!
    @IBOutlet weak var interestRatePreviousDetailTitle: UILabel!
    @IBOutlet weak var principalPreviousDetailTitle: UILabel!
    @IBOutlet weak var periodPreviousDetailTitle: UILabel!
    
    // label judul untuk new detail
    @IBOutlet weak var newDetailviewStack: UIStackView!
    @IBOutlet weak var newDetailTitle: UILabel!
    @IBOutlet weak var newDetailTitle2: UILabel! // NO CASH MOVEMENT
    
    @IBOutlet weak var tenorNewDetailTitle: UILabel!
    @IBOutlet weak var requestInterestRateNewDetailTitle: UILabel!
    @IBOutlet weak var approvedInterestRateNewDetailTitle: UILabel!
    @IBOutlet weak var principalNewDetailTitle: UILabel!
    @IBOutlet weak var periodNewDetailTitle: UILabel!
    @IBOutlet weak var newDetailView: UIView!
    
    
    // label value untuk previous detail
    @IBOutlet weak var tenorPreviousDetailLabel: UILabel!
    @IBOutlet weak var interestRatePreviousDetailLabel: UILabel!
    @IBOutlet weak var principalPreviousDetailLabel: UILabel!
    @IBOutlet weak var periodPreviousDetailLabel: UILabel!
    @IBOutlet weak var previousDetailView: UIView!
    
    
    // label value untuk new detail
    @IBOutlet weak var tenorNewDetailLabel: UILabel!
    @IBOutlet weak var requestInterestRateNewDetailLabel: UILabel!
    @IBOutlet weak var principalNewDetailLabel: UILabel!
    @IBOutlet weak var fieldApprovedInterestRateNewDetail: UITextField!
    
    @IBOutlet weak var fieldPrincipalInterestNewDetail: UITextField!
    @IBOutlet weak var periodNewDetailLabel1: UILabel!
    @IBOutlet weak var viewApproveBio: UIView!
    @IBOutlet weak var newDetailTotalApproveLabel: UILabel!
    @IBOutlet weak var viewDeclineBio: UIView!
    @IBOutlet weak var newDetailTotalDeclineLabel: UILabel!
    
    // @IBOutlet weak var periodNewDetailLabel2: UIButton!
    
    // notes
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    // constraint
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var viewUSD: UIView!
    @IBOutlet weak var view3: UIView!
    
    
    
    @IBOutlet weak var constraintTopViewUSD: NSLayoutConstraint!
    @IBOutlet weak var constraintTopView4: NSLayoutConstraint!
    // END
    
    // custom stack view
    @IBOutlet weak var customStackView: UIStackView!
    @IBOutlet weak var customPanelView: AuctionPanelView!
    @IBOutlet weak var statusChanged: UILabel!
    
    
    @IBOutlet weak var stackWinnerDetail: UIStackView!
    @IBOutlet weak var auctionWinnerDetail: AuctionWinnerDetailView!
    @IBOutlet weak var winnerDetailTitleLable: UILabel!
    
    
    
    func showUSDnewDetailLayout(){
        // jika found type berjenis USD
        view4.isHidden = true
        // constraintTopViewUSD.constant = -26.5
    }
    func showIDRnewDetailLayout(){
        viewUSD.isHidden = true
        // constraintTopView4.constant = -22.0
    }
    func showMatureLayout(){
        view4.isHidden = false
        // constraintTopViewUSD.constant = 0
        showIDRnewDetailLayout()
    }
    // function to check IDR or USD
    func checkUSDorIDR() -> Int {
        // nilai 1 = USD
        // nilai 2 = IDR
        if self.multifundAuction {
            if dataMultifund.fund_type == "USD" {
                return 1
            }else{
                return 2
            }
        }else{
            if data.fund_type == "USD" {
                return 1
            }
            return 2
        }
    }
    // end function
    func setPeriodNewDetail(){
        // untuk mengatur bentuk value period pada new detail
        let dataMature = "no mature"
        if self.checkUSDorIDR() == 1 {
            // untuk manata layout form USD
            showUSDnewDetailLayout()
            if dataMature == "mature"{
                showMatureLayout()
            }
        }else{
            // untuk menata layout form IDR
            showIDRnewDetailLayout()
        }
        
        let period = "\(convertDateToString(convertStringToDatetime(data.issue_date)!)!) -  \(convertDateToString(convertStringToDatetime(data.maturity_date)!)!)"
        // let period2 = "\(convertDateToString(convertStringToDatetime(data.maturity_date)!)!)"
        periodNewDetailLabel1.text = period
        /*
        periodNewDetailLabel2.setTitle("\(period2)", for: .normal)
        periodNewDetailLabel2.contentHorizontalAlignment = .left
        */
    }
    func setTitleForPreviousDetail(){
        // untuk mengatur value judul sesuai bahasa
        // FOR : Previoud Detail
        /*
        constraintViewNewDetailPrincipal.isHidden = true
        constraintView5Top.constant = -24.0
        */
        
        previousDetailTitle.text = localize("previous_detail")
        tenorPreviousDetailTitle.text = localize("tenor")
        interestRatePreviousDetailTitle.text = localize("interest_rate")
        principalPreviousDetailTitle.text = localize("principal_bio")
        periodPreviousDetailTitle.text = localize("period")
         
    }
    func setTitleForNewDetail(){
        // untuk mengatur value judul sesuai bahasa
        // FOR : New Detail
        
        newDetailTitle.text = localize("new_detail")
        tenorNewDetailTitle.text = localize("tenor")
        requestInterestRateNewDetailTitle.text = localize("request_interest_rate")
        approvedInterestRateNewDetailTitle.text = localize("approved_interest_rate")
        principalNewDetailTitle.text = localize("principal_bio")
        periodNewDetailTitle.text = localize("period")
        
    }
    
    func setContentPreviousDetail(){
        self.setTitleForPreviousDetail()
        previousDetailTitle.textColor = primaryColor
        
        let cardBackgroundColor = lightRedColor
        previousDetailView.backgroundColor = cardBackgroundColor
        previousDetailView.layer.cornerRadius = 5
        previousDetailView.layer.shadowColor = UIColor.gray.cgColor
        previousDetailView.layer.shadowOffset = CGSize(width: 0, height: 0)
        previousDetailView.layer.shadowRadius = 4
        previousDetailView.layer.shadowOpacity = 0.5
        
        
        if self.multifundAuction {
            tenorPreviousDetailLabel.text = dataMultifund.period
            interestRatePreviousDetailLabel.text = "\(checkPercentage(dataMultifund.previous_interest_rate)) %"
            
            principalPreviousDetailLabel.text = (checkUSDorIDR() == 1) ? "USD \(toUsdBio(dataMultifund.investment_range_start))": "IDR \(toIdrBio(dataMultifund.investment_range_start))"
            
            periodPreviousDetailLabel.text = "\(convertDateToString(convertStringToDatetime(dataMultifund.previous_issue_date)!)!) - \(convertDateToString(convertStringToDatetime(dataMultifund.issue_date)!)!)"
        }else{
            tenorPreviousDetailLabel.text = data.period
            interestRatePreviousDetailLabel.text = "\(checkPercentage(data.previous_interest_rate)) %"
            
            principalPreviousDetailLabel.text = (checkUSDorIDR() == 1) ? "USD \(toUsdBio(data.investment_range_start))": "IDR \(toIdrBio(data.investment_range_start))"
            
            periodPreviousDetailLabel.text = "\(convertDateToString(convertStringToDatetime(data.previous_issue_date)!)!) - \(convertDateToString(convertStringToDatetime(data.issue_date)!)!)"
        }
    }
    
    func setContentNewDetail(){
        self.setTitleForNewDetail()
        newDetailTitle.textColor = primaryColor
        
        let cardBackgroundColor = lightRedColor
        newDetailView.backgroundColor = cardBackgroundColor
        newDetailView.layer.cornerRadius = 5
        newDetailView.layer.shadowColor = UIColor.gray.cgColor
        newDetailView.layer.shadowOffset = CGSize(width: 0, height: 0)
        newDetailView.layer.shadowRadius = 4
        newDetailView.layer.shadowOpacity = 0.5
        
        if self.multifundAuction {
            tenorNewDetailLabel.text = dataMultifund.period
            requestInterestRateNewDetailLabel.text = dataMultifund.last_bid_rate != nil ? "\(checkPercentage(dataMultifund.last_bid_rate!)) %" : "-"
            principalNewDetailLabel.text = (checkUSDorIDR() == 1) ? "USD \(dataMultifund.investment_range_start)" : "IDR \(toIdrBio(dataMultifund.investment_range_start))"
            let period = "\(convertDateToString(convertStringToDatetime(dataMultifund.issue_date)!)!) -  \(convertDateToString(convertStringToDatetime(dataMultifund.maturity_date)!)!)"
            // let period2 = "\(convertDateToString(convertStringToDatetime(data.maturity_date)!)!)"
            periodNewDetailLabel1.text = period
        }else{
            tenorNewDetailLabel.text = data.period
            requestInterestRateNewDetailLabel.text = data.last_bid_rate != nil ? "\(checkPercentage(data.last_bid_rate!)) %" : "-"
            principalNewDetailLabel.text = (checkUSDorIDR() == 1) ? "USD \(data.investment_range_start)" : "IDR \(toIdrBio(data.investment_range_start))"
            self.setPeriodNewDetail()
        }
        
    }
    
    func setContentPreviousDetailAndNewDetail(){
        detailStack.isHidden = true
        // hidupkan form chage mature date
        changeMatureDateStack.isHidden = false
        // changeMatureDateField.isHidden = true
        
        self.setContentPreviousDetail()
        self.setContentNewDetail()
    }
    
    
    
    
    var loadingView = UIView()
    
    var presenter: AuctionDetailRolloverPresenter!
    
    var id = Int()
    var data: AuctionDetailRollover!
    var dataMultifund: AuctionDetailRolloverMultifund!
    var serverHourDifference = Int()
    
    var revisionRate: String?
    var confirmationType: String!
    
    var backToRoot = false
    
    var datePicker = UIDatePicker()
    
    var matureDateAktif:Bool = true
    
    var multifundAuction:Bool = false
    
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
        //loadingView.isHidden = true
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
        
        titleLabel.text = localize("rollover").uppercased()
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
        
        changeMatureTitle.textColor = primaryColor
        changeMatureTitle.text = localize("change_mature_date").uppercased()
        
        winnerDetailTitleLable.textColor = primaryColor
        winnerDetailTitleLable.text = localize("winner_detail").uppercased()
        
        interestRateTextField.placeholder = localize("interest_rate")
        interestRateTextField.keyboardType = .numbersAndPunctuation
        
        noteTitle.textColor = primaryColor
        noteTitle.text = localize("notes").uppercased()
        
        submitButton.setTitle(localize("submit").uppercased(), for: .normal)
        submitButton.backgroundColor = primaryColor
        submitButton.layer.cornerRadius = 3
        
        
        changeMatureDateButton.setTitle(localize("submit"), for: .normal)
        changeMatureDateButton.backgroundColor = primaryColor
        changeMatureDateButton.layer.cornerRadius = 3
        
        // changeMatureDateStack.isHidden = true // untuk menghilangkan form
        // change Mature date
        
        
        confirmButton.setTitle(localize("confirm").uppercased(), for: .normal)
        confirmButton.backgroundColor = blueColor
        confirmButton.layer.cornerRadius = 3
        
        presenter = AuctionDetailRolloverPresenter(delegate: self)
        
        refresh()
        
        // Refresh page
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .refreshAuctionDetail, object: nil)
    }
    
    let Formatter = DateFormatter()
    
    func getDateToChangeMatureField() -> String{
//        let dateString = "\(convertDateToString(convertStringToDatetime( (self.multifundAuction) ? dataMultifund.maturity_date : data.maturity_date)!)!)"
//        print("Tanggal cair 99: \(dateString)")
        let dateString = formatDateNew(((self.multifundAuction) ? dataMultifund.maturity_date : data.maturity_date)!)

        let datePicker = UIDatePicker()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd MMM yy"
        let tanggal = formatter.date(from:dateString) ?? Date()

        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.setDate(tanggal, animated: false)
        //
        formatter.dateFormat = "dd MMM yy" // lama --> "yyyy-MM-dd"
        return formatter.string(from: datePicker.date)
    }
    
    
    
    func changeFormatTgl(format: String, tgl: String) -> String{
        let formater = DateFormatter()
        let datePicker = UIDatePicker()
        formater.dateFormat = "dd MMMM yyyy"
        let tgl = formater.date(from:tgl) ?? Date()
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.setDate(tgl, animated: false)
        formater.dateFormat = format
        return formater.string(from: datePicker.date)
    }
    
    func createDatePicker(){
        let dateString = self.getDateToChangeMatureField()
        changeMatureDateField.text = dateString
        
        // var dateFormater = DateFormatter()
        Formatter.dateFormat = "dd MMMM yyyy"
        let tanggal = Formatter.date(from: dateString) ?? Date()
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.setDate(tanggal, animated: false)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancel = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done, spaceButton, cancel], animated: true)
        changeMatureDateField.inputAccessoryView = toolbar
        changeMatureDateField.inputView = datePicker
    }
    @objc func donePressed(){
        // let Formatter = DateFormatter()
        Formatter.dateStyle = DateFormatter.Style.medium
        Formatter.timeStyle = DateFormatter.Style.none
        Formatter.dateFormat = "dd MMM yy" // lama --> "yyyy-MM-dd"
        changeMatureDateField.text = Formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelPressed(){
        changeMatureDateField.text = ""
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showConfirmation" {
            if let destinationVC = segue.destination as? AuctionDetailConfirmationViewController {
                destinationVC.auctionID = id
                destinationVC.auctionType = "rollover"
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
    
    @objc func refresh() {
        if self.multifundAuction {
            scrollView.isHidden = true
            showLoading(true)
            presenter.getAuctionWithMultifund(id)
            stackWinnerDetail.isHidden = false
        }else{
            scrollView.isHidden = true
            showLoading(true)
            presenter.getAuction(id)
            stackWinnerDetail.isHidden = true
        }
    }
    
    func showLoading(_ show: Bool) {
        loadingView.isHidden = !show
    }

    @IBAction func periodChangeMatureDatePressed(_ sender: Any) {
        if matureDateAktif == false {
            matureDateAktif = true
        } else {
            matureDateAktif = false
        }
        changeMatureTitle.isHidden = matureDateAktif
        changeMatureDateField.isHidden = matureDateAktif
    }
    var checkCaseRollover = false
    func hitungCaseRollover() -> Bool {

        let penempatan_pertama = Double(data.investment_range_start)
        let data_tenor = data.period.components(separatedBy: " ")
        let tenor = Double(data_tenor[0])! * 30.0
        
        let rate = Double(data.last_bid_rate!)
        let pokokBaru = Double(fieldPrincipalInterestNewDetail.text!)!
        
        let jumlahBaru = pokokBaru
        var bunga = penempatan_pertama * (rate/100) * (1 - (20/100))
        bunga = bunga * (tenor/365)
        let pokok_baru = penempatan_pertama + bunga
        let selisih_nilai_pokok = pokok_baru - jumlahBaru
        // let harusnya = pokok_baru - 0.2
        
        let pembulatanSelisihNilaiPokok = roundf(Float(selisih_nilai_pokok * 100)) / 100
        // print("selisih nilai = \(roundf(Float(selisih_nilai_pokok * 100)) / 100)")
        if pembulatanSelisihNilaiPokok > 0.2 {

            if checkCaseRollover == false {
                self.showAlert("Please re-check new principal + interest, our calculation show \(pembulatanSelisihNilaiPokok)%", false)
                checkCaseRollover = true
            }else{
                print("Langsung approve setelah warning")
                return true
            }
            
        }else{
            print("Langsung approve")
            return true
        }
       return false
    }
    
    @IBAction func actionChangeMatureDateAndInterestRatePressed(_ sender: Any) {
        // ini adalah tombol submit yang atas
        let date = getDateToChangeMatureField()
        let newDate = changeMatureDateField.text!
        
        print("tgl : \(newDate)")
                
        if validateForm() {
            if self.multifundAuction {
                let rate = Double(fieldApprovedInterestRateNewDetail.text!)!
                var auctionWinnerDetailData = [AuctionStackPlacement]()
                for stackAuctionWinner in auctionWinnerDetail.checkPlacements {
                    if stackAuctionWinner.checkBox {
                        auctionWinnerDetailData.append(stackAuctionWinner)
                    }
                }
                showLoading(true)
                let tanggal = formatDate(newDate, formatStart:"dd MMM yy", formatEnd: "yyyy-MM-d")
                // simpan ke API:api/v1/multi-fund-rollover/{id}/post
                presenter.saveAuctionforMultifund(id: self.id, rate: rate, tgl: tanggal, detailsWinner: auctionWinnerDetailData, approved: "yes", fund_type: checkUSDorIDR())
                // print(auctionWinnerDetailData)
                //
            }else{
                showLoading(true)
                    if checkUSDorIDR() == 1{
                        // jika tipe pembayaran USD
                        let rate = Double(fieldApprovedInterestRateNewDetail.text!)!
                        let principalInterest = Double(fieldPrincipalInterestNewDetail.text!)!
                        if date == newDate {
                            // jika tidak ada perubahan tanggal
                            print("Mulai simpan")
                            presenter.saveAuctionForUSD(id, rate: rate, tgl: nil, new_nominal: principalInterest)
                        }else{
                            // jika ada perubahan tanggal
                            if(matureDateAktif){
                                // jika form maturity date di hide
                                presenter.saveAuctionForUSD(id, rate: rate, tgl: nil, new_nominal: principalInterest)
                            }else{
                                let tanggal = self.changeFormatTgl(format: "yyyy-M-dd", tgl: newDate) + " 00:00:00"
                                presenter.saveAuctionForUSD(id, rate: rate, tgl: tanggal, new_nominal: principalInterest)
                            }
                            
                        }
                    } else {
                        // jika tipe pembayaran IDR
                        let rate = Double(fieldApprovedInterestRateNewDetail.text!)!
                        if date == newDate {
                            // jika tidak ada perubahan tanggal
                            presenter.saveAuction(id, rate)
                        }else{
                            // jika ada perubahan tanggal
                            if(matureDateAktif){
                                // jika form maturity date di hide
                                presenter.saveAuction(id, rate)
                            }else{
                                let tanggal = self.changeFormatTgl(format: "yyyy-M-dd", tgl: newDate) + " 00:00:00"
                                presenter.saveAuctionWithdate(id, rate:rate, tgl:tanggal)
                
                            }
                            
                        }
                    }
            }
        }
    }
    
    
    func setContent() {
        /* Buat date picker */
        createDatePicker()
                
        /*Menghilangkan form change mature date*/
        changeMatureDateStack.isHidden = true
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
        previousInterestRateLabel.text = "\(checkPercentage(data.previous_interest_rate)) %"
        newInterestRateLabel.text = data.last_bid_rate != nil ? "\(checkPercentage(data.last_bid_rate!)) %" : "-"
        investmentLabel.text = (checkUSDorIDR() == 1) ? "USD \(data.investment_range_start)" : "IDR \(toIdrBio(data.investment_range_start))"
        previousPeriodLabel.text = "\(convertDateToString(convertStringToDatetime(data.previous_issue_date)!)!) - \(convertDateToString(convertStringToDatetime(data.issue_date)!)!)"
        newPeriodLabel.text = "\(convertDateToString(convertStringToDatetime(data.issue_date)!)!) - \(convertDateToString(convertStringToDatetime(data.maturity_date)!)!)"
        
        // notes
        noteLabel.text = data.notes
        
        // Action
        print("aku ada di \(data.view)")
        if data.view == 0 {
            // layout akan menampilkan informasi detail
            self.setContentPreviousDetailAndNewDetail()
//            previousDetailviewStack.isHidden = true
//            newDetailviewStack.isHidden = true
            
            interestRateStackView.isHidden = true
            interestRateTitleLabel.isHidden = false
            interestRateTextField.isHidden = false
            submitButton.isHidden = false
            confirmButton.isHidden = false
            // changeMatureDateField.isHidden = true
            changeMatureDateStack.isHidden = true
            //
            view3.isHidden = true
            viewUSD.isHidden = true
            viewApproveBio.isHidden = true
            viewDeclineBio.isHidden = true
        } else if data.view == 1 {
            // layout akan menampilkan tombol confirmasi untuk meminta persetujuan dari RM
            previousDetailviewStack.isHidden = true
            newDetailviewStack.isHidden = true
            
            interestRateStackView.isHidden = false
            interestRateTitleLabel.isHidden = true
            interestRateTextField.isHidden = true
            submitButton.isHidden = true
            confirmButton.isHidden = false
            changeMatureDateField.isHidden = true
        } else if data.view == 2 {
            // layout akan manampilkan form yang akan diinput oleh RM
            self.setContentPreviousDetailAndNewDetail()
            
            interestRateStackView.isHidden = true
            interestRateTitleLabel.isHidden = false
            interestRateTextField.isHidden = false
            // interestRateStackView.isHidden = false
            submitButton.isHidden = false
            confirmButton.isHidden = true
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
    } // END setContent
    
    func setRateAndUpdateWinnerDetail(approved: String){
        let newDate = changeMatureDateField.text!
        let checkUSDorIDR = self.checkUSDorIDR()
        if validateForm() {
            if self.multifundAuction {
                let rate = Double(fieldApprovedInterestRateNewDetail.text!)!
                var auctionWinnerDetailData = [AuctionStackPlacement]()
                for stackAuctionWinner in auctionWinnerDetail.checkPlacements {
                    if stackAuctionWinner.checkBox {
                        auctionWinnerDetailData.append(stackAuctionWinner)
                    }
                }
                showLoading(true)
                let tanggal = formatDate(newDate, formatStart:"dd MMM yy", formatEnd: "yyyy-MM-d")
                
                presenter.saveAuctionforMultifund(id: self.id, rate: rate, tgl: tanggal, detailsWinner: auctionWinnerDetailData, approved: approved, fund_type: checkUSDorIDR)
                // print(auctionWinnerDetailData)
                //
            }
        }
    }
    
    @objc func approvedWinnerDetailPressed(_ sender: UIButton){
        setRateAndUpdateWinnerDetail(approved: "yes")
    }
    
    @objc func declinedWinnerDetailPressed(_ sender: UIButton){
        setRateAndUpdateWinnerDetail(approved: "no")
    }
    
    func setContentMultifund(){
        /* Buat date picker */
        createDatePicker()
        
        /*Hide View 4 */
        view4.isHidden = true
        
        /*Hide view usd*/
        viewUSD.isHidden = true
        
        /*Hide portfolio view*/
        portfolioView.isHidden = true
        
        /*Hide Interest rate view*/
        interestRateStackView.isHidden = true

        /*Menghilangkan form change mature date*/
        changeMatureDateStack.isHidden = true
        
        /*Set content auction winner detail*/
        auctionWinnerDetail.layer.cornerRadius = 5
        auctionWinnerDetail.layer.shadowColor = UIColor.gray.cgColor
        auctionWinnerDetail.layer.shadowOffset = CGSize(width: 0, height: 0)
        auctionWinnerDetail.layer.shadowRadius = 4
        auctionWinnerDetail.layer.shadowOpacity = 0.5
        auctionWinnerDetail.checkUSDorIDR = self.checkUSDorIDR()
        auctionWinnerDetail.setContent()
        
        auctionWinnerDetail.approvedBtn.addTarget(self, action: #selector(approvedWinnerDetailPressed), for: .touchUpInside)
        auctionWinnerDetail.declinedBtn.addTarget(self, action: #selector(declinedWinnerDetailPressed), for: .touchUpInside)
        
        titleLabel.text = localize("multifund_rollover").uppercased()
        
        // Check status
        if dataMultifund.status == "-" {
            statusView.isHidden = true
        } else {
            statusView.isHidden = false
            statusView.backgroundColor = primaryColor
            statusLabel.text = dataMultifund.status
            statusViewWidth.constant = statusLabel.intrinsicContentSize.width + 20
        }
        
        newDetailTotalApproveLabel.text = (self.checkUSDorIDR() == 1) ? "USD \(toUsdBio(dataMultifund.investment_range_approved))" : "IDR \(toIdrBio(dataMultifund.investment_range_approved))"
        
        newDetailTotalDeclineLabel.text = (self.checkUSDorIDR() == 1) ? "USD \(toUsdBio(dataMultifund.investment_range_declined))" : "IDR \(toIdrBio(dataMultifund.investment_range_declined))"
        
        countdown()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        
        // Portfolio
//        fundNameLabel.text = dataMultifund.portfolio
//        custodianBankLabel.text = dataMultifund.custodian_bank
//        picCustodianLabel.text = dataMultifund.pic_custodian
        
        // Detail
        tenorLabel.text = dataMultifund.period
        previousInterestRateLabel.text = "\(checkPercentage(dataMultifund.previous_interest_rate)) %"
        newInterestRateLabel.text = dataMultifund.last_bid_rate != nil ? "\(checkPercentage(dataMultifund.last_bid_rate!)) %" : "-"
        investmentLabel.text = (checkUSDorIDR() == 1) ? "USD \(toUsdBio(dataMultifund.investment_range_start))" : "IDR \(toIdrBio(dataMultifund.investment_range_start))"
        previousPeriodLabel.text = "\(convertDateToString(convertStringToDatetime(dataMultifund.previous_issue_date)!)!) - \(convertDateToString(convertStringToDatetime(dataMultifund.issue_date)!)!)"
        newPeriodLabel.text = "\(convertDateToString(convertStringToDatetime(dataMultifund.issue_date)!)!) - \(convertDateToString(convertStringToDatetime(dataMultifund.maturity_date)!)!)"
        
        // notes
        noteLabel.text = dataMultifund.notes
        
        // Action
        self.setContentPreviousDetailAndNewDetail()
        
        if dataMultifund.view == 2 && dataMultifund.is_pending_exists == true {
            auctionWinnerDetail.AllCheckButtonView.isHidden = false
            changeMatureDateButton.isHidden = false
        }else if dataMultifund.view == 2 && dataMultifund.is_pending_exists == false {
            // ini digunakan untuk menghidden checkbox pada multifund
            auctionWinnerDetail.AllCheckButtonView.isHidden = false
            for stackAuctionWinner in auctionWinnerDetail.checkPlacements {
                stackAuctionWinner.checkBoxViewHide = false
                stackAuctionWinner.checkBoxView.isHidden = false
            }
        }else if dataMultifund.view == 0 || dataMultifund.view == 1 {
            changeMatureDateButton.isHidden = true
            auctionWinnerDetail.AllCheckButtonView.isHidden = true
            changeMatureDateStack.isHidden = true
            view3.isHidden = true
            for stackAuctionWinner in auctionWinnerDetail.checkPlacements {
                stackAuctionWinner.checkBoxView.isHidden = true
            }
        }

        // Footer
        let mutableAttributedString = NSMutableAttributedString()
        
        let topTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let bottomTextAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 8), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        
        let topText = NSAttributedString(string: localize("auction_detail_footer"), attributes: topTextAttribute)
        mutableAttributedString.append(topText)
        let bottomText = NSAttributedString(string: "\n\(localize("ref_code"))\(dataMultifund.auction_name)", attributes: bottomTextAttribute)
        mutableAttributedString.append(bottomText)
        
        footerLabel.attributedText = mutableAttributedString
    }
    
    @objc func countdown() {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .hour, value: -serverHourDifference, to: Date())!
        
        if convertStringToDatetime( (self.multifundAuction) ? dataMultifund.end_date : data.end_date)! > date {
            let endAuction = calculateDateDifference(date, convertStringToDatetime( (self.multifundAuction) ? dataMultifund.end_date : data.end_date)!)
            
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
    
    func validateForm() -> Bool {
        if checkUSDorIDR() == 1 {
            print("cek field USD")
            // jika layout tampil untuk tipe pembayaran USD
            if multifundAuction {
                if fieldApprovedInterestRateNewDetail.text! == nil ||
                   fieldApprovedInterestRateNewDetail.text! != nil && Double(fieldApprovedInterestRateNewDetail.text!) == nil ||
               Double(fieldApprovedInterestRateNewDetail.text!) != nil && Double(fieldApprovedInterestRateNewDetail.text!)! < 0.0 || Double(fieldApprovedInterestRateNewDetail.text!)! > 99.9 {
                   showAlert("Rate not valid", false)
                   return false
                } else {
                    return true
                }
            }else{
                if fieldApprovedInterestRateNewDetail.text! == nil ||
                    fieldApprovedInterestRateNewDetail.text! != nil && Double(fieldApprovedInterestRateNewDetail.text!) == nil ||
                Double(fieldApprovedInterestRateNewDetail.text!) != nil && Double(fieldApprovedInterestRateNewDetail.text!)! < 0.0 || Double(fieldApprovedInterestRateNewDetail.text!)! > 99.9 {
                    showAlert("Rate not valid", false)
                    return false
                } else if fieldPrincipalInterestNewDetail.text! == nil || (fieldPrincipalInterestNewDetail.text! != nil && Double(fieldPrincipalInterestNewDetail.text!) == nil) {
                    showAlert("principal interest not valid", false)
                    return false
                }else {
                    return true
                }
            }
        }else{
            print("cek field IDR")
            // jika layout tampil untuk tipe pembayaran IDR
            if fieldApprovedInterestRateNewDetail.text! == nil ||
                fieldApprovedInterestRateNewDetail.text! != nil && Double(fieldApprovedInterestRateNewDetail.text!) == nil ||
            Double(fieldApprovedInterestRateNewDetail.text!) != nil && Double(fieldApprovedInterestRateNewDetail.text!)! < 0.0 || Double(fieldApprovedInterestRateNewDetail.text!)! > 99.9 {
                showAlert("Rate not valid", false)
                return false
            } else {
                return true
            }
        }
        
        /*
         if interestRateTextField.text! == nil ||
             interestRateTextField.text! != nil && Double(interestRateTextField.text!) == nil ||
         Double(interestRateTextField.text!) != nil && Double(interestRateTextField.text!)! < 0.0 || Double(interestRateTextField.text!)! > 99.9 {
             showAlert("Rate not valid", false)
             return false
         } else {
             return true
         }
         */
        return false
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
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if validateForm() {
            let rate = Double(interestRateTextField.text!)!
            showLoading(true)
            presenter.saveAuction(id, rate)
        }
    }
    
    @IBAction func confirmationButtonPressed(_ sender: Any) {
        confirmationType = "chosen_winner"
        
        self.performSegue(withIdentifier: "showConfirmation", sender: self)
    }
    
}

extension AuctionDetailRolloverViewController: AuctionDetailRolloverDelegate {
    func setData(_ data: AuctionDetailRollover) {
        self.data = data
        setContent()
        scrollView.isHidden = false
        showLoading(false)
    }
    
    func setDataWithMultifund(_ data: AuctionDetailRolloverMultifund){
        print("ID : \(self.id)")
        self.dataMultifund = data
        auctionWinnerDetail.details = data.details
        self.setContentMultifund()
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
        showAlert(message, isSuccess)
    }
    
    func openLoginPage() {
        let authStoryboard : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginViewController : UIViewController = authStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    func hideLoading() {
        self.showLoading(false)
    }
}
