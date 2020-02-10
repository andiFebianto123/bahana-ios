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
    
    var spinner = UIActivityIndicatorView()
    
    var errors = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.color = .black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        showLoading(true)
        
        presenter = ProfilePresenter(delegate: self)
        presenter.getBank()
        
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
            NotificationCenter.default.post(name: Notification.Name("RegisterBack"), object: nil, userInfo: ["step": 1])
        }))
        alert.addAction(UIAlertAction(title: "Coba Lagi", style: .default, handler: { action in
            self.presenter.getBank()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showValidationAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadForm() {
        form
        +++ Section("DATA PRIBADI")
        <<< TextRow() {
            $0.title = "Nama Lengkap"
            $0.tag = "name"
            //$0.cell.titleLabel?.attributedText = requiredField("Nama Lengkap")
            //$0.placeholder = "Nama Lengkap"
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            //cell.titleLabel?.attributedText = self.requiredField("Nama Lengkap")
            //cell.titleLabel?.sizeToFit()
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< EmailRow() {
            $0.title = "Alamat Email"
            $0.tag = "email"
            $0.add(rule: RuleRequired())
            $0.add(rule: RuleEmail())
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< PhoneRow() {
            $0.title = "Nomor Telepon"
            $0.tag = "phone"
            $0.add(rule: RuleRequired())
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< TextRow() {
            $0.title = "PIC Alternatif"
            $0.tag = "pic_alternative"
            $0.add(rule: RuleRequired())
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< PhoneRow() {
            $0.title = "Telepon Alternatif"
            $0.tag = "phone_alternative"
            $0.add(rule: RuleRequired())
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        +++ Section("INFORMASI BANK")
        <<< SearchablePushRow<Bank>("bank") {
            $0.title = "Bank"
            $0.tag = "bank"
            $0.options = banks
            $0.selectorTitle = "Choose bank"
            $0.displayValueFor = { value in
                return value?.name
            }
            $0.add(rule: RuleRequired())
        }.onChange { row in
            // Get bank branchs after bank choosed
            self.presenter.getBankBranch((row.value?.id)!)
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< TextRow() {
            $0.title = "Nama Bank Baru"
            $0.tag = "bank_name"
            $0.hidden = .function(["bank"], { form -> Bool in
                if form.rowBy(tag: "bank")?.baseValue != nil {
                    let bank = form.rowBy(tag: "bank")?.baseValue as! Bank
                    if bank.id != "1" {
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
            $0.title = "Cabang"
            $0.tag = "bank_branch"
            $0.selectorTitle = "Choose branch"
            $0.displayValueFor = { value in
                return value?.name
            }
            $0.disabled = .function(["bank"], { form -> Bool in
                if form.rowBy(tag: "bank")?.baseValue != nil {
                    return false
                } else {
                    return true
                }
            })
            $0.add(rule: RuleRequired())
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
            $0.title = "Nama Cabang Baru"
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
            $0.title = "Alamat Cabang"
            $0.tag = "bank_branch_address"
            $0.add(rule: RuleRequired())
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< AlertRow<String>() { row in
            row.title = "Tipe Bank"
            row.tag = "bank_type"
            row.options = self.options["bank_type"]
            row.add(rule: RuleRequired())
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< AlertRow<String>() { row in
            row.title = "Devisa"
            row.tag = "foreign_exchange"
            row.options = self.options["foreign_exchange"]
            row.add(rule: RuleRequired())
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< AlertRow<String>() { row in
            row.title = "Buku"
            row.tag = "book"
            row.options = self.options["book"]
            row.add(rule: RuleRequired())
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< AlertRow<String>() { row in
            row.title = "Syariah"
            row.tag = "sharia"
            row.options = self.options["sharia"]
            row.add(rule: RuleRequired())
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< AlertRow<String>() { row in
            row.title = "Konversi Bunga Harian"
            row.tag = "interest_day_count_convertion"
            row.options = self.options["interest_day_count_convertion"]
            row.add(rule: RuleRequired())
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< AlertRow<String>() { row in
            row.title = "Tanggal Akhir"
            row.tag = "end_date"
            row.options = self.options["end_date"]
            row.add(rule: RuleRequired())
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< AlertRow<String>() { row in
            row.title = "Kembali Tanggal Awal"
            row.tag = "return_to_start_date"
            row.options = self.options["return_to_start_date"]
            row.add(rule: RuleRequired())
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< AlertRow<String>() { row in
            row.title = "Bunga hari libur"
            row.tag = "holiday_interest"
            row.options = self.options["holiday_interest"]
            row.add(rule: RuleRequired())
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        +++ Section("SANDI")
        <<< PasswordRow("password") {
            $0.title = "Sandi"
            $0.tag = "password"
            $0.add(rule: RuleRequired())
            $0.add(rule: RuleMinLength(minLength: 6))
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
        }
        <<< PasswordRow() {
            $0.title = "Konfirmasi Sandi"
            $0.tag = "password_confirmation"
            $0.placeholder = ""
            $0.add(rule: RuleRequired())
            $0.add(rule: RuleMinLength(minLength: 6))
            $0.add(rule: RuleEqualsToRow(form: form, tag: "password"))
        }.onRowValidationChanged { cell, row in
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    self.errors.append("\(row.title!) \(validationMsg)")
                }
            }
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
    
    func isBankEmpty() -> Bool {
        if form.rowBy(tag: "bank")?.baseValue == nil {
            return true
        } else {
            return false
        }
    }
    
    @objc func save(notification:Notification) {
        if let data = notification.userInfo as? [String: Int] {
            let idx = data["idx"]!
            if idx == 0 {
                form.cleanValidationErrors()
                errors = [String]()
                let formData = form.values()
                
                //let validateForm = form.validate()
                /*
                // Manual Validation
                // Phone - Number only
                if formData["phone"]! != nil {
                    if Int(formData["phone"] as! String) == nil {
                        errors.append("Phone must be number")
                    }
                }
                
                //if(validateForm.count == 0) {
                if errors.count == 0 {
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
                    
                    let data: [String: String] = [
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
                    
                    setLocalData(data)
                    //NotificationCenter.default.post(name: Notification.Name("RegisterNextValidation"), object: nil, userInfo: ["step": 1])
                    NotificationCenter.default.post(name: Notification.Name("RegisterTab"), object: nil, userInfo: ["idx": 1])
                    
                    
                } else {
                    var msg = String()
                    for error in errors {
                        msg += "\(error)\n"
                    }
                    
                    showValidationAlert(title: "Informasi", message: msg)
                }*/
                NotificationCenter.default.post(name: Notification.Name("RegisterNextValidation"), object: nil, userInfo: ["idx": 1])
            }
        }
    }
}

extension ProfileViewController: ProfileDelegate {
    func setBanks(_ data: [Bank]) {
        self.banks = data
        presenter.getOptions()
    }
    
    func setBankBranchs(_ data: [BankBranch]) {
        self.branchs = data
        print(data.count)
    }
    
    func setOptions(_ data: [String : [String]]) {
        self.options = data
        showLoading(false)
        loadForm()
    }
    
    func getDataFail() {
        showConnectionAlert(title: "Informasi", message: "Gagal memproses data dari server")
    }
}
