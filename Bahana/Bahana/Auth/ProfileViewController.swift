//
//  ProfileViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/31.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit
import Eureka

class ProfileViewController: FormViewController {
    
    var presenter: ProfilePresenter!
    
    var banks = [Bank]()
    var branchs = [BankBranch]()
    var options = [String:[String]]()
    var data = [String: Any]()
    
    var isRegisterPage = false
    
    var loadingView = UIView()
    
    var refreshControl = UIRefreshControl()
    
    var errors = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if !isRegisterPage {
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            tableView.addSubview(refreshControl)
        }
        
        presenter = ProfilePresenter(delegate: self)
        refresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(isRegisterPage(notification:)), name: Notification.Name("RegisterPage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(save(notification:)), name: Notification.Name("RegisterNext"), object: nil)
        
        // Clear form data if exit
        NotificationCenter.default.addObserver(self, selector: #selector(clearForm), name: Notification.Name("RegisterExit"), object: nil)
    }
    
    func showConnectionAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("back"), style: .default, handler: { action in
            NotificationCenter.default.post(name: Notification.Name("RegisterBack"), object: nil, userInfo: ["step": 1])
        }))
        alert.addAction(UIAlertAction(title: localize("try_again"), style: .default, handler: { action in
            self.refresh()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showValidationAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadForm() {
        form.removeAll()
        
        form
        +++ Section(localize("personal_information"))
        <<< TextRow() {
            $0.title = localize("fullname")
            $0.tag = "name"
            //$0.placeholder = "Nama Lengkap"
            $0.add(rule: RuleRequired())
            $0.value = !isDataEmpty("name") ? data["name"]! as! String : nil
        }.cellUpdate { cell, row in
            cell.titleLabel?.attributedText = self.requiredField(localize("fullname"))
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< EmailRow() {
            $0.title = localize("email")
            $0.tag = "email"
            $0.add(rule: RuleRequired())
            $0.add(rule: RuleEmail())
            $0.value = !isDataEmpty("email") ? data["email"]! as! String : nil
        }.cellUpdate { cell, row in
            cell.titleLabel?.attributedText = self.requiredField(localize("email"))
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< PhoneRow() {
            $0.title = localize("phone_number")
            $0.tag = "phone"
            $0.add(rule: RuleRequired())
            $0.value = !isDataEmpty("phone") ? data["phone"]! as! String : nil
        }.cellUpdate { cell, row in
            cell.titleLabel?.attributedText = self.requiredField(localize("phone_number"))
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< TextRow() {
            $0.title = localize("alternative_pic")
            $0.tag = "pic_alternative"
            $0.add(rule: RuleRequired())
            $0.value = !isDataEmpty("pic_alternative") ? data["pic_alternative"]! as! String : nil
        }.cellUpdate { cell, row in
            cell.titleLabel?.attributedText = self.requiredField(localize("alternative_pic"))
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< PhoneRow() {
            $0.title = localize("alternative_phone")
            $0.tag = "phone_alternative"
            $0.add(rule: RuleRequired())
            $0.value = !isDataEmpty("phone_alternative") ? data["phone_alternative"]! as! String : nil
        }.cellUpdate { cell, row in
            cell.titleLabel?.attributedText = self.requiredField(localize("alternative_phone"))
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        +++ Section(localize("bank_information"))
        <<< SearchablePushRow<Bank>("bank") {
            $0.title = localize("bank")
            $0.tag = "bank"
            $0.options = banks
            $0.selectorTitle = localize("choose_bank")
            $0.value = !isDataEmpty("bank") ? data["bank"]! as! Bank : nil
            $0.displayValueFor = { value in
                return value?.name
            }
            $0.disabled = isRegisterPage == true ? false : true
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            if !self.isRegisterPage {
                cell.textLabel?.textColor = .black
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                cell.detailTextLabel?.textColor = .black
                cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                cell.accessoryType = .none
            } else {
                cell.textLabel?.attributedText = self.requiredField(localize("bank"))
            }
        }.onChange { row in
            // Get bank branchs after bank choosed
            self.form.rowBy(tag: "bank_branch")?.baseValue = nil
            if row.value != nil {
                self.presenter.getParentBankBranch((row.value?.id)!)
            }
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< TextRow() {
            $0.title = localize("new_bank_name")
            $0.tag = "bank_name"
            $0.hidden = .function(["bank"], { form -> Bool in
                if form.rowBy(tag: "bank")?.baseValue != nil {
                    let bank = form.rowBy(tag: "bank")?.baseValue as! Bank
                    if bank.id != "0" {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return true
                }
            })
        }
        <<< SearchablePushRow<BankBranch>("bank_branch") {
            $0.title = localize("bank_branch")
            $0.tag = "bank_branch"
            $0.selectorTitle = localize("choose_bank_branch")
            $0.value = !isDataEmpty("bank_branch") ? data["bank_branch"]! as! BankBranch : nil
            $0.displayValueFor = { value in
                return value?.name
            }
            $0.disabled = .function(["bank"], { form -> Bool in
                if form.rowBy(tag: "bank")?.baseValue != nil {
                    if self.isRegisterPage == true {
                        return false
                    } else {
                        return true
                    }
                } else {
                    return true
                }
            })
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            if !self.isRegisterPage {
                cell.textLabel?.textColor = .black
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                cell.detailTextLabel?.textColor = .black
                cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                cell.accessoryType = .none
            } else {
                cell.textLabel?.attributedText = self.requiredField(localize("bank_branch"))
            }
        }.onCellSelection { cell, row in
            row.options = self.branchs
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< TextRow() {
            $0.title = localize("new_bank_branch_name")
            $0.tag = "bank_branch_name"
            $0.hidden = .function(["bank_branch"], { form -> Bool in
                if form.rowBy(tag: "bank_branch")?.baseValue != nil {
                    let branch = form.rowBy(tag: "bank_branch")?.baseValue as! BankBranch
                    if branch.id != "1" {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return true
                }
            })
        }
        <<< TextRow() {
            $0.title = localize("bank_branch_address")
            $0.tag = "bank_branch_address"
            $0.add(rule: RuleRequired())
            $0.value = !isDataEmpty("address") ? data["address"]! as! String : nil
        }.cellUpdate { cell, row in
            cell.titleLabel?.attributedText = self.requiredField(localize("bank_branch_address"))
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< AlertRow<String>() { row in
            row.title = localize("bank_type")
            row.tag = "bank_type"
            row.options = self.options["bank_type"]
            row.add(rule: RuleRequired())
            row.value = !isDataEmpty("bank_type") ? data["bank_type"]! as! String : self.options["bank_type"]?.first
        }.cellUpdate { cell, row in
            cell.textLabel!.attributedText = self.requiredField(localize("bank_type"))
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< AlertRow<String>() { row in
            row.title = localize("foreign_exchange")
            row.tag = "foreign_exchange"
            row.options = self.options["foreign_exchange"]
            row.add(rule: RuleRequired())
            row.value = !isDataEmpty("foreign_exchange") ? data["foreign_exchange"]! as! String : self.options["foreign_exchange"]?.first
        }.cellUpdate { cell, row in
            cell.textLabel!.attributedText = self.requiredField(localize("foreign_exchange"))
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< AlertRow<String>() { row in
            row.title = localize("book")
            row.tag = "book"
            row.options = self.options["book"]
            row.add(rule: RuleRequired())
            row.value = !isDataEmpty("book") ? data["book"]! as! String : self.options["book"]?.first
        }.cellUpdate { cell, row in
            cell.textLabel!.attributedText = self.requiredField(localize("book"))
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< AlertRow<String>() { row in
            row.title = localize("sharia")
            row.tag = "sharia"
            row.options = self.options["sharia"]
            row.add(rule: RuleRequired())
            row.value = !isDataEmpty("sharia") ? data["sharia"]! as! String : self.options["sharia"]?.first
        }.cellUpdate { cell, row in
            cell.textLabel!.attributedText = self.requiredField(localize("sharia"))
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< AlertRow<String>() { row in
            row.title = localize("interest_day_count_convertion")
            row.tag = "interest_day_count_convertion"
            row.options = self.options["interest_day_count_convertion"]
            row.add(rule: RuleRequired())
            row.value = !isDataEmpty("interest_day_count_convertion") ? data["interest_day_count_convertion"]! as! String : self.options["interest_day_count_convertion"]?.first
        }.cellUpdate { cell, row in
            cell.textLabel!.attributedText = self.requiredField(localize("interest_day_count_convertion"))
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< AlertRow<String>() { row in
            row.title = localize("end_date")
            row.tag = "end_date"
            row.options = self.options["end_date"]
            row.add(rule: RuleRequired())
            row.value = !isDataEmpty("end_date") ? data["end_date"]! as! String : self.options["end_date"]?.first
        }.cellUpdate { cell, row in
            cell.textLabel!.attributedText = self.requiredField(localize("end_date"))
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< AlertRow<String>() { row in
            row.title = localize("return_to_start_date")
            row.tag = "return_to_start_date"
            row.options = self.options["return_to_start_date"]
            row.add(rule: RuleRequired())
            row.value = !isDataEmpty("return_to_start_date") ? data["return_to_start_date"]! as! String : self.options["return_to_start_date"]?.first
        }.cellUpdate { cell, row in
            cell.textLabel!.attributedText = self.requiredField(localize("return_to_start_date"))
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< AlertRow<String>() { row in
            row.title = localize("holiday_interest")
            row.tag = "holiday_interest"
            row.options = self.options["holiday_interest"]
            row.add(rule: RuleRequired())
            row.value = !isDataEmpty("holiday_interest") ? data["holiday_interest"]! as! String : self.options["holiday_interest"]?.first
        }.cellUpdate { cell, row in
            cell.textLabel!.attributedText = self.requiredField(localize("holiday_interest"))
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        +++ Section(localize("password").uppercased())
        <<< PasswordRow("password") {
            $0.title = localize("password")
            $0.tag = "password"
            $0.add(rule: RuleRequired())
            $0.add(rule: RuleMinLength(minLength: 6))
        }.cellUpdate { cell, row in
            if self.isRegisterPage {
                cell.textLabel!.attributedText = self.requiredField(localize("password"))
            }
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< PasswordRow() {
            $0.title = localize("password_confirmation")
            $0.tag = "password_confirmation"
            $0.placeholder = ""
            $0.add(rule: RuleRequired())
            //$0.add(rule: RuleMinLength(minLength: 6))
            $0.add(rule: RuleEqualsToRow(form: form, tag: "password"))
        }.cellUpdate { cell, row in
            if self.isRegisterPage {
                cell.textLabel!.attributedText = self.requiredField(localize("password_confirmation"))
            }
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        +++ Section("")
        <<< ButtonRow() {
            $0.title = localize("update_profile").uppercased()
            $0.hidden = isRegisterPage == true ? true : false
        }.onCellSelection() { cell, row in
            self.edit()
        }.cellUpdate() { cell, row in
            cell.backgroundColor = primaryColor
            cell.textLabel?.textColor = .white
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showLoading(_ show: Bool) {
        if show {
            loadingView.isHidden = false
        } else {
            loadingView.isHidden = true
        }
    }
    
    func requiredField(_ str: String) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString()
        
        let redColor = [NSAttributedString.Key.foregroundColor: UIColor.red]
        let blackColor = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let requiredAsterisk = NSAttributedString(string: " *", attributes: redColor)
        let title = NSAttributedString(string: str, attributes: blackColor)
        mutableAttributedString.append(title)
        mutableAttributedString.append(requiredAsterisk)
        
        return mutableAttributedString
    }
    
    @objc func isRegisterPage(notification:Notification) {
        isRegisterPage = true
    }
    
    @objc func refresh() {
        showLoading(true)
        presenter.getParentBank()
    }
    
    func isBankEmpty() -> Bool {
        if form.rowBy(tag: "bank")?.baseValue == nil {
            return true
        } else {
            return false
        }
    }
    
    func getFormValues() -> [String: String]? {
        form.cleanValidationErrors()
        errors = [String]()
        let formData = form.values()
        
        form.validate()
        
        // Manual Validation
        // Phone - Number only
        if formData["phone"]! != nil {
            if Int(formData["phone"] as! String) == nil {
                errors.append(String.localizedStringWithFormat(localize("input_must_be_number"), localize("phone_number")))
            }
        }
        
        if formData["phone_alternative"]! != nil {
            if Int(formData["phone_alternative"] as! String) == nil {
                errors.append(String.localizedStringWithFormat(localize("input_must_be_number"), localize("alternative_phone")))
            }
        }
        
        var bankVal = String()
        if formData["bank"]! != nil {
            let bank = formData["bank"] as! Bank
            bankVal = "\(bank.id)"
        }
        
        var bankBranchVal = String()
        if formData["bank_branch"]! != nil {
            let bankBranch = formData["bank_branch"] as! BankBranch
            bankBranchVal = "\(bankBranch.id)"
        }
        
        var data: [String: String]?
        
        if errors.count == 0 {
            data = [
                "name": formData["name"]! != nil ? formData["name"] as! String : "",
                "email": formData["email"]! != nil ? formData["email"] as! String : "",
                "phone": formData["phone"]! != nil ? formData["phone"] as! String : "",
                "pic_alternative": formData["pic_alternative"]! != nil ? formData["pic_alternative"] as! String : "",
                "phone_alternative": formData["phone_alternative"]! != nil ? formData["phone_alternative"] as! String : "",
                "bank": bankVal,
                "bank_name": bankVal == "1" ? (formData["bank_name"]! != nil ? formData["bank_name"] as! String : "") : "",
                "bank_branch": bankBranchVal,
                "bank_branch_name": bankBranchVal == "1" ? (formData["bank_branch_name"]! != nil ? formData["bank_branch_name"] as! String : "") : "",
                "bank_branch_address": formData["bank_branch_address"]! != nil ? formData["bank_branch_address"] as! String : "",
                "bank_type": formData["bank_type"]! != nil ? formData["bank_type"] as! String : "",
                "foreign_exchange": formData["foreign_exchange"]! != nil ? formData["foreign_exchange"] as! String : "",
                "book": formData["book"]! != nil ? formData["book"] as! String : "",
                "sharia": formData["sharia"]! != nil ? formData["sharia"] as! String : "",
                "interest_day_count_convertion": formData["interest_day_count_convertion"]! != nil ? formData["interest_day_count_convertion"] as! String : "",
                "end_date": formData["end_date"]! != nil ? formData["end_date"] as! String : "",
                "return_to_start_date": formData["return_to_start_date"]! != nil ? formData["return_to_start_date"] as! String : "",
                "holiday_interest": formData["holiday_interest"]! != nil ? formData["holiday_interest"] as! String : "",
                "password": formData["password"]! != nil ? formData["password"] as! String : "",
                "password_confirmation": formData["password_confirmation"]! != nil ? formData["password_confirmation"] as! String : "",
            ]
        } else {
            var msg = ""
            for error in errors {
                //print(error)
                //msg += "\(error)\n"
                if error.contains("Field required!") && !msg.contains(localize("fill_required_field")) {
                    let newline = msg != "" ? "\n" : ""
                    msg += "\(newline)\(localize("fill_required_field"))"
                }
                if error == String.localizedStringWithFormat(localize("input_must_be_number"), localize("phone_number")) || error == String.localizedStringWithFormat(localize("input_must_be_number"), localize("alternative_phone")) {
                    let newline = msg != "" ? "\n" : ""
                    msg += "\(newline)\(error)"
                }
                if error == "\(localize("email")) Field value should be a valid email!" {
                    let newline = msg != "" ? "\n" : ""
                    msg += "\(newline)\(localize("email_not_valid"))"
                }
                if error == "\(localize("password")) Field value must have at least 6 characters" {
                    let newline = msg != "" ? "\n" : ""
                    msg += "\(newline)\(localize("password_character_not_enough"))"
                }
                if error == "\(localize("password_confirmation")) Fields don't match!" {
                    let newline = msg != "" ? "\n" : ""
                    msg += "\(newline)\(localize("password_not_match"))"
                }
            }
            
            showValidationAlert(title: localize("information"), message: msg)
        }
        
        return data
    }
    
    @objc func save(notification:Notification) {
        if let data = notification.userInfo as? [String: Int] {
            let idx = data["idx"]!
            if idx == 0 {
                let data = getFormValues()
                if data != nil {
                    setLocalData(data!)
                    NotificationCenter.default.post(name: Notification.Name("RegisterNextValidation"), object: nil, userInfo: ["idx": 1])
                }
                //NotificationCenter.default.post(name: Notification.Name("RegisterNextValidation"), object: nil, userInfo: ["idx": 1])
            }
        }
    }
    
    func edit() {
        let data = getFormValues()
        if data != nil {
            presenter.updateProfile(data!)
        }
    }
    
    func isDataEmpty(_ key: String) -> Bool {
        if data[key] != nil {
            if case Optional<Any>.none = data[key]! {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    @objc func clearForm() {
        form.setValues([
            "name": nil,
            "email": nil,
            "phone": nil,
            "pic_alternative": nil,
            "phone_alternative": nil,
            "bank": nil,
            "bank_name": nil,
            "bank_branch": nil,
            "bank_branch_name": nil,
            "bank_branch_address": nil,
            "bank_type": nil,
            "foreign_exchange": nil,
            "book": nil,
            "sharia": nil,
            "interest_day_count_convertion": nil,
            "end_date": nil,
            "return_to_start_date": nil,
            "holiday_interest": nil,
            "password": nil,
            "password_confirmation": nil,
        ])
    }
}

extension ProfileViewController: ProfileDelegate {
    func setParentBanks(_ data: [Bank]) {
        self.banks = data
        presenter.getOptions()
    }
    
    func setParentBankBranchs(_ data: [BankBranch]) {
        self.branchs = data
    }
    
    func setOptions(_ data: [String : [String]]) {
        self.options = data
        if isRegisterPage {
            refreshControl.endRefreshing()
            showLoading(false)
            loadForm()
        } else {
            presenter.getProfile()
        }
    }
    
    func getDataFail() {
        showConnectionAlert(title: localize("information"), message: localize("fail_to_process_data_from_server"))
    }
    
    func setProfile(_ data: [String : Any]) {
        self.data = data
        refreshControl.endRefreshing()
        showLoading(false)
        loadForm()
        if let bankRow = form.rowBy(tag: "bank") as? SearchablePushRow<Bank> {
            if let bank = bankRow.value {
                presenter.getBankBranch(bank.id)
            }
        }
    }
    
    func isUpdateSuccess(_ isSuccess: Bool, _ message: String) {
        showValidationAlert(title: localize("information"), message: message)
    }
}
