//
//  AuctionDetailConfirmationViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/28.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionDetailConfirmationViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var changeEndDateButton: UIButton!
    
    var loadingView = UIView()
    
    var auctionID: Int!
    var auctionType: String!
    var id: Int?
    var revisionRate: String?
    var confirmationType: String!
    var needRefresh: Bool = false
    
    var textField = UITextField()
    var datePicker = UIDatePicker()
    
    var presenter: AuctionDetailConfirmationPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationTitle.text = localize("confirmation").uppercased()
        mainView.layer.cornerRadius = 5
        mainView.layer.shadowColor = UIColor.gray.cgColor
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.shadowRadius = 4
        mainView.layer.shadowOpacity = 0.5
        
        // Set loading view
        loadingView.isHidden = true
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
        
        closeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        
        noButton.backgroundColor = primaryColor
        noButton.setTitle(localize("no").uppercased(), for: .normal)
        noButton.setTitleColor(.white, for: .normal)
        
        yesButton.backgroundColor = greenColor
        yesButton.setTitle(localize("yes").uppercased(), for: .normal)
        yesButton.setTitleColor(.white, for: .normal)
        
        changeEndDateButton.backgroundColor = accentColor
        changeEndDateButton.setTitle(localize("change_end_date").uppercased(), for: .normal)
        changeEndDateButton.setTitleColor(.white, for: .normal)
        
        if confirmationType == "chosen_bidder" {
            confirmationLabel.text = localize("confirmation_chosen_bidder")
            changeEndDateButton.isHidden = true
        } else if confirmationType == "chosen_winner" {
            confirmationLabel.text = localize("confirmation_chosen_winner")
            //id = auctionID
        } else if confirmationType == "revise_rate" {
            confirmationLabel.text = localize("confirmation_revise_rate")
            //id = auctionID
        }
        
        setDatePicker()
        
        presenter = AuctionDetailConfirmationPresenter(delegate: self)
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
        navigationViewHeight.constant = getNavigationHeight()
        navigationTitle.text = localize("confirmation").uppercased()
    }

    func setDatePicker() {
        var locale: Locale!
        switch getLocalData(key: "language") {
        case "language_id":
            locale = Locale(identifier: "id")
        case "language_en":
            locale = Locale(identifier: "en")
        default:
            break
        }
        datePicker.locale = locale
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: localize("ok"), style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: localize("cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(closePicker))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        textField = UITextField()
        view.addSubview(textField)
        textField.inputView = datePicker
        textField.inputAccessoryView = toolbar
    }
    
    func showLoading(_ isShow: Bool) {
        loadingView.isHidden = !isShow
    }
    
    func showAlert(title: String, message: String, _ isReturnToDetail: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: { action in
            if isReturnToDetail {
                self.goBack()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func noButtonPressed(_ sender: Any) {
        if self.confirmationType == "revise_rate" {
            goBack()
        } else {
            showLoading(true)
            presenter.confirm(auctionID, auctionType, false, nil, id)
        }
    }
    
    @IBAction func yesButtonPressed(_ sender: Any) {
        showLoading(true)
        if self.confirmationType == "revise_rate" {
            presenter.reviseAuction(self.auctionID, self.revisionRate)
        } else {
            
            presenter.confirm(auctionID, auctionType, true, nil, id)
        }
        // print(self.auctionType)
    }
    
    @IBAction func changeEndDatePressed(_ sender: Any) {
        textField.becomeFirstResponder()
    }
    
    @objc func goBack() {
        if needRefresh {
            NotificationCenter.default.post(name: .refreshAuctionDetail, object: nil, userInfo: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dateChanged(sender: UIDatePicker) {
        let date = convertDateToString(datePicker.date)
        //auctionRequestMaturityDate = date!
    }
    
    @objc func closePicker() {
        textField.resignFirstResponder()
    }
    
    @objc func donePicker() {
        textField.resignFirstResponder()
        let date = convertDateToString(datePicker.date)!
        showConfirmationAlert(date)
    }
    
    func showConfirmationAlert(_ date: String) {
        let alert = UIAlertController(title: localize("information"), message: "\(localize("confirmation_change_end_date")) \(date)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("no"), style: .default, handler: { action in
            
        }))
        alert.addAction(UIAlertAction(title: localize("yes"), style: .default, handler: { action in
            self.showLoading(true)
            let maturityDate = convertDateToString(self.datePicker.date, format: "yyyy-MM-dd")
            self.presenter.confirm(self.auctionID, self.auctionType, true, maturityDate, self.id)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AuctionDetailConfirmationViewController: AuctionDetailConfirmationDelegate {
    func isConfirmed(_ isConfirmed: Bool, _ message: String) {
        showLoading(false)
        if isConfirmed {
            needRefresh = true
        }
        showAlert(title: localize("information"), message: message, isConfirmed)
    }
    
    func setDataFail() {
        showLoading(false)
        let alert = UIAlertController(title: localize("information"), message: localize("cannot_connect_to_server"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
