//
//  AuctionDetailNormalViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/25.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var interestRateTitleLabel: UILabel!
    @IBOutlet weak var interestRateStackView: UIStackView!
    @IBOutlet weak var interestRateStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var interestRateButtonStackView: UIStackView!
    @IBOutlet weak var interestRateAddDayButton: UIButton!
    @IBOutlet weak var interestRateAddMonthButton: UIButton!
    @IBOutlet weak var maxPlacementTitleLabel: UILabel!
    @IBOutlet weak var maxPlacementTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var footerLabel: UILabel!
    
    var loadingView = UIView()
    
    var presenter: AuctionDetailNormalPresenter!
    
    var id = Int()
    var data: AuctionDetailNormal!
    
    var interestRateTenorType = [String]()
    var interestRateTenorFields = [UITextField]()
    var interestRateIdrFields = [UITextField]()
    var interestRateShariaFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = backgroundColor
        
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
        noteTitleLabel.text = localize("notes")
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
            interestRateTitleLabel.isHidden = true
            interestRateStackView.isHidden = true
            interestRateButtonStackView.isHidden = true
            maxPlacementTitleLabel.isHidden = true
            maxPlacementTextField.isHidden = true
            submitButton.isHidden = true
        } else if data.view == 2 {
            
        }
        
        footerLabel.text = """
        \(localize("auction_detail_footer"))
        """
    }
    
    func setBids(_ data: [Bid]) {
        for dt in data {
            let rateView = UIView()
            rateView.backgroundColor = .white
            //rateView.translatesAutoresizingMaskIntoConstraints = false
            
            let titleFont = UIFont.boldSystemFont(ofSize: 12)
            let contentFont = UIFont.systemFont(ofSize: 12)
            
            let statusTitle = UILabel()
            statusTitle.text = localize("status")
            statusTitle.font = titleFont
            statusTitle.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(statusTitle)
            let status = UILabel()
            status.text = dt.is_accepted == "yes" ? localize("accepted") : localize("pending")
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
            
            let interestRateTitle = UILabel()
            interestRateTitle.text = localize("interest_rate")
            interestRateTitle.font = titleFont
            interestRateTitle.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(interestRateTitle)
            var interestRateContent = String()
            if dt.interest_rate_idr != nil {
                interestRateContent += "(IDR) \(dt.interest_rate_idr!)%\n"
            }
            if dt.interest_rate_usd != nil {
                interestRateContent += "(USD) \(dt.interest_rate_usd!)%\n"
            }
            if dt.interest_rate_sharia != nil {
                interestRateContent += "(Sharia) \(dt.interest_rate_sharia!)%\n"
            }
            let interestRate = UILabel()
            interestRate.text = interestRateContent
            interestRate.font = contentFont
            interestRate.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(interestRate)
            
            bidStackView.addArrangedSubview(rateView)
            bidStackViewHeight.constant += 100
            
            NSLayoutConstraint.activate([
                //rateView.leadingAnchor.constraint(equalTo: bidStackView.leadingAnchor),
                //rateView.trailingAnchor.constraint(equalTo: bidStackView.trailingAnchor),
                statusTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 20),
                statusTitle.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 20),
                statusTitle.heightAnchor.constraint(equalToConstant: 14),
                status.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 130),
                status.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 20),
                status.heightAnchor.constraint(equalToConstant: 14),
                
                tenorTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 20),
                tenorTitle.topAnchor.constraint(equalTo: statusTitle.bottomAnchor, constant: 10),
                tenorTitle.heightAnchor.constraint(equalToConstant: 14),
                tenor.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 130),
                tenor.topAnchor.constraint(equalTo: status.bottomAnchor, constant: 10),
                tenor.heightAnchor.constraint(equalToConstant: 14),
                
                interestRateTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 20),
                interestRateTitle.topAnchor.constraint(equalTo: tenorTitle.bottomAnchor, constant: 10),
                interestRateTitle.heightAnchor.constraint(equalToConstant: 14),
                interestRate.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 130),
                interestRate.topAnchor.constraint(equalTo: tenor.bottomAnchor, constant: 10),

            ])
            
        }
    }
    
    /*
    func setInterestRates(_ data: [Bid]) {
        for dt in data {
            let rateView = UIView()
            rateView.backgroundColor = .red
            
            let titleFont = UIFont.boldSystemFont(ofSize: 12)
            let contentFont = UIFont.systemFont(ofSize: 12)
            
            let statusTitle = UILabel()
            statusTitle.text = "Status"
            statusTitle.font = titleFont
            statusTitle.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(statusTitle)
            let status = UILabel()
            //status.text = dt.status
            status.text = "-"
            status.font = contentFont
            status.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(status)
            
            let tenorTitle = UILabel()
            tenorTitle.text = "Tenor"
            tenorTitle.font = titleFont
            tenorTitle.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(tenorTitle)
            let tenor = UILabel()
            //tenor.text = dt.tenor
            tenor.text = "-"
            tenor.font = contentFont
            tenor.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(tenor)
            
            let interestRateTitle = UILabel()
            interestRateTitle.text = "Interest Rate (%)"
            interestRateTitle.font = titleFont
            interestRateTitle.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(interestRateTitle)
            let interestRate = UILabel()
            /*interestRate.text = """
            (IDR) \(dt.interest_rate_idr!)
            (Sharia) \(dt.interest_rate_sharia!)
            """*/
            interestRate.text = ""
            interestRate.font = contentFont
            interestRate.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(interestRate)
            
            NSLayoutConstraint.activate([
                statusTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 20),
                statusTitle.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 20),
                statusTitle.heightAnchor.constraint(equalToConstant: 14),
                status.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 130),
                status.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 20),
                status.heightAnchor.constraint(equalToConstant: 14),
                
                tenorTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 20),
                tenorTitle.topAnchor.constraint(equalTo: statusTitle.bottomAnchor, constant: 10),
                tenorTitle.heightAnchor.constraint(equalToConstant: 14),
                tenor.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 130),
                tenor.topAnchor.constraint(equalTo: status.bottomAnchor, constant: 10),
                tenor.heightAnchor.constraint(equalToConstant: 14),
                
                interestRateTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 20),
                interestRateTitle.topAnchor.constraint(equalTo: tenorTitle.bottomAnchor, constant: 10),
                interestRateTitle.heightAnchor.constraint(equalToConstant: 14),
                interestRate.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 130),
                interestRate.topAnchor.constraint(equalTo: tenor.bottomAnchor, constant: 10),

            ])
            
            bidStackView.addArrangedSubview(rateView)
            bidStackViewHeight.constant += 80
        }
    }*/
    
    @IBAction func addInterestRateDayButtonPressed(_ sender: Any) {
        addInterestRate("day")
    }
    
    @IBAction func addInterestRateMonthButtonPressed(_ sender: Any) {
        addInterestRate("month")
    }
    
    func addInterestRate(_ tenorType: String) {
        let rateView = UIView()
        rateView.backgroundColor = .white
        //rateView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleFont = UIFont.boldSystemFont(ofSize: 12)
        let contentFont = UIFont.systemFont(ofSize: 12)
        
        let tenorTitle = UILabel()
        tenorTitle.text = localize("tenor")
        tenorTitle.font = titleFont
        tenorTitle.translatesAutoresizingMaskIntoConstraints = false
        rateView.addSubview(tenorTitle)
        let tenor = UITextField()
        tenor.borderStyle = .roundedRect
        tenor.keyboardType = .numbersAndPunctuation
        tenor.font = contentFont
        tenor.translatesAutoresizingMaskIntoConstraints = false
        rateView.addSubview(tenor)
        
        let interestRateIdrTitle = UILabel()
        interestRateIdrTitle.text = "\(localize("interest_rate")) IDR"
        interestRateIdrTitle.font = titleFont
        interestRateIdrTitle.translatesAutoresizingMaskIntoConstraints = false
        rateView.addSubview(interestRateIdrTitle)
        let interestRateIdr = UITextField()
        interestRateIdr.borderStyle = .roundedRect
        interestRateIdr.keyboardType = .numbersAndPunctuation
        interestRateIdr.font = contentFont
        interestRateIdr.translatesAutoresizingMaskIntoConstraints = false
        rateView.addSubview(interestRateIdr)
        
        let interestRateShariaTitle = UILabel()
        interestRateShariaTitle.text = "\(localize("interest_rate")) Syariah"
        interestRateShariaTitle.font = titleFont
        interestRateShariaTitle.translatesAutoresizingMaskIntoConstraints = false
        rateView.addSubview(interestRateShariaTitle)
        let interestRateSharia = UITextField()
        interestRateSharia.borderStyle = .roundedRect
        interestRateSharia.keyboardType = .numbersAndPunctuation
        interestRateSharia.font = contentFont
        interestRateSharia.translatesAutoresizingMaskIntoConstraints = false
        rateView.addSubview(interestRateSharia)
        
        interestRateTenorType.append(tenorType)
        interestRateTenorFields.append(tenor)
        interestRateIdrFields.append(interestRateIdr)
        interestRateShariaFields.append(interestRateSharia)
        
        interestRateStackView.addArrangedSubview(rateView)
        interestRateStackViewHeight.constant += 140
        
        NSLayoutConstraint.activate([
            tenorTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 20),
            tenorTitle.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 20),
            tenorTitle.heightAnchor.constraint(equalToConstant: 18),
            tenor.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 150),
            tenor.trailingAnchor.constraint(equalTo: rateView.trailingAnchor, constant: -20),
            tenor.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 20),
            tenor.heightAnchor.constraint(equalToConstant: 25),
            
            interestRateIdrTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 20),
            interestRateIdrTitle.topAnchor.constraint(equalTo: tenorTitle.bottomAnchor, constant: 30),
            interestRateIdrTitle.heightAnchor.constraint(equalToConstant: 18),
            interestRateIdr.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 150),
            interestRateIdr.trailingAnchor.constraint(equalTo: rateView.trailingAnchor, constant: -20),
            interestRateIdr.topAnchor.constraint(equalTo: tenor.bottomAnchor, constant: 21),
            interestRateIdr.heightAnchor.constraint(equalToConstant: 25),
            
            interestRateShariaTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 20),
            interestRateShariaTitle.topAnchor.constraint(equalTo: interestRateIdrTitle.bottomAnchor, constant: 30),
            interestRateShariaTitle.heightAnchor.constraint(equalToConstant: 18),
            interestRateSharia.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 150),
            interestRateSharia.trailingAnchor.constraint(equalTo: rateView.trailingAnchor, constant: -20),
            interestRateSharia.topAnchor.constraint(equalTo: interestRateIdr.bottomAnchor, constant: 21),
            interestRateSharia.heightAnchor.constraint(equalToConstant: 25),

        ])
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        var bids = [Bid]()
        var isValid = true
        for (idx, tenor) in interestRateTenorFields.enumerated() {
            if isInputValid(interestRateTenorFields[idx].text, "int") && isInputValid(interestRateIdrFields[idx].text, "double") &&
                isInputValid(interestRateShariaFields[idx].text, "double") {
                let tenor = Int(interestRateTenorFields[idx].text!)!
                let idr = Double(interestRateIdrFields[idx].text!)
                let usd = Double(0)
                let sharia = Double(interestRateShariaFields[idx].text!)
                let bid = Bid(id: tenor, auction_header_id: 0, is_accepted: "", is_winner: "", interest_rate_idr: idr, interest_rate_usd: usd, interest_rate_sharia: sharia, used_investment_value: 0, bilyet: [], choosen_rate: nil, period: interestRateTenorType[idx])
                bids.append(bid)
            } else {
                isValid = false
                break
            }
        }
        
        if isValid {
            presenter.saveAuction(id, bids, maxPlacementTextField != nil ? maxPlacementTextField.text! : "")
        }
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
}

extension AuctionDetailNormalViewController: AuctionDetailNormalDelegate {
    func setData(_ data: AuctionDetailNormal) {
        self.data = data
        showLoading(false)
        setContent()
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
