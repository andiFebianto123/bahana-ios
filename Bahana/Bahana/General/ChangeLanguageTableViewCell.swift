//
//  ChangeLanguageTableViewCell.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/10.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class ChangeLanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var checkedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func checked() {
        checkedImageView.isHidden = false
    }
    
    func unchecked() {
        checkedImageView.isHidden = true
    }
}
