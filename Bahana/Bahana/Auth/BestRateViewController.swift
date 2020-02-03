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
    
    var spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        showLoading(true)
        
        presenter = BestRatePresenter(delegate: self)
        presenter.getOptions()
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
            row.options = self.options["breakable_policy"]
        }
        <<< TextAreaRow() {
            $0.title = "Catatan Polis"
            $0.placeholder = "Catatan Polis"
        }
        <<< TextRow() {
            $0.title = "Nomor Rekening"
            $0.placeholder = "Nomor Rekening"
        }
        <<< TextRow() {
            $0.title = "A/n Rekening"
            $0.placeholder = "A/n Rekening"
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 1 Bulan (%)"
            $0.placeholder = "Best Rate 1 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 3 Bulan (%)"
            $0.placeholder = "Best Rate 3 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 6 Bulan (%)"
            $0.placeholder = "Best Rate 6 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        +++ Section("PENEMPATAN USD")
        <<< AlertRow<String>() { row in
            row.title = "Polis Break"
            row.options = self.options["breakable_policy"]
        }
        <<< TextAreaRow() {
            $0.title = "Catatan Polis"
            $0.placeholder = "Catatan Polis"
        }
        <<< TextRow() {
            $0.title = "Nomor Rekening"
            $0.placeholder = "Nomor Rekening"
        }
        <<< TextRow() {
            $0.title = "A/n Rekening"
            $0.placeholder = "A/n Rekening"
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 1 Bulan (%)"
            $0.placeholder = "Best Rate 1 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 3 Bulan (%)"
            $0.placeholder = "Best Rate 3 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 6 Bulan (%)"
            $0.placeholder = "Best Rate 6 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        +++ Section("PENEMPATAN SYARIAH")
        <<< AlertRow<String>() { row in
            row.title = "Polis Break"
            row.options = self.options["breakable_policy"]
        }
        <<< TextAreaRow() {
            $0.title = "Catatan Polis"
            $0.placeholder = "Catatan Polis"
        }
        <<< TextRow() {
            $0.title = "Nomor Rekening"
            $0.placeholder = "Nomor Rekening"
        }
        <<< TextRow() {
            $0.title = "A/n Rekening"
            $0.placeholder = "A/n Rekening"
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 1 Bulan (%)"
            $0.placeholder = "Best Rate 1 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 3 Bulan (%)"
            $0.placeholder = "Best Rate 3 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
        }
        <<< DecimalRow() {
            $0.title = "Best Rate 6 Bulan (%)"
            $0.placeholder = "Best Rate 6 Bulan (%)"
            $0.formatter = DecimalFormatter()
            $0.useFormatterDuringInput = true
        }.cellSetup { cell, _ in
            cell.textField.keyboardType = .numberPad
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
