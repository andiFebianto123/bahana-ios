//
//  Auction.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/10.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation

struct Auction {
    var id: Int
    var auction_name: String
    var portfolio: String
    var portfolio_short: String
    var pic_custodian: String?
    var custodian_bank: String?
    var investment_range_start: Double
    var investment_range_end: Double
    var start_date: String
    var end_date: String
    var break_maturity_date: String?
    var maturity_date: String?
    var period: String
    var type: String
    var status: String
    var ncm_type: String?
    var fund_type: String?
}
