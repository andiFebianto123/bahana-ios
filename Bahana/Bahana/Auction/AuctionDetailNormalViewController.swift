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
        
        titleLabel.text = localize("auction").uppercased()
        titleLabel.textColor = primaryColor
        statusView.layer.cornerRadius = 10
        let cardBackgroundColor = UIColorFromHex(rgbValue: 0xffe0e0)
        portfolioView.backgroundColor = cardBackgroundColor
        portfolioView.layer.cornerRadius = 5
        portfolioView.layer.shadowColor = UIColor.gray.cgColor
        portfolioView.layer.shadowOffset = CGSize(width: 0, height: 0)
        portfolioView.layer.shadowRadius = 4
        portfolioView.layer.shadowOpacity = 0.5
        fundNameTitleLabel.text = localize("fund_name")
        investmentTitleLabel.text = localize("investment")
        placementDateTitleLabel.text = localize("placement_date")
        custodianBankTitleLabel.text = localize("custodian_bank")
        picCustodianTitleLabel.text = localize("pic_custodian")
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
        maxPlacementTitleLabel.text = localize("max_placement")
        maxPlacementTitleLabel.textColor = primaryColor
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
        }
        
        // Portfolio
        fundNameLabel.text = data.portfolio
        //investmentLabel.text = "IDR \(toIdrBio(data.investment_range_start)) - \(toIdrBio(data.investment_range_end != nil ? data.investment_range_end! : 0))"
        investmentLabel.text = "IDR \(toIdrBio(data.investment_range_start))"
        placementDateLabel.text = convertDateToString(convertStringToDatetime(data.start_date)!)
        custodianBankLabel.text = data.custodian_bank != nil ? data.custodian_bank : "-"
        picCustodianLabel.text = data.pic_custodian != nil ? data.pic_custodian : "-"
        
        // Note
        noteLabel.text = data.notes
        
        setBids(data.bids)
        
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
        for dt in bidData {
            let rateView = UIView()
            if dt.is_winner == "yes" {
                rateView.backgroundColor = UIColorFromHex(rgbValue: 0xb4eeb4)
            } else {
                rateView.backgroundColor = .white
            }
            var rateViewHeight: CGFloat = 70
            //rateView.translatesAutoresizingMaskIntoConstraints = false
            
            let titleFont = UIFont.boldSystemFont(ofSize: 12)
            let contentFont = UIFont.systemFont(ofSize: 12)
            
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
            var interestRateViewHeight: CGFloat = 15
            if dt.interest_rate_idr != nil {
                interestRateContent += "(IDR) \(dt.interest_rate_idr!)%"
                if dt.choosen_rate != nil && dt.choosen_rate == "IDR" {
                    interestRateContent += " [Chosen Rate]\n"
                } else {
                    interestRateContent += "\n"
                }
                rateViewHeight += 15
                interestRateViewHeight += 15
            }
            if dt.interest_rate_usd != nil {
                interestRateContent += "(USD) \(dt.interest_rate_usd!)%"
                if dt.choosen_rate != nil && dt.choosen_rate == "USD" {
                    interestRateContent += " [Chosen Rate]\n"
                } else {
                    interestRateContent += "\n"
                }
                rateViewHeight += 15
                interestRateViewHeight += 15
            }
            if dt.interest_rate_sharia != nil {
                interestRateContent += "(Sharia) \(dt.interest_rate_sharia!)%"
                if dt.choosen_rate != nil && dt.choosen_rate == "Sharia" {
                    interestRateContent += " [Chosen Rate]\n"
                } else {
                    interestRateContent += "\n"
                }
                rateViewHeight += 15
                interestRateViewHeight += 15
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
                let investmentTitle = UILabel()
                investmentTitle.text = localize("investment")
                investmentTitle.font = titleFont
                investmentTitle.translatesAutoresizingMaskIntoConstraints = false
                rateView.addSubview(investmentTitle)
                
                let investment = UILabel()
                investment.text = "IDR \(toIdrBio(dt.used_investment_value))"
                investment.font = contentFont
                investment.translatesAutoresizingMaskIntoConstraints = false
                rateView.addSubview(investment)
                
                let bilyetView = UIView()
                bilyetView.translatesAutoresizingMaskIntoConstraints = false
                rateView.addSubview(bilyetView)
                
                let bilyetTitle = UILabel()
                bilyetTitle.text = localize("bilyet")
                bilyetTitle.font = titleFont
                bilyetTitle.translatesAutoresizingMaskIntoConstraints = false
                bilyetView.addSubview(bilyetTitle)
               
                var bilyetStr = """
                """
                for bilyetArr in dt.bilyet {
                    bilyetStr += "- IDR \(toIdrBio(bilyetArr.quantity)) [\(convertDateToString(convertStringToDatetime(bilyetArr.issue_date)!)!) - \(convertDateToString(convertStringToDatetime(bilyetArr.maturity_date)!)!)]\n"
                }
                let cnt = CGFloat(dt.bilyet.count)
                
                var bilyetViewHeight: CGFloat = 15
                let bilyet = UILabel()
                bilyet.text = bilyetStr
                bilyet.numberOfLines = 0
                bilyet.font = contentFont
                bilyet.translatesAutoresizingMaskIntoConstraints = false
                bilyetView.addSubview(bilyet)
                
                NSLayoutConstraint.activate([
                    investmentTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 15),
                    investmentTitle.topAnchor.constraint(equalTo: interestRateView.bottomAnchor, constant: 0),
                    investmentTitle.heightAnchor.constraint(equalToConstant: 14),
                    investment.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 125),
                    investment.topAnchor.constraint(equalTo: interestRateView.bottomAnchor, constant: 0),
                    investment.heightAnchor.constraint(equalToConstant: 14),
                    
                    bilyetView.topAnchor.constraint(equalTo: investment.bottomAnchor, constant: 10),
                    bilyetView.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 15),
                    bilyetView.trailingAnchor.constraint(equalTo: rateView.trailingAnchor, constant: -15),
                    //bilyetView.bottomAnchor.constraint(equalTo: rateView.bottomAnchor, constant: -15),
                    bilyetView.heightAnchor.constraint(equalToConstant: bilyetViewHeight),
                    bilyetTitle.leadingAnchor.constraint(equalTo: bilyetView.leadingAnchor, constant: 0),
                    bilyetTitle.topAnchor.constraint(equalTo: bilyetView.topAnchor, constant: 0),
                    bilyetTitle.widthAnchor.constraint(equalToConstant: 110),
                    bilyet.leadingAnchor.constraint(equalTo: bilyetTitle.trailingAnchor, constant: 0),
                    bilyet.trailingAnchor.constraint(equalTo: bilyetView.trailingAnchor, constant: 0),
                    bilyet.topAnchor.constraint(equalTo: bilyetView.topAnchor, constant: 0),
                    bilyet.bottomAnchor.constraint(equalTo: bilyetView.bottomAnchor, constant: 0)
                ])
                
                rateViewHeight += 50 + (bilyetViewHeight * cnt - 1)
                
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
                        confirmButton.topAnchor.constraint(equalTo: bilyetView.bottomAnchor, constant: 15),
                        //confirmButton.bottomAnchor.constraint(equalTo: rateView.bottomAnchor, constant: -10),
                        confirmButton.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 15),
                        confirmButton.trailingAnchor.constraint(equalTo: rateView.trailingAnchor, constant: -15),
                    ])
                    
                    rateViewHeight += 30
                }
            }
            
            bidStackViewHeight.constant += rateViewHeight
        }
    }
    
    @IBAction func addInterestRateDayButtonPressed(_ sender: Any) {
        addInterestRate("day")
    }
    
    @IBAction func addInterestRateMonthButtonPressed(_ sender: Any) {
        addInterestRate("month")
    }
    
    func addInterestRate(_ tenorType: String) {
        let rateView = UIView()
        rateView.tag = interestRateIdx
        rateView.backgroundColor = .white
        //rateView.translatesAutoresizingMaskIntoConstraints = false
        interestRateStackView.addArrangedSubview(rateView)
        
        let rateStackView = UIStackView()
        rateStackView.axis = .vertical
        rateStackView.spacing = 10
        rateStackView.translatesAutoresizingMaskIntoConstraints = false
        rateView.addSubview(rateStackView)
        
        let titleFont = UIFont.boldSystemFont(ofSize: 12)
        let contentFont = UIFont.systemFont(ofSize: 12)
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
        let tenor = UITextField()
        tenor.borderStyle = .roundedRect
        tenor.keyboardType = .numbersAndPunctuation
        tenor.font = contentFont
        tenor.translatesAutoresizingMaskIntoConstraints = false
        tenorView.addSubview(tenor)
        
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
            tenorView.heightAnchor.constraint(equalToConstant: 25),
            tenorTitle.leadingAnchor.constraint(equalTo: tenorView.leadingAnchor, constant: 0),
            tenorTitle.widthAnchor.constraint(equalToConstant: titleWidth),
            tenorTitle.centerYAnchor.constraint(equalTo: tenorView.centerYAnchor),
            tenor.leadingAnchor.constraint(equalTo: tenorTitle.trailingAnchor, constant: 0),
            tenor.trailingAnchor.constraint(equalTo: tenorView.trailingAnchor, constant: -80),
            //tenor.topAnchor.constraint(equalTo: tenorView.topAnchor, constant: 0),
            //tenor.heightAnchor.constraint(equalToConstant: 25),
            tenor.centerYAnchor.constraint(equalTo: tenorView.centerYAnchor),
            period.leadingAnchor.constraint(equalTo: tenor.trailingAnchor, constant: 5),
            period.centerYAnchor.constraint(equalTo: tenorView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 25),
            deleteButton.heightAnchor.constraint(equalToConstant: 25),
            deleteButton.trailingAnchor.constraint(equalTo: tenorView.trailingAnchor, constant: 0),
            deleteButton.centerYAnchor.constraint(equalTo: tenorView.centerYAnchor)
        ])
        
        let addHeight: CGFloat = 120
        interestRateStackViewHeight.constant += addHeight
        
        currentHeight += addHeight
        setHeight(currentHeight)
        
        let interestRate = InterestRate(idx: interestRateIdx, tenorType: tenorType, tenorField: tenor, idrField: idrInterestRate, usdField: usdInterestRate, shariaField: shariaInterestRate, isHidden: false)
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
                if isInputValid(interestRates[idx].tenorField!.text, "int") && isInputValid(interestRates[idx].idrField!.text, "double") &&
                    isInputValid(interestRates[idx].shariaField!.text, "double") {
                    let tenor = Int(interestRates[idx].tenorField!.text!)!
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
        print("presedd")
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
        showAlert(message)
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
