//
//  AuctionListReloadTableViewCell.swift
//  Bahana
//
//  Created by Christian Chandra on /2005/19.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

protocol AuctionListReloadDelegate {
    func reload()
}

class AuctionListReloadTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var retryButtonWidth: NSLayoutConstraint!
    
    var delegate: AuctionListReloadDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = backgroundColor
        
        title.text = localize("cannot_connect_to_server")
        retryButton.setTitle(localize("try_again").uppercased(), for: .normal)
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.backgroundColor = accentColor
        retryButtonWidth.constant = retryButton.intrinsicContentSize.width + 6
        //retryButton.titleEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func retryButtonPressed(_ sender: Any) {
        delegate?.reload()
    }
}
