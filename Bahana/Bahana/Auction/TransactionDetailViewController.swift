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
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationBackView: UIView!
    @IBOutlet weak var navigationBackImageView: UIImageView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var transactionIDTitle: UILabel!
    @IBOutlet weak var transactionIDLabel: UILabel!
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
    
    var loadingView = UIView()
    
    var presenter: TransactionDetailPresenter!
    
    var data: Transaction!
    var transactionID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationItems()
        
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
        
        transactionIDTitle.text = localize("transaction_id").uppercased()
        transactionStatusTitle.textColor = .white
        transactionStatusTitle.text = localize("transaction_status").uppercased()
        transactionStatus.textColor = .white
        generalInformationTitle.textColor = primaryColor
        generalInformationTitle.text = localize("general_information").uppercased()
        generalInformationView.backgroundColor = UIColorFromHex(rgbValue: 0xfee2e1)
        breakInformationTitle.textColor = primaryColor
        breakInformationTitle.text = localize("break_information")
        breakInformationTitle.isHidden = true
        breakInformationView.backgroundColor = UIColorFromHex(rgbValue: 0xfee2e1)
        breakInformationView.isHidden = true
        
        presenter = TransactionDetailPresenter(delegate: self)
        presenter.getTransaction(transactionID)
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
        navigationViewHeight.constant = getNavigationHeight()
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        navigationTitle.text = localize("transaction_detail").uppercased()
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backButtonPressed))
        navigationBackImageView.image = UIImage(named: "icon_left")
        navigationBackView.addGestureRecognizer(backTap)
    }

    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showLoading(_ show: Bool) {
        if show {
            loadingView.isHidden = false
        } else {
            loadingView.isHidden = true
        }
    }

    func setContent() {
        transactionIDLabel.text = "\(data.id)"
        
        switch data.status {
        case "Active":
            transactionStatusView.backgroundColor = UIColorFromHex(rgbValue: 0x65d663)
        case "Canceled":
            transactionStatusView.backgroundColor = UIColorFromHex(rgbValue: 0x3e3e3e)
        case "Used in Break Auction":
            transactionStatusView.backgroundColor = UIColorFromHex(rgbValue: 0x990000)
        case "Mature":
            transactionStatusView.backgroundColor = UIColorFromHex(rgbValue: 0x2d91ff)
        default:
            break
        }
        
        transactionStatus.text = data.status.uppercased()
        var interest_rate = "-"
        if data.coupon_rate != nil {
            let newCouponRate = Double(data.coupon_rate!)
            interest_rate = newCouponRate!.truncatingRemainder(dividingBy: 1) == 0 ? "\(String(format: "%.0f", newCouponRate!)) %" : "\(data.coupon_rate!) %"
        }
       
        setGeneralInformation([
            TransactionContent(title: localize("fund_name"), content: data.portfolio),
            TransactionContent(title: localize("custodian_bank"), content: data.custodian_bank != nil ? data.custodian_bank : "-"),
            TransactionContent(title: localize("pic_custodian"), content: data.pic_custodian != nil ? data.pic_custodian : "-"),
            TransactionContent(title: localize("investment"), content: "IDR \(toIdrBio(data.quantity))"),
            TransactionContent(title: localize("tenor"), content: data.period),
            TransactionContent(title: localize("issue_date"), content: convertDateToString(convertStringToDatetime(data.issue_date))),
            TransactionContent(title: localize("maturity_date"), content: convertDateToString(convertStringToDatetime(data.maturity_date)!)),
            TransactionContent(title: localize("interest_rate"), content: interest_rate),
            TransactionContent(title: localize("break_date"), content: convertDateToString(convertStringToDatetime(data.break_maturity_date)))
        ])
        
        if data.break_maturity_date != nil {
            setBreakInformation([
                TransactionContent(title: localize("break_rate"), content: "\(data.break_coupon_rate) %")
            ])
        }
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
        breakInformationTitle.isHidden = false
        breakInformationView.isHidden = false
        for dt in data {
            if dt.content != nil {
                let subView = addDescriptionText(dt.title, dt.content!)
                breakInformationStackView.addArrangedSubview(subView)
                breakInformationViewHeight.constant += CGFloat(30)
            }
        }
    }
}

extension TransactionDetailViewController: TransactionDetailDelegate {
    func setData(_ data: Transaction) {
        self.data = data
        showLoading(false)
        setContent()
    }
}
