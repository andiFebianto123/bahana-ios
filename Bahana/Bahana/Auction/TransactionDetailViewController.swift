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
    
    var refreshControl = UIRefreshControl()
    
    var presenter: TransactionDetailPresenter!
    
    var data: Transaction!
    var transactionID: Int!
    
    var backToRoot = false
    
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
            loadingView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinner.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
        
        //refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        //tableView.addSubview(refreshControl)
        
        transactionIDTitle.text = localize("transaction_id").uppercased()
        transactionStatusView.backgroundColor = darkGreyColor
        transactionStatusTitle.textColor = .white
        transactionStatusTitle.text = localize("transaction_status").uppercased()
        transactionStatus.textColor = .white
        generalInformationTitle.textColor = primaryColor
        generalInformationTitle.text = localize("general_information").uppercased()
        generalInformationView.backgroundColor = lightRedColor
        breakInformationTitle.textColor = primaryColor
        breakInformationTitle.text = localize("break_information")
        breakInformationTitle.isHidden = true
        breakInformationView.backgroundColor = lightRedColor
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
        if backToRoot {
            self.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
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
        
        var title = String()
        var backgroundColor: UIColor!
        switch data.status {
        case "Active":
            title = localize("active")
            backgroundColor = greenColor
        case "Break":
            title = localize("break")
            backgroundColor = primaryColor
        case "Mature":
            title = localize("mature")
            backgroundColor = blueColor
        case "Rollover":
            title = localize("rollover")
            backgroundColor = accentColor
        case "Canceled":
            title = localize("canceled")
            backgroundColor = darkGreyColor
        case "Used in RO Auction":
            title = localize("used_in_ro_auction")
            backgroundColor = darkYellowColor
        case "Used in Break Auction":
            title = localize("used_in_break_auction")
            backgroundColor = darkRedColor
        case "Used in Mature NCM Auction":
            title = localize("used_in_mature_ncm_auction")
            backgroundColor = darkYellowColor
        case "Used in Break NCM Auction":
            title = localize("used_in_break_ncm_auction")
            backgroundColor = darkYellowColor
        case "Used in RO Multifund Auction":
            title = localize("used_in_ro_multifund_auction")
            backgroundColor = darkYellowColor
        case "Multifund Rollover":
            title = localize("multifund-rollover")
            backgroundColor = yellowColor
        default:
            break
        }
        transactionStatusView.backgroundColor = backgroundColor
        
        transactionStatus.text = title.uppercased()
        var interest_rate = "-"
        if data.coupon_rate != nil {
            let newCouponRate = Double(data.coupon_rate!)
            interest_rate = "\(checkPercentage(newCouponRate!)) %"
        }
       
        setGeneralInformation([
            TransactionContent(title: localize("fund_name"), content: data.portfolio),
            TransactionContent(title: localize("custodian_bank"), content: data.custodian_bank != nil ? data.custodian_bank : "-"),
            TransactionContent(title: localize("pic_custodian"), content: data.pic_custodian != nil ? data.pic_custodian : "-"),
            TransactionContent(title: localize("investment"), content: "IDR \(toIdrBio(data.quantity))"),
            TransactionContent(title: localize("tenor"), content: data.period),
            TransactionContent(title: localize("issue_date"), content: convertDateToString(convertStringToDatetime(data.issue_date))),
            TransactionContent(title: localize("maturity_date"), content: convertDateToString(convertStringToDatetime(data.maturity_date)!)),
            TransactionContent(title: localize("interest_rate"), content: interest_rate)
        ])
        
        if data.break_maturity_date != nil {
            let breakRate = Double(data.break_coupon_rate!)
            setBreakInformation([
                TransactionContent(title: localize("break_date"), content: convertDateToString(convertStringToDatetime(data.break_maturity_date))),
                TransactionContent(title: localize("break_rate"), content: "\(checkPercentage(breakRate!)) %")
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
    
    @objc func refresh() {
        presenter.getTransaction(transactionID)
    }
}

extension TransactionDetailViewController: TransactionDetailDelegate {
    func setData(_ data: Transaction) {
        self.data = data
        showLoading(false)
        setContent()
    }
    
    func getDataFail(_ message: String?) {
        refreshControl.endRefreshing()
        showLoading(false)
        var msg = localize("cannot_connect_to_server")
        if message != nil {
            msg = message!
        }
        let alert = UIAlertController(title: localize("information"), message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openLoginPage() {
        let authStoryboard : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginViewController : UIViewController = authStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
}
