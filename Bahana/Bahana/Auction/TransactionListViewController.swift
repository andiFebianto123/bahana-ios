//
//  TransactionListViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/12.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

struct Option {
    var key: String?
    var val: String
}

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
    var filterListView = UIView()
    
    var pickerView = UIPickerView()
    
    var refreshControl = UIRefreshControl()
    
    var presenter: TransactionListPresenter!
    
    var fundField = UITextField()
    var statusField = UITextField()
    var issueDateField = UITextField()
    var maturityDateField = UITextField()
    var breakDateField = UITextField()
    var outstandingSwitch = UISwitch()
    
    var stopFetch: Bool = false
    var loadFinished: Bool = false
    
    var isFilterReady = false
    var currentFieldTag: Int!
    //var currentOptionChoosed: Option?
    var currentOptionChoosed: String?
    var filters = [String: String]()
    
    //var pickerOptions = [Option]()
    var pickerOptions = [String]()
    
    var fundOptions = [String]()
    /*let statusOptions =  [
        "all", "active", "break", "canceled", "mature", "used_in_break_auction", "used_in_ro_auction", "rollover"
    ]*/
    let statusOptions =  [
        localize("all"), localize("active"), localize("break"), localize("canceled"), localize("mature"), localize("used_in_break_auction"), localize("used_in_ro_auction"), localize("rollover")
    ]
    let issueDateOptions = [
        localize("any_time"), localize("today"), localize("yesterday"), localize("this_week"), localize("this_month"), localize("this_year")
    ]
    let maturityDateOptions = [
        localize("any_time"), localize("today"), localize("yesterday"), localize("this_week"), localize("this_month"), localize("this_year")
    ]
    let breakDateOptions = [
        localize("none"), localize("any_time"), localize("today"), localize("yesterday"), localize("this_week"), localize("this_month"), localize("this_year")
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
        setViewText()
        setFilter()
        
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
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        filterView.layer.cornerRadius = 3
        filterView.backgroundColor = UIColor.black
        let filterTap = UITapGestureRecognizer(target: self, action: #selector(showFilter))
        filterView.addGestureRecognizer(filterTap)
        filterLabel.font = UIFont.systemFont(ofSize: 10)
        filterLabel.textColor = .white
        
        tableView.register(UINib(nibName: "AuctionListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = backgroundColor
        
        tableView.dataSource = self
        tableView.delegate = self
        
        presenter = TransactionListPresenter(delegate: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: Notification.Name("LanguageChanged"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationItems()
        refresh()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            if let destinationVC = segue.destination as?  TransactionDetailViewController {
                destinationVC.transactionID = transaction.id
            }
        }
    }

    func setNavigationItems() {
        navigationView.backgroundColor = primaryColor
        navigationViewHeight.constant = getNavigationHeight()
        //let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        navigationTitle.textColor = .white
        navigationTitle.font = UIFont.systemFont(ofSize: 16)
        navigationTitle.text = localize("transaction").uppercased()
        
        // Set badge notification
        let badgeView = UIView()
        badgeView.backgroundColor = .lightGray
        badgeView.layer.cornerRadius = 6
        badgeView.isHidden = true
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        notificationView.addSubview(badgeView)
        
        let badgeLabel = UILabel()
        getUnreadNotificationCount() { count in
            badgeView.isHidden = false
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
    
    func setTableBackgroundView() {
        let customView = UIView()
        
        let text = UILabel()
        text.text = "No data available"
        text.textColor = UIColor.gray
        text.font = UIFont.systemFont(ofSize: 13)
        customView.addSubview(text)
        
        text.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            text.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            text.centerYAnchor.constraint(equalTo: customView.centerYAnchor, constant: 0),
        ])
        
        tableView.backgroundView = customView
    }
    
    func setViewText() {
        filterLabel.text = localize("filter_transaction").uppercased()
    }
    
    @objc func refresh() {
        page = 1
        showLoading(true)
        self.data.removeAll()
        tableView.reloadData()
        getData(lastId: nil)
    }
    
    func getData(lastId: Int?, page: Int = 1) {
        let filters = [
            "portfolio": fundField.text!,
            "status": statusField.text!,
            "issue_date": issueDateField.text!,
            "maturity_date": maturityDateField.text!,
            "break_date": breakDateField.text!,
            "outstanding": outstandingSwitch.isOn ? "true" : "false"
        ]
        
        presenter.getTransaction(filters, lastId: lastId, page)
    }
    
    func setFilter() {
        filterListBackgroundView = UIView()
        filterListBackgroundView.isHidden = true
        filterListBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        filterListBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterListBackgroundView)
        
        // Set picker view
        pickerView.backgroundColor = UIColor.white
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneBarButton = UIBarButtonItem(title: localize("done"), style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: localize("cancel"), style: .plain, target: self, action: #selector(self.cancelTapped))

        toolBar.setItems([cancelBarButton, spaceBarButton, doneBarButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        filterListView.backgroundColor = .white
        filterListView.isHidden = true
        filterListView.layer.cornerRadius = 3
        filterListView.translatesAutoresizingMaskIntoConstraints = false
        filterListBackgroundView.addSubview(filterListView)
        
        // Title
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 18)
        title.text = localize("filter_transaction")
        title.translatesAutoresizingMaskIntoConstraints = false
        filterListView.addSubview(title)
        
        // Stack view
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        filterListView.addSubview(stackView)
        
        let titleFont = UIFont.systemFont(ofSize: 13)
        let contentFont = UIFont.systemFont(ofSize: 14)
        
        // Fund
        let fundView = UIView()
        fundView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(fundView)
        let fundTitle = UILabel()
        fundTitle.font = titleFont
        fundTitle.textColor = .lightGray
        fundTitle.text = localize("fund")
        fundTitle.translatesAutoresizingMaskIntoConstraints = false
        fundView.addSubview(fundTitle)
        fundField = UITextField()
        fundField.tag = 1
        fundField.delegate = self
        fundField.inputView = self.pickerView
        fundField.inputAccessoryView = toolBar
        fundField.font = contentFont
        fundField.translatesAutoresizingMaskIntoConstraints = false
        fundView.addSubview(fundField)
        
        NSLayoutConstraint.activate([
            fundView.heightAnchor.constraint(equalToConstant: 30),
            fundTitle.leadingAnchor.constraint(equalTo: fundView.leadingAnchor, constant: 0),
            fundTitle.centerYAnchor.constraint(equalTo: fundView.centerYAnchor),
            fundField.trailingAnchor.constraint(equalTo: fundView.trailingAnchor, constant: 0),
            fundField.centerYAnchor.constraint(equalTo: fundView.centerYAnchor)
        ])
        
        // Status
        let statusView = UIView()
        statusView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(statusView)
        let statusTitle = UILabel()
        statusTitle.font = titleFont
        statusTitle.textColor = .lightGray
        statusTitle.text = localize("status")
        statusTitle.translatesAutoresizingMaskIntoConstraints = false
        statusView.addSubview(statusTitle)
        statusField = UITextField()
        statusField.tag = 2
        statusField.delegate = self
        statusField.inputView = self.pickerView
        statusField.inputAccessoryView = toolBar
        statusField.font = contentFont
        statusField.translatesAutoresizingMaskIntoConstraints = false
        statusView.addSubview(statusField)
        
        NSLayoutConstraint.activate([
            statusView.heightAnchor.constraint(equalToConstant: 30),
            statusTitle.leadingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: 0),
            statusTitle.centerYAnchor.constraint(equalTo: statusView.centerYAnchor),
            statusField.trailingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: 0),
            statusField.centerYAnchor.constraint(equalTo: statusView.centerYAnchor)
        ])
        
        // Issue date
        let issueDateView = UIView()
        issueDateView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(issueDateView)
        let issueDateTitle = UILabel()
        issueDateTitle.font = titleFont
        issueDateTitle.textColor = .lightGray
        issueDateTitle.text = localize("issue_date")
        issueDateTitle.translatesAutoresizingMaskIntoConstraints = false
        issueDateView.addSubview(issueDateTitle)
        issueDateField = UITextField()
        issueDateField.tag = 3
        issueDateField.delegate = self
        issueDateField.inputView = self.pickerView
        issueDateField.inputAccessoryView = toolBar
        issueDateField.font = contentFont
        issueDateField.translatesAutoresizingMaskIntoConstraints = false
        issueDateView.addSubview(issueDateField)
        
        NSLayoutConstraint.activate([
            issueDateView.heightAnchor.constraint(equalToConstant: 30),
            issueDateTitle.leadingAnchor.constraint(equalTo: issueDateView.leadingAnchor, constant: 0),
            issueDateTitle.centerYAnchor.constraint(equalTo: issueDateView.centerYAnchor),
            issueDateField.trailingAnchor.constraint(equalTo: issueDateView.trailingAnchor, constant: 0),
            issueDateField.centerYAnchor.constraint(equalTo: issueDateView.centerYAnchor)
        ])
        
        // Maturity date
        let maturityDateView = UIView()
        maturityDateView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(maturityDateView)
        let maturityDateTitle = UILabel()
        maturityDateTitle.font = titleFont
        maturityDateTitle.textColor = .lightGray
        maturityDateTitle.text = localize("maturity_date")
        maturityDateTitle.translatesAutoresizingMaskIntoConstraints = false
        maturityDateView.addSubview(maturityDateTitle)
        maturityDateField = UITextField()
        maturityDateField.tag = 4
        maturityDateField.delegate = self
        maturityDateField.inputView = self.pickerView
        maturityDateField.inputAccessoryView = toolBar
        maturityDateField.font = contentFont
        maturityDateField.translatesAutoresizingMaskIntoConstraints = false
        maturityDateView.addSubview(maturityDateField)
        
        NSLayoutConstraint.activate([
            maturityDateView.heightAnchor.constraint(equalToConstant: 30),
            maturityDateTitle.leadingAnchor.constraint(equalTo: maturityDateView.leadingAnchor, constant: 0),
            maturityDateTitle.centerYAnchor.constraint(equalTo: maturityDateView.centerYAnchor),
            maturityDateField.trailingAnchor.constraint(equalTo: maturityDateView.trailingAnchor, constant: 0),
            maturityDateField.centerYAnchor.constraint(equalTo: maturityDateView.centerYAnchor)
        ])
        
        // Break date
        let breakDateView = UIView()
        breakDateView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(breakDateView)
        let breakDateTitle = UILabel()
        breakDateTitle.font = titleFont
        breakDateTitle.textColor = .lightGray
        breakDateTitle.text = localize("break_date")
        breakDateTitle.translatesAutoresizingMaskIntoConstraints = false
        breakDateView.addSubview(breakDateTitle)
        breakDateField = UITextField()
        breakDateField.tag = 5
        breakDateField.delegate = self
        breakDateField.inputView = self.pickerView
        breakDateField.inputAccessoryView = toolBar
        breakDateField.font = contentFont
        breakDateField.translatesAutoresizingMaskIntoConstraints = false
        breakDateView.addSubview(breakDateField)
        
        NSLayoutConstraint.activate([
            breakDateView.heightAnchor.constraint(equalToConstant: 30),
            breakDateTitle.leadingAnchor.constraint(equalTo: breakDateView.leadingAnchor, constant: 0),
            breakDateTitle.centerYAnchor.constraint(equalTo: breakDateView.centerYAnchor),
            breakDateField.trailingAnchor.constraint(equalTo: breakDateView.trailingAnchor, constant: 0),
            breakDateField.centerYAnchor.constraint(equalTo: breakDateView.centerYAnchor)
        ])
        
        // Outstanding
        let outstandingView = UIView()
        outstandingView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(outstandingView)
        let outstandingTitle = UILabel()
        outstandingTitle.font = contentFont
        outstandingTitle.text = localize("outstanding").uppercased()
        outstandingTitle.translatesAutoresizingMaskIntoConstraints = false
        outstandingView.addSubview(outstandingTitle)
        outstandingSwitch = UISwitch()
        outstandingSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        outstandingSwitch.translatesAutoresizingMaskIntoConstraints = false
        outstandingView.addSubview(outstandingSwitch)
        
        NSLayoutConstraint.activate([
            outstandingView.heightAnchor.constraint(equalToConstant: 30),
            outstandingSwitch.leadingAnchor.constraint(equalTo: outstandingView.leadingAnchor, constant: -10),
            outstandingSwitch.centerYAnchor.constraint(equalTo: outstandingView.centerYAnchor),
            outstandingTitle.leadingAnchor.constraint(equalTo: outstandingSwitch.trailingAnchor, constant: 10),
            outstandingTitle.centerYAnchor.constraint(equalTo: outstandingView.centerYAnchor),
        ])
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        filterListView.addSubview(buttonsView)
        
        // Cancel button
        let cancelButton = UIButton()
        cancelButton.setTitleColor(.systemYellow, for: .normal)
        cancelButton.titleLabel?.font = contentFont
        cancelButton.setTitle(localize("cancel").uppercased(), for: .normal)
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeFilter))
        cancelButton.addGestureRecognizer(closeTap)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.addSubview(cancelButton)
        
        // Submit button
        let submitButton = UIButton()
        submitButton.setTitleColor(.systemYellow, for: .normal)
        submitButton.titleLabel?.font = contentFont
        submitButton.setTitle(localize("filter").uppercased(), for: .normal)
        let submitTap = UITapGestureRecognizer(target: self, action: #selector(submitFilter))
        submitButton.addGestureRecognizer(submitTap)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            filterListBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            filterListBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filterListBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterListBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterListView.centerYAnchor.constraint(equalTo: filterListBackgroundView.centerYAnchor, constant: 0),
            filterListView.leadingAnchor.constraint(equalTo: filterListBackgroundView.leadingAnchor, constant: 25),
            filterListView.trailingAnchor.constraint(equalTo: filterListBackgroundView.trailingAnchor, constant: -25),
            title.topAnchor.constraint(equalTo: filterListView.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: filterListView.leadingAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: filterListView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: filterListView.trailingAnchor, constant: -20),
            buttonsView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            buttonsView.leadingAnchor.constraint(equalTo: filterListView.leadingAnchor, constant: 20),
            buttonsView.trailingAnchor.constraint(equalTo: filterListView.trailingAnchor, constant: -20),
            buttonsView.heightAnchor.constraint(equalToConstant: 30),
            cancelButton.trailingAnchor.constraint(equalTo: submitButton.leadingAnchor, constant: -20),
            cancelButton.centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor),
            submitButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor, constant: 0),
            submitButton.centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor),
            filterListView.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 20),
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
        filterListView.isHidden = true
    }
    
    @objc func showFilter() {
        if isFilterReady {
            if fundField.text == "" {
                fundField.text = fundOptions.first
            }
            
            if statusField.text == "" {
                statusField.text = localize(statusOptions.first!)
            }
            
            if issueDateField.text == "" {
                issueDateField.text = localize(issueDateOptions.first!)
            }
            
            if maturityDateField.text == "" {
                maturityDateField.text = localize(maturityDateOptions.first!)
            }
            
            if breakDateField.text == "" {
                breakDateField.text = localize(breakDateOptions.first!)
            }
            
            filterListBackgroundView.isHidden = false
            filterListView.isHidden = false
        }
    }
    
    @objc func submitFilter() {
        closeFilter()
        page = 1
        showLoading(true)
        self.data.removeAll()
        tableView.reloadData()
        getData(lastId: nil)
    }
    
    func optionChoosed(_ tag: Int, _ option: String?) {
        switch tag {
        case 1:
            //fundField.text = option != nil ? option?.val : fundOptions.first
            fundField.text = option != nil ? option! : fundOptions.first
        case 2:
            //statusField.text = option != nil ? option?.val : localize(statusOptions.first!)
            statusField.text = option != nil ? option! : localize(statusOptions.first!)
        case 3:
            //issueDateField.text = option != nil ? option?.val : localize(issueDateOptions.first!)
            issueDateField.text = option != nil ? option! : localize(issueDateOptions.first!)
        case 4:
            //maturityDateField.text = option != nil ? option?.val : localize(maturityDateOptions.first!)
            maturityDateField.text = option != nil ? option! : localize(maturityDateOptions.first!)
        case 5:
            //breakDateField.text = option != nil ? option?.val : localize(breakDateOptions.first!)
            breakDateField.text = option != nil ? option! : localize(breakDateOptions.first!)
        default:
            break
        }
    }
    
    @objc func doneTapped() {
        self.view.endEditing(true)
        optionChoosed(currentFieldTag, currentOptionChoosed)
    }

    @objc func cancelTapped() {
        self.view.endEditing(true)
    }
    
    @objc func languageChanged() {
        setNavigationItems()
        setViewText()
    }
}

extension TransactionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == data.count - 1 && loadFinished && !stopFetch {
            page += 1
            loadFinished = false
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

extension TransactionListViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //var options = [Option]()
        var options = [String]()
        var currentText: String?
        
        let tag = textField.tag
        currentFieldTag = tag
        switch tag {
        case 1:
            // Fund
            /*for option in fundOptions {
                //let opt = Option(key: nil, val: option)
                //options.append(opt)
            }*/
            options = fundOptions
            currentText = fundField.text
        case 2:
            // Status
            /*for option in statusOptions {
                //let opt = Option(key: option, val: localize(option))
                //options.append(opt)
            }*/
            options = statusOptions
            currentText = statusField.text
        case 3:
            // Issue date
            /*for option in issueDateOptions {
                //let opt = Option(key: option, val: localize(option))
                //options.append(opt)
            }*/
            options = issueDateOptions
            currentText = issueDateField.text
        case 4:
            // Maturity date
            /*for option in maturityDateOptions {
                //let opt = Option(key: option, val: localize(option))
                //options.append(opt)
            }*/
            options = maturityDateOptions
            currentText = maturityDateField.text
        case 5:
            // Break date
            /*for option in breakDateOptions {
                //let opt = Option(key: option, val: localize(option))
                //options.append(opt)
            }*/
            options = breakDateOptions
            currentText = breakDateField.text
        default:
            break
        }
        pickerOptions = options
        //print(options)
        self.pickerView.reloadAllComponents()
        
        //if let idx = pickerOptions.firstIndex(where: { $0.val == currentText! }) {
        if let idx = pickerOptions.firstIndex(where: { $0 == currentText! }) {
            pickerView.selectRow(idx, inComponent: 0, animated: true)
        }
    }
}

extension TransactionListViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return pickerOptions[row].val
        return pickerOptions[row]
    }
}

extension TransactionListViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentOptionChoosed = pickerOptions[row]
    }
}

extension TransactionListViewController: TransactionListDelegate {
    func openLoginPage() {
        let authStoryboard : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginViewController : UIViewController = authStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    func setData(_ data: [Transaction], _ page: Int) {
        tableView.backgroundView = UIView()
        if data.count > 0 && self.page == page {
            for dt in data {
                self.data.append(dt)
            }
            
            if data.count < dataPerPage {
                stopFetch = true
            }
            showLoading(false)
            loadFinished = true
            refreshControl.endRefreshing()
            tableView.reloadData()
        }
        
        if self.data.count == 0 {
            refreshControl.endRefreshing()
            showLoading(false)
            setTableBackgroundView()
        }
    }
    
    func setFunds(_ data: [String]) {
        self.fundOptions = data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isFilterReady = true
        }
    }
    
    func getDataFail() {
        refreshControl.endRefreshing()
        showLoading(false)
        let alert = UIAlertController(title: localize("information"), message: localize("cannot_connect_to_server"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
