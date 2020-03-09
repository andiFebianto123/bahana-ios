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
    @IBOutlet weak var portfolioView: UIView!
    @IBOutlet weak var fundNameLabel: UILabel!
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var placementDateLabel: UILabel!
    @IBOutlet weak var custodianBankLabel: UILabel!
    @IBOutlet weak var picCustodianLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var bidStackView: UIStackView!
    @IBOutlet weak var bidStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var interestRateStackView: UIStackView!
    @IBOutlet weak var interestRateStackViewHeight: NSLayoutConstraint!
    
    var presenter: AuctionDetailNormalPresenter!
    
    var id = Int()
    var data: AuctionDetailNormal!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.textColor = primaryColor
        let cardBackgroundColor = UIColorFromHex(rgbValue: 0xffe0e0)
        portfolioView.backgroundColor = cardBackgroundColor
        portfolioView.layer.cornerRadius = 5
        portfolioView.layer.shadowColor = UIColor.gray.cgColor
        portfolioView.layer.shadowOffset = CGSize(width: 0, height: 0)
        portfolioView.layer.shadowRadius = 4
        portfolioView.layer.shadowOpacity = 0.5
        
        presenter = AuctionDetailNormalPresenter(delegate: self)
        //presenter.getAuction(id)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setContent() {
        // Check status
        if data.status == "-" {
            
        }
        
        if convertStringToDatetime(data.end_date)! > Date() {
            auctionEndLabel.text = "Ends in: \(calculateDateDifference(Date(), convertStringToDatetime(data.end_date)!))"
        } else {
            auctionEndLabel.isHidden = true
        }
        
        // Portfolio
        /*fundNameLabel.text = data.portfolio
        //investmentLabel.text = data.
        //placementDateLabel.text = data.
        custodianBankLabel.text = data.custodian_bank
        picCustodianLabel.text = data.pic_custodian
        
        // Note
        noteLabel.text = data.notes
        */
        setBids([
            Bid(id: 1, auction_header_id: 1, is_accepted: "yes", is_winner: "yes", interest_rate_idr: 2000, interest_rate_usd: 1000, interest_rate_sharia: nil, used_investment_value: 1000, bilyet: [], choosen_rate: nil, period: "1 month"),
        ])
    }
    
    func setBids(_ data: [Bid]) {
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
}

extension AuctionDetailNormalViewController: AuctionDetailNormalDelegate {
    func setData(_ data: AuctionDetailNormal) {
        self.data = data
        setContent()
    }
}
