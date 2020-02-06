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
    
    var spinner = UIActivityIndicatorView()
    
    var errors = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        spinner.color = .black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        showLoading(true)
        
        presenter = BestRatePresenter(delegate: self)
        presenter.getOptions()
        
        NotificationCenter.default.addObserver(self, selector: #selector(save(notification:)), name: Notification.Name("RegisterNext"), object: nil)
    }
    
    func showLoading(_ isShow: Bool) {
        if isShow {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
    }
    
    func showConnectionAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: { action in
            NotificationCenter.default.post(name: Notification.Name("RegisterBack"), object: nil, userInfo: ["step": 2])
        }))
        alert.addAction(UIAlertAction(title: "Coba Lagi", style: .default, handler: { action in
            self.presenter.getOptions()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadForm() {
        form
        +++ Section("PENEMPATAN IDR")
        <<< AlertRow<String>() { row in
            row.title = "Polis Break"
            row.tag = "idr_breakable_policy"
            row.options = self.options["breakable_policy"]
            row.add(rule: RuleRequired())
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< TextAreaRow() {
            $0.title = "Catatan Polis"
            $0.tag = "idr_breakable_policy_notes"
            $0.placeholder = "Catatan Polis"
        }
        <<< TextRow() {
            $0.title = "Nomor Rekening"
            $0.tag = "idr_account_number"
            $0.placeholder = "Nomor Rekening"
            $0.add(rule: RuleRequired())
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< TextRow() {
            $0.title = "A/n Rekening"
            $0.tag = "idr_account_name"
            $0.placeholder = "A/n Rekening"
            $0.add(rule: RuleRequired())
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 1 Bulan (%)"
            $0.tag = "idr_month_rate_1"
            $0.placeholder = "Best Rate 1 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 3 Bulan (%)"
            $0.tag = "idr_month_rate_3"
            $0.placeholder = "Best Rate 3 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 6 Bulan (%)"
            $0.tag = "idr_month_rate_6"
            $0.placeholder = "Best Rate 6 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        +++ Section("PENEMPATAN USD")
        <<< AlertRow<String>() { row in
            row.title = "Polis Break"
            row.tag = "usd_breakable_policy"
            row.options = self.options["breakable_policy"]
        }
        <<< TextAreaRow() {
            $0.title = "Catatan Polis"
            $0.tag = "usd_breakable_policy_notes"
            $0.placeholder = "Catatan Polis"
        }
        <<< TextRow() {
            $0.title = "Nomor Rekening"
            $0.tag = "usd_account_number"
            $0.placeholder = "Nomor Rekening"
        }
        <<< TextRow() {
            $0.title = "A/n Rekening"
            $0.tag = "usd_account_name"
            $0.placeholder = "A/n Rekening"
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 1 Bulan (%)"
            $0.tag = "usd_month_rate_1"
            $0.placeholder = "Best Rate 1 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 3 Bulan (%)"
            $0.tag = "usd_month_rate_3"
            $0.placeholder = "Best Rate 3 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 6 Bulan (%)"
            $0.tag = "usd_month_rate_6"
            $0.placeholder = "Best Rate 6 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        +++ Section("PENEMPATAN SYARIAH")
        <<< AlertRow<String>() { row in
            row.title = "Polis Break"
            row.tag = "sharia_breakable_policy"
            row.options = self.options["breakable_policy"]
        }
        <<< TextAreaRow() {
            $0.title = "Catatan Polis"
            $0.tag = "sharia_breakable_policy_notes"
            $0.placeholder = "Catatan Polis"
        }
        <<< TextRow() {
            $0.title = "Nomor Rekening"
            $0.tag = "sharia_account_number"
            $0.placeholder = "Nomor Rekening"
        }
        <<< TextRow() {
            $0.title = "A/n Rekening"
            $0.tag = "sharia_account_name"
            $0.placeholder = "A/n Rekening"
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 1 Bulan (%)"
            $0.tag = "sharia_month_rate_1"
            $0.placeholder = "Best Rate 1 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 3 Bulan (%)"
            $0.tag = "sharia_month_rate_3"
            $0.placeholder = "Best Rate 3 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 6 Bulan (%)"
            $0.tag = "sharia_month_rate_6"
            $0.placeholder = "Best Rate 6 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        
        //print(getProfileForm(key: "sharia"))
        switch getLocalData(key: "sharia") {
        case "Yes Umum":
            form.sectionBy(tag: "PENEMPATAN IDR")?.hidden = true
        case "No":
            form.sectionBy(tag: "PENEMPATAN SYARIAH")?.hidden = true
        default:
            break
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

    func showValidationAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func save(notification:Notification) {
        if let data = notification.userInfo as? [String: Int] {
            let idx = data["idx"]!
            if idx == 1 {
                let formData = form.values()
                
                let validateForm = form.validate()
                
                //if(form.validate().count == 0) {
                if errors.count == 0 {
                    let data: [String: String] = [
                        "idr_breakable_policy": formData["idr_breakable_policy"]! != nil ? formData["idr_breakable_policy"] as! String : "",
                        "idr_breakable_policy_notes": formData["idr_breakable_policy_notes"]! != nil ? formData["idr_breakable_policy_notes"] as! String : "",
                        "idr_account_number": formData["idr_account_number"]! != nil ? formData["idr_account_number"] as! String : "",
                        "idr_account_name": formData["idr_account_name"]! != nil ? formData["idr_account_name"] as! String : "",
                        "idr_month_rate_1": formData["idr_month_rate_1"]! != nil ? formData["idr_month_rate_1"] as! String : "",
                        "idr_month_rate_3": formData["idr_month_rate_3"]! != nil ? formData["idr_month_rate_3"] as! String : "",
                        "idr_month_rate_6": formData["idr_month_rate_6"]! != nil ? formData["idr_month_rate_6"] as! String : "",
                        "usd_breakable_policy": formData["usd_breakable_policy"]! != nil ? formData["usd_breakable_policy"] as! String : "",
                        "usd_breakable_policy_notes": formData["usd_breakable_policy_notes"]! != nil ? formData["usd_breakable_policy_notes"] as! String : "",
                        "usd_account_number": formData["usd_account_number"]! != nil ? formData["usd_account_number"] as! String : "",
                        "usd_account_name": formData["usd_account_name"]! != nil ? formData["usd_account_name"] as! String : "",
                        "usd_month_rate_1": formData["usd_month_rate_1"]! != nil ? formData["usd_month_rate_1"] as! String : "",
                        "usd_month_rate_3": formData["usd_month_rate_3"]! != nil ? formData["usd_month_rate_3"] as! String : "",
                        "usd_month_rate_6": formData["usd_month_rate_6"]! != nil ? formData["usd_month_rate_6"] as! String : "",
                        "sharia_breakable_policy": formData["sharia_breakable_policy"]! != nil ? formData["sharia_breakable_policy"] as! String : "",
                        "sharia_breakable_policy_notes": formData["sharia_breakable_policy_notes"]! != nil ? formData["sharia_breakable_policy_notes"] as! String : "",
                        "sharia_account_number": formData["sharia_account_number"]! != nil ? formData["sharia_account_number"] as! String : "",
                        "sharia_account_name": formData["sharia_account_name"]! != nil ? formData["sharia_account_name"] as! String : "",
                        "sharia_month_rate_1": formData["sharia_month_rate_1"]! != nil ? formData["sharia_month_rate_1"] as! String : "",
                        "sharia_month_rate_3": formData["sharia_month_rate_3"]! != nil ? formData["sharia_month_rate_3"] as! String : "",
                        "sharia_month_rate_6": formData["sharia_month_rate_6"]! != nil ? formData["sharia_month_rate_6"] as! String : "",
                    ]
                    
                    setLocalData(data)
                    NotificationCenter.default.post(name: Notification.Name("RegisterNextValidation"), object: nil, userInfo: ["step": 2])
                } else {
                    var msg = String()
                    for error in errors {
                        msg += "\(error)\n"
                    }
                    
                    showValidationAlert(title: "Error", message: msg)
                }
                //NotificationCenter.default.post(name: Notification.Name("RegisterNextValidation"), object: nil, userInfo: ["idx": 1])
            }
        }
    }
}

extension BestRateViewController: BestRateDelegate {
    func setOptions(_ data: [String:[String]]) {
        self.options = data
        showLoading(false)
        loadForm()
    }
    
    func getDataFail() {
        showConnectionAlert(title: "Error", message: "Gagal memproses data dari server")
    }
}
