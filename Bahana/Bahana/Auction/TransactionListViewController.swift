//
//  TransactionListViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/12.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class TransactionListViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var tableBackgroundView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var loadingView = UIView()
    var filterListBackgroundView = UIView()
    
    var presenter: TransactionListPresenter!
    
    var statusField = UITextField()
    var issueDateField = UITextField()
    var maturityDateField = UITextField()
    var breakDateField = UITextField()
    
    var stopFetch: Bool = false
    var loadFinished: Bool = false
    
    let statusOptions =  [
        "ALL", "ACTIVE", "BREAK", "CANCELED", "MATURE", localize("used_in_break_auction"), localize("used_in_ro_auction"), "ROLLOVER"
    ]
    let issueDateOptions = [
        "ANY TIME", "TODAY", "YESTERDAY", "THIS WEEK", "THIS MONTH", "THIS YEAR"
    ]
    let maturityDateOptions = [
        "ANY TIME", "TODAY", "YESTERDAY", "THIS WEEK", "THIS MONTH", "THIS YEAR"
    ]
    let breakDateOptions = [
        "NONE", "ANY TIME", "TODAY", "YESTERDAY", "THIS WEEK", "THIS MONTH", "THIS YEAR"
    ]
    
    var transactionID = Int()
    var transactionType = String()
    var transaction: Transaction!
    
    var data = [Transaction]()
    let dataPerPage = 10
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationItems()
        
        tableBackgroundView.backgroundColor = backgroundColor
        view.backgroundColor = backgroundColor
        
        // Set loading view
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        tableBackgroundView.addSubview(loadingView)
        tableBackgroundView.bringSubviewToFront(loadingView)
        
        let spinner = UIActivityIndicatorView()
        spinner.color = .black
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: tableBackgroundView.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: tableBackgroundView.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: tableBackgroundView.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: tableBackgroundView.bottomAnchor),
            spinner.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
        
        filterView.layer.cornerRadius = 3
        filterView.backgroundColor = UIColorFromHex(rgbValue: 0x3f3f3f)
        let filterTap = UITapGestureRecognizer(target: self, action: #selector(showFilter))
        filterView.addGestureRecognizer(filterTap)
        filterLabel.font = UIFont.systemFont(ofSize: 10)
        filterLabel.textColor = .white
        filterLabel.text = localize("filter_transaction").uppercased()
        
        tableView.register(UINib(nibName: "AuctionListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColorFromHex(rgbValue: 0xecf0f5)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        presenter = TransactionListPresenter(delegate: self)
        showLoading(true)
        getData(lastId: nil)
        
        setFilter()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            if let destinationVC = segue.destination as?  TransactionDetailViewController {
                destinationVC.data = transaction
            }
        }
    }

    func setNavigationItems() {
        navigationView.backgroundColor = primaryColor
        navigationViewHeight.constant = getNavigationHeight()
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        navigationTitle.textColor = .white
        navigationTitle.font = UIFont.systemFont(ofSize: 16)
        navigationTitle.text = localize("transaction").uppercased()
        
        // Set badge notification
        let badgeView = UIView()
        badgeView.backgroundColor = .lightGray
        badgeView.layer.cornerRadius = 6
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        notificationView.addSubview(badgeView)
        
        let badgeLabel = UILabel()
        getUnreadNotificationCount() { count in
            if count > 99 {
                badgeLabel.text = "99+"
            } else {
                badgeLabel.text = "\(count)"
            }
        }
        badgeLabel.font = UIFont.systemFont(ofSize: 8)
        badgeLabel.textColor = .white
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeView.addSubview(badgeLabel)
        
        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(equalTo: notificationView.topAnchor, constant: 0),
            badgeView.trailingAnchor.constraint(equalTo: notificationView.trailingAnchor, constant: -2),
            badgeView.heightAnchor.constraint(equalToConstant: 14),
            badgeView.widthAnchor.constraint(equalToConstant: 22),
            badgeLabel.centerXAnchor.constraint(equalTo: badgeView.centerXAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor),
        ])
        
        notificationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showNotification)))
    }
    
    func getData(lastId: Int?, page: Int = 1) {
        let filter: [String: String] = [
            "status": statusField.text!,
            "issue_date": issueDateField.text!,
            "maturity_date": maturityDateField.text!,
            "break_date": breakDateField.text!
        ]
        
        presenter.getTransaction(filter, lastId: lastId, page)
    }
    
    func setFilter() {
        filterListBackgroundView = UIView()
        filterListBackgroundView.isHidden = true
        filterListBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addSubview(filterListBackgroundView)
        
        let filterListView = UIView()
        filterListView.backgroundColor = .white
        filterListView.layer.cornerRadius = 3
        filterListBackgroundView.addSubview(filterListView)
        
        //Title
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 18)
        title.text = localize("filter_transaction")
        filterListView.addSubview(title)
        
        let titleFont = UIFont.systemFont(ofSize: 13)
        
        //Status
        let statusTitle = UILabel()
        statusTitle.font = titleFont
        statusTitle.textColor = .lightGray
        statusTitle.text = localize("status")
        filterListView.addSubview(statusTitle)
        statusField = UITextField()
        statusField.tag = 1
        statusField.isUserInteractionEnabled = true
        statusField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showOptions(_:))))
        statusField.text = statusOptions.first
        filterListView.addSubview(statusField)
        
        //Issue date
        let issueDateTitle = UILabel()
        issueDateTitle.font = titleFont
        issueDateTitle.textColor = .lightGray
        issueDateTitle.text = localize("issue_date")
        filterListView.addSubview(issueDateTitle)
        issueDateField = UITextField()
        issueDateField.tag = 2
        issueDateField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showOptions(_:))))
        issueDateField.text = issueDateOptions.first
        filterListView.addSubview(issueDateField)
        
        //Maturity date
        let maturityDateTitle = UILabel()
        maturityDateTitle.font = titleFont
        maturityDateTitle.textColor = .lightGray
        maturityDateTitle.text = localize("maturity_date")
        filterListView.addSubview(maturityDateTitle)
        maturityDateField = UITextField()
        maturityDateField.tag = 3
        maturityDateField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showOptions(_:))))
        maturityDateField.text = maturityDateOptions.first
        filterListView.addSubview(maturityDateField)
        
        //Break date
        let breakDateTitle = UILabel()
        breakDateTitle.font = titleFont
        breakDateTitle.textColor = .lightGray
        breakDateTitle.text = localize("break_date")
        filterListView.addSubview(breakDateTitle)
        breakDateField = UITextField()
        breakDateField.tag = 4
        breakDateField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showOptions(_:))))
        breakDateField.text = breakDateOptions.first
        filterListView.addSubview(breakDateField)
        
        //Cancel button
        let cancelButton = UIButton()
        cancelButton.setTitleColor(.systemYellow, for: .normal)
        cancelButton.setTitle(localize("cancel").uppercased(), for: .normal)
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeFilter))
        cancelButton.addGestureRecognizer(closeTap)
        filterListView.addSubview(cancelButton)
        
        //Submit button
        let submitButton = UIButton()
        submitButton.setTitleColor(.systemYellow, for: .normal)
        submitButton.setTitle(localize("filter").uppercased(), for: .normal)
        let submitTap = UITapGestureRecognizer(target: self, action: #selector(submitFilter))
        submitButton.addGestureRecognizer(submitTap)
        filterListView.addSubview(submitButton)
        
        filterListBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        filterListView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        statusTitle.translatesAutoresizingMaskIntoConstraints = false
        statusField.translatesAutoresizingMaskIntoConstraints = false
        issueDateTitle.translatesAutoresizingMaskIntoConstraints = false
        issueDateField.translatesAutoresizingMaskIntoConstraints = false
        maturityDateTitle.translatesAutoresizingMaskIntoConstraints = false
        maturityDateField.translatesAutoresizingMaskIntoConstraints = false
        breakDateTitle.translatesAutoresizingMaskIntoConstraints = false
        breakDateField.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filterListBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            filterListBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filterListBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterListBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterListView.centerYAnchor.constraint(equalTo: filterListBackgroundView.centerYAnchor, constant: 0),
            filterListView.leadingAnchor.constraint(equalTo: filterListBackgroundView.leadingAnchor, constant: 25),
            filterListView.trailingAnchor.constraint(equalTo: filterListBackgroundView.trailingAnchor, constant: -25),
            filterListView.heightAnchor.constraint(equalToConstant: 300),
            title.topAnchor.constraint(equalTo: filterListView.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: filterListView.leadingAnchor, constant: 20),
            statusTitle.topAnchor.constraint(equalTo: filterListView.topAnchor, constant: 70),
            statusTitle.leadingAnchor.constraint(equalTo: filterListView.leadingAnchor, constant: 20),
            statusField.topAnchor.constraint(equalTo: filterListView.topAnchor, constant: 72),
            statusField.trailingAnchor.constraint(equalTo: filterListView.trailingAnchor, constant: -20),
            issueDateTitle.topAnchor.constraint(equalTo: statusTitle.bottomAnchor, constant: 30),
            issueDateTitle.leadingAnchor.constraint(equalTo: filterListView.leadingAnchor, constant: 20),
            issueDateField.topAnchor.constraint(equalTo: statusField.bottomAnchor, constant: 22),
            issueDateField.trailingAnchor.constraint(equalTo: filterListView.trailingAnchor, constant: -20),
            maturityDateTitle.topAnchor.constraint(equalTo: issueDateTitle.bottomAnchor, constant: 30),
            maturityDateTitle.leadingAnchor.constraint(equalTo: filterListView.leadingAnchor, constant: 20),
            maturityDateField.topAnchor.constraint(equalTo: issueDateField.bottomAnchor, constant: 22),
            maturityDateField.trailingAnchor.constraint(equalTo: filterListView.trailingAnchor, constant: -20),
            breakDateTitle.topAnchor.constraint(equalTo: maturityDateTitle.bottomAnchor, constant: 30),
            breakDateTitle.leadingAnchor.constraint(equalTo: filterListView.leadingAnchor, constant: 20),
            breakDateField.topAnchor.constraint(equalTo: maturityDateField.bottomAnchor, constant: 22),
            breakDateField.trailingAnchor.constraint(equalTo: filterListView.trailingAnchor, constant: -20),
            cancelButton.trailingAnchor.constraint(equalTo: submitButton.trailingAnchor, constant: -100),
            cancelButton.bottomAnchor.constraint(equalTo: filterListView.bottomAnchor, constant: -20),
            submitButton.trailingAnchor.constraint(equalTo: filterListView.trailingAnchor, constant: -20),
            submitButton.bottomAnchor.constraint(equalTo: filterListView.bottomAnchor, constant: -20),
        ])
    }
    
    func showLoading(_ show: Bool) {
        if show {
            loadingView.isHidden = false
        } else {
            loadingView.isHidden = true
        }
    }
    
    @objc func showNotification() {
        performSegue(withIdentifier: "showNotification", sender: self)
    }
    
    @objc func closeFilter() {
        filterListBackgroundView.isHidden = true
    }
    
    @objc func showFilter() {
        filterListBackgroundView.isHidden = false
    }
    
    @objc func submitFilter() {
        closeFilter()
        data.removeAll()
        page = 1
        showLoading(true)
        getData(lastId: nil)
    }
    
    @objc func showOptions(_ sender: UITapGestureRecognizer) {
        var options = [String]()
        
        let tag = (sender.view?.tag)!
        switch tag {
        case 1:
            // Status
            options = statusOptions
        case 2:
            // Issue date
            options = issueDateOptions
        case 3:
            // Maturity date
            options = maturityDateOptions
        case 4:
            // Break date
            options = breakDateOptions
        default:
            break
        }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        for option in options {
            alert.addAction(UIAlertAction(title: option, style: .default, handler: { action in
                self.optionChoosed(tag, option)
            }))
        }
        alert.addAction(UIAlertAction(title: localize("cancel"), style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func optionChoosed(_ tag: Int, _ option: String) {
        switch tag {
        case 1:
            statusField.text = option
        case 2:
            issueDateField.text = option
        case 3:
            maturityDateField.text = option
        case 4:
            breakDateField.text = option
        default:
            break
        }
    }
}

extension TransactionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == data.count - 1 && loadFinished && !stopFetch {
            page += 1
            self.getData(lastId: data[indexPath.row].id, page: page)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AuctionListTableViewCell
        let transaction = data[indexPath.row]
        cell.setTransaction(transaction)
        return cell
    }
}

extension TransactionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transaction = data[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

extension TransactionListViewController: TransactionListDelegate {
    func openLoginPage() {
        let authStoryboard : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginViewController : UIViewController = authStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    func setData(_ data: [Transaction], _ page: Int) {
        if data.count > 0 && self.page == page {
            for dt in data {
                self.data.append(dt)
            }
            
            if data.count < dataPerPage {
                stopFetch = true
            }
            showLoading(false)
            loadFinished = true
            tableView.reloadData()
        }
    }
}
