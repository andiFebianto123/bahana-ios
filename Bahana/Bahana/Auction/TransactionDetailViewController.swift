//
//  TransactionDetailViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/12.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class TransactionDetailViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationBackView: UIView!
    @IBOutlet weak var navigationBackImageView: UIImageView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var transactionIDTitle: UILabel!
    @IBOutlet weak var transactionID: UILabel!
    @IBOutlet weak var transactionStatusView: UIView!
    @IBOutlet weak var transactionStatusTitle: UILabel!
    @IBOutlet weak var transactionStatus: UILabel!
    @IBOutlet weak var generalInformationTitle: UILabel!
    @IBOutlet weak var generalInformationView: UIView!
    @IBOutlet weak var generalInformationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var generalInformationStackView: UIStackView!
    @IBOutlet weak var breakInformationTitle: UILabel!
    @IBOutlet weak var breakInformationView: UIView!
    @IBOutlet weak var breakInformationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var breakInformationStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        transactionIDTitle.text = "TRANSACTION ID"
        transactionStatusTitle.textColor = .white
        transactionStatusTitle.text = "TRANSACTION STATUS"
        transactionStatus.textColor = .white
        generalInformationTitle.textColor = primaryColor
        generalInformationTitle.text = "GENERAL INFORMATION"
        generalInformationView.backgroundColor = UIColorFromHex(rgbValue: 0xfee2e1)
        breakInformationTitle.textColor = primaryColor
        breakInformationTitle.text = "BREAK INFORMATION"
        breakInformationView.backgroundColor = UIColorFromHex(rgbValue: 0xfee2e1)
        
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

    func setContent() {
        transactionID.text = "941"
        transactionStatusView.backgroundColor = primaryColor
        transactionStatus.text = "BREAK"
        setGeneralInformation("Fund Name", "BLP")
        setGeneralInformation("Investment (BIO)", "IDR 10")
        setGeneralInformation("Tenor", "1 month")
        setGeneralInformation("Issue Date", "21 Dec 19")
        setGeneralInformation("Maturity Date", "21 Jan 20")
        setGeneralInformation("Interest Rate (%)", "8.5 %")
        setBreakInformation("Break Date", "20 Jan 20")
        setBreakInformation("Break Rate(%)", "8.25 %")
    }
    
    func addDescriptionText(_ title: String, _ content: String) -> UIView {
        let portfolio = UIView()
        
        let titleFont = UIFont.boldSystemFont(ofSize: 10)
        let titleColor = titleLabelColor
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
        
        return portfolio
    }
    
    func setGeneralInformation(_ title: String, _ content: String) {
        let subView = addDescriptionText(title, content)
        generalInformationStackView.addArrangedSubview(subView)
        generalInformationViewHeight.constant += CGFloat(30)
    }
    
    func setBreakInformation(_ title: String, _ content: String) {
        let subView = addDescriptionText(title, content)
        breakInformationStackView.addArrangedSubview(subView)
        breakInformationViewHeight.constant += CGFloat(30)
    }
}
