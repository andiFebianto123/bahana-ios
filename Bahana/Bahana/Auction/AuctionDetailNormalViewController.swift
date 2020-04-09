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
    
    var currentHeight: CGFloat!
    
    var presenter: AuctionDetailNormalPresenter!
    
    var id = Int()
    var data: AuctionDetailNormal!
    
    var interestRates = [InterestRate]()
    var interestRateIdx = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = backgroundColor
        
        let titleFont = UIFont.systemFont(ofSize: 11)
        let contentFont = UIFont.boldSystemFont(ofSize: 12)
        
        titleLabel.text = localize("auction").uppercased()
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
        interestRateAddDayButton.backgroundColor = UIColorFromHex(rgbValue: 0x87cc62)
        interestRateAddDayButton.setTitleColor(UIColorFromHex(rgbValue: 0x318803), for: .normal)
        interestRateAddDayButton.layer.cornerRadius = 5
        interestRateAddMonthButton.backgroundColor = UIColorFromHex(rgbValue: 0x63cb7c)
        interestRateAddMonthButton.setTitleColor(UIColorFromHex(rgbValue: 0x2b890f), for: .normal)
        interestRateAddMonthButton.layer.cornerRadius = 5
        maxPlacementTitleLabel.text = localize("max_placement").uppercased()
        maxPlacementTitleLabel.textColor = primaryColor
        maxPlacementTextField.placeholder = localize("max_placement")
        submitButton.backgroundColor = primaryColor
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 5
        
        presenter = AuctionDetailNormalPresenter(delegate: self)
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
        var investment = "IDR \(toIdrBio(data.investment_range_start))"
        if data.investment_range_end != nil {
            investment += " - \(toIdrBio(data.investment_range_end!))"
        }
        investmentLabel.text = investment
        placementDateLabel.text = convertDateToString(convertStringToDatetime(data.start_date)!)
        custodianBankLabel.text = data.custodian_bank != nil ? data.custodian_bank : "-"
        picCustodianLabel.text = data.pic_custodian != nil ? data.pic_custodian : "-"
        
        // Note
        noteLabel.text = data.notes
        
        setBids(data.bids)
        
        for detail in data.details {
            addInterestRate(detail.td_period_type, false, detail.td_period)
        }
        
        // Action
        if data.view == 0 || data.view == 1 {
            interestRateParentStackView.isHidden = true
            interestRateButtonStackView.isHidden = true
            maxPlacementStackView.isHidden = true
        } else if data.view == 2 {
            
        }
        
        let footerDate = convertDateToString(convertStringToDatetime(data.start_date)!, format: "ddMMyy")!
        
        footerLabel.text = """
        \(localize("auction_detail_footer"))
        Ref Code : NP.\(data.portfolio_short).\(footerDate)
        """
    }
    
    func setBids(_ bidData: [Bid]) {
        var totalRateViewHeight: CGFloat = 0
        for dt in bidData {
            let rateView = UIView()
            if dt.is_winner == "yes" {
                rateView.backgroundColor = UIColorFromHex(rgbValue: 0xb4eeb4)
            } else {
                rateView.backgroundColor = .white
            }
            var rateViewHeight: CGFloat = 50
            //rateView.translatesAutoresizingMaskIntoConstraints = false
            
            let titleFont = UIFont.boldSystemFont(ofSize: 10)
            let contentFont = UIFont.systemFont(ofSize: 10)
            
            let statusTitle = UILabel()
            statusTitle.text = localize("status")
            statusTitle.font = titleFont
            statusTitle.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(statusTitle)
            let status = UILabel()
            if dt.is_winner == "yes" {
                if dt.is_accepted == "yes" {
                    status.text = "Win (\(localize("accepted")))"
                } else {
                    status.text = "Win (\(localize("pending")))"
                }
            } else {
                status.text = localize("pending")
            }
            status.font = contentFont
            status.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(status)
            
            let tenorTitle = UILabel()
            tenorTitle.text = localize("tenor")
            tenorTitle.font = titleFont
            tenorTitle.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(tenorTitle)
            let tenor = UILabel()
            tenor.text = dt.period
            tenor.font = contentFont
            tenor.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(tenor)
            
            let interestRateView = UIView()
            interestRateView.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(interestRateView)
            
            let interestRateTitle = UILabel()
            interestRateTitle.text = localize("interest_rate")
            interestRateTitle.font = titleFont
            interestRateTitle.translatesAutoresizingMaskIntoConstraints = false
            interestRateView.addSubview(interestRateTitle)
            var interestRateContent = """
            """
            var interestRateViewHeight: CGFloat = 5
            if dt.interest_rate_idr != nil {
                interestRateContent += "(IDR) \(checkPercentage(dt.interest_rate_idr!)) %"
                if dt.choosen_rate != nil && dt.choosen_rate == "IDR" {
                    interestRateContent += " [Chosen Rate]\n"
                } else {
                    interestRateContent += "\n"
                }
                rateViewHeight += 10
                interestRateViewHeight += 10
            }
            if dt.interest_rate_usd != nil {
                interestRateContent += "(USD) \(checkPercentage(dt.interest_rate_usd!)) %"
                if dt.choosen_rate != nil && dt.choosen_rate == "USD" {
                    interestRateContent += " [Chosen Rate]\n"
                } else {
                    interestRateContent += "\n"
                }
                rateViewHeight += 10
                interestRateViewHeight += 10
            }
            if dt.interest_rate_sharia != nil {
                interestRateContent += "(Sharia) \(checkPercentage(dt.interest_rate_sharia!)) %"
                if dt.choosen_rate != nil && dt.choosen_rate == "Sharia" {
                    interestRateContent += " [Chosen Rate]\n"
                } else {
                    interestRateContent += "\n"
                }
                rateViewHeight += 10
                interestRateViewHeight += 10
            }
            let interestRate = UILabel()
            interestRate.text = interestRateContent
            interestRate.numberOfLines = 0
            interestRate.font = contentFont
            interestRate.translatesAutoresizingMaskIntoConstraints = false
            interestRateView.addSubview(interestRate)
            
            bidStackView.addArrangedSubview(rateView)
            
            NSLayoutConstraint.activate([
                //rateView.leadingAnchor.constraint(equalTo: bidStackView.leadingAnchor),
                //rateView.trailingAnchor.constraint(equalTo: bidStackView.trailingAnchor),
                statusTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 15),
                statusTitle.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 20),
                statusTitle.heightAnchor.constraint(equalToConstant: 14),
                status.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 125),
                status.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 20),
                status.heightAnchor.constraint(equalToConstant: 14),
                
                tenorTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 15),
                tenorTitle.topAnchor.constraint(equalTo: statusTitle.bottomAnchor, constant: 10),
                tenorTitle.heightAnchor.constraint(equalToConstant: 14),
                tenor.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 125),
                tenor.topAnchor.constraint(equalTo: status.bottomAnchor, constant: 10),
                tenor.heightAnchor.constraint(equalToConstant: 14),
                
                interestRateView.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 15),
                interestRateView.trailingAnchor.constraint(equalTo: rateView.trailingAnchor, constant: -15),
                interestRateView.topAnchor.constraint(equalTo: tenorTitle.bottomAnchor, constant: 10),
                interestRateView.heightAnchor.constraint(equalToConstant: interestRateViewHeight),
                interestRateTitle.leadingAnchor.constraint(equalTo: interestRateView.leadingAnchor, constant: 0),
                interestRateTitle.topAnchor.constraint(equalTo: interestRateView.topAnchor, constant: 0),
                interestRateTitle.widthAnchor.constraint(equalToConstant: 110),
                interestRate.leadingAnchor.constraint(equalTo: interestRateTitle.trailingAnchor, constant: 0),
                interestRate.trailingAnchor.constraint(equalTo: interestRateView.trailingAnchor, constant: 0),
                interestRate.topAnchor.constraint(equalTo: interestRateView.topAnchor, constant: 0),
                //interestRate.bottomAnchor.constraint(equalTo: interestRateView.bottomAnchor, constant: 0),
            ])
            
            if dt.is_winner == "yes" {
                let investmentStackView = UIStackView()
                investmentStackView.axis = .horizontal
                investmentStackView.translatesAutoresizingMaskIntoConstraints = false
                rateView.addSubview(investmentStackView)
                
                let investmentTitle = UILabel()
                investmentTitle.text = localize("investment")
                investmentTitle.font = titleFont
                investmentTitle.translatesAutoresizingMaskIntoConstraints = false
                investmentStackView.addArrangedSubview(investmentTitle)
                
                let investment = UILabel()
                investment.text = "IDR \(toIdrBio(dt.used_investment_value))"
                investment.font = contentFont
                investment.translatesAutoresizingMaskIntoConstraints = false
                investmentStackView.addArrangedSubview(investment)
                
                let bilyetStackView = UIStackView()
                bilyetStackView.axis = .horizontal
                bilyetStackView.translatesAutoresizingMaskIntoConstraints = false
                rateView.addSubview(bilyetStackView)
                
                let bilyetTitleView = UIView()
                bilyetTitleView.backgroundColor = .clear
                bilyetTitleView.translatesAutoresizingMaskIntoConstraints = false
                bilyetStackView.addArrangedSubview(bilyetTitleView)
                
                let bilyetTitle = UILabel()
                bilyetTitle.text = localize("bilyet")
                bilyetTitle.font = titleFont
                bilyetTitle.translatesAutoresizingMaskIntoConstraints = false
                bilyetTitleView.addSubview(bilyetTitle)
               
                var bilyetStr = """
                """
                for bilyetArr in dt.bilyet {
                    bilyetStr += "\u{2022} IDR \(toIdrBio(bilyetArr.quantity)) [\(convertDateToString(convertStringToDatetime(bilyetArr.issue_date)!)!) - \(convertDateToString(convertStringToDatetime(bilyetArr.maturity_date)!)!)]\n"
                }
                let cnt = CGFloat(dt.bilyet.count)
                
                let bilyet = UILabel()
                bilyet.text = bilyetStr
                bilyet.numberOfLines = 0
                bilyet.font = contentFont
                bilyet.translatesAutoresizingMaskIntoConstraints = false
                bilyetStackView.addArrangedSubview(bilyet)
                
                NSLayoutConstraint.activate([
                    investmentStackView.heightAnchor.constraint(equalToConstant: 30),
                    investmentStackView.topAnchor.constraint(equalTo: interestRateView.bottomAnchor, constant: 0),
                    investmentStackView.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 15),
                    investmentStackView.trailingAnchor.constraint(equalTo: rateView.trailingAnchor, constant: 15),
                    investmentTitle.leadingAnchor.constraint(equalTo: investmentStackView.leadingAnchor, constant: 0),
                    investmentTitle.topAnchor.constraint(equalTo: investmentStackView.bottomAnchor, constant: 0),
                    investmentTitle.widthAnchor.constraint(equalToConstant: 110),
                    investment.leadingAnchor.constraint(equalTo: investmentTitle.trailingAnchor, constant: 0),
                    investment.topAnchor.constraint(equalTo: investmentStackView.topAnchor, constant: 0),
                    investment.bottomAnchor.constraint(equalTo: investmentStackView.bottomAnchor, constant: 0),
                    
                    bilyetStackView.topAnchor.constraint(equalTo: investmentStackView.bottomAnchor, constant: 10),
                    bilyetStackView.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 15),
                    bilyetStackView.trailingAnchor.constraint(equalTo: rateView.trailingAnchor, constant: -15),
                    //bilyetView.bottomAnchor.constraint(equalTo: rateView.bottomAnchor, constant: -15),
                    //bilyetStackView.heightAnchor.constraint(equalToConstant: bilyetViewHeight),
                    bilyetTitleView.leadingAnchor.constraint(equalTo: bilyetStackView.leadingAnchor, constant: 0),
                    bilyetTitleView.topAnchor.constraint(equalTo: bilyetStackView.topAnchor, constant: 0),
                    bilyetTitleView.bottomAnchor.constraint(equalTo: bilyetStackView.bottomAnchor, constant: 0),
                    bilyetTitleView.widthAnchor.constraint(equalToConstant: 110),
                    bilyetTitle.leadingAnchor.constraint(equalTo: bilyetTitleView.leadingAnchor, constant: 0),
                    bilyetTitle.topAnchor.constraint(equalTo: bilyetTitleView.topAnchor, constant: 0),
                    bilyet.leadingAnchor.constraint(equalTo: bilyetTitle.trailingAnchor, constant: 0),
                    bilyet.trailingAnchor.constraint(equalTo: bilyetStackView.trailingAnchor, constant: 0),
                    bilyet.topAnchor.constraint(equalTo: bilyetStackView.topAnchor, constant: 0),
                    bilyet.bottomAnchor.constraint(equalTo: bilyetStackView.bottomAnchor, constant: 0)
                ])
                
                bilyetTitle.sizeToFit()
                
                var bilyetViewHeight: CGFloat = 20
                rateViewHeight += CGFloat(50) + (bilyetViewHeight * cnt - 1)
                
                if self.data.view == 2 && dt.is_accepted == "pending" {
                    let confirmButton = UIButton()
                    confirmButton.setTitle(localize("confirm"), for: .normal)
                    confirmButton.setTitleColor(UIColor.white, for: .normal)
                    confirmButton.titleLabel?.font = contentFont
                    confirmButton.backgroundColor = UIColorFromHex(rgbValue: 0x2a91ff)
                    confirmButton.layer.cornerRadius = 3
                    confirmButton.addTarget(self, action: #selector(confirmationButtonPressed), for: .touchUpInside)
                    confirmButton.translatesAutoresizingMaskIntoConstraints = false
                    rateView.addSubview(confirmButton)
                    
                    NSLayoutConstraint.activate([
                        confirmButton.topAnchor.constraint(equalTo: bilyetStackView.bottomAnchor, constant: 15),
                        //confirmButton.bottomAnchor.constraint(equalTo: rateView.bottomAnchor, constant: -10),
                        confirmButton.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 15),
                        confirmButton.trailingAnchor.constraint(equalTo: rateView.trailingAnchor, constant: -15),
                    ])
                    
                    rateViewHeight += 30
                }
            }
            
            bidStackViewHeight.constant += rateViewHeight + 20
            totalRateViewHeight += rateViewHeight
        }
        
        currentHeight += totalRateViewHeight
        setHeight(currentHeight)
    }
    
    @IBAction func addInterestRateDayButtonPressed(_ sender: Any) {
        addInterestRate("day", true)
    }
    
    @IBAction func addInterestRateMonthButtonPressed(_ sender: Any) {
        addInterestRate("month", true)
    }
    
    func addInterestRate(_ tenorType: String, _ canEditTenor: Bool, _ period: Int? = nil) {
        let rateView = UIView()
        rateView.tag = interestRateIdx
        rateView.backgroundColor = .white
        //rateView.translatesAutoresizingMaskIntoConstraints = false
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
            tenorView.heightAnchor.constraint(equalToConstant: 25),
            tenorTitle.leadingAnchor.constraint(equalTo: tenorView.leadingAnchor, constant: 0),
            tenorTitle.widthAnchor.constraint(equalToConstant: titleWidth),
            tenorTitle.centerYAnchor.constraint(equalTo: tenorView.centerYAnchor)
        ])
        
        var tenorField: UITextField?
        if canEditTenor {
            tenorField = UITextField()
            tenorField!.borderStyle = .roundedRect
            tenorField!.keyboardType = .numbersAndPunctuation
            tenorField!.font = contentFont
            tenorField!.translatesAutoresizingMaskIntoConstraints = false
            tenorView.addSubview(tenorField!)
            
            let period = UILabel()
            if tenorType == "day" {
                period.text = "Day(s)"
            } else if tenorType == "month" {
                period.text = "Month(s)"
            }
            period.font = UIFont.systemFont(ofSize: 14)
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
                deleteButton.centerYAnchor.constraint(equalTo: tenorView.centerYAnchor)
            ])
        } else {
            let tenor = UILabel()
            var periodType = String()
            if tenorType == "day" {
                periodType = period! > 1 ? "Days" : "Day"
            } else if tenorType == "month" {
                periodType = period! > 1 ? "Months" : "Month"
            }
            tenor.text = "\(period!) \(periodType)"
            tenor.font = contentFont
            tenor.translatesAutoresizingMaskIntoConstraints = false
            tenorView.addSubview(tenor)
            
            NSLayoutConstraint.activate([
                tenor.leadingAnchor.constraint(equalTo: tenorTitle.trailingAnchor, constant: 0),
                tenor.trailingAnchor.constraint(equalTo: tenorView.trailingAnchor, constant: 0),
                tenor.centerYAnchor.constraint(equalTo: tenorView.centerYAnchor)
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
            // Label Content
            /*let idrRateLabel = UILabel()
            idrRateLabel.font = contentFont
            idrRateLabel.numberOfLines = 0
            idrRateLabel.text = """
            Test 2
            Test 3
            Test 4
            """
            idrRateLabel.translatesAutoresizingMaskIntoConstraints = false
            idrRateView.addSubview(usdRateLabel)
            
            NSLayoutConstraint.activate([
                idrRateLabel.leadingAnchor.constraint(equalTo: idrRateTitleLabel.trailingAnchor, constant: 0),
                idrRateLabel.topAnchor.constraint(equalTo: idrRateView.topAnchor, constant: 0),
                idrRateLabel.bottomAnchor.constraint(equalTo: idrRateView.bottomAnchor, constant: 0)
            ])*/
            
            // Field content
            idrInterestRate = UITextField()
            idrInterestRate!.borderStyle = .roundedRect
            idrInterestRate!.keyboardType = .numbersAndPunctuation
            idrInterestRate!.font = contentFont
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
                idrInterestRate!.heightAnchor.constraint(equalToConstant: 25)
            ])
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
            // Label Content
            /*let usdRateLabel = UILabel()
            usdRateLabel.font = contentFont
            usdRateLabel.numberOfLines = 0
            usdRateLabel.text = """
            Test 2
            Test 3
            Test 4
            """
            usdRateLabel.translatesAutoresizingMaskIntoConstraints = false
            usdRateView.addSubview(usdRateLabel)
            
            NSLayoutConstraint.activate([
                usdRateLabel.leadingAnchor.constraint(equalTo: usdRateTitleLabel.trailingAnchor, constant: 0),
                usdRateLabel.topAnchor.constraint(equalTo: usdRateView.topAnchor, constant: 0),
                usdRateLabel.bottomAnchor.constraint(equalTo: usdRateView.bottomAnchor, constant: 0)
            ])*/
            
            // Field content
            usdInterestRate = UITextField()
            usdInterestRate!.borderStyle = .roundedRect
            usdInterestRate!.keyboardType = .numbersAndPunctuation
            usdInterestRate!.font = contentFont
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
                usdInterestRate!.heightAnchor.constraint(equalToConstant: 25)
            ])
        }
        
        var shariaInterestRate: UITextField?
        if data.allowed_rate.contains("Syariah") {
            // Interest Rate Sharia
            let shariaRateView = UIView()
            shariaRateView.translatesAutoresizingMaskIntoConstraints = false
            rateStackView.addArrangedSubview(shariaRateView)
            
            let shariaRateTitleLabel = UILabel()
            shariaRateTitleLabel.text = "\(localize("interest_rate")) Syariah"
            shariaRateTitleLabel.font = titleFont
            shariaRateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            shariaRateView.addSubview(shariaRateTitleLabel)
            
            NSLayoutConstraint.activate([
                shariaRateTitleLabel.widthAnchor.constraint(equalToConstant: titleWidth),
                shariaRateTitleLabel.leadingAnchor.constraint(equalTo: shariaRateView.leadingAnchor, constant: 0),
                shariaRateTitleLabel.centerYAnchor.constraint(equalTo: shariaRateView.centerYAnchor)
            ])
            // Label Content
            /*let shariaRateLabel = UILabel()
            shariaRateLabel.font = contentFont
            shariaRateLabel.numberOfLines = 0
            shariaRateLabel.text = """
            Test 2
            Test 3
            Test 4
            """
            shariaRateLabel.translatesAutoresizingMaskIntoConstraints = false
            shariaRateView.addSubview(usdRateLabel)
            
            NSLayoutConstraint.activate([
                shariaRateLabel.leadingAnchor.constraint(equalTo: shariaRateTitleLabel.trailingAnchor, constant: 0),
                shariaRateLabel.topAnchor.constraint(equalTo: shariaRateView.topAnchor, constant: 0),
                shariaRateLabel.bottomAnchor.constraint(equalTo: shariaRateView.bottomAnchor, constant: 0)
            ])*/
            
            // Field content
            shariaInterestRate = UITextField()
            shariaInterestRate!.borderStyle = .roundedRect
            shariaInterestRate!.keyboardType = .numbersAndPunctuation
            shariaInterestRate!.font = contentFont
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
                shariaInterestRate!.heightAnchor.constraint(equalToConstant: 25)
            ])
        }
        
        NSLayoutConstraint.activate([
            rateStackView.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 15),
            rateStackView.bottomAnchor.constraint(equalTo: rateView.bottomAnchor, constant: -15),
            rateStackView.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 15),
            rateStackView.trailingAnchor.constraint(equalTo: rateView.trailingAnchor, constant: -15),
        ])
        
        let addHeight: CGFloat = 120
        interestRateStackViewHeight.constant += addHeight
        
        currentHeight += addHeight
        setHeight(currentHeight)
        
        let interestRate = InterestRate(idx: interestRateIdx, tenorType: tenorType, tenor: period, tenorField: tenorField, idrField: idrInterestRate, usdField: usdInterestRate, shariaField: shariaInterestRate, isHidden: false)
        interestRates.append(interestRate)
        interestRateIdx += 1
    }
    
    @objc func deleteRateButtonTapped(sender: UIButton) {
        interestRateStackView.subviews.forEach { view in
            if view.tag == sender.tag {
                var rate = interestRates.filter { $0.idx == sender.tag }.first
                if rate != nil {
                    rate!.isHidden = true
                    view.isHidden = true
                    
                    // Decrease height
                    interestRateStackViewHeight.constant -= 140
                    
                    currentHeight -= CGFloat(140)
                    setHeight(currentHeight)
                }
            }
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        var bids = [Bid]()
        var isValid = true
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
                let isIdrValid = isInputValid(interestRates[idx].idrField!.text, "double")
                let isShariaValid = isInputValid(interestRates[idx].shariaField!.text, "double")
                if isTenorValid && isIdrValid && isShariaValid {
                    let idr = Double(interestRates[idx].idrField!.text!)
                    let usd = Double(0)
                    let sharia = Double(interestRates[idx].shariaField!.text!)
                    let bid = Bid(id: tenor, auction_header_id: 0, is_accepted: "", is_winner: "", interest_rate_idr: idr, interest_rate_usd: usd, interest_rate_sharia: sharia, used_investment_value: 0, bilyet: [], choosen_rate: nil, period: interestRates[idx].tenorType)
                    bids.append(bid)
                } else {
                    isValid = false
                    break
                }
            }
        }
        
        if isValid {
            presenter.saveAuction(id, bids, maxPlacementTextField != nil ? maxPlacementTextField.text! : "")
        } else {
            showAlert("Invalid")
        }
    }
    
    @objc func confirmationButtonPressed() {
        NotificationCenter.default.post(name: Notification.Name("AuctionDetailConfirmation"), object: nil, userInfo: ["date": data.end_date])
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
    
    func showAlert(_ message: String) {
        NotificationCenter.default.post(name: Notification.Name("AuctionDetailAlert"), object: nil, userInfo: ["message": message])
    }
    
    func setHeight(_ height: CGFloat) {
        NotificationCenter.default.post(name: Notification.Name("AuctionDetailHeight"), object: nil, userInfo: ["height": height])
    }
}

extension AuctionDetailNormalViewController: AuctionDetailNormalDelegate {
    func setData(_ data: AuctionDetailNormal) {
        self.data = data
        showLoading(false)
        setContent()
    }
    
    func isPosted(_ isSuccess: Bool, _ message: String) {
        //presenter.getAuction(id)
        showAlert(message)
        navigationController?.popViewController(animated: true)
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
