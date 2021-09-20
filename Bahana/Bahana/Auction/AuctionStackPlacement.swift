//
//  AuctionStackPlacement.swift
//  Bahana
//
//  Created by RECTmedia MD102 on 10/05/21.
//  Copyright © 2021 Rectmedia. All rights reserved.
//

import UIKit

class AuctionStackPlacement: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var portfolioLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var custodianLabel: UILabel!
    @IBOutlet weak var bilyetLabel: UILabel!
    @IBOutlet weak var approvedRmLabel: UILabel!
    @IBOutlet weak var fullnameTitleLabel: UILabel!
    @IBOutlet weak var portfolioTitleLabel: UILabel!
    @IBOutlet weak var custodianTitleLabel: UILabel!
    @IBOutlet weak var bilyetTitleLabel: UILabel!
    @IBOutlet weak var statusByRmTitleLabel: UILabel!
    
    // view
    @IBOutlet weak var statusByRmView: UIView!
    
    @IBOutlet weak var stackPrincipal: UIStackView!
    
    
    
    var id = Int()
    var status:String!
    
    var checkBox:Bool = false
    
    @IBOutlet weak var checkBoxView: UIView!
    var checkBoxViewHide:Bool = false
    
    var statusView = Int()
    
    var bidder_security_history = [Int]() // untuk multifund rollover
    var transaction_id = [Int]() // untuk multifund mature
    
    var new_nominal = [Int]() // untuk multifund rollover tipe USD
        
    override init(frame: CGRect){
        super.init(frame:frame)
        commoninit()
    }
       
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        commoninit()
    }
    private func commoninit(){
        Bundle.main.loadNibNamed("AuctionStackPlacement", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        portfolioTitleLabel.text = localize("portfolio")
        fullnameTitleLabel.text = localize("fullname")
        custodianTitleLabel.text = localize("custodian")
        bilyetTitleLabel.text = localize("bilyet")
        statusByRmTitleLabel.text = localize("status_by_rm")
    }
    
    func autoLoad(){
        if status == "Pending" && statusView == 1{
//            checkBoxViewHide = false // cek box hidup
            self.viewBoxCheckHide(false)
            checkBox = false
        }else if status == "Pending" && statusView == 0{
//            checkBoxViewHide = true // cek box mati
            self.viewBoxCheckHide(true)
            checkBox = false
        }else{
//            checkBoxViewHide = true // cek box mati
            self.viewBoxCheckHide(true)
            checkBox = false
        }
    }
    
    func viewBoxCheckHide(_ hide:Bool){
        checkBoxViewHide = hide
        self.setContent()
    }
    
    func setContent(){
        if checkBoxViewHide {
            checkBoxView.isHidden = true
        }
    }
    
    func checked(){
        checkBox = true
        btnCheck.setImage(UIImage(named:"checked_checkbox"), for: .normal)
    }
    
    func unchecked(){
        checkBox = false
        btnCheck.setImage(UIImage(named:"unchecked_checkbox"), for: .normal)
    }
    
    @IBAction func checkPress(_ sender: Any) {
        if checkBox {
            // lepas
            checkBox = false
            btnCheck.setImage(UIImage(named:"unchecked_checkbox"), for: .normal)
        }else{
            // check
            checkBox = true
            btnCheck.setImage(UIImage(named:"checked_checkbox"), for: .normal)
        }
    }
    
    func addPrincipalBilyet(_ status:String){
        for (index, nominal) in self.new_nominal.enumerated() {
            let view = AuctionPrincipalBilyetUsd()
            view.TitleLabel.text = "\(localize("title_bilyet_detail_winner")) \(index+1)"
            if nominal > 0 {
                if status != "Pending" {
                    view.fieldBilyet.isEnabled = false
                }
                view.fieldBilyet.text = "\(nominal)"
            }
            stackPrincipal.addArrangedSubview(view)
        }
    }
    
}
