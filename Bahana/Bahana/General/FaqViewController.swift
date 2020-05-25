//
//  FaqViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/10.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class FaqViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var loadingView = UIView()
    
    var refreshControl = UIRefreshControl()
    
    var presenter: FaqPresenter!
    
    var data = [Faq]()
    var tempData = [Faq]()
    
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
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        searchBar.placeholder = localize("search_faq")
        searchBar.delegate = self
        
        tableView.backgroundColor = backgroundColor
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "FaqTableViewCell", bundle: nil), forCellReuseIdentifier: "FaqTableViewCell")
        
        presenter = FaqPresenter(delegate: self)
        refresh()
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
        navigationView.backgroundColor = primaryColor
        navigationViewHeight.constant = getNavigationHeight()
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        navigationTitle.textColor = .white
        navigationTitle.font = UIFont.systemFont(ofSize: 16)
        navigationTitle.text = localize("faq").uppercased()
        
        closeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
    }
    
    func showLoading(_ show: Bool) {
        if show {
            loadingView.isHidden = false
        } else {
            loadingView.isHidden = true
        }
    }
    
    @objc func refresh() {
        showLoading(true)
        presenter.getData()
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FaqViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaqTableViewCell", for: indexPath) as! FaqTableViewCell
        let faq = tempData[indexPath.row]
        cell.shrink()
        cell.titleLabel.text = faq.question
        cell.answerLabel.text = faq.answer
        return cell
    }
}

extension FaqViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FaqTableViewCell
        if cell.isExpanded! {
            cell.shrink()
        } else {
            cell.expand()
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.cellForRow(at: indexPath) as? FaqTableViewCell
        if cell != nil {
            return cell!.getHeight()
        } else {
            return 70
        }
    }
}

extension FaqViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            tempData = data
        } else {
            tempData = data.filter { $0.answer.lowercased().contains(searchText.lowercased()) || $0.question.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //tableView.reloadData()
    }
}

extension FaqViewController: FaqDelegate {
    func setData(_ data: [Faq]) {
        self.data = data
        self.tempData = data
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
        refreshControl.endRefreshing()
        showLoading(false)
        let authStoryboard : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginViewController : UIViewController = authStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
}
