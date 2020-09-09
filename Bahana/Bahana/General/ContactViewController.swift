//
//  ContactViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/09.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var loadingView = UIView()
    
    var refreshControl = UIRefreshControl()
    
    var presenter: ContactPresenter!
    
    var data = [Contact]()
    
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
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.backgroundColor = backgroundColor
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
        presenter = ContactPresenter(delegate: self)
        showLoading(true)
        presenter.getData()
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
        //self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let label = UILabel()
        label.text = localize("contact").uppercased()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        let titleBar = UIBarButtonItem.init(customView: label)
        //navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.setLeftBarButton(titleBar, animated: true)
        
        let closeButton = UIButton(type: UIButton.ButtonType.custom)
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 70, bottom: 10, right: 0)
        //closeButton.frame = buttonFrame
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        //navigationItem.setHidesBackButton(true, animated: false)
        
        navigationItem.rightBarButtonItem = closeBarButton
    }
    
    func showLoading(_ show: Bool) {
        if show {
            loadingView.isHidden = false
        } else {
            loadingView.isHidden = true
        }
    }
    
    @objc func refresh() {
        presenter.getData()
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ContactViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactTableViewCell
        let contact = data[indexPath.row]
        cell.position.text = contact.position
        cell.name.text = contact.name
        cell.phone.text = contact.phone
        return cell
    }
}

extension ContactViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ContactViewController: ContactDelegate {
    func setData(_ data: [Contact]) {
        self.data = data
        refreshControl.endRefreshing()
        showLoading(false)
        tableView.reloadData()
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
