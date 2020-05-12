//
//  RegisterViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/31.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit
import Eureka

class RegisterViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topTabView: UIView!
    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var bottomNavigationView: UIView!
    @IBOutlet weak var previousView: UIView!
    @IBOutlet weak var previousViewWidth: NSLayoutConstraint!
    @IBOutlet weak var nextView: UIView!
    @IBOutlet weak var nextViewWidth: NSLayoutConstraint!
    @IBOutlet weak var previousIcon: UIImageView!
    @IBOutlet weak var previousLabel: UILabel!
    @IBOutlet weak var nextIcon: UIImageView!
    @IBOutlet weak var nextLabel: UILabel!
    
    var presenter: RegisterPresenter!
    
    var viewTo = String()
    var currentViewIdx = 0
    
    var formValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "RegisterStepCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RegisterStepCollectionViewCell")
        
        setNavigationItems()
        
        bottomBorderView.backgroundColor = primaryColor
        previousLabel.textColor = UIColor.gray
        nextLabel.textColor = primaryColor
        
        presenter = RegisterPresenter(delegate: self)
        
        if viewTo == "" {
            // If view is register
            let previousTap = UITapGestureRecognizer(target: self, action: #selector(showPrev))
            previousView.addGestureRecognizer(previousTap)
            let nextTap = UITapGestureRecognizer(target: self, action: #selector(validateForm))
            nextView.addGestureRecognizer(nextTap)
            
            loadMainView(index: 0)
        } else if viewTo == "profile" {
            topTabView.isHidden = true
            bottomBorderView.isHidden = true
            bottomNavigationView.isHidden = true
            loadMainView(index: 0)
        } else if viewTo == "best_rate" {
            topTabView.isHidden = true
            bottomBorderView.isHidden = true
            bottomNavigationView.isHidden = true
            loadMainView(index: 1)
        }
        
        // Back when form failed to load
        NotificationCenter.default.addObserver(self, selector: #selector(back(notification:)), name: Notification.Name("RegisterBack"), object: nil)
        // Go to next step
        NotificationCenter.default.addObserver(self, selector: #selector(showNext(notification:)), name: Notification.Name("RegisterNextValidation"), object: nil)
        // Check if user checked agreement checkbox
        NotificationCenter.default.addObserver(self, selector: #selector(isAgree(notification:)), name: Notification.Name("RegisterAgreement"), object: nil)
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
        if viewTo == "" {
            label.text = localize("registration").uppercased()
        } else if viewTo == "profile" {
            label.text = localize("edit_profile").uppercased()
        } else if viewTo == "best_rate" {
            label.text = localize("edit_best_rate").uppercased()
        }
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
        closeButton.addTarget(self, action: #selector(showAlertExit), for: .touchUpInside)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        //navigationItem.setHidesBackButton(true, animated: false)
        
        navigationItem.rightBarButtonItem = closeBarButton
    }
    
    @objc func showAlertExit() {
        let alert = UIAlertController(title: localize("information"), message: localize("confirmation_leave_page"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("no"), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: localize("yes"), style: .default, handler: { action in
            self.resetRegisterData()
            NotificationCenter.default.post(name: Notification.Name("RegisterExit"), object: nil, userInfo: nil)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadMainView(index: Int) {
        previousLabel.text = localize("previous").uppercased()
        nextLabel.text = localize("next").uppercased()
        if index == 0 {
            previousView.isHidden = true
        } else if index == 1 {
            previousView.isHidden = false
        } else if index == 2 {
            nextLabel.text = localize("submit").uppercased()
        }
        
        previousViewWidth.constant = previousLabel.intrinsicContentSize.width + 25
        nextViewWidth.constant = nextLabel.intrinsicContentSize.width + 25
        
        // Load view by tab index
        NotificationCenter.default.post(name: Notification.Name("RegisterTab"), object: nil, userInfo: ["idx": index])
        
        if viewTo == "" {
            NotificationCenter.default.post(name: Notification.Name("RegisterPage"), object: nil, userInfo: nil)
        }
    }
    
    @objc func back(notification:Notification) {
        if let data = notification.userInfo as? [String: Int] {
            let idx = data["step"]!
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func validateForm() {
        // Before go to next step, validate form first
        NotificationCenter.default.post(name: Notification.Name("RegisterNext"), object: nil, userInfo: ["idx": currentViewIdx])
    }
    
    @objc func showPrev() {
        currentViewIdx -= 1
        if currentViewIdx == 2 && !formValid {
            nextView.isUserInteractionEnabled = false
            //nextIcon.image = UIImage(named: "icon_chevron_right_grey")
        } else {
           nextView.isUserInteractionEnabled = true
            nextIcon.image = UIImage(named: "icon_chevron_right_red")
        }
        loadMainView(index: currentViewIdx)
        collectionView.reloadData()
    }
    
    @objc func showNext(notification:Notification) {
        if let data = notification.userInfo as? [String: Int] {
            if let idx = data["idx"] {
                if idx == 2 && !formValid {
                    // Last step
                    nextView.isUserInteractionEnabled = false
                    nextIcon.image = nil
                    nextViewWidth.constant = nextLabel.intrinsicContentSize.width
                } else {
                    nextView.isUserInteractionEnabled = true
                }
                currentViewIdx = idx
                
                if idx == 3 {
                    // Submit from last step
                    presenter.submit()
                } else {
                    loadMainView(index: idx)
                    collectionView.reloadData()
                }
            }
        }
    }
    
    @objc func isAgree(notification:Notification) {
        if let data = notification.userInfo as? [String: Int] {
            let isChecked = data["isChecked"]!
            if isChecked == 1 {
                formValid = true
                nextView.isUserInteractionEnabled = true
                nextLabel.textColor = UIColor.black
            } else {
                formValid = false
                nextView.isUserInteractionEnabled = false
                nextLabel.textColor = UIColor.gray
            }
        }
    }
    
    func resetRegisterData() {
        let data: [String: String] = [
            "name": "",
            "email": "",
            "phone": "",
            "pic_alternative": "",
            "phone_alternative": "",
            "bank": "",
            "bank_name": "",
            "bank_branch": "",
            "bank_branch_name": "",
            "bank_branch_address": "",
            "bank_type": "",
            "foreign_exchange": "",
            "book": "",
            "sharia": "",
            "interest_day_count_convertion": "",
            "end_date": "",
            "return_to_start_date": "",
            "holiday_interest": "",
            "password": "",
            "password_confirmation": "",
            "idr_breakable_policy": "",
            "idr_breakable_policy_notes": "",
            "idr_account_number": "",
            "idr_account_name": "",
            "idr_month_rate_1": "",
            "idr_month_rate_3": "",
            "idr_month_rate_6": "",
            "usd_breakable_policy": "",
            "usd_breakable_policy_notes": "",
            "usd_account_number": "",
            "usd_account_name": "",
            "usd_month_rate_1": "",
            "usd_month_rate_3": "",
            "usd_month_rate_6": "",
            "sharia_breakable_policy": "",
            "sharia_breakable_policy_notes": "",
            "sharia_account_number": "",
            "sharia_account_name": "",
            "sharia_month_rate_1": "",
            "sharia_month_rate_3": "",
            "sharia_month_rate_6": "",
        ]
        setLocalData(data)
    }
}

extension RegisterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegisterStepCollectionViewCell", for: indexPath) as! RegisterStepCollectionViewCell
        let fontSize = UIFont.systemFont(ofSize: 9)
        switch indexPath.row {
        case 0:
            cell.number.text = "1"
            cell.number.font = fontSize
            cell.name.text = localize("registration_form")
            cell.name.font = fontSize
            if currentViewIdx >= 0 {
                cell.setActive()
            } else {
                cell.setInactive()
            }
        case 1:
            cell.number.text = "2"
            cell.number.font = fontSize
            cell.name.text = localize("best_rate")
            cell.name.font = fontSize
            if currentViewIdx >= 1 {
                cell.setActive()
            } else {
                cell.setInactive()
            }
        case 2:
            cell.number.text = "3"
            cell.number.font = fontSize
            cell.name.text = localize("terms_and_conditions")
            cell.name.font = fontSize
            if currentViewIdx == 2 {
                cell.setActive()
            } else {
                cell.setInactive()
            }
        default:
            break
        }
        return cell
    }
    
    
}

extension RegisterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: (screenSize.width - 30) / 3, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension RegisterViewController: RegisterDelegate {
    func isRegisterSuccess(_ isSuccess: Bool, _ message: String) {
        let alert = UIAlertController(title: localize("information"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: { action in
            if isSuccess {
                self.resetRegisterData()
                self.dismiss(animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
