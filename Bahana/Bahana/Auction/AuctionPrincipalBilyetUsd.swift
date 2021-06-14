//
//  AuctionPrincipalBilyetUsd.swift
//  Bahana
//
//  Created by RECTmedia MD102 on 10/06/21.
//  Copyright © 2021 Rectmedia. All rights reserved.
//

import UIKit

class AuctionPrincipalBilyetUsd: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var fieldBilyet: UITextField!
    
    override init(frame: CGRect){
       super.init(frame:frame)
       commoninit()
    }
       
   required init?(coder: NSCoder) {
       super.init(coder:coder)
       commoninit()
   }
   private func commoninit(){
       Bundle.main.loadNibNamed("AuctionPrincipalBilyetUsd", owner: self, options: nil)
       addSubview(contentView)
       contentView.frame = self.bounds
       contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
   }
    
}
