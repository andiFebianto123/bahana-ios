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
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: TransactionListPresenter!
    
    var status = "All"
    var issue_date = "Any Time"
    var maturity_date = "Any Time"
    var break_date = "None"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationItems()
        
        view.backgroundColor = backgroundColor
        
        filterView.layer.cornerRadius = 3
        filterView.backgroundColor = UIColorFromHex(rgbValue: 0x3f3f3f)
        filterLabel.font = UIFont.systemFont(ofSize: 10)
        filterLabel.textColor = .white
        filterLabel.text = "FILTER TRANSACTION"
        
        tableView.register(UINib(nibName: "AuctionListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColorFromHex(rgbValue: 0xecf0f5)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        presenter = TransactionListPresenter(delegate: self)
        getData()
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
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        navigationTitle.textColor = .white
        navigationTitle.font = UIFont.systemFont(ofSize: 16)
        
        let notificationButton = UIButton(type: UIButton.ButtonType.custom)
        //notificationButton.setImage(UIImage(named: "icon_notification"), for: .normal)
        notificationButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //notificationButton.frame = buttonFrame
        //notificationButton.addTarget(self, action: #selector(showNotification), for: .touchUpInside)
    }
    
    func getData() {
        presenter.getTransaction(status, issue_date)
    }
    
    func showOptions(_ field: String, _ options: [String]) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        for option in options {
            alert.addAction(UIAlertAction(title: option, style: .default, handler: { action in
                self.optionChoosed(field, option)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func optionChoosed(_ field: String, _ option: String) {
        switch field {
        case "status":
            //statusTextField.text = option
            status = option
        case "issue_date":
            print("")
        default:
            break
        }
        self.getData()
    }
}

extension TransactionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AuctionListTableViewCell
        
        return cell
    }
}

extension TransactionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
//        performSegue(withIdentifier: "showDetail2", sender: self)
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
    
}
