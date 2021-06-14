//
//  AuctionWinnerDetailView.swift
//  Bahana
//
//  Created by RECTmedia MD102 on 03/06/21.
//  Copyright © 2021 Rectmedia. All rights reserved.
//

import UIKit

class AuctionWinnerDetailView: UIView {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var AllCheckButtonView: UIView!
    
    @IBOutlet weak var stackViewCheck: UIStackView!
    @IBOutlet weak var approvedBtn: UIButton!
    @IBOutlet weak var declinedBtn: UIButton!
    
    @IBOutlet weak var selectAllBtn: UIButton!
    
    var selectAlltrigger = false
    
    var details = [DetailsRolloverMultifund]()
    
    var detailsMature = [AuctionDetailMatureMultifundDetails]()
    
    var checkPlacements = [AuctionStackPlacement]()
    
    var checkUSDorIDR = Int()
    
    override init(frame: CGRect){
           super.init(frame:frame)
           commoninit()
    }
       
   required init?(coder: NSCoder) {
       super.init(coder:coder)
       commoninit()
   }
   private func commoninit(){
       Bundle.main.loadNibNamed("AuctionWinnerDetailView", owner: self, options: nil)
       addSubview(contentView)
       contentView.frame = self.bounds
       contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func addStackPortfolio(){
        stackViewCheck.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        for detail in details {
            let winnerStack = AuctionStackPlacement()
            winnerStack.portfolioLabel.text = detail.portfolio
            winnerStack.fullNameLabel.text = detail.description
            winnerStack.custodianLabel.text = detail.custodian_bank
            winnerStack.bilyetLabel.text = detail.bilyet
            winnerStack.approvedRmLabel.text = detail.status
            if detail.status == "Approved" || detail.status == "Declined"{
                winnerStack.viewBoxCheckHide(true)
            }
            winnerStack.bidder_security_history = detail.bidder_security_history_id
            if self.checkUSDorIDR == 1 {
                // hanya dipakai untuk USD
                winnerStack.new_nominal = detail.new_nominal
                winnerStack.addPrincipalBilyet(detail.status)
            }
            
            checkPlacements.append(winnerStack)
            stackViewCheck.addArrangedSubview(winnerStack)
        }
    }
    
    func setContent(){
        approvedBtn.setTitle(localize("approved").uppercased(), for: .normal)
        declinedBtn.setTitle(localize("declined").uppercased(), for: .normal)
        self.addStackPortfolio()
    }
    
    func setContentForMature(){
        AllCheckButtonView.isHidden = true
        stackViewCheck.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        for detail in detailsMature {
            let winnerStack = AuctionStackPlacement()
            winnerStack.portfolioLabel.text = detail.portfolio
            winnerStack.fullNameLabel.text = detail.description
            winnerStack.custodianLabel.text = detail.custodian_bank
            winnerStack.bilyetLabel.text = detail.bilyet
            // winnerStack.approvedRmLabel.text = detail.status
            winnerStack.statusByRmView.isHidden = true
            winnerStack.viewBoxCheckHide(true)
            winnerStack.transaction_id = detail.transaction_id
            checkPlacements.append(winnerStack)
            stackViewCheck.addArrangedSubview(winnerStack)
        }
    }
    
    @IBAction func pressCheckAll(_ sender: Any) {
        if selectAlltrigger {
            selectAlltrigger = false
            selectAllBtn.setImage(UIImage(named:"unchecked_checkbox"), for: .normal)
            checkPlacements.forEach { placement in
                if !placement.checkBoxViewHide {
                    placement.unchecked()
                }
            }
        }else{
            selectAlltrigger = true
            selectAllBtn.setImage(UIImage(named:"checked_checkbox"), for: .normal)
            checkPlacements.forEach { placement in
                if !placement.checkBoxViewHide {
                    placement.checked()
                }
            }
        }
        
    }
    

}
