//
//  AuctionListViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/05.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionListViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var statusTextFieldWidth: NSLayoutConstraint!
    @IBOutlet weak var typeTextFieldWidth: NSLayoutConstraint!
    @IBOutlet weak var showButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var tableBackgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var loadingView = UIView()
    
    var refreshControl = UIRefreshControl()
    
    var presenter: AuctionListPresenter!
    
    var pageType: String!
    var stopFetch: Bool = false
    var loadFinished: Bool = false
    
    let statusOptions = ["ALL", "-", "ACC", "REJ", "NEC"]
    let typeOptions = ["ALL", "AUCTION", "DIRECT AUCTION", "BREAK", "ROLLOVER"]
    
    var auctionID = Int()
    var auctionType = String()
    
    var data = [Auction]()
    let dataPerPage = 10
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationItems()
        setViewText()
        
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
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        let statusTap = UITapGestureRecognizer(target: self, action: #selector(statusFieldTapped))
        statusTextField.addGestureRecognizer(statusTap)
        statusTextField.borderStyle = .none
        statusTextField.rightViewMode = .always
        statusTextField.placeholder = " Status"
        let dropdownView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        let dropdownImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        dropdownImageView.contentMode = .center
        //dropdownImageView.image = UIImage(systemName: "chevron.down")
        //dropdownImageView.image?.withTintColor(UIColor.black)
        dropdownView.addSubview(dropdownImageView)
        statusTextField.rightView = dropdownView
        let typeTap = UITapGestureRecognizer(target: self, action: #selector(typeFieldTapped))
        typeTextField.addGestureRecognizer(typeTap)
        typeTextField.borderStyle = .none
        typeTextField.rightViewMode = .always
        typeTextField.placeholder = " Type"
        let dropdownView2 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        let dropdownImageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        dropdownImageView2.contentMode = .center
        //dropdownImageView2.image = UIImage(systemName: "chevron.down")
        //dropdownImageView2.image?.withTintColor(UIColor.black)
        dropdownView2.addSubview(dropdownImageView2)
        typeTextField.rightView = dropdownView2
        showButton.setTitleColor(UIColor.white, for: .normal)
        showButton.backgroundColor = UIColor.black
        
        showButtonWidth.constant = 100
        let screenWidth = UIScreen.main.bounds.width
        statusTextFieldWidth.constant = (screenWidth / 2) - (showButtonWidth.constant - 50)
        typeTextFieldWidth.constant = (screenWidth / 2) - (showButtonWidth.constant - 50)
        
        tableView.register(UINib(nibName: "AuctionListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColorFromHex(rgbValue: 0xecf0f5)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        presenter = AuctionListPresenter(delegate: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: Notification.Name("LanguageChanged"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        page = 1
        showLoading(true)
        self.getData(lastId: nil, lastDate: nil, lastType: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            if let destinationVC = segue.destination as? AuctionDetailViewController {
                destinationVC.auctionID = auctionID
                destinationVC.auctionType = auctionType
            }
        }
    }

    func setNavigationItems() {
        navigationView.backgroundColor = primaryColor
        navigationViewHeight.constant = getNavigationHeight()
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        navigationTitle.textColor = .white
        navigationTitle.font = UIFont.systemFont(ofSize: 16)
        if pageType == "auction" {
            navigationTitle.text = localize("auction").uppercased()
        } else if pageType == "history" {
            navigationTitle.text = localize("history").uppercased()
        }
        
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
    
    func setViewText() {
        statusTextField.placeholder = localize("status")
        typeTextField.placeholder = localize("type")
        showButton.setTitle(localize("show"), for: .normal)
    }
    
    func showLoading(_ show: Bool) {
        if show {
            loadingView.isHidden = false
        } else {
            loadingView.isHidden = true
        }
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
    
    @objc func refresh(sender:AnyObject) {
        page = 1
        showLoading(true)
        self.data.removeAll()
        tableView.reloadData()
        self.getData(lastId: nil, lastDate: nil, lastType: nil)
    }
    
    @objc func showNotification() {
        performSegue(withIdentifier: "showNotification", sender: self)
    }
    
    func getData(lastId: Int?, lastDate: String?, lastType: String?, page: Int = 1) {
        let status = statusTextField.text!
        let type = typeTextField.text!
        
        let filter = [
            "status": status,
            "type": type
        ]
        
        if pageType == "auction" {
            presenter.getAuction(filter, lastId: lastId, lastDate: lastDate, page)
        } else if pageType == "history" {
            presenter.getAuctionHistory(filter, lastId: lastId, lastDate: lastDate, lastType: lastType, page)
        }
    }
    
    @objc func statusFieldTapped() {
        showOptions("status", statusOptions)
    }
    
    @objc func typeFieldTapped() {
        showOptions("type", typeOptions)
    }
    
    func showOptions(_ field: String, _ options: [String]) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        for option in options {
            alert.addAction(UIAlertAction(title: option, style: .default, handler: { action in
                self.optionChoosed(field, option)
            }))
        }
        alert.addAction(UIAlertAction(title: localize("cancel"), style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func optionChoosed(_ field: String, _ option: String) {
        switch field {
        case "status":
            statusTextField.text = "\(option)"
        case "type":
            typeTextField.text = "\(option)"
        default:
            break
        }
    }

    @IBAction func showButtonPressed(_ sender: Any) {
        page = 1
        showLoading(true)
        self.data.removeAll()
        tableView.reloadData()
        self.getData(lastId: nil, lastDate: nil, lastType: nil)
    }
    
    @objc func languageChanged() {
        setNavigationItems()
        setViewText()
    }
}

extension AuctionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == data.count - 1 && loadFinished && !stopFetch {
            page += 1
            loadFinished = false
            self.getData(lastId: data[indexPath.row].id, lastDate: data[indexPath.row].end_date, lastType: data[indexPath.row].type, page: page)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AuctionListTableViewCell
        let auction = data[indexPath.row]
        cell.pageType = pageType
        cell.setAuction(auction)
        return cell
    }
}

extension AuctionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        auctionID = data[indexPath.row].id
        auctionType = data[indexPath.row].type
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
}

extension AuctionListViewController: AuctionListDelegate {
    func openLoginPage() {
        let authStoryboard : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginViewController : UIViewController = authStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    func setData(_ data: [Auction], _ page: Int) {
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
            showLoading(false)
            setTableBackgroundView()
        }
    }
}
