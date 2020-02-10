//
//  AuctionDetailViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/05.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionDetailViewController: UIViewController {

    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var portfolioView: UIView!
    @IBOutlet weak var portfolioViewHeight: NSLayoutConstraint!
    @IBOutlet weak var portfolioStackView: UIStackView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var rateStackView: UIStackView!
    @IBOutlet weak var rateViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setNavigationItems()
        
        view.backgroundColor = backgroundColor
        
        typeLabel.textColor = primaryColor
        endLabel.textColor = primaryColor
        endLabel.font = UIFont.boldSystemFont(ofSize: 14)
            
        statusView.layer.cornerRadius = 10
        
        portfolioView.layer.cornerRadius = 3
        portfolioView.layer.shadowColor = UIColor.gray.cgColor
        portfolioView.layer.shadowOffset = CGSize(width: 0, height: 0)
        portfolioView.layer.shadowRadius = 4
        portfolioView.layer.shadowOpacity = 0.5
        portfolioView.backgroundColor = UIColorFromHex(rgbValue: 0xfee2e1)
        
        setContent()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setNavigationItems() {
        //navigationBar.barTintColor = UIColor.red
        navigationController?.navigationBar.barTintColor = primaryColor
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let label = UILabel()
        label.text = "AUCTION DETAIL"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        let titleBar = UIBarButtonItem.init(customView: label)
        navigationItem.titleView = label
        
        //navigationItem.setHidesBackButton(true, animated: false)
        //navigationController?.navigationItem.setLeftBarButton(titleBar, animated: true)
    }

    func setContent() {
        statusLabel.text = "NEC"
        statusView.isHidden = true
        
        typeLabel.text = "NORMAL AUCTION"
        endLabel.text = "Ends Bid in: 1 hour 43 mins"
        setPortfolio("Fund Name", "ABF (RD ABF INDONESIA BOND INDEX FUND)")
        setPortfolio("Investment (BIO)", "IDR 1 - 2.5")
        setPortfolio("Placement Date", "10 Jan 20")
        setPortfolio("Custodian Bank", "-")
        setPortfolio("PIC Custodian", "-")
        setRates()
    }
    
    func setPortfolio(_ title: String, _ content: String) {
        let portfolio = UIView()
        
        let titleFont = UIFont.boldSystemFont(ofSize: 10)
        let titleColor = primaryColor
        let contentFont = UIFont.boldSystemFont(ofSize: 14)
        
        let titleLabel = UILabel()
        titleLabel.font = titleFont
        titleLabel.textColor = titleColor
        titleLabel.text = title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        portfolio.addSubview(titleLabel)
        let contentLabel = UILabel()
        contentLabel.text = content
        contentLabel.font = contentFont
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        portfolio.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            portfolio.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: portfolio.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: portfolio.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: portfolio.leadingAnchor, constant: 10),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            contentLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        portfolioStackView.addArrangedSubview(portfolio)
        portfolioViewHeight.constant += CGFloat(30)
    }
    
    func setRates() {
        let rateView = UIView()
        
        let titleFont = UIFont.boldSystemFont(ofSize: 12)
        let contentFont = UIFont.systemFont(ofSize: 12)
        
        let statusTitle = UILabel()
        statusTitle.text = "Status"
        statusTitle.font = titleFont
        statusTitle.translatesAutoresizingMaskIntoConstraints = false
        rateView.addSubview(statusTitle)
        let status = UILabel()
        status.text = "Pending"
        status.font = contentFont
        status.translatesAutoresizingMaskIntoConstraints = false
        rateView.addSubview(status)
        
        let tenorTitle = UILabel()
        tenorTitle.text = "Tenor"
        tenorTitle.font = titleFont
        tenorTitle.translatesAutoresizingMaskIntoConstraints = false
        rateView.addSubview(tenorTitle)
        let tenor = UILabel()
        tenor.text = "3 months"
        tenor.font = contentFont
        tenor.translatesAutoresizingMaskIntoConstraints = false
        rateView.addSubview(tenor)
        
        let interestRateTitle = UILabel()
        interestRateTitle.text = "Interest Rate (%)"
        interestRateTitle.font = titleFont
        interestRateTitle.translatesAutoresizingMaskIntoConstraints = false
        rateView.addSubview(interestRateTitle)
        let interestRateRupiah = UILabel()
        interestRateRupiah.text = "(IDR) 2%"
        interestRateRupiah.font = contentFont
        interestRateRupiah.translatesAutoresizingMaskIntoConstraints = false
        rateView.addSubview(interestRateRupiah)
        let interestRateSharia = UILabel()
        interestRateSharia.text = "(Syariah) 2%"
        interestRateSharia.font = contentFont
        interestRateSharia.translatesAutoresizingMaskIntoConstraints = false
        rateView.addSubview(interestRateSharia)
        
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
            interestRateRupiah.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 130),
            interestRateRupiah.topAnchor.constraint(equalTo: tenor.bottomAnchor, constant: 10),
            interestRateRupiah.heightAnchor.constraint(equalToConstant: 14),
            interestRateSharia.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 130),
            interestRateSharia.topAnchor.constraint(equalTo: interestRateRupiah.bottomAnchor, constant: 2),
            interestRateSharia.heightAnchor.constraint(equalToConstant: 14),
        ])
        
        rateStackView.addArrangedSubview(rateView)
        rateViewHeight.constant += 100
    }
}
