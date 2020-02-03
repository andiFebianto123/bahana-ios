//
//  RegisterStepCollectionViewCell.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/31.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class RegisterStepCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        numberView.layer.cornerRadius = 12
        numberView.layer.masksToBounds = true
        number.textColor = UIColor.white
        setInactive()
    }

    func setActive() {
        numberView.backgroundColor = UIColor.red
        name.textColor = UIColor.red
    }
    
    func setInactive() {
        numberView.backgroundColor = UIColor.gray
        name.textColor = UIColor.gray
    }
}
