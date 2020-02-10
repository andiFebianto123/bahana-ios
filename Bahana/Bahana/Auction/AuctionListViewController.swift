//
//  AuctionListViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/05.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionListViewController: UIViewController {

    //@IBOutlet weak var navigationItem2: UINavigationItem!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var statusTextFieldWidth: NSLayoutConstraint!
    @IBOutlet weak var typeTextFieldWidth: NSLayoutConstraint!
    @IBOutlet weak var showButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: AuctionListPresenter!
    
    var test = "auction"
    
    var status = "ALL"
    var type = "ALL"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationItems()
        
        view.backgroundColor = backgroundColor
        
        let statusTap = UITapGestureRecognizer(target: self, action: #selector(statusFieldTapped))
        statusTextField.addGestureRecognizer(statusTap)
        statusTextField.placeholder = "Status"
        statusTextField.rightViewMode = .always
        let dropdownView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        let dropdownImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        dropdownImageView.contentMode = .center
        //dropdownImageView.image = UIImage(systemName: "chevron.down")
        //dropdownImageView.image?.withTintColor(UIColor.black)
        dropdownView.addSubview(dropdownImageView)
        statusTextField.rightView = dropdownView
        let typeTap = UITapGestureRecognizer(target: self, action: #selector(typeFieldTapped))
        typeTextField.addGestureRecognizer(typeTap)
        typeTextField.placeholder = "Type"
        typeTextField.rightViewMode = .always
        let dropdownView2 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        let dropdownImageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        dropdownImageView2.contentMode = .center
        //dropdownImageView2.image = UIImage(systemName: "chevron.down")
        //dropdownImageView2.image?.withTintColor(UIColor.black)
        dropdownView2.addSubview(dropdownImageView2)
        typeTextField.rightView = dropdownView2
        showButton.setTitle("Show", for: .normal)
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
        //navigationBar.barTintColor = UIColor.red
        navigationController?.navigationBar.barTintColor = primaryColor
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let label = UILabel()
        if test == "auction" {
            label.text = "AUCTION"
        } else if test == "history" {
            label.text = "HISTORY"
        }
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        let titleBar = UIBarButtonItem.init(customView: label)
        //navigationItem2.setHidesBackButton(true, animated: false)
        //navigationItem2.setLeftBarButton(titleBar, animated: true)
        //navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationItem.setLeftBarButton(titleBar, animated: true)
        
        let notificationButton = UIButton(type: UIButton.ButtonType.custom)
        //closeButton.setImage(UIImage(named: "icon_back_white"), for: .normal)
        notificationButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //closeButton.frame = buttonFrame
        //closeButton.addTarget(self, action: #selector(showAlertExit), for: .touchUpInside)
        let notificationBarButton = UIBarButtonItem(customView: notificationButton)
        //navigationItem.setHidesBackButton(true, animated: false)
        
        //navigationItem.rightBarButtonItem = notificationBarButton
    }
    
    func getData() {
        if test == "auction" {
            presenter.getAuction(status, type)
        } else if test == "history" {
            presenter.getAuctionHistory(status, type)
        }
    }
    
    @objc func statusFieldTapped() {
        let options = [
            "ALL", "-", "ACC", "REJ", "NEC"
        ]
        showOptions("status", options)
    }
    
    @objc func typeFieldTapped() {
        let options = [
            "ALL", "AUCTION", "DIRECT AUCTION", "BREAK", "ROLLOVER"
        ]
        showOptions("type", options)
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
            statusTextField.text = option
            status = option
        case "type":
            typeTextField.text = option
            type = option
        default:
            break
        }
        self.getData()
    }
}

extension AuctionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AuctionListTableViewCell
        
        return cell
    }
    
    
}

extension AuctionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

extension AuctionListViewController: AuctionListDelegate {
    func openLoginPage() {
        let authStoryboard : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginViewController : UIViewController = authStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
}
