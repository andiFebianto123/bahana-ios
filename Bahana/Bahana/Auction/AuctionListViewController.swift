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
    
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var statusTextFieldWidth: NSLayoutConstraint!
    @IBOutlet weak var typeTextFieldWidth: NSLayoutConstraint!
    @IBOutlet weak var showButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: AuctionListPresenter!
    
    var pageType = "auction"
    
    var auctionID = Int()
    var auctionType = String()
    
    var data = [Auction]()
    
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
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        navigationTitle.textColor = .white
        navigationTitle.font = UIFont.systemFont(ofSize: 16)
        if pageType == "auction" {
            navigationTitle.text = "AUCTION"
        } else if pageType == "history" {
            navigationTitle.text = "HISTORY"
        }
        
        let notificationButton = UIButton(type: UIButton.ButtonType.custom)
        //notificationButton.setImage(UIImage(named: "icon_notification"), for: .normal)
        notificationButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //notificationButton.frame = buttonFrame
        //notificationButton.addTarget(self, action: #selector(showNotification), for: .touchUpInside)
    }
    
    func getData() {
        let status = statusTextField.text!
        let type = typeTextField.text!
        if pageType == "auction" {
            presenter.getAuction(status, type, page: 1)
        } else if pageType == "history" {
            presenter.getAuctionHistory(status, type, page: 1)
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
        case "type":
            typeTextField.text = option
        default:
            break
        }
        self.getData()
    }
}

extension AuctionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AuctionListTableViewCell
        let auction = data[indexPath.row]
        cell.typeLabel.text = auction.type.uppercased()
        cell.setStatus(auction.status)
        cell.fundNameLabel.text = auction.portfolio_short
        cell.investmentLabel.text = "IDR \(toIdrBio(auction.investment_range_start)) - \(toIdrBio(auction.investment_range_end))"
        cell.tenorLabel.text = auction.period
        cell.placementDateLabel.text = convertDateToString(convertStringToDatetime(auction.start_date)!)
        cell.endLabel.text = "\(calculateDateDifference(Date(), convertStringToDatetime(auction.end_date)!))"
        return cell
    }
}

extension AuctionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        auctionID = data[indexPath.row].id
        auctionType = data[indexPath.row].type.uppercased()
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
    
    func setData(_ data: [Auction]) {
        self.data = data
        tableView.reloadData()
    }
}
