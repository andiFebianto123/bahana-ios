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
    @IBOutlet weak var tableView: UITableView!
    
    var loadingView = UIView()
    
    var refreshControl = UIRefreshControl()
    
    var presenter: NotificationPresenter!
    
    var data = [NotificationModel]()
    let dataPerPage = 10
    var page = 1
    
    var stopFetch: Bool = false
    var loadFinished: Bool = false
    
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
        
        setNavigationItems()
        
        presenter = NotificationPresenter(delegate: self)
        refresh()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showAuctionDetail" {
            if let destinationVC = segue.destination as? AuctionDetailViewController {
                destinationVC.auctionID = auctionID
                destinationVC.auctionType = auctionType
            }
        } else if segue.identifier == "showTransactionDetail" {
            if let destinationVC = segue.destination as? TransactionDetailViewController {
                destinationVC.transactionID = transactionID
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
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationTableViewCell
        let notification = data[indexPath.row]
        cell.setData(notification)
        return cell
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
            if notification.data!.type != "transaction" && notification.data?.sub_type != nil && notification.data!.sub_type == "detail" {
                auctionID = notification.data?.id
                auctionType = notification.data?.type!
                presenter.markAsRead(notification.id)
                performSegue(withIdentifier: "showAuctionDetail", sender: self)
            } else if notification.data!.type == "transaction" {
                transactionID = notification.data?.id
                presenter.markAsRead(notification.id)
                performSegue(withIdentifier: "showTransactionDetail", sender: self)
            }
        }
    }
}

extension NotificationViewController: NotificationDelegate {
    func setData(_ data: [NotificationModel], _ page: Int) {
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
    }
    
    func isMarkAsRead(_ isRead: Bool) {
        //tableView.reloadData()
    }
    
    func getDataFail() {
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
