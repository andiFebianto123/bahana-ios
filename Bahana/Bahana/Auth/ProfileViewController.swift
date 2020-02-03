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
    
    var optionType = String()
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
            //$0.cell.titleLabel?.attributedText = requiredField("Nama Lengkap")
            //$0.placeholder = "Nama Lengkap"
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            //cell.titleLabel?.attributedText = self.requiredField("Nama Lengkap")
            //cell.titleLabel?.sizeToFit()
        }
        <<< TextRow() {
            $0.title = "Alamat Email"
            $0.placeholder = "Alamat Email"
            $0.add(rule: RuleRequired())
        }
        <<< TextRow() {
            $0.title = "Nomor Telepon"
            $0.placeholder = "Nomor Telepon"
            $0.add(rule: RuleRequired())
        }
        <<< TextRow() {
            $0.title = "PIC Alternatif"
            $0.placeholder = "PIC Alternatif"
            $0.add(rule: RuleRequired())
        }
        <<< TextRow() {
            $0.title = "Telepon Alternatif"
            $0.placeholder = "Telepon Alternatif"
            $0.add(rule: RuleRequired())
        }
        +++ Section("INFORMASI BANK")
        <<< PushRow<Bank> {
            $0.title = "Bank"
            //$0.presentationMode = PresentationMode.segueName(segueName: "showOption", onDismiss: nil)
            $0.options = banks
            $0.selectorTitle = "Choose bank"
            $0.add(rule: RuleRequired())
        }.onCellSelection { _, _  in
            //self.optionType = "bank"
            //print("bbb")
            //print(self.optionType)
        } .onPresent { from, to in
            to.dismissOnSelection = true
            to.dismissOnChange = false
        }
        <<< PushRow<String> {
            $0.title = "Cabang"
            $0.presentationMode = PresentationMode.segueName(segueName: "showOption", onDismiss: nil)
            $0.add(rule: RuleRequired())
        }.onCellSelection { _, _  in
            self.optionType = "bank_branch"
        }
        <<< TextRow() {
            $0.title = "Alamat Cabang"
            $0.placeholder = "Alamat Cabang"
            $0.add(rule: RuleRequired())
        }
        <<< AlertRow<String>() { row in
            row.title = "Tipe Bank"
            row.options = self.options["bank_type"]
            row.add(rule: RuleRequired())
        }
        <<< AlertRow<String>() { row in
            row.title = "Devisa"
            row.options = self.options["foreign_exchange"]
            row.add(rule: RuleRequired())
        }
        <<< AlertRow<String>() { row in
            row.title = "Buku"
            row.options = self.options["book"]
            row.add(rule: RuleRequired())
        }
        <<< AlertRow<String>() { row in
            row.title = "Syariah"
            row.options = self.options["sharia"]
            row.add(rule: RuleRequired())
        }
        <<< AlertRow<String>() { row in
            row.title = "Konversi Bunga Harian"
            row.options = self.options["interest_day_count_convertion"]
            row.add(rule: RuleRequired())
        }
        <<< AlertRow<String>() { row in
            row.title = "Tanggal Akhir"
            row.options = self.options["end_date"]
            row.add(rule: RuleRequired())
        }
        <<< AlertRow<String>() { row in
            row.title = "Kembali Tanggal Awal"
            row.options = self.options["return_to_start_date"]
            row.add(rule: RuleRequired())
        }
        <<< AlertRow<String>() { row in
            row.title = "Bunga hari libur"
            row.options = self.options["holiday_interest"]
            row.add(rule: RuleRequired())
        }
        +++ Section("SANDI")
        <<< PasswordRow() {
            $0.title = "Sandi"
            $0.placeholder = "Sandi"
            $0.add(rule: RuleRequired())
        }
        <<< PasswordRow() {
            $0.title = "Konfirmasi Sandi"
            $0.placeholder = ""
            $0.add(rule: RuleRequired())
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showOption" {
            if let destination = segue.destination as? OptionViewController {
                destination.type = optionType
                print("opsion")
                print(optionType)
                destination.test(banks, branchs)
            }
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
}

extension ProfileViewController: ProfileDelegate {
    func setBanks(_ data: [Bank]) {
        self.banks = data
        presenter.getOptions()
    }
    
    func setBankBranchs(_ data: [BankBranch]) {
        self.branchs = data
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
