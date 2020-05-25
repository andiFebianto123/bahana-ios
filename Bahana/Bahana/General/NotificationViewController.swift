//
//  NotificationViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/09.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var navigationBackView: UIView!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var loadingView = UIView()
    
    var refreshControl = UIRefreshControl()
    
    var presenter: NotificationPresenter!
    
    var data = [NotificationModel]()
    let dataPerPage = 10
    var page = 1
    
    var stopFetch: Bool = false
    var loadFinished: Bool = false
    var loadFailed: Bool = false
    
    var auctionID: Int!
    var auctionType: String!
    var transactionID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = backgroundColor
        //tableView.estimatedRowHeight = CGFloat()
        
        tableView.register(UINib(nibName: "AuctionListReloadTableViewCell", bundle: nil), forCellReuseIdentifier: "AuctionListReloadTableViewCell")
        
        setNavigationItems()
        
        presenter = NotificationPresenter(delegate: self)
        refresh()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showAuctionDetailNormal" {
            if let destinationVC = segue.destination as? AuctionDetailNormalViewController {
                destinationVC.id = auctionID
            }
        } else if segue.identifier == "showAuctionDetailDirect" {
            if let destinationVC = segue.destination as? AuctionDetailDirectViewController {
                destinationVC.id = auctionID
            }
        } else if segue.identifier == "showAuctionDetailBreak" {
            if let destinationVC = segue.destination as? AuctionDetailBreakViewController {
                destinationVC.id = auctionID
            }
        } else if segue.identifier == "showAuctionDetailRollover" {
            if let destinationVC = segue.destination as? AuctionDetailRolloverViewController {
                destinationVC.id = auctionID
            }
        } else if segue.identifier == "showAuctionDetailMature" {
           if let destinationVC = segue.destination as? AuctionDetailMatureViewController {
               destinationVC.id = auctionID
           }
        } else if segue.identifier == "showTransactionDetail" {
            if let destinationVC = segue.destination as? TransactionDetailViewController {
                destinationVC.transactionID = transactionID
            }
        } else if segue.identifier == "showBestRate" {
            if let navigation = segue.destination as? UINavigationController {
                if let destinationVC = navigation.topViewController as? RegisterViewController {
                    destinationVC.viewTo = "best_rate"
                }
            }
        }
    }

    func setNavigationItems() {
        navigationView.backgroundColor = primaryColor
        navigationViewHeight.constant = getNavigationHeight()
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        navigationTitle.textColor = .white
        navigationTitle.font = UIFont.systemFont(ofSize: 16)
        navigationTitle.text = localize("notification").uppercased()
        
        navigationBackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        
        moreView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moreButtonPressed)))
    }
    
    func getData(lastId: Int?, lastDate: String?, page: Int = 1) {
        presenter.getData(lastId: lastId, lastDate: lastDate, page)
    }
    
    func showLoading(_ show: Bool) {
        if show {
            loadingView.isHidden = false
        } else {
            loadingView.isHidden = true
        }
    }
    
    @objc func refresh() {
        page = 1
        showLoading(true)
        self.data.removeAll()
        tableView.reloadData()
        getData(lastId: nil, lastDate: nil)
    }
    
    @objc func moreButtonPressed() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: localize("mark_all_as_read"), style: .default, handler: { action in
            self.presenter.markAllAsRead()
        }))
        alert.addAction(UIAlertAction(title: localize("cancel"), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setTableBackgroundView() {
        let customView = UIView()
        
        let text = UILabel()
        text.text = localize("no_data_available")
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
}

extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == data.count - 1 && loadFinished && !stopFetch {
            page += 1
            loadFinished = false
            let lastData = data[indexPath.row]
            let lastId = lastData.id
            let lastDate = lastData.available_at
            self.getData(lastId: lastId, lastDate: lastDate, page: page)
        }
        
        var customCell: UITableViewCell!
        
        if indexPath.row <= data.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationTableViewCell
            let notification = data[indexPath.row]
            cell.setData(notification)
            customCell = cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AuctionListReloadTableViewCell", for: indexPath) as! AuctionListReloadTableViewCell
            cell.delegate = self
            cell.isHidden = true
            if loadFailed {
                cell.isHidden = false
            }
            customCell = cell
        }
        
        return customCell
    }
}

extension NotificationViewController: UITableViewDelegate {
    /*func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableView.automaticDimension
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = data[indexPath.row]
        if notification.data != nil {
            if notification.data!.type != "transaction" && notification.data!.type != "base-placement" && notification.data?.sub_type != nil && notification.data!.sub_type == "detail" {
                auctionID = notification.data?.id
                auctionType = notification.data?.type!
                presenter.markAsRead(notification.id)
                switch notification.data?.type {
                case "auction":
                    performSegue(withIdentifier: "showAuctionDetailNormal", sender: self)
                case "direct-auction":
                    performSegue(withIdentifier: "showAuctionDetailDirect", sender: self)
                case "break":
                    performSegue(withIdentifier: "showAuctionDetailBreak", sender: self)
                case "rollover":
                    performSegue(withIdentifier: "showAuctionDetailRollover", sender: self)
                case "mature":
                    performSegue(withIdentifier: "showAuctionDetailMature", sender: self)
                default:
                    break
                }
                //performSegue(withIdentifier: "showAuctionDetail", sender: self)
            } else if notification.data!.type == "transaction" {
                transactionID = notification.data?.id
                presenter.markAsRead(notification.id)
                performSegue(withIdentifier: "showTransactionDetail", sender: self)
            } else if notification.data!.type == "base-placement" {
                performSegue(withIdentifier: "showBestRate", sender: self)
            }
        }
    }
}

extension NotificationViewController: NotificationDelegate {
    func setData(_ data: [NotificationModel], _ page: Int) {
        loadFailed = false
        tableView.backgroundView = UIView()
        if data.count > 0 && self.page == page {
            for dt in data {
                self.data.append(dt)
            }
            
            if data.count < dataPerPage {
                stopFetch = true
            }
            refreshControl.endRefreshing()
            showLoading(false)
            loadFinished = true
            tableView.reloadData()
        }
        
        if self.data.count == 0 {
            refreshControl.endRefreshing()
            showLoading(false)
            setTableBackgroundView()
        }
    }
    
    func isMarkAsRead(_ isRead: Bool) {
        refresh()
    }
    
    func getDataFail() {
        loadFailed = true
        tableView.reloadData()
        refreshControl.endRefreshing()
        showLoading(false)
        let alert = UIAlertController(title: localize("information"), message: localize("cannot_connect_to_server"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openLoginPage() {
        let authStoryboard : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginViewController : UIViewController = authStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
}

extension NotificationViewController: AuctionListReloadDelegate {
    func reload() {
        let lastRow = data.last
        self.getData(lastId: lastRow?.id, lastDate: lastRow?.available_at, page: page)
    }
}
