//
//  AuctionDetailNormalViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/25.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

struct InterestRate {
    var idx: Int
    var tenorType: String
    var tenor: Int?
    var tenorField: UITextField?
    var idrField: UITextField?
    var usdField: UITextField?
    var shariaField: UITextField?
    var isHidden: Bool
}

class AuctionDetailNormalViewController: UIViewController {

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
    @IBOutlet weak var investmentTitleLabel: UILabel!
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var placementDateTitleLabel: UILabel!
    @IBOutlet weak var placementDateLabel: UILabel!
    @IBOutlet weak var custodianBankTitleLabel: UILabel!
    @IBOutlet weak var custodianBankLabel: UILabel!
    @IBOutlet weak var picCustodianTitleLabel: UILabel!
    @IBOutlet weak var picCustodianLabel: UILabel!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var bidStackView: UIStackView!
    @IBOutlet weak var bidStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var interestRateParentStackView: UIStackView!
    @IBOutlet weak var interestRateTitleLabel: UILabel!
    @IBOutlet weak var interestRateStackView: UIStackView!
    @IBOutlet weak var interestRateStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var interestRateButtonStackView: UIStackView!
    @IBOutlet weak var interestRateAddDayButton: UIButton!
    @IBOutlet weak var interestRateAddMonthButton: UIButton!
    @IBOutlet weak var maxPlacementStackView: UIStackView!
    @IBOutlet weak var maxPlacementTitleLabel: UILabel!
    @IBOutlet weak var maxPlacementTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var footerLabel: UILabel!
    
    var loadingView = UIView()
    
    var presenter: AuctionDetailNormalPresenter!
    
    var id = Int()
    var data: AuctionDetailNormal!
    var serverHourDifference = Int()
    
    var interestRates = [InterestRate]()
    var interestRateIdx = Int()
    
    var confirmationType: String!
    var confirmationID: Int?
    
    var backToRoot = false
    
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
        
        titleLabel.text = localize("auction").uppercased()
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
        investmentTitleLabel.font = titleFont
        investmentTitleLabel.textColor = titleLabelColor
        investmentTitleLabel.text = localize("investment")
        investmentLabel.font = contentFont
        placementDateTitleLabel.font = titleFont
        placementDateTitleLabel.textColor = titleLabelColor
        placementDateTitleLabel.text = localize("placement_date")
        placementDateLabel.font = contentFont
        custodianBankTitleLabel.font = titleFont
        custodianBankTitleLabel.textColor = titleLabelColor
        custodianBankTitleLabel.text = localize("custodian_bank")
        custodianBankLabel.font = contentFont
        picCustodianTitleLabel.font = titleFont
        picCustodianTitleLabel.textColor = titleLabelColor
        picCustodianTitleLabel.text = localize("pic_custodian")
        picCustodianLabel.font = contentFont
        noteTitleLabel.text = localize("notes").uppercased()
        noteTitleLabel.textColor = primaryColor
        interestRateTitleLabel.text = localize("interest_rate").uppercased()
        interestRateTitleLabel.textColor = primaryColor
        interestRateAddDayButton.backgroundColor = lightGreenColor
        interestRateAddDayButton.setTitleColor(UIColorFromHex(rgbValue: 0x308a00), for: .normal)
        interestRateAddDayButton.setTitle(localize("add_rate_day"), for: .normal)
        interestRateAddDayButton.layer.cornerRadius = 5
        interestRateAddMonthButton.backgroundColor = greenColor
        interestRateAddMonthButton.setTitleColor(UIColorFromHex(rgbValue: 0x308a00), for: .normal)
        interestRateAddMonthButton.setTitle(localize("add_rate_month"), for: .normal)
        interestRateAddMonthButton.layer.cornerRadius = 5
        maxPlacementTitleLabel.text = localize("max_placement").uppercased()
        maxPlacementTitleLabel.textColor = primaryColor
        maxPlacementTextField.placeholder = localize("max_placement")
        submitButton.backgroundColor = primaryColor
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.setTitle(localize("submit"), for: .normal)
        submitButton.layer.cornerRadius = 3
        
        presenter = AuctionDetailNormalPresenter(delegate: self)
        
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
                destinationVC.auctionType = "auction"
                destinationVC.confirmationType = confirmationType
                destinationVC.id = confirmationID
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
        var investment = "IDR \(toIdrBio(data.investment_range_start))"
        if data.investment_range_end != nil {
            investment += " - \(toIdrBio(data.investment_range_end!))"
        }
        investmentLabel.text = investment
        placementDateLabel.text = convertDateToString(convertStringToDatetime(data.end_date)!)
        custodianBankLabel.text = data.custodian_bank != nil ? data.custodian_bank : "-"
        picCustodianLabel.text = data.pic_custodian != nil ? data.pic_custodian : "-"
        
        // Note
        noteLabel.text = data.notes
        
        setBids(data.bids)
        
        for (idx, detail) in data.details.enumerated() {
            addInterestRate(detail.td_period_type, false, detail.td_period, idx: idx)
        }
        
        // Action
        if data.view == 0 || data.view == 1 {
            interestRateParentStackView.isHidden = true
            interestRateButtonStackView.isHidden = true
            maxPlacementStackView.isHidden = true
        } else if data.view == 2 {
            interestRateParentStackView.isHidden = false
            interestRateButtonStackView.isHidden = false
            maxPlacementStackView.isHidden = false
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
            let endBid = calculateDateDifference(date, convertStringToDatetime(data.end_bidding_rm)!)
            
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
    
    func setBids(_ bidData: [Bid]) {
        bidStackViewHeight.constant = 0
        for bidView in bidStackView.arrangedSubviews {
            bidStackView.removeArrangedSubview(bidView)
        }
        
        //let auctionStoryboard : UIStoryboard = UIStoryboard(name: "Auction", bundle: nil)
        for (idx, dt) in bidData.enumerated() {
            /*
            let bidViewController = auctionStoryboard.instantiateViewController(withIdentifier: "AuctionNormalBid") as! AuctionNormalBidViewController
            bidViewController.setBid(dt)
            bidStackView.addArrangedSubview(bidViewController.view)
            
            bidStackViewHeight.constant += 150
            */
            let rateView = UIView()
            if dt.is_winner == "yes" {
                rateView.backgroundColor = lightGreenColor
            } else {
                rateView.backgroundColor = .white
            }
            var rateViewHeight: CGFloat = 0
            
            bidStackView.addArrangedSubview(rateView)
            
            let spacing: CGFloat = 5
            
            let rateStackView = UIStackView()
            rateStackView.axis = .vertical
            rateStackView.spacing = spacing
            rateStackView.distribution = .fillProportionally
            rateStackView.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(rateStackView)
            
            let titleFont = UIFont.boldSystemFont(ofSize: 10)
            let contentFont = UIFont.systemFont(ofSize: 10)
            
            let statusView = UIView()
            statusView.translatesAutoresizingMaskIntoConstraints = false
            rateStackView.addArrangedSubview(statusView)
            
            let statusTitle = UILabel()
            statusTitle.text = localize("status")
            statusTitle.font = titleFont
            statusTitle.translatesAutoresizingMaskIntoConstraints = false
            statusView.addSubview(statusTitle)
            let status = UILabel()
            if dt.is_winner == "yes" {
                if dt.is_accepted == "yes" {
                    status.text = "\(localize("win")) (\(localize("accepted")))"
                } else if dt.is_accepted == "pending" {
                    status.text = "\(localize("win")) (\(localize("pending")))"
                } else {
                    status.text = "\(localize("win")) (\(localize("rejected")))"
                }
            } else {
                status.text = localize("pending")
            }
            status.font = contentFont
            status.numberOfLines = 0
            let statusHeight = status.intrinsicContentSize.height
            status.translatesAutoresizingMaskIntoConstraints = false
            statusView.addSubview(status)
            
            rateViewHeight += statusHeight
            
            NSLayoutConstraint.activate([
                statusTitle.leadingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: 0),
                statusTitle.topAnchor.constraint(equalTo: statusView.topAnchor, constant: 0),
                statusTitle.widthAnchor.constraint(equalToConstant: 110),
                status.leadingAnchor.constraint(equalTo: statusTitle.trailingAnchor, constant: 0),
                status.trailingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: 0),
                status.topAnchor.constraint(equalTo: statusView.topAnchor, constant: 0),
                statusView.heightAnchor.constraint(equalToConstant: statusHeight)
            ])
            
            let tenorView = UIView()
            tenorView.translatesAutoresizingMaskIntoConstraints = false
            rateStackView.addArrangedSubview(tenorView)
            
            let tenorTitle = UILabel()
            tenorTitle.text = localize("tenor")
            tenorTitle.font = titleFont
            tenorTitle.translatesAutoresizingMaskIntoConstraints = false
            tenorView.addSubview(tenorTitle)
            let tenor = UILabel()
            tenor.text = dt.period
            tenor.font = contentFont
            let tenorHeight = tenor.intrinsicContentSize.height
            tenor.translatesAutoresizingMaskIntoConstraints = false
            tenorView.addSubview(tenor)
            
            rateViewHeight += tenorHeight + spacing
            
            NSLayoutConstraint.activate([
                tenorTitle.leadingAnchor.constraint(equalTo: tenorView.leadingAnchor, constant: 0),
                tenorTitle.topAnchor.constraint(equalTo: tenorView.topAnchor, constant: 0),
                tenorTitle.widthAnchor.constraint(equalToConstant: 110),
                tenor.leadingAnchor.constraint(equalTo: tenorTitle.trailingAnchor, constant: 0),
                tenor.trailingAnchor.constraint(equalTo: tenorView.trailingAnchor, constant: 0),
                tenor.topAnchor.constraint(equalTo: tenorView.topAnchor, constant: 0),
                tenorView.heightAnchor.constraint(equalToConstant: tenorHeight)
            ])
            
            let interestRateView = UIView()
            interestRateView.translatesAutoresizingMaskIntoConstraints = false
            rateStackView.addArrangedSubview(interestRateView)
            
            let interestRateTitle = UILabel()
            interestRateTitle.text = localize("interest_rate")
            interestRateTitle.font = titleFont
            interestRateTitle.translatesAutoresizingMaskIntoConstraints = false
            interestRateView.addSubview(interestRateTitle)
            
            var interestRateContent = """
            """
            var newLine = false
            
            if dt.interest_rate_idr != nil {
                interestRateContent += "(IDR) \(checkPercentage(dt.interest_rate_idr!)) %"
                if dt.chosen_rate != nil && dt.chosen_rate == "IDR" {
                    interestRateContent += " [\(localize("chosen_rate"))]"
                }
                newLine = true
            }
            if dt.interest_rate_usd != nil {
                if newLine {
                    interestRateContent += "\n"
                }
                interestRateContent += "(USD) \(checkPercentage(dt.interest_rate_usd!)) %"
                if dt.chosen_rate != nil && dt.chosen_rate == "USD" {
                    interestRateContent += " [\(localize("chosen_rate"))]"
                }
                newLine = true
            }
            if dt.interest_rate_sharia != nil {
                if newLine {
                    interestRateContent += "\n"
                }
                interestRateContent += "(\(localize("sharia"))) \(checkPercentage(dt.interest_rate_sharia!)) %"
                if dt.chosen_rate != nil && dt.chosen_rate == "Sharia" {
                    interestRateContent += " [\(localize("chosen_rate"))]"
                }
            }
            
            let interestRate = UILabel()
            interestRate.text = interestRateContent
            interestRate.numberOfLines = 0
            interestRate.font = contentFont
            let interestRateHeight = interestRate.intrinsicContentSize.height
            interestRate.translatesAutoresizingMaskIntoConstraints = false
            interestRateView.addSubview(interestRate)
            
            rateViewHeight += (interestRateHeight * 2) + spacing
            
            NSLayoutConstraint.activate([
                interestRateTitle.leadingAnchor.constraint(equalTo: interestRateView.leadingAnchor, constant: 0),
                interestRateTitle.topAnchor.constraint(equalTo: interestRateView.topAnchor, constant: 0),
                interestRateTitle.widthAnchor.constraint(equalToConstant: 110),
                interestRate.leadingAnchor.constraint(equalTo: interestRateTitle.trailingAnchor, constant: 0),
                interestRate.trailingAnchor.constraint(equalTo: interestRateView.trailingAnchor, constant: 0),
                interestRate.topAnchor.constraint(equalTo: interestRateView.topAnchor, constant: 0),
                //interestRateView.heightAnchor.constraint(equalToConstant: interestRateHeight),
                interestRateView.bottomAnchor.constraint(equalTo: interestRate.bottomAnchor, constant: 0)
                //interestRate.bottomAnchor.constraint(equalTo: interestRateView.bottomAnchor, constant: 0),
            ])
            
            if dt.is_winner == "yes" {
                let investmentView = UIView()
                investmentView.translatesAutoresizingMaskIntoConstraints = false
                rateStackView.addArrangedSubview(investmentView)
                
                let investmentTitle = UILabel()
                investmentTitle.text = localize("investment")
                investmentTitle.font = titleFont
                investmentTitle.translatesAutoresizingMaskIntoConstraints = false
                investmentView.addSubview(investmentTitle)
                
                let investment = UILabel()
                investment.text = "IDR \(toIdrBio(dt.used_investment_value))"
                investment.font = contentFont
                let investmentHeight = investment.intrinsicContentSize.height
                investment.translatesAutoresizingMaskIntoConstraints = false
                investmentView.addSubview(investment)
                
                rateViewHeight += investmentHeight + spacing
                
                let bilyetView = UIView()
                bilyetView.backgroundColor = .clear
                bilyetView.translatesAutoresizingMaskIntoConstraints = false
                rateStackView.addArrangedSubview(bilyetView)
                
                let bilyetTitle = UILabel()
                bilyetTitle.text = localize("bilyet")
                bilyetTitle.font = titleFont
                bilyetTitle.translatesAutoresizingMaskIntoConstraints = false
                bilyetView.addSubview(bilyetTitle)
               
                var bilyetStr = """
                """
                for (idx, bilyetArr) in dt.bilyet.enumerated() {
                    bilyetStr += "\u{2022} IDR \(toIdrBio(bilyetArr.quantity)) [\(convertDateToString(convertStringToDatetime(bilyetArr.issue_date)!)!) - \(convertDateToString(convertStringToDatetime(bilyetArr.maturity_date)!)!)]"
                    if idx < dt.bilyet.count - 1 {
                        bilyetStr += "\n"
                    }
                }
                
                let bilyet = UILabel()
                bilyet.text = bilyetStr
                bilyet.numberOfLines = 0
                bilyet.font = contentFont
                let bilyetHeight = bilyet.intrinsicContentSize.height
                bilyet.translatesAutoresizingMaskIntoConstraints = false
                bilyetView.addSubview(bilyet)
                
                rateViewHeight += (bilyetHeight * 2) + spacing
                
                NSLayoutConstraint.activate([
                    investmentTitle.leadingAnchor.constraint(equalTo: investmentView.leadingAnchor, constant: 0),
                    investmentTitle.topAnchor.constraint(equalTo: investmentView.topAnchor, constant: 0),
                    investmentTitle.widthAnchor.constraint(equalToConstant: 110),
                    investment.leadingAnchor.constraint(equalTo: investmentTitle.trailingAnchor, constant: 0),
                    investment.trailingAnchor.constraint(equalTo: investmentView.trailingAnchor, constant: 0),
                    investment.topAnchor.constraint(equalTo: investmentView.topAnchor, constant: 0),
                    investmentView.bottomAnchor.constraint(equalTo: investment.bottomAnchor, constant: 0),
                    //investmentView.heightAnchor.constraint(equalToConstant: investmentHeight),
                    
                    bilyetTitle.leadingAnchor.constraint(equalTo: bilyetView.leadingAnchor, constant: 0),
                    bilyetTitle.topAnchor.constraint(equalTo: bilyetView.topAnchor, constant: 0),
                    bilyetTitle.widthAnchor.constraint(equalToConstant: 110),
                    bilyet.leadingAnchor.constraint(equalTo: bilyetTitle.trailingAnchor, constant: 0),
                    bilyet.trailingAnchor.constraint(equalTo: bilyetView.trailingAnchor, constant: 0),
                    bilyet.topAnchor.constraint(equalTo: bilyetView.topAnchor, constant: 0),
                    //bilyetView.heightAnchor.constraint(equalToConstant: bilyetHeight),
                    bilyetView.bottomAnchor.constraint(equalTo: bilyet.bottomAnchor, constant: 0)
                    //bilyet.bottomAnchor.constraint(equalTo: bilyetView.bottomAnchor, constant: 0)
                ])
                
                if self.data.view == 1 && dt.is_accepted.lowercased() == "pending" {
                    let confirmButton = UIButton()
                    confirmButton.tag = idx
                    confirmButton.setTitle(localize("confirm"), for: .normal)
                    confirmButton.setTitleColor(UIColor.white, for: .normal)
                    confirmButton.titleLabel?.font = contentFont
                    confirmButton.backgroundColor = blueColor
                    confirmButton.layer.cornerRadius = 3
                    confirmButton.addTarget(self, action: #selector(confirmationButtonPressed(sender:)), for: .touchUpInside)
                    confirmButton.translatesAutoresizingMaskIntoConstraints = false
                    rateStackView.addArrangedSubview(confirmButton)
                    
                    let confirmButtonHeight: CGFloat = 30
                    
                    NSLayoutConstraint.activate([
                        confirmButton.heightAnchor.constraint(equalToConstant: confirmButtonHeight)
                    ])
                    
                    rateViewHeight += confirmButtonHeight + spacing
                }
            }
            
            NSLayoutConstraint.activate([
                rateStackView.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 20),
                rateStackView.trailingAnchor.constraint(equalTo: rateView.trailingAnchor, constant: -20),
                rateStackView.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 20),
                rateStackView.bottomAnchor.constraint(equalTo: rateView.bottomAnchor, constant: -20),
            ])
            
            if idx == 0 {
                bidStackViewHeight.constant += rateViewHeight + 10
            } else {
                bidStackViewHeight.constant += rateViewHeight + 10 + bidStackView.spacing
            }
        }
    }
    
    @IBAction func addInterestRateDayButtonPressed(_ sender: Any) {
        addInterestRate("day", true)
    }
    
    @IBAction func addInterestRateMonthButtonPressed(_ sender: Any) {
        addInterestRate("month", true)
    }
    
    func addInterestRate(_ tenorType: String, _ canEditTenor: Bool, _ period: Int? = nil, idx: Int? = nil) {
        /*let auctionStoryboard : UIStoryboard = UIStoryboard(name: "Auction", bundle: nil)
        let rateViewController = auctionStoryboard.instantiateViewController(withIdentifier: "AuctionNormalInterestRate") as! AuctionNormalInterestRateViewController
        rateViewController.setRate(tenorType, canEditTenor, period)
        interestRateStackView.addArrangedSubview(rateViewController.view)
        
        if idx == 0 {
            interestRateStackViewHeight.constant += 170
        } else {
            interestRateStackViewHeight.constant += 170 + interestRateStackView.spacing
        }*/
        
        var rateHeight: CGFloat = 40
        
        let rateView = UIView()
        rateView.tag = interestRateIdx
        rateView.backgroundColor = .white
        interestRateStackView.addArrangedSubview(rateView)
        
        let rateStackView = UIStackView()
        rateStackView.axis = .vertical
        rateStackView.spacing = 10
        rateStackView.distribution = .fillEqually
        rateStackView.translatesAutoresizingMaskIntoConstraints = false
        rateView.addSubview(rateStackView)
        
        let titleFont = UIFont.boldSystemFont(ofSize: 10)
        let contentFont = UIFont.systemFont(ofSize: 10)
        let titleWidth: CGFloat = 150
        
        // Tenor
        let tenorView = UIView()
        tenorView.translatesAutoresizingMaskIntoConstraints = false
        rateStackView.addArrangedSubview(tenorView)
        let tenorTitle = UILabel()
        tenorTitle.text = localize("tenor")
        tenorTitle.font = titleFont
        tenorTitle.translatesAutoresizingMaskIntoConstraints = false
        tenorView.addSubview(tenorTitle)
        
        NSLayoutConstraint.activate([
            tenorTitle.leadingAnchor.constraint(equalTo: tenorView.leadingAnchor, constant: 0),
            tenorTitle.widthAnchor.constraint(equalToConstant: titleWidth),
            tenorTitle.centerYAnchor.constraint(equalTo: tenorView.centerYAnchor)
        ])
        
        let fieldHeight: CGFloat = 30
        
        var tenorField: UITextField?
        if canEditTenor {
            tenorField = UITextField()
            tenorField!.borderStyle = .roundedRect
            tenorField!.keyboardType = .numbersAndPunctuation
            tenorField!.font = contentFont
            let tenorFieldHeight = fieldHeight
            tenorField!.translatesAutoresizingMaskIntoConstraints = false
            tenorView.addSubview(tenorField!)
            
            let period = UILabel()
            if tenorType == "day" {
                period.text = localize("day()")
            } else if tenorType == "month" {
                period.text = localize("month()")
            }
            period.font = contentFont
            period.textColor = UIColor.lightGray
            period.translatesAutoresizingMaskIntoConstraints = false
            tenorView.addSubview(period)
            let deleteButton = UIButton()
            deleteButton.layer.cornerRadius = 3
            deleteButton.backgroundColor = .red
            deleteButton.setImage(UIImage(named: "icon_trash_can"), for: .normal)
            deleteButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            deleteButton.tag = interestRateIdx
            deleteButton.addTarget(self, action: #selector(deleteRateButtonTapped(sender:)), for: .touchUpInside)
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            tenorView.addSubview(deleteButton)
            
            NSLayoutConstraint.activate([
                tenorField!.leadingAnchor.constraint(equalTo: tenorTitle.trailingAnchor, constant: 0),
                tenorField!.trailingAnchor.constraint(equalTo: tenorView.trailingAnchor, constant: -80),
                //tenor.topAnchor.constraint(equalTo: tenorView.topAnchor, constant: 0),
                //tenor.heightAnchor.constraint(equalToConstant: 25),
                tenorField!.centerYAnchor.constraint(equalTo: tenorView.centerYAnchor),
                period.leadingAnchor.constraint(equalTo: tenorField!.trailingAnchor, constant: 5),
                period.centerYAnchor.constraint(equalTo: tenorView.centerYAnchor),
                deleteButton.widthAnchor.constraint(equalToConstant: 25),
                deleteButton.heightAnchor.constraint(equalToConstant: 25),
                deleteButton.trailingAnchor.constraint(equalTo: tenorView.trailingAnchor, constant: 0),
                deleteButton.centerYAnchor.constraint(equalTo: tenorView.centerYAnchor),
                tenorView.heightAnchor.constraint(equalToConstant: tenorFieldHeight),
            ])
        } else {
            let tenor = UILabel()
            var periodType = String()
            if tenorType == "day" {
                periodType = period! > 1 ? localize("days") : localize("day")
            } else if tenorType == "month" {
                periodType = period! > 1 ? localize("months") : localize("month")
            }
            tenor.text = "\(period!) \(periodType)"
            tenor.font = contentFont
            let tenorHeight = tenor.intrinsicContentSize.height
            tenor.translatesAutoresizingMaskIntoConstraints = false
            tenorView.addSubview(tenor)
            
            NSLayoutConstraint.activate([
                tenor.leadingAnchor.constraint(equalTo: tenorTitle.trailingAnchor, constant: 0),
                tenor.trailingAnchor.constraint(equalTo: tenorView.trailingAnchor, constant: 0),
                tenor.centerYAnchor.constraint(equalTo: tenorView.centerYAnchor),
                tenorView.heightAnchor.constraint(equalToConstant: tenorHeight)
            ])
        }
        
        var idrInterestRate: UITextField?
        if data.allowed_rate.contains("IDR") {
            // Interest Rate IDR
            let idrRateView = UIView()
            idrRateView.translatesAutoresizingMaskIntoConstraints = false
            rateStackView.addArrangedSubview(idrRateView)
            
            let idrRateTitleLabel = UILabel()
            idrRateTitleLabel.text = "\(localize("interest_rate")) IDR"
            idrRateTitleLabel.font = titleFont
            idrRateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            idrRateView.addSubview(idrRateTitleLabel)
            
            NSLayoutConstraint.activate([
                idrRateTitleLabel.widthAnchor.constraint(equalToConstant: titleWidth),
                idrRateTitleLabel.leadingAnchor.constraint(equalTo: idrRateView.leadingAnchor, constant: 0),
                idrRateTitleLabel.centerYAnchor.constraint(equalTo: idrRateView.centerYAnchor)
            ])
            
            // Field content
            idrInterestRate = UITextField()
            idrInterestRate!.borderStyle = .roundedRect
            idrInterestRate!.keyboardType = .numbersAndPunctuation
            idrInterestRate!.font = contentFont
            let idrInterestRateHeight = fieldHeight
            idrInterestRate!.translatesAutoresizingMaskIntoConstraints = false
            idrRateView.addSubview(idrInterestRate!)
            
            var defaultRate: String?
            if tenorType == "month" && !canEditTenor {
                switch period! {
                case 1:
                    if data.default_rate.month_rate_1 != nil {
                        defaultRate = checkPercentage(data.default_rate.month_rate_1!)
                    }
                case 3:
                    if data.default_rate.month_rate_3 != nil {
                        defaultRate = checkPercentage(data.default_rate.month_rate_3!)
                    }
                case 6:
                    if data.default_rate.month_rate_6 != nil {
                        defaultRate = checkPercentage(data.default_rate.month_rate_6!)
                    }
                default:
                    break
                }
            }
            idrInterestRate?.text = defaultRate
            
            NSLayoutConstraint.activate([
                idrInterestRate!.leadingAnchor.constraint(equalTo: idrRateTitleLabel.trailingAnchor, constant: 0),
                idrInterestRate!.trailingAnchor.constraint(equalTo: idrRateView.trailingAnchor, constant: 0),
                idrInterestRate!.topAnchor.constraint(equalTo: idrRateView.topAnchor, constant: 0),
                idrInterestRate!.bottomAnchor.constraint(equalTo: idrRateView.bottomAnchor, constant: 0),
                idrInterestRate!.heightAnchor.constraint(equalToConstant: idrInterestRateHeight)
            ])
            
            rateHeight += 40 + rateStackView.spacing
        }
        
        var usdInterestRate: UITextField?
        if data.allowed_rate.contains("USD") {
            // Interest Rate USD
            let usdRateView = UIView()
            usdRateView.translatesAutoresizingMaskIntoConstraints = false
            rateStackView.addArrangedSubview(usdRateView)
            
            let usdRateTitleLabel = UILabel()
            usdRateTitleLabel.text = "\(localize("interest_rate")) USD"
            usdRateTitleLabel.font = titleFont
            usdRateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            usdRateView.addSubview(usdRateTitleLabel)
            
            NSLayoutConstraint.activate([
                usdRateTitleLabel.widthAnchor.constraint(equalToConstant: titleWidth),
                usdRateTitleLabel.leadingAnchor.constraint(equalTo: usdRateView.leadingAnchor, constant: 0),
                usdRateTitleLabel.centerYAnchor.constraint(equalTo: usdRateView.centerYAnchor)
            ])
            
            // Field content
            usdInterestRate = UITextField()
            usdInterestRate!.borderStyle = .roundedRect
            usdInterestRate!.keyboardType = .numbersAndPunctuation
            usdInterestRate!.font = contentFont
            let usdInterestRateHeight = fieldHeight
            usdInterestRate!.translatesAutoresizingMaskIntoConstraints = false
            usdRateView.addSubview(usdInterestRate!)
            
            var defaultRate: String?
            if tenorType == "month" && !canEditTenor {
                switch period! {
                case 1:
                    if data.default_rate.month_rate_1_usd != nil {
                        defaultRate = checkPercentage(data.default_rate.month_rate_1_usd!)
                    }
                case 3:
                    if data.default_rate.month_rate_3_usd != nil {
                        defaultRate = checkPercentage(data.default_rate.month_rate_3_usd!)
                    }
                case 6:
                    if data.default_rate.month_rate_6_usd != nil {
                        defaultRate = checkPercentage(data.default_rate.month_rate_6_usd!)
                    }
                default:
                    break
                }
            }
            usdInterestRate?.text = defaultRate
            
            NSLayoutConstraint.activate([
                usdInterestRate!.leadingAnchor.constraint(equalTo: usdRateTitleLabel.trailingAnchor, constant: 0),
                usdInterestRate!.trailingAnchor.constraint(equalTo: usdRateView.trailingAnchor, constant: 0),
                usdInterestRate!.topAnchor.constraint(equalTo: usdRateView.topAnchor, constant: 0),
                usdInterestRate!.bottomAnchor.constraint(equalTo: usdRateView.bottomAnchor, constant: 0),
                usdInterestRate!.heightAnchor.constraint(equalToConstant: usdInterestRateHeight)
            ])
            
            rateHeight += 40 + rateStackView.spacing
        }
        
        var shariaInterestRate: UITextField?
        if data.allowed_rate.contains("Syariah") {
            // Interest Rate Sharia
            let shariaRateView = UIView()
            shariaRateView.translatesAutoresizingMaskIntoConstraints = false
            rateStackView.addArrangedSubview(shariaRateView)
            
            let shariaRateTitleLabel = UILabel()
            shariaRateTitleLabel.text = "\(localize("interest_rate")) \(localize("sharia"))"
            shariaRateTitleLabel.font = titleFont
            shariaRateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            shariaRateView.addSubview(shariaRateTitleLabel)
            
            NSLayoutConstraint.activate([
                shariaRateTitleLabel.widthAnchor.constraint(equalToConstant: titleWidth),
                shariaRateTitleLabel.leadingAnchor.constraint(equalTo: shariaRateView.leadingAnchor, constant: 0),
                shariaRateTitleLabel.centerYAnchor.constraint(equalTo: shariaRateView.centerYAnchor)
            ])
            
            // Field content
            shariaInterestRate = UITextField()
            shariaInterestRate!.borderStyle = .roundedRect
            shariaInterestRate!.keyboardType = .numbersAndPunctuation
            shariaInterestRate!.font = contentFont
            let shariaInterestRateHeight = fieldHeight
            shariaInterestRate!.translatesAutoresizingMaskIntoConstraints = false
            shariaRateView.addSubview(shariaInterestRate!)
            
            var defaultRate: String?
            if tenorType == "month" && !canEditTenor {
                switch period! {
                case 1:
                    if data.default_rate.month_rate_1_sharia != nil {
                        defaultRate = checkPercentage(data.default_rate.month_rate_1_sharia!)
                    }
                case 3:
                    if data.default_rate.month_rate_3_sharia != nil {
                        defaultRate = checkPercentage(data.default_rate.month_rate_3_sharia!)
                    }
                case 6:
                    if data.default_rate.month_rate_6_sharia != nil {
                        defaultRate = checkPercentage(data.default_rate.month_rate_6_sharia!)
                    }
                default:
                    break
                }
            }
            shariaInterestRate?.text = defaultRate
            
            NSLayoutConstraint.activate([
                shariaInterestRate!.leadingAnchor.constraint(equalTo: shariaRateTitleLabel.trailingAnchor, constant: 0),
                shariaInterestRate!.trailingAnchor.constraint(equalTo: shariaRateView.trailingAnchor, constant: 0),
                shariaInterestRate!.topAnchor.constraint(equalTo: shariaRateView.topAnchor, constant: 0),
                shariaInterestRate!.bottomAnchor.constraint(equalTo: shariaRateView.bottomAnchor, constant: 0),
                shariaInterestRate!.heightAnchor.constraint(equalToConstant: shariaInterestRateHeight)
            ])
            
            rateHeight += 40 + rateStackView.spacing
        }
        
        rateHeight += rateStackView.spacing
        
        NSLayoutConstraint.activate([
            rateStackView.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 15),
            rateStackView.bottomAnchor.constraint(equalTo: rateView.bottomAnchor, constant: -15),
            rateStackView.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 15),
            rateStackView.trailingAnchor.constraint(equalTo: rateView.trailingAnchor, constant: -15),
        ])
        
        if idx == 0 {
            //interestRateStackViewHeight.constant += 150
            interestRateStackViewHeight.constant += rateHeight
        } else {
            //interestRateStackViewHeight.constant += 150 + interestRateStackView.spacing
            interestRateStackViewHeight.constant += rateHeight + interestRateStackView.spacing
        }
        
        let interestRate = InterestRate(idx: interestRateIdx, tenorType: tenorType, tenor: period, tenorField: tenorField, idrField: idrInterestRate, usdField: usdInterestRate, shariaField: shariaInterestRate, isHidden: false)
        interestRates.append(interestRate)
        interestRateIdx += 1
    }
    
    @objc func deleteRateButtonTapped(sender: UIButton) {
        interestRateStackView.subviews.forEach { view in
            if view.tag == sender.tag {
                var rate = interestRates.filter { $0.idx == sender.tag }.first
                if rate != nil {
                    interestRates[sender.tag].isHidden = true
                    view.isHidden = true
                    
                    // Decrease height
                    interestRateStackViewHeight.constant -= 140
                }
            }
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        var bids = [Bid]()
        //var isValid = true
        for (idx, tenor) in interestRates.enumerated() {
            if !tenor.isHidden {
                var isTenorValid: Bool!
                var tenor: Int!
                if interestRates[idx].tenor != nil {
                    isTenorValid = true
                    tenor = interestRates[idx].tenor!
                } else {
                    isTenorValid = isInputValid(interestRates[idx].tenorField!.text, "int")
                    if isTenorValid {
                        tenor = Int(interestRates[idx].tenorField!.text!)!
                    }
                }
                
                var isIdrValid: Bool = false
                if interestRates[idx].idrField != nil {
                    isIdrValid = isInputValid(interestRates[idx].idrField!.text, "double")
                }
                
                var isUsdValid: Bool = false
                if interestRates[idx].usdField != nil {
                    isUsdValid = isInputValid(interestRates[idx].usdField!.text, "double")
                }
                
                var isShariaValid: Bool = false
                if interestRates[idx].shariaField != nil {
                    isShariaValid = isInputValid(interestRates[idx].shariaField!.text, "double")
                }
                
                if isTenorValid && isIdrValid || isUsdValid || isShariaValid {
                    let idr = isIdrValid ? Double(interestRates[idx].idrField!.text!) : nil
                    let usd = isUsdValid ? Double(interestRates[idx].usdField!.text!) : nil
                    let sharia = isShariaValid ? Double(interestRates[idx].shariaField!.text!) : nil
                    let bid = Bid(id: tenor, auction_header_id: 0, is_accepted: "", is_winner: "", interest_rate_idr: idr, interest_rate_usd: usd, interest_rate_sharia: sharia, used_investment_value: 0, bilyet: [], chosen_rate: nil, period: interestRates[idx].tenorType)
                    bids.append(bid)
                } else {
                    //isValid = false
                    continue
                }
            }
        }
        showLoading(true)
        presenter.saveAuction(id, bids, maxPlacementTextField != nil ? maxPlacementTextField.text! : "")
    }
    
    @objc func confirmationButtonPressed(sender: UIButton) {
        let idx = sender.tag
        let bidID = data.bids[idx].id
        
        confirmationType = "chosen_winner"
        confirmationID = bidID
        
        self.performSegue(withIdentifier: "showConfirmation", sender: self)
    }
    
    func isInputValid(_ input: String?, _ dataType: String) -> Bool {
        if dataType == "int" {
            if input == nil || (Int(input!) == nil) {
                return false
            } else {
                return true
            }
        } else if dataType == "double" {
            if input == nil || (Double(input!) == nil) {
                return false
            } else {
                return true
            }
        }
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
}

extension AuctionDetailNormalViewController: AuctionDetailNormalDelegate {
    func setData(_ data: AuctionDetailNormal) {
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
        showLoading(false)
        //presenter.getAuction(id)
        showAlert(message, isSuccess)
    }
    
    func openLoginPage() {
        let authStoryboard : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginViewController : UIViewController = authStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
}

extension AuctionDetailNormalViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted

        let components = string.components(separatedBy: inverseSet)

        let filtered = components.joined(separator: "")

        if filtered == string {
            return true
        } else {
            if string == Locale.current.decimalSeparator {
                let countdots = textField.text!.components(separatedBy: ".").count - 1
                if countdots == 0 {
                    return true
                }else{
                    if countdots > 0 && string == Locale.current.decimalSeparator {
                        return false
                    } else {
                        return true
                    }
                }
            }else{
                return false
            }
        }
    }
}
