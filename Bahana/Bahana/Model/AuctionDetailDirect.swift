//
//  AuctionDetailDirect.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/25.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation

struct AuctionDetailDirect {
    var id: Int
    var start_date: String
    var end_date: String
    var end_bidding_rm: String
    var investment_range_start: Double
    var investment_range_end: Double
    var auction_name: String
    var portfolio:String
    var portfolio_short: String
    var fund_type: String
    var revision_rate_rm: String
    var interest_rate: Double
    var notes: String
    var pic_custodian: String?
    var custodian_bank: String?
    var period: String
    var bilyet: [Bilyet]
    var status: String
    var message: String
    var view: Int
}
