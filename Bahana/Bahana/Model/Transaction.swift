//
//  Transaction.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/03.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation

struct Transaction {
    var id: Int
    var quantity: Double
    var issue_date: String
    var maturity_date: String
    var status: String
    var portfolio: String
    var pic_custodian: String?
    var custodian_bank: String?
    var break_maturity_date: String?
    var coupon_rate: String?
    var break_coupon_rate: String?
    var period: String
}
