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
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var changeEndDateButton: UIButton!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    
    var auctionID: Int!
    var auctionType: String!
    var auctionRequestMaturityDate: String?
    
    var textField = UITextField()
    var datePicker = UIDatePicker()
    
    var presenter: AuctionDetailConfirmationPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainView.layer.cornerRadius = 5
        mainView.layer.shadowColor = UIColor.gray.cgColor
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.shadowRadius = 4
        mainView.layer.shadowOpacity = 0.5
        
        closeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        
        confirmationLabel.text = "Are you sure you want to be the winner?"
        
        noButton.backgroundColor = primaryColor
        noButton.setTitleColor(.white, for: .normal)
        
        yesButton.backgroundColor = UIColorFromHex(rgbValue: 0x85cc63)
        yesButton.setTitleColor(.white, for: .normal)
        
        changeEndDateButton.backgroundColor = UIColorFromHex(rgbValue: 0xffc74e)
        changeEndDateButton.setTitleColor(.white, for: .normal)
        
        if auctionType == "BREAK" {
            confirmationLabel.text = "Are you sure you want to be the choosen bidder?"
            changeEndDateButton.isHidden = true
            mainViewHeight.constant -= 20
        } else {
            confirmationLabel.text = "Are you sure you want to be the winner?"
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

    func setDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: localize("done"), style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: localize("cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(closePicker))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        textField = UITextField()
        view.addSubview(textField)
        textField.inputView = datePicker
        textField.inputAccessoryView = toolbar
    }
    
    @IBAction func noButtonPressed(_ sender: Any) {
        presenter.confirm(auctionID, auctionType, false, auctionRequestMaturityDate)
    }
    
    @IBAction func yesButtonPressed(_ sender: Any) {
        presenter.confirm(auctionID, auctionType, true, auctionRequestMaturityDate)
    }
    
    @IBAction func changeEndDatePressed(_ sender: Any) {
        textField.becomeFirstResponder()
    }
    
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dateChanged(sender: UIDatePicker) {
        let date = convertDateToString(datePicker.date)
        auctionRequestMaturityDate = date!
    }
    
    @objc func closePicker() {
        textField.resignFirstResponder()
    }
    
    @objc func donePicker() {
        textField.resignFirstResponder()
        showConfirmationAlert(auctionRequestMaturityDate!)
    }
    
    func showConfirmationAlert(_ date: String) {
        let alert = UIAlertController(title: localize("information"), message: "Are you sure you want to change end date to \(date)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("no"), style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: localize("yes"), style: .default, handler: { action in
            print("yes")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AuctionDetailConfirmationViewController: AuctionDetailConfirmationDelegate {
    func isConfirmed(_ isConfirmed: Bool, _ message: String) {
        //
    }
}
