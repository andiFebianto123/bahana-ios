//
//  AuctionPanelView.swift
//  Bahana
//
//  Created by RECTmedia MD102 on 11/11/20.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionPanelView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var viewBody: UIView!
    
    @IBOutlet weak var listPrincipalBio: UIView!
    
    // variabel title
    @IBOutlet weak var panelTitle: UILabel!
    @IBOutlet weak var panelTItle2: UILabel!
    
    @IBOutlet weak var tenorTitle: UILabel!
    @IBOutlet weak var requestRateBreakTitle: UILabel!
    @IBOutlet weak var requestInterestRateTitle: UILabel!
    @IBOutlet weak var approvedInterestRateTitle: UILabel!
    @IBOutlet weak var totalApproveTitle: UILabel!
    @IBOutlet weak var totalDecilineTitle: UILabel!
    @IBOutlet weak var principalTitle: UILabel!
    // title sub stack
    @IBOutlet weak var transferTitle: UILabel!
    @IBOutlet weak var matureTitle: UILabel! // status red color
    @IBOutlet weak var newPlacementTitle: UILabel!
    @IBOutlet weak var noCashMovementTitle: UILabel! // status red color
    //
    @IBOutlet weak var periodTitle: UILabel!
    
    // variabel label
    @IBOutlet weak var tenorLabel: UILabel!
    @IBOutlet weak var requestRateBreakLabel: UILabel!
    @IBOutlet weak var requestInterestRateLabel: UILabel!
    @IBOutlet weak var fieldApprovedInterestRate: UITextField!
    @IBOutlet weak var totalApproveLabel: UILabel!
    @IBOutlet weak var totalDecilineLabel: UILabel!
    @IBOutlet weak var principalLabel: UILabel!
    @IBOutlet weak var statusTenorChanged: UILabel!
    
    // sub stack label
    @IBOutlet weak var transferLabel: UILabel!
    @IBOutlet weak var newPlacementLabel: UILabel!
    //
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var btnperiodLabel: UIButton!
    
    // variabel view per stack
    @IBOutlet weak var totalApproveView: UIView!
    @IBOutlet weak var totalDecilineView: UIView!
    @IBOutlet weak var approvedInterestRateView: UIView!
    
    //
    var Rollover:AuctionDetailRolloverViewController!
    var Break:AuctionDetailBreakViewController!
    private var type:String!
    
    override init(frame: CGRect){
           super.init(frame:frame)
           commoninit()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder:coder)
           commoninit()
       }
       private func commoninit(){
           Bundle.main.loadNibNamed("AuctionPanelView", owner: self, options: nil)
           addSubview(contentView)
           contentView.frame = self.bounds
           contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    func setType(type:String){
        self.type = type
    }
    @IBAction func periodAction(_ sender: Any) {
        if self.type == "rollover"{
//            print(fieldApprovedInterestRate.text!)
            if Rollover.matureDateAktif == false {
                Rollover.matureDateAktif = true
            } else {
                Rollover.matureDateAktif = false
            }
            Rollover.changeMatureTitle.isHidden = Rollover.matureDateAktif
            Rollover.changeMatureDateField.isHidden = Rollover.matureDateAktif
        }else if self.type == "break" {
            
        }
    }
    func setContent(){
        if self.type == "rollover" {
            // untuk rollover
            
            totalApproveView.isHidden = true
            totalDecilineView.isHidden = true
            
        }else if self.type == "break" {
            // untuk break
        }else{
            contentView.isHidden = true
        }
    }
    
}
