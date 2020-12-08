//
//  panelView.swift
//  Bahana
//
//  Created by RECTmedia MD102 on 10/11/20.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class panelView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var contentView2: UIView!
    @IBOutlet weak var rootView: UIView!
    @IBOutlet var contentView3: UIView!
    
    
    override init(frame: CGRect){
        super.init(frame:frame)
        commoninit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        commoninit()
    }
    private func commoninit(){
        Bundle.main.loadNibNamed("panelView", owner: self, options: nil)
        addSubview(contentView3)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
 }
    
}
