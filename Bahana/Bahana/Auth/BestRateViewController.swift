//
//  BestRateViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/31.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit
import Eureka

class BestRateViewController: FormViewController {

    var presenter: BestRatePresenter!
    var options = [String:[String]]()
    var data = [String:Any]()
    
    var isRegisterPage = false
    
    var loadingView = UIView()
    
    var refreshControl = UIRefreshControl()
    
    var errors = [String]()
    
    var isIdrRequired = false
    var isUsdRequired = false
    var isShariaRequired = false
    var isIdrHidden = false
    var isUsdHidden = false
    var isShariaHidden = false
    var isIdrOptional = false
    var isUsdOptional = false
    var isShariaOptional = false
    
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
        
        presenter = BestRatePresenter(delegate: self)
        //presenter.getOptions()
        
        NotificationCenter.default.addObserver(self, selector: #selector(isRegisterPage(notification:)), name: Notification.Name("RegisterPage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(save(notification:)), name: Notification.Name("RegisterNext"), object: nil)
        
        // Clear form data if exit
        NotificationCenter.default.addObserver(self, selector: #selector(clearForm), name: Notification.Name("RegisterExit"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    func showConnectionAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("back"), style: .default, handler: { action in
            NotificationCenter.default.post(name: Notification.Name("RegisterBack"), object: nil, userInfo: ["step": 2])
        }))
        alert.addAction(UIAlertAction(title: localize("try_again"), style: .default, handler: { action in
            self.presenter.getOptions()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadForm() {
        var idrRules = RuleSet<String>()
        if isIdrRequired {
            idrRules.add(rule: RuleRequired())
        }
        
        var usdRules = RuleSet<String>()
        if isUsdRequired {
            usdRules.add(rule: RuleRequired())
        }
        
        var shariaRules = RuleSet<String>()
        if isShariaRequired {
            shariaRules.add(rule: RuleRequired())
        }
        
        form.removeAll()
        
        form
        +++ Section(!isIdrHidden ? "- \(String.localizedStringWithFormat(localize("placement"), "IDR"))" : "")
        <<< AlertRow<String>() { row in
            row.title = localize("breakable_policy")
            row.tag = "idr_breakable_policy"
            row.options = self.options["breakable_policy"]
            row.value = !isDataEmpty("breakable_policy") ? data["breakable_policy"]! as! String : self.options["breakable_policy"]?.first
            row.add(ruleSet: idrRules)
            row.hidden = isIdrHidden == true ? true : false
        }.cellUpdate { cell, row in
            if self.isIdrRequired {
                cell.textLabel?.attributedText = self.requiredField(localize("breakable_policy"))
            }
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg) IDR")
                }
            }
        }.onChange() { row in
            self.form.sectionBy(tag: String.localizedStringWithFormat(localize("placement"), "IDR"))?.hidden = self.isIdrHidden == true ? true : false
            
            self.form.sectionBy(tag: String.localizedStringWithFormat(localize("placement"), localize("sharia")))?.hidden = self.isShariaHidden == true ? true : false
        }
        <<< TextAreaRow() {
            $0.title = localize("breakable_policy_notes")
            $0.tag = "idr_breakable_policy_notes"
            $0.value = !isDataEmpty("breakable_policy_notes") ? data["breakable_policy_notes"]! as! String : nil
            $0.placeholder = localize("breakable_policy_notes")
            $0.hidden = isIdrHidden == true ? true : false
        }
        <<< TextRow() {
            $0.title = localize("account_number")
            $0.tag = "idr_account_number"
            $0.value = !isDataEmpty("account_number") ? data["account_number"]! as! String : nil
            //$0.placeholder = "Nomor Rekening"
            $0.add(ruleSet: idrRules)
            $0.hidden = isIdrHidden == true ? true : false
        }.cellUpdate { cell, row in
            if self.isIdrRequired {
                cell.titleLabel?.attributedText = self.requiredField(localize("account_number"))
            }
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg) IDR")
                }
            }
        }
        <<< TextRow() {
            $0.title = localize("account_name")
            $0.tag = "idr_account_name"
            //$0.placeholder = "A/n Rekening"
            $0.value = !isDataEmpty("account_name") ? data["account_name"]! as! String : nil
            $0.add(ruleSet: idrRules)
            $0.hidden = isIdrHidden == true ? true : false
        }.cellUpdate { cell, row in
            if self.isIdrRequired {
                cell.titleLabel?.attributedText = self.requiredField(localize("account_name"))
            }
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg) IDR")
                }
            }
        }
        <<< DecimalRow() {
            $0.title = localize("month_rate_1")
            $0.tag = "idr_month_rate_1"
            //$0.placeholder = "Best Rate 1 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
            $0.value = !isDataEmpty("month_rate_1") ? data["month_rate_1"]! as! Double : nil
            $0.hidden = isIdrHidden == true ? true : false
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = localize("month_rate_3")
            $0.tag = "idr_month_rate_3"
            //$0.placeholder = "Best Rate 3 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
            $0.value = !isDataEmpty("month_rate_3") ? data["month_rate_3"]! as! Double : nil
            $0.hidden = isIdrHidden == true ? true : false
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = localize("month_rate_6")
            $0.tag = "idr_month_rate_6"
            //$0.placeholder = "Best Rate 6 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
            $0.value = !isDataEmpty("month_rate_6") ? data["month_rate_6"]! as! Double : nil
            $0.hidden = isIdrHidden == true ? true : false
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        +++ Section(!isUsdHidden ? "- \(String.localizedStringWithFormat(localize("placement"), "USD"))" : "")
        <<< AlertRow<String>() { row in
            row.title = localize("breakable_policy")
            row.tag = "usd_breakable_policy"
            row.options = self.options["breakable_policy"]
            row.value = !isDataEmpty("usd_breakable_policy") ? data["usd_breakable_policy"]! as! String : self.options["breakable_policy"]?.first
            row.add(ruleSet: usdRules)
            row.hidden = isUsdHidden == true ? true : false
        }.cellUpdate { cell, row in
            if self.isUsdRequired {
                cell.textLabel?.attributedText = self.requiredField(localize("breakable_policy"))
            }
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg) USD")
                }
            }
        }
        <<< TextAreaRow() {
            $0.title = localize("breakable_policy_notes")
            $0.tag = "usd_breakable_policy_notes"
            $0.value = !isDataEmpty("usd_breakable_policy_notes") ? data["usd_breakable_policy_notes"]! as! String : nil
            $0.placeholder = localize("breakable_policy_notes")
            $0.hidden = isUsdHidden == true ? true : false
        }
        <<< TextRow() {
            $0.title = localize("account_number")
            $0.tag = "usd_account_number"
            //$0.placeholder = "Nomor Rekening"
            $0.value = !isDataEmpty("usd_account_number") ? data["usd_account_number"]! as! String : nil
            $0.add(ruleSet: usdRules)
            $0.hidden = isUsdHidden == true ? true : false
        }.cellUpdate { cell, row in
            if self.isUsdRequired {
                cell.titleLabel?.attributedText = self.requiredField(localize("account_number"))
            }
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg) USD")
                }
            }
        }
        <<< TextRow() {
            $0.title = localize("account_name")
            $0.tag = "usd_account_name"
            //$0.placeholder = "A/n Rekening"
            $0.value = !isDataEmpty("usd_account_name") ? data["usd_account_name"]! as! String : nil
            $0.add(ruleSet: usdRules)
            $0.hidden = isUsdHidden == true ? true : false
        }.cellUpdate { cell, row in
            if self.isUsdRequired {
                cell.titleLabel?.attributedText = self.requiredField(localize("account_name"))
            }
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg) USD")
                }
            }
        }
        <<< DecimalRow() {
            $0.title = localize("month_rate_1")
            $0.tag = "usd_month_rate_1"
            //$0.placeholder = "Best Rate 1 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
            $0.value = !isDataEmpty("usd_month_rate_1") ? data["usd_month_rate_1"]! as! Double : nil
            $0.hidden = isUsdHidden == true ? true : false
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = localize("month_rate_3")
            $0.tag = "usd_month_rate_3"
            //$0.placeholder = "Best Rate 3 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
            $0.value = !isDataEmpty("usd_month_rate_3") ? data["usd_month_rate_3"]! as! Double : nil
            $0.hidden = isUsdHidden == true ? true : false
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = localize("month_rate_6")
            $0.tag = "usd_month_rate_6"
            //$0.placeholder = "Best Rate 6 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
            $0.value = !isDataEmpty("usd_month_rate_6") ? data["usd_month_rate_6"]! as! Double : nil
            $0.hidden = isUsdHidden == true ? true : false
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        +++ Section(!isShariaHidden ? "- \(String.localizedStringWithFormat(localize("placement"), localize("sharia")))" : "")
        <<< AlertRow<String>() { row in
            row.title = localize("breakable_policy")
            row.tag = "sharia_breakable_policy"
            row.options = self.options["breakable_policy"]
            row.value = !isDataEmpty("sharia_breakable_policy") ? data["sharia_breakable_policy"]! as! String : self.options["breakable_policy"]?.first
            row.add(ruleSet: shariaRules)
            row.hidden = isShariaHidden == true ? true : false
        }.cellUpdate { cell, row in
            if self.isShariaRequired {
                cell.textLabel?.attributedText = self.requiredField(localize("breakable_policy"))
            }
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg) \(localize("sharia"))")
                }
            }
        }
        <<< TextAreaRow() {
            $0.title = localize("breakable_policy_notes")
            $0.tag = "sharia_breakable_policy_notes"
            $0.value = !isDataEmpty("sharia_breakable_policy_notes") ? data["sharia_breakable_policy_notes"]! as! String : nil
            $0.placeholder = localize("breakable_policy_notes")
            $0.hidden = isShariaHidden == true ? true : false
        }
        <<< TextRow() {
            $0.title = localize("account_number")
            $0.tag = "sharia_account_number"
            //$0.placeholder = "Nomor Rekening"
            $0.value = !isDataEmpty("sharia_account_number") ? data["sharia_account_number"]! as! String : nil
            $0.add(ruleSet: shariaRules)
            $0.hidden = isShariaHidden == true ? true : false
        }.cellUpdate { cell, row in
            if self.isShariaRequired {
                cell.titleLabel?.attributedText = self.requiredField(localize("account_number"))
            }
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg) \(localize("sharia"))")
                }
            }
        }
        <<< TextRow() {
            $0.title = localize("account_name")
            $0.tag = "sharia_account_name"
            //$0.placeholder = "A/n Rekening"
            $0.value = !isDataEmpty("sharia_account_name") ? data["sharia_account_name"]! as! String : nil
            $0.add(ruleSet: shariaRules)
            $0.hidden = isShariaHidden == true ? true : false
        }.cellUpdate { cell, row in
            if self.isShariaRequired {
                cell.titleLabel?.attributedText = self.requiredField(localize("account_name"))
            }
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg) \(localize("sharia"))")
                }
            }
        }
        <<< DecimalRow() {
            $0.title = localize("month_rate_1")
            $0.tag = "sharia_month_rate_1"
            //$0.placeholder = "Best Rate 1 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
            $0.value = !isDataEmpty("sharia_month_rate_1") ? data["sharia_month_rate_1"]! as! Double : nil
            $0.hidden = isShariaHidden == true ? true : false
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = localize("month_rate_3")
            $0.tag = "sharia_month_rate_3"
            //$0.placeholder = "Best Rate 3 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
            $0.value = !isDataEmpty("sharia_month_rate_3") ? data["sharia_month_rate_3"]! as! Double : nil
            $0.hidden = isShariaHidden == true ? true : false
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = localize("month_rate_6")
            $0.tag = "sharia_month_rate_6"
            //$0.placeholder = "Best Rate 6 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
            $0.value = !isDataEmpty("sharia_month_rate_6") ? data["sharia_month_rate_6"]! as! Double : nil
            $0.hidden = isShariaHidden == true ? true : false
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        +++ Section("")
        <<< ButtonRow() {
            $0.title = localize("update_best_rate").uppercased()
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
        let requiredAsterisk = NSAttributedString(string: "*", attributes: redColor)
        let title = NSAttributedString(string: str, attributes: blackColor)
        mutableAttributedString.append(title)
        mutableAttributedString.append(requiredAsterisk)
        
        return mutableAttributedString
    }
    
    func showValidationAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func refresh() {
        showLoading(true)
        presenter.getOptions()
    }
    
    @objc func isRegisterPage(notification:Notification) {
        isRegisterPage = true
    }
    
    func setFormValues() {
        form.setValues([
            "idr_breakable_policy": getLocalData(key: "idr_breakable_policy"),
            "idr_breakable_policy_notes": getLocalData(key: "idr_breakable_policy_notes"),
            "idr_account_number": getLocalData(key: "idr_account_number"),
            "idr_account_name": getLocalData(key: "idr_account_name"),
            "idr_month_rate_1": getLocalData(key: "idr_month_rate_1"),
            "idr_month_rate_3": getLocalData(key: "idr_month_rate_3"),
            "idr_month_rate_6": getLocalData(key: "idr_month_rate_6"),
            "usd_breakable_policy": getLocalData(key: "usd_breakable_policy"),
            "usd_breakable_policy_notes": getLocalData(key: "usd_breakable_policy_notes"),
            "usd_account_number": getLocalData(key: "usd_account_number"),
            "usd_account_name": getLocalData(key: "usd_account_name"),
            "usd_month_rate_1": getLocalData(key: "usd_month_rate_1"),
            "usd_month_rate_3": getLocalData(key: "usd_month_rate_3"),
            "usd_month_rate_6": getLocalData(key: "usd_month_rate_6"),
            "sharia_breakable_policy": getLocalData(key: "sharia_breakable_policy"),
            "sharia_breakable_policy_notes": getLocalData(key: "sharia_breakable_policy_notes"),
            "sharia_account_number": getLocalData(key: "sharia_account_number"),
            "sharia_account_name": getLocalData(key: "sharia_account_name"),
            "sharia_month_rate_1": getLocalData(key: "sharia_month_rate_1"),
            "sharia_month_rate_3": getLocalData(key: "sharia_month_rate_3"),
            "sharia_month_rate_6": getLocalData(key: "sharia_month_rate_6")
        ])
        tableView.reloadData()
    }
    
    func getFormValues() -> [String: String]? {
        form.cleanValidationErrors()
        errors = [String]()
        let formData = form.values()
        
        form.validate()
        
        // Manual Validation
        // Rate - Less equal than 100
        if formData["idr_month_rate_1"] != nil && formData["idr_month_rate_1"]! != nil {
            if formData["idr_month_rate_1"] as! Double > 100 {
                errors.append(String.localizedStringWithFormat(localize("rate_out_of_range"), "1", "IDR"))
            }
            
        }
        
        if formData["idr_month_rate_3"] != nil && formData["idr_month_rate_3"]! != nil {
            if formData["idr_month_rate_3"] as! Double > 100 {
                errors.append(String.localizedStringWithFormat(localize("rate_out_of_range"), "3", "IDR"))
            }
        }
        
        if formData["idr_month_rate_6"] != nil && formData["idr_month_rate_6"]! != nil {
            if formData["idr_month_rate_6"] as! Double > 100 {
                errors.append(String.localizedStringWithFormat(localize("rate_out_of_range"), "6", "IDR"))
            }
        }
        
        if formData["usd_month_rate_1"] != nil && formData["usd_month_rate_1"]! != nil {
            if formData["usd_month_rate_1"] as! Double > 100 {
                errors.append(String.localizedStringWithFormat(localize("rate_out_of_range"), "1", "USD"))
            }
        }
        
        if formData["usd_month_rate_3"] != nil && formData["usd_month_rate_3"]! != nil {
            if formData["usd_month_rate_3"] as! Double > 100 {
                errors.append(String.localizedStringWithFormat(localize("rate_out_of_range"), "3", "USD"))
            }
        }
        
        if formData["usd_month_rate_6"] != nil && formData["usd_month_rate_6"]! != nil {
            if formData["usd_month_rate_6"] as! Double > 100 {
                errors.append(String.localizedStringWithFormat(localize("rate_out_of_range"), "6", "USD"))
            }
        }
        
        if formData["sharia_month_rate_1"] != nil && formData["sharia_month_rate_1"]! != nil {
            if formData["sharia_month_rate_1"] as! Double > 100 {
                errors.append(String.localizedStringWithFormat(localize("rate_out_of_range"), "1", localize("sharia")))
            }
        }
        
        if formData["sharia_month_rate_3"] != nil && formData["sharia_month_rate_3"]! != nil {
            if formData["sharia_month_rate_3"] as! Double > 100 {
                errors.append(String.localizedStringWithFormat(localize("rate_out_of_range"), "3", localize("sharia")))
            }
        }
        
        if formData["sharia_month_rate_6"] != nil && formData["sharia_month_rate_6"]! != nil {
            if formData["sharia_month_rate_6"] as! Double > 100 {
                errors.append(String.localizedStringWithFormat(localize("rate_out_of_range"), "6", localize("sharia")))
            }
        }
        
        // Cek kalau ada idr, usd, atau sharia yang terisi walaupun tidak required, maka akan jadi required
        if !isUsdRequired && isUsdOptional {
            let breakablePolicy = formData["usd_breakable_policy"] != nil && formData["usd_breakable_policy"]! != nil && formData["usd_breakable_policy"]! as! String != ""
            let breakablePolicyNotes = formData["usd_breakable_policy_notes"] != nil && formData["usd_breakable_policy_notes"]! != nil && formData["usd_breakable_policy_notes"]! as! String != ""
            let accountNumber = formData["usd_account_number"] != nil && formData["usd_account_number"]! != nil && formData["usd_account_number"]! as! String != ""
            let accountName = formData["usd_account_name"] != nil && formData["usd_account_name"]! != nil && formData["usd_account_name"]! as! String != ""
            let monthRate1 = formData["usd_month_rate_1"] != nil && formData["usd_month_rate_1"]! != nil
            let monthRate3 = formData["usd_month_rate_3"] != nil && formData["usd_month_rate_3"]! != nil
            let monthRate6 = formData["usd_month_rate_6"] != nil && formData["usd_month_rate_6"]! != nil
            
            if (breakablePolicy || breakablePolicyNotes || accountNumber || accountName || monthRate1 || monthRate3 || monthRate6) && !breakablePolicy && !accountNumber && !accountName {
                errors.append("USD Field required!")
            }
        }
        
        if !isShariaRequired && isShariaOptional {
            let breakablePolicy = formData["sharia_breakable_policy"] != nil && formData["sharia_breakable_policy"]! != nil && formData["sharia_breakable_policy"]! as! String != ""
            let breakablePolicyNotes = formData["sharia_breakable_policy_notes"] != nil && formData["sharia_breakable_policy_notes"]! != nil && formData["sharia_breakable_policy_notes"]! as! String != ""
            let accountNumber = formData["sharia_account_number"] != nil && formData["sharia_account_number"]! != nil && formData["sharia_account_number"]! as! String != ""
            let accountName = formData["sharia_account_name"] != nil && formData["sharia_account_name"]! != nil && formData["sharia_account_name"]! as! String != ""
            let monthRate1 = formData["sharia_month_rate_1"] != nil && formData["sharia_month_rate_1"]! != nil
            let monthRate3 = formData["sharia_month_rate_3"] != nil && formData["sharia_month_rate_3"]! != nil
            let monthRate6 = formData["sharia_month_rate_6"] != nil && formData["sharia_month_rate_6"]! != nil
            
            if (breakablePolicy || breakablePolicyNotes || accountNumber || accountName || monthRate1 || monthRate3 || monthRate6) && !breakablePolicy && !accountNumber && !accountName {
                errors.append("\(localize("sharia")) Field required!")
            }
        }
        
        var data: [String: String]?
        
        if errors.count == 0 {
            data = [
                "idr_breakable_policy": !isDataEmpty2("idr_breakable_policy", "string") ? formData["idr_breakable_policy"]! as! String : "",
                "idr_breakable_policy_notes": !isDataEmpty2("idr_breakable_policy_notes", "string") ? formData["idr_breakable_policy_notes"]! as! String : "",
                "idr_account_number": !isDataEmpty2("idr_account_number", "string") ? formData["idr_account_number"]! as! String : "",
                "idr_account_name": !isDataEmpty2("idr_account_name", "string") ? formData["idr_account_name"]! as! String : "",
                "idr_month_rate_1": !isDataEmpty2("idr_month_rate_1", "double") ? String(formData["idr_month_rate_1"]! as! Double) : "",
                "idr_month_rate_3": !isDataEmpty2("idr_month_rate_3", "double") ? String(formData["idr_month_rate_3"]! as! Double) : "",
                "idr_month_rate_6": !isDataEmpty2("idr_month_rate_6", "double") ? String(formData["idr_month_rate_6"]! as! Double) : "",
                "usd_breakable_policy": !isDataEmpty2("usd_breakable_policy", "string") ? formData["usd_breakable_policy"]! as! String : "",
                "usd_breakable_policy_notes": !isDataEmpty2("usd_breakable_policy_notes", "string") ? formData["usd_breakable_policy_notes"]! as! String : "",
                "usd_account_number": !isDataEmpty2("usd_account_number", "string") ? formData["usd_account_number"]! as! String : "",
                "usd_account_name": !isDataEmpty2("usd_account_name", "string") ? formData["usd_account_name"]! as! String : "",
                "usd_month_rate_1": !isDataEmpty2("usd_month_rate_1", "double") ? String(formData["usd_month_rate_1"]! as! Double) : "",
                "usd_month_rate_3": !isDataEmpty2("usd_month_rate_3", "double") ? String(formData["usd_month_rate_3"]! as! Double) : "",
                "usd_month_rate_6": !isDataEmpty2("usd_month_rate_6", "double") ? String(formData["usd_month_rate_6"]! as! Double) : "",
                "sharia_breakable_policy": !isDataEmpty2("sharia_breakable_policy", "string") ? formData["sharia_breakable_policy"]! as! String : "",
                "sharia_breakable_policy_notes": !isDataEmpty2("sharia_breakable_policy_notes", "string") ? formData["sharia_breakable_policy_notes"]! as! String : "",
                "sharia_account_number": !isDataEmpty2("sharia_account_number", "string") ? formData["sharia_account_number"]! as! String : "",
                "sharia_account_name": !isDataEmpty2("sharia_account_name", "string") ? formData["sharia_account_name"]! as! String : "",
                "sharia_month_rate_1": !isDataEmpty2("sharia_month_rate_1", "double") ? String(formData["sharia_month_rate_1"]! as! Double) : "",
                "sharia_month_rate_3": !isDataEmpty2("sharia_month_rate_3", "double") ? String(formData["sharia_month_rate_3"]! as! Double) : "",
                "sharia_month_rate_6": !isDataEmpty2("sharia_month_rate_6", "double") ? String(formData["sharia_month_rate_6"]! as! Double) : "",
            ]
        } else {
            var msg = String()
            for error in errors {
                //msg += "\n\(error)"
                if error.contains("Field required!") && error.contains("IDR") && !msg.contains("\(localize("fill_required_field")) (\(String.localizedStringWithFormat(localize("placement"), "IDR")))") {
                    let newline = msg != "" ? "\n" : ""
                    msg += "\(newline)\(localize("fill_required_field")) (\(String.localizedStringWithFormat(localize("placement"), "IDR")))"
                }
                if error.contains("Field required!") && error.contains("USD") && !msg.contains("\(localize("fill_required_field")) (\(String.localizedStringWithFormat(localize("placement"), "USD")))") {
                    let newline = msg != "" ? "\n" : ""
                    msg += "\(newline)\(localize("fill_required_field")) (\(String.localizedStringWithFormat(localize("placement"), "USD")))"
                }
                if error.contains("Field required!") && error.contains(localize("sharia")) && !msg.contains("\(localize("fill_required_field")) (\(String.localizedStringWithFormat(localize("placement"), localize("sharia"))))") {
                    let newline = msg != "" ? "\n" : ""
                    msg += "\(newline)\(localize("fill_required_field")) (\(String.localizedStringWithFormat(localize("placement"), localize("sharia"))))"
                }
                if !error.contains("Field required!") {
                    let newline = msg != "" ? "\n" : ""
                    msg += "\(newline)\(error)"
                }
            }
            
            showValidationAlert(title: localize("information"), message: msg)
        }
        
        return data
    }
    
    @objc func save(notification:Notification) {
        if let data = notification.userInfo as? [String: Int] {
            let idx = data["idx"]!
            if idx == 1 {
                let data = getFormValues()
                if data != nil {
                    setLocalData(data!)
                    NotificationCenter.default.post(name: Notification.Name("RegisterNextValidation"), object: nil, userInfo: ["idx": 2])
                }
                //NotificationCenter.default.post(name: Notification.Name("RegisterNextValidation"), object: nil, userInfo: ["idx": 2])
            }
        }
    }
    
    func edit() {
        let data = getFormValues()
        if data != nil {
            presenter.updateBasePlacement(data!)
        }
    }
    
    func checkSharia() {
        var sharia = String()
        var foreign_exchange = String()
        
        isIdrRequired = false
        isUsdRequired = false
        isShariaRequired = false
        isIdrHidden = false
        isUsdHidden = false
        isShariaHidden = false
        isIdrOptional = false
        isUsdOptional = false
        isShariaOptional = false
        
        if isRegisterPage {
            // Get from user default
            sharia = getLocalData(key: "sharia")
            foreign_exchange = getLocalData(key: "foreign_exchange")
        } else {
            // Get from api
            sharia = data["sharia"]! as! String
            foreign_exchange = data["foreign_exchange"]! as! String
        }
        foreign_exchange = foreign_exchange.lowercased()
        
        if foreign_exchange == "yes" && sharia == "Yes UUS" {
            isIdrRequired = true
            isUsdRequired = true
            isShariaRequired = false
            isShariaOptional = true
        } else if foreign_exchange == "yes" && sharia == "Yes Umum" {
            isIdrRequired = false
            isUsdRequired = true
            isShariaRequired = true
            isIdrHidden = true
        } else if foreign_exchange == "yes" && sharia == "No" {
            isIdrRequired = true
            isUsdRequired = true
            isShariaRequired = false
            isShariaHidden = true
        } else if foreign_exchange == "no" && sharia == "Yes UUS" {
            isIdrRequired = true
            isUsdRequired = false
            isShariaRequired = false
            isUsdOptional = true
            isShariaOptional = true
        } else if foreign_exchange == "no" && sharia == "Yes Umum" {
            isIdrRequired = false
            isUsdRequired = false
            isShariaRequired = true
            isIdrHidden = true
            isUsdOptional = true
        } else if foreign_exchange == "no" && sharia == "No" {
            isIdrRequired = true
            isUsdRequired = false
            isShariaRequired = false
            isShariaHidden = true
            isUsdOptional = true
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
    
    func isDataEmpty2(_ key: String, _ type: String) -> Bool {
        let data = form.values()
        if data[key] != nil {
            if data[key]! != nil {
                if type == "string" {
                    if data[key]! as? String != nil {
                        return false
                    } else {
                        return true
                    }
                } else if type == "double" {
                    if data[key]! as? Double != nil {
                        return false
                    } else {
                        return true
                    }
                } else {
                    return true
                }
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    @objc func clearForm() {
        form.setValues([
            "idr_breakable_policy": nil,
            "idr_breakable_policy_notes": nil,
            "idr_account_number": nil,
            "idr_account_name": nil,
            "idr_month_rate_1": nil,
            "idr_month_rate_3": nil,
            "idr_month_rate_6": nil,
            "usd_breakable_policy": nil,
            "usd_breakable_policy_notes": nil,
            "usd_account_number": nil,
            "usd_account_name": nil,
            "usd_month_rate_1": nil,
            "usd_month_rate_3": nil,
            "usd_month_rate_6": nil,
            "sharia_breakable_policy": nil,
            "sharia_breakable_policy_notes": nil,
            "sharia_account_number": nil,
            "sharia_account_name": nil,
            "sharia_month_rate_1": nil,
            "sharia_month_rate_3": nil,
            "sharia_month_rate_6": nil,
        ])
    }
}

extension BestRateViewController: BestRateDelegate {
    func setOptions(_ data: [String:[String]]) {
        self.options = data
        if isRegisterPage {
            checkSharia()
            refreshControl.endRefreshing()
            showLoading(false)
            loadForm()
            setFormValues()
        } else {
            presenter.getBasePlacement()
        }
    }
    
    func setData(_ data: [String: Any]?) {
        if data != nil {
            self.data = data!
            checkSharia()
        }
        refreshControl.endRefreshing()
        showLoading(false)
        loadForm()
    }
    
    func getDataFail() {
        showConnectionAlert(title: localize("information"), message: localize("fail_to_process_data_from_server"))
    }
    
    func isUpdateSuccess(_ isSuccess: Bool, _ message: String) {
        showValidationAlert(title: localize("information"), message: message)
    }
}
