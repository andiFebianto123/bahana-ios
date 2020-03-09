//
//  Notification.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/09.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation

struct NotificationModel {
    var id: String
    var title: String
    var message: String
    var data: nData?
    var is_read: Int
    var created_at: String
    var available_at:String
}

struct nData {
    var type: String?
    var sub_type: String?
    var id: Int
    var portfolio:String?
    var issue_date:String?
    var maturity_date:String?
    var quantity:Double?
    var coupon_rate:Double?
    var period:String?
    var title_in:String?
    var message_in:String?
}
