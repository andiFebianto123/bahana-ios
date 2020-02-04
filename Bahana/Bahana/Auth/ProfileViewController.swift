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
    
    var spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        showLoading(true)
        
        presenter = ProfilePresenter(delegate: self)
        presenter.getBank()
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
        }
        <<< TextRow() {
            $0.title = "Alamat Email"
            $0.tag = "email"
            $0.placeholder = "Alamat Email"
            $0.add(rule: RuleRequired())
        }
        <<< TextRow() {
            $0.title = "Nomor Telepon"
            $0.tag = "phone"
            $0.placeholder = "Nomor Telepon"
            $0.add(rule: RuleRequired())
        }
        <<< TextRow() {
            $0.title = "PIC Alternatif"
            $0.tag = "pic_alternative"
            $0.placeholder = "PIC Alternatif"
            $0.add(rule: RuleRequired())
        }
        <<< TextRow() {
            $0.title = "Telepon Alternatif"
            $0.tag = "phone_alternative"
            $0.placeholder = "Telepon Alternatif"
            $0.add(rule: RuleRequired())
        }
        +++ Section("INFORMASI BANK")
        <<< SearchablePushRow<Bank> {
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
            self.isBankEmpty()
        }
        <<< SearchablePushRow<BankBranch> {
            $0.title = "Cabang"
            $0.tag = "bank_branch"
            $0.selectorTitle = "Choose branch"
            $0.displayValueFor = { value in
                return value?.name
            }
            $0.add(rule: RuleRequired())
        }.onCellSelection { cell, row in
            row.options = self.branchs
            self.save()
        }
        <<< TextRow() {
            $0.title = "Alamat Cabang"
            $0.tag = "bank_branch_address"
            $0.placeholder = "Alamat Cabang"
            $0.add(rule: RuleRequired())
        }
        <<< AlertRow<String>() { row in
            row.title = "Tipe Bank"
            row.tag = "bank_type"
            row.options = self.options["bank_type"]
            row.add(rule: RuleRequired())
        }
        <<< AlertRow<String>() { row in
            row.title = "Devisa"
            row.tag = "foreign_exchange"
            row.options = self.options["foreign_exchange"]
            row.add(rule: RuleRequired())
        }
        <<< AlertRow<String>() { row in
            row.title = "Buku"
            row.tag = "book"
            row.options = self.options["book"]
            row.add(rule: RuleRequired())
        }
        <<< AlertRow<String>() { row in
            row.title = "Syariah"
            row.tag = "sharia"
            row.options = self.options["sharia"]
            row.add(rule: RuleRequired())
        }
        <<< AlertRow<String>() { row in
            row.title = "Konversi Bunga Harian"
            row.tag = "interest_day_count_convertion"
            row.options = self.options["interest_day_count_convertion"]
            row.add(rule: RuleRequired())
        }
        <<< AlertRow<String>() { row in
            row.title = "Tanggal Akhir"
            row.tag = "end_date"
            row.options = self.options["end_date"]
            row.add(rule: RuleRequired())
        }
        <<< AlertRow<String>() { row in
            row.title = "Kembali Tanggal Awal"
            row.tag = "return_to_start_date"
            row.options = self.options["return_to_start_date"]
            row.add(rule: RuleRequired())
        }
        <<< AlertRow<String>() { row in
            row.title = "Bunga hari libur"
            row.tag = "holiday_interest"
            row.options = self.options["holiday_interest"]
            row.add(rule: RuleRequired())
        }
        +++ Section("SANDI")
        <<< PasswordRow() {
            $0.title = "Sandi"
            $0.tag = "password"
            $0.placeholder = "Sandi"
            $0.add(rule: RuleRequired())
        }
        <<< PasswordRow() {
            $0.title = "Konfirmasi Sandi"
            $0.tag = "password_confirmation"
            $0.placeholder = ""
            $0.add(rule: RuleRequired())
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
    
    func isBankEmpty() {
        print(form.rowBy(tag: "bank")?.baseValue)
    }
    
    func save() {
        let formData = form.values()
        if(form.validate().count == 0) {
            let data: [String: String] = [
                "name": formData["name"] != nil ? formData["name"] as! String : "",
                "email": formData["email"] != nil ? formData["email"] as! String : "",
                "phone": formData["phone"] != nil ? formData["phone"] as! String : "",
                "pic_alternative": formData["pic_alternative"] != nil ? formData["pic_alternative"] as! String : "",
                "phone_alternative": formData["phone_alternative"] != nil ? formData["pic_alternative"] as! String : "",
                "bank": formData["bank"] != nil ? formData["bank"] as! String : "",
                "bank_branch": formData["bank_branch"] != nil ? formData["bank_branch"] as! String : "",
                "bank_branch_address": formData["bank_branch_address"] != nil ? formData["bank_branch_address"] as! String : "",
                "bank_type": formData["bank_type"] != nil ? formData["bank_type"] as! String : "",
                "foreign_exchange": formData["foreign_exchange"] != nil ? formData["foreign_exchange"] as! String : "",
                "book": formData["book"] != nil ? formData["book"] as! String : "",
                "sharia": formData["sharia"] != nil ? formData["sharia"] as! String : "",
                "interest_day_count_convertion": formData["interest_day_count_convertion"] != nil ? formData["interest_day_count_convertion"] as! String : "",
                "end_date": formData["end_date"] != nil ? formData["end_date"] as! String : "",
                "return_to_start_date": formData["return_to_start_date"] != nil ? formData["return_to_start_date"] as! String : "",
                "holiday_interest": formData["holiday_interest"] != nil ? formData["holiday_interest"] as! String : "",
                "password": formData["password"] != nil ? formData["password"] as! String : "",
                "password_confirmation": formData["password_confirmation"] != nil ? formData["password_confirmation"] as! String : "",
            ]
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
        showConnectionAlert(title: "Error", message: "Gagal memproses data dari server")
    }
}
