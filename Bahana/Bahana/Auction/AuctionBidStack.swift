//
//  AuctionBidStack.swift
//  Bahana
//
//  Created by RECTmedia MD102 on 12/05/21.
//  Copyright © 2021 Rectmedia. All rights reserved.
//

import UIKit

protocol AuctionBidStackDelegate {
    func getConfirm(bidID:Int)
    func cancelPressed22(text: UITextField)
    func donePressed22(text: UITextField, date: UIDatePicker?)
    func changeMatureDatePressed(_ bidID: Int, textDate:UITextField)
}

class AuctionBidStack: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var container: UIView!
    // label
    @IBOutlet weak var statusTitleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tenorTitleLabel: UILabel!
    @IBOutlet weak var tenorLabel: UILabel!
    @IBOutlet weak var interestRateTitleLabel: UILabel!
    @IBOutlet weak var interestRateLabel: UILabel!
    @IBOutlet weak var investmentTitleLabel: UILabel!
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var bilyetTitleLabel: UILabel!
    @IBOutlet weak var textDatePicker: UITextField!
    @IBOutlet weak var changeMatureDateTitleLabel: UILabel!
    
    @IBOutlet weak var changeMatureDateView: UIView!
    @IBOutlet weak var investmentBioView: UIView!
    @IBOutlet weak var bilyetBioView: UIView!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var changeMatureDateBtn: UIButton!
    
    
    var presenter: AuctionBidStackDelegate!
    
    var data:Bid!
    
    var bidID = Int()
    
    var fund_type = String()
    
    var view = Int()
    
    var globalView = UIView()

    var datePickerCustom = UIDatePicker()
    
    @IBOutlet weak var stackBilyet: UIStackView!
    override init(frame: CGRect){
           super.init(frame:frame)
           commoninit()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder:coder)
           commoninit()
       }
       private func commoninit(){
           Bundle.main.loadNibNamed("AuctionBidStack", owner: self, options: nil)
           addSubview(contentView)
           contentView.frame = self.bounds
           contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        confirmBtn.setTitle(localize("confirm").uppercased(), for: .normal)
        changeMatureDateBtn.setTitle(localize("change_mature_date_btn").uppercased(), for: .normal)
        changeMatureDateTitleLabel.text = localize("change_mature_date_")
    }
    
    func setContent(){
        if data.is_winner == "yes"{
            container.backgroundColor = lightGreenColor
        }else{
            container.backgroundColor = .white
            investmentBioView.isHidden = true
            bilyetBioView.isHidden = true
            confirmView.isHidden = true
        }
        changeMatureDateView.isHidden = true
        confirmBtn.setTitle(localize("details").uppercased(), for: .normal)
        getStatus()
        getTenor()
        getInterestRate()
        getInvestment()
    }
    
    private func getStatus(){
        if data.is_winner == "yes" {
            if(data.is_accepted == "yes(with decline)"){
                statusLabel.text = "\(localize("win")) (\(localize("accepted_with_decline")))"
            }
            else if (data.is_accepted == "yes(with pending)"){
                statusLabel.text = "\(localize("win")) (\(localize("accepted_with_pending")))"
            }
            else if(data.is_accepted == "no(with pending)"){
                statusLabel.text = "\(localize("win")) (\(localize("rejected_with_pending")))"
            } else if (data.is_accepted == "yes") {
                statusLabel.text = "\(localize("win")) (\(localize("accepted")))"
            } else if (data.is_accepted == "no") {
                statusLabel.text = "\(localize("win")) (\(localize("rejected")))"
            }else{
                statusLabel.text = "\(localize("win")) (\(localize("pending")))"
            }
        }else{
            statusLabel.text = localize("pending")
        }
    }
    private func getTenor(){
        tenorTitleLabel.text = localize("tenor")
        tenorLabel.text = data.period
    }
    
    private func getInterestRate(){
        interestRateTitleLabel.text = localize("interest_rate")
        var interestRateContent = """
        """
        var newLine = false
        
        if data.interest_rate_idr != nil {
            interestRateContent += "(IDR) \(checkPercentage(data.interest_rate_idr!)) %"
            if data.chosen_rate != nil && data.chosen_rate == "IDR" {
                interestRateContent += " [\(localize("chosen_rate"))]"
            }
            newLine = true
        }
        if data.interest_rate_usd != nil {
            if newLine {
                interestRateContent += "\n"
            }
            interestRateContent += "(USD) \(checkPercentage(data.interest_rate_usd!)) %"
            if data.chosen_rate != nil && data.chosen_rate == "USD" {
                interestRateContent += " [\(localize("chosen_rate"))]"
            }
            newLine = true
        }
        if data.interest_rate_sharia != nil {
            if newLine {
                interestRateContent += "\n"
            }
            interestRateContent += "(\(localize("sharia"))) \(checkPercentage(data.interest_rate_sharia!)) %"
            if data.chosen_rate != nil && data.chosen_rate == "Sharia" {
                interestRateContent += " [\(localize("chosen_rate"))]"
            }
        }
        interestRateLabel.text = interestRateContent
    }
    
    private func getInvestment(){
        if data.is_winner == "yes"{
            investmentTitleLabel.text = localize("investment")
            if self.fund_type == "USD" {
                investmentLabel.text = "USD \(toUsdBio(data.investment_value!))"
                investmentTitleLabel.text = localize("investment_usd")
            }else{
                investmentLabel.text = "IDR \(toIdrBio(data.used_investment_value))"
            }
            
            
            getBilyet()
            getAccessButton()
            
        }else{
            
        }
    }
    
    private func getBilyet(){
        bilyetTitleLabel.text = (self.fund_type == "USD") ? localize("bilyet_usd") : localize("bilyet")
        
        for (_, bilyetArr) in data.bilyet.enumerated() {
            var bilyetStr = """
            """
            if self.fund_type == "USD" {
                // untuk perhitungan bilyet USD
                bilyetStr += "USD \(toUsdBio(bilyetArr.quantity)) [\(convertDateToString(convertStringToDatetime(bilyetArr.issue_date)!)!) - \(convertDateToString(convertStringToDatetime(bilyetArr.maturity_date)!)!)]"
            }else{
                // untuk perhitungan bilyet IDR
                bilyetStr += "IDR \(toIdrBio(bilyetArr.quantity)) [\(convertDateToString(convertStringToDatetime(bilyetArr.issue_date)!)!) - \(convertDateToString(convertStringToDatetime(bilyetArr.maturity_date)!)!)]"
            }
            
//            if idx < data.bilyet.count - 1 {
//                bilyetStr += "\n"
//            }
            addBilyetCustom(bilyet: bilyetStr)
        }
        
    }
    
    private func getAccessButton(){
        if (self.view == 0 || self.view == 1) && (data.is_accepted.lowercased() == "yes" ||  data.is_accepted.lowercased() == "yes(with decline)" || data.is_accepted.lowercased() == "yes(with pending)") && (data.is_requested == 0) {
            // hidupkan tombol maturity date
            changeMatureDateView.isHidden = false
            
            
        }
        if (self.view == 0 || self.view == 1) && (data.is_accepted.lowercased() == "yes" ||  data.is_accepted.lowercased() == "yes(with decline)" || data.is_accepted.lowercased() == "yes(with pending)"){
            // hidup
            confirmBtn.setTitle(localize("details").uppercased(), for: .normal)
        }
//        print("request : \(data.is_requested)")
//        print("status : \(data.is_accepted.lowercased())")
//        print("Posisi view : \(self.view)")
        
    }
    
    func addBilyetCustom(bilyet: String){
        let view = UIView()

        let blackView = UIView()
        blackView.layer.cornerRadius = 5
        blackView.layer.shadowColor = UIColor.gray.cgColor
        blackView.layer.shadowOffset = CGSize(width:0, height:0)
        blackView.layer.shadowRadius = 4
        blackView.layer.shadowOpacity = 0.5
        blackView.backgroundColor = .black
        
        view.addSubview(blackView)
        
        let text = UILabel()
        text.textColor = UIColor.black
        text.font = UIFont.systemFont(ofSize: 13)
        text.numberOfLines = 0
        text.text = bilyet
        
        view.addSubview(text)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        blackView.translatesAutoresizingMaskIntoConstraints = false
        text.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            view.heightAnchor.constraint(equalToConstant: 15.0),
            
            blackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4.5),
            blackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            blackView.widthAnchor.constraint(equalToConstant: 6),
            blackView.heightAnchor.constraint(equalToConstant: 6),
            
            text.leadingAnchor.constraint(equalTo: blackView.trailingAnchor, constant: 6.0),
            text.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            text.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            text.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        stackBilyet.addArrangedSubview(view)
    }
    
    func createDatePicker(datePicker: UIDatePicker) {
        // [REVISI]
        datePickerCustom.datePickerMode = UIDatePicker.Mode.date
        datePicker.datePickerMode = UIDatePicker.Mode.date

        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let tgl = dateFormat.date(from: "2021-11-29 00:00:00") ?? Date()

        datePicker.setDate(tgl, animated:true)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        // let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPressed))
        let cancel = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([done, spaceButton, cancel], animated: true)
        textDatePicker.inputAccessoryView = toolbar
        textDatePicker.inputView = datePickerCustom // datePicker
    }
    
    @objc func donePressed(){
        presenter?.donePressed22(text: textDatePicker, date: datePickerCustom)
    }
    
    @objc func cancelPressed(){
        presenter?.cancelPressed22(text: textDatePicker)
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        presenter?.getConfirm(bidID: bidID)
    }

    @IBAction func changeMaturityDatePressed(_ sender: Any) {
        presenter?.changeMatureDatePressed(bidID, textDate: textDatePicker)
    }
}
