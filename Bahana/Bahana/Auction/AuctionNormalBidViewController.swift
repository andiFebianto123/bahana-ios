//
//  AuctionNormalBidViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2006/04.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionNormalBidViewController: UIViewController {

    @IBOutlet weak var statusTitleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tenorTitleLabel: UILabel!
    @IBOutlet weak var tenorLabel: UILabel!
    @IBOutlet weak var interestRateTitleLabel: UILabel!
    @IBOutlet weak var interestRateLabel: UILabel!
    @IBOutlet weak var investmentTitleLabel: UILabel!
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var bilyetTitleLabel: UILabel!
    @IBOutlet weak var bilyetLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    var height: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setBid(_ bid: Bid) {
        /*
        bidStackViewHeight.constant = 0
        for bidView in bidStackView.arrangedSubviews {
            bidStackView.removeArrangedSubview(bidView)
        }
        var totalRateViewHeight: CGFloat = 0
        for (idx, dt) in bidData.enumerated() {
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
            rateStackView.distribution = .fill
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
            
            if dt.interest_rate_idr != nil {
                interestRateContent += "(IDR) \(checkPercentage(dt.interest_rate_idr!)) %"
                if dt.chosen_rate != nil && dt.chosen_rate == "IDR" {
                    interestRateContent += " [\(localize("chosen_rate"))]\n"
                } else {
                    interestRateContent += "\n"
                }
            }
            if dt.interest_rate_usd != nil {
                interestRateContent += "(USD) \(checkPercentage(dt.interest_rate_usd!)) %"
                if dt.chosen_rate != nil && dt.chosen_rate == "USD" {
                    interestRateContent += " [\(localize("chosen_rate"))]\n"
                } else {
                    interestRateContent += "\n"
                }
                
            }
            if dt.interest_rate_sharia != nil {
                interestRateContent += "(\(localize("sharia"))) \(checkPercentage(dt.interest_rate_sharia!)) %"
                if dt.chosen_rate != nil && dt.chosen_rate == "Sharia" {
                    interestRateContent += " [\(localize("chosen_rate"))]\n"
                } else {
                    interestRateContent += "\n"
                }
            }
            let interestRate = UILabel()
            interestRate.text = interestRateContent
            interestRate.numberOfLines = 0
            interestRate.font = contentFont
            let interestRateHeight = interestRate.intrinsicContentSize.height
            interestRate.translatesAutoresizingMaskIntoConstraints = false
            interestRateView.addSubview(interestRate)
            
            rateViewHeight += interestRateHeight + spacing
            
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
                for bilyetArr in dt.bilyet {
                    bilyetStr += "\u{2022} IDR \(toIdrBio(bilyetArr.quantity)) [\(convertDateToString(convertStringToDatetime(bilyetArr.issue_date)!)!) - \(convertDateToString(convertStringToDatetime(bilyetArr.maturity_date)!)!)]\n"
                }
                
                let bilyet = UILabel()
                bilyet.text = bilyetStr
                bilyet.numberOfLines = 0
                bilyet.font = contentFont
                let bilyetHeight = bilyet.intrinsicContentSize.height
                bilyet.translatesAutoresizingMaskIntoConstraints = false
                bilyetView.addSubview(bilyet)
                
                rateViewHeight += bilyetHeight + spacing
                
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
            
            bidStackViewHeight.constant += rateViewHeight + 20 + bidStackView.spacing
            totalRateViewHeight += rateViewHeight
        }
        
        //currentHeight += totalRateViewHeight
        //setHeight(currentHeight)
        */
    }
}
