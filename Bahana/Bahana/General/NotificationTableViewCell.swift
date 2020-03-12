//
//  NotificationTableViewCell.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/09.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationTitle: UILabel!
    @IBOutlet weak var notificationContent: UILabel!
    @IBOutlet weak var notificationDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.backgroundColor = backgroundColor
        notificationView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func isUnread() {
        notificationView.backgroundColor = UIColorFromHex(rgbValue: 0xfff7e2)
    }
}
