//
//  FaqTableViewCell.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/10.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class FaqTableViewCell: UITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var answerTitleLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    var isExpanded: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.backgroundColor = backgroundColor
        answerTitleLabel.font = UIFont.boldSystemFont(ofSize: 10)
        answerTitleLabel.text = localize("answer")
        
        if isExpanded == nil {
            isExpanded = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func expand() {
        isExpanded = true
        titleImageView.image = UIImage(named: "icon_substract")
        UIView.animate(withDuration: 0.5) {
            self.bottomView.isHidden = false
        }
    }
    
    func shrink() {
        isExpanded = false
        titleImageView.image = UIImage(named: "icon_add")
        UIView.animate(withDuration: 0.5) {
            self.bottomView.isHidden = true
        }
    }
    
    func getHeight() -> CGFloat {
        if isExpanded != nil && isExpanded! {
            return 100 + answerLabel.intrinsicContentSize.height
        } else {
            return 70
        }
    }
}
