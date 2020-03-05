//
//  TransactionDetailViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/12.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

struct TransactionContent {
    var title: String!
    var content: String?
}

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
    
    var data: Transaction!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationItems()
        
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
    
    func setNavigationItems() {
        //navigationBar.barTintColor = UIColor.red
        //navigationController?.navigationBar.barTintColor = primaryColor
        navigationView.backgroundColor = primaryColor
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backButtonPressed))
        navigationBackImageView.image = UIImage(named: "icon_left")
        navigationBackView.addGestureRecognizer(backTap)
        
        /*let label = UILabel()
        label.text = "AUCTION DETAIL"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        let titleBar = UIBarButtonItem.init(customView: label)
        navigationItem.titleView = label*/
        /*
        let backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        let backBar = UIBarButtonItem.init(customView: backButton)
        
        //navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationItem.setLeftBarButton(backBar, animated: true)*/
    }

    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    func setContent() {
        transactionID.text = "\(data.id)"
        if data.status == "Active" {
            transactionStatusView.backgroundColor = UIColorFromHex(rgbValue: 0x65d663)
        } else if data.status == "Canceled" {
            transactionStatusView.backgroundColor = primaryColor
        }
        
        transactionStatus.text = data.status
        setGeneralInformation([
            TransactionContent(title: "Fund Name", content: data.portfolio),
            TransactionContent(title: "Investment (BIO)", content: "IDR \(toIdrBio(data.quantity))"),
            TransactionContent(title: "Tenor", content: data.period),
            TransactionContent(title: "Issue Date", content: convertDateToString(convertStringToDatetime(data.issue_date))),
            TransactionContent(title: "Maturity Date", content: convertDateToString(convertStringToDatetime(data.maturity_date)!)),
            TransactionContent(title: "Interest Rate (%)", content: "8.5 %"),
            TransactionContent(title: "Break Date", content: convertDateToString(convertStringToDatetime(data.break_maturity_date)))
        ])
        
        setBreakInformation([
            TransactionContent(title: "Break Rate(%)", content: "8.25 %")
        ])
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
    
    func setGeneralInformation(_ data: [TransactionContent]) {
        for dt in data {
            if dt.content != nil {
                let subView = addDescriptionText(dt.title, dt.content!)
                generalInformationStackView.addArrangedSubview(subView)
                generalInformationViewHeight.constant += CGFloat(30)
            }
        }
    }
    
    func setBreakInformation(_ data: [TransactionContent]) {
        for dt in data {
            if dt.content != nil {
                let subView = addDescriptionText(dt.title, dt.content!)
                breakInformationStackView.addArrangedSubview(subView)
                breakInformationViewHeight.constant += CGFloat(30)
            }
        }
    }
}
