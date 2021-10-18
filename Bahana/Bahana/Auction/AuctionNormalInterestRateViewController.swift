//
//  AuctionNormalInterestRateViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2006/03.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionNormalInterestRateViewController: UIViewController {

    @IBOutlet weak var tenorTitleLabel: UILabel!
    @IBOutlet weak var tenorLabel: UILabel!
    @IBOutlet weak var tenorTextField: UITextField!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var idrTitleLabel: UILabel!
    @IBOutlet weak var idrTextField: UITextField!
    @IBOutlet weak var usdTitleLabel: UILabel!
    @IBOutlet weak var usdTextField: UITextField!
    @IBOutlet weak var shariaTitleLabel: UILabel!
    @IBOutlet weak var shariaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tenorTitleLabel.text = localize("tenor")
        deleteButton.backgroundColor = primaryColor
        deleteButton.layer.cornerRadius = 3
        deleteButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        idrTitleLabel.text = "\(localize("interest_rate")) IDR"
        usdTitleLabel.text = "\(localize("interest_rate")) USD"
        shariaTitleLabel.text = "\(localize("interest_rate")) \(localize("sharia"))"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setRate(_ tenorType: String, _ canEditTenor: Bool, _ period: Int? = nil) {
        if canEditTenor {
            tenorTextField.isHidden = true
        } else {
            self.periodLabel.isHidden = true
            self.deleteButton.isHidden = true
        }
    }
    
    func test() {
        var _: CGFloat = 0
        
        /*let rateView = UIView()
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
            tenorTitle.leadingAnchor.constraint(equalTo: tenorView.leadingAnchor, constant: 0),
            tenorTitle.widthAnchor.constraint(equalToConstant: titleWidth),
            tenorTitle.centerYAnchor.constraint(equalTo: tenorView.centerYAnchor)
        ])
        
        let fieldHeight: CGFloat = 60
        
        var tenorField: UITextField?
        if canEditTenor {
            tenorField = UITextField()
            tenorField!.borderStyle = .roundedRect
            tenorField!.keyboardType = .numbersAndPunctuation
            tenorField!.font = contentFont
            let tenorFieldHeight = fieldHeight
            tenorField!.translatesAutoresizingMaskIntoConstraints = false
            tenorView.addSubview(tenorField!)
            
            rateHeight += tenorFieldHeight
            
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
            
            rateHeight += tenorHeight
            
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
            let idrInterestRateHeight = fieldHeight
            idrInterestRate!.translatesAutoresizingMaskIntoConstraints = false
            idrRateView.addSubview(idrInterestRate!)
            
            rateHeight += idrInterestRateHeight
            
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
            let usdInterestRateHeight = fieldHeight
            usdInterestRate!.translatesAutoresizingMaskIntoConstraints = false
            usdRateView.addSubview(usdInterestRate!)
            
            rateHeight += usdInterestRateHeight
            
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
            let shariaInterestRateHeight = fieldHeight
            shariaInterestRate!.translatesAutoresizingMaskIntoConstraints = false
            shariaRateView.addSubview(shariaInterestRate!)
            
            rateHeight += shariaInterestRateHeight
            
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
        }
        
        NSLayoutConstraint.activate([
            rateStackView.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 15),
            rateStackView.bottomAnchor.constraint(equalTo: rateView.bottomAnchor, constant: -15),
            rateStackView.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 15),
            rateStackView.trailingAnchor.constraint(equalTo: rateView.trailingAnchor, constant: -15),
        ])
        
        interestRateStackViewHeight.constant += rateHeight
        
        //currentHeight += rateHeight
        //setHeight(currentHeight)
        
        let interestRate = InterestRate(idx: interestRateIdx, tenorType: tenorType, tenor: period, tenorField: tenorField, idrField: idrInterestRate, usdField: usdInterestRate, shariaField: shariaInterestRate, isHidden: false)
        interestRates.append(interestRate)
        interestRateIdx += 1
         */
    }

}
