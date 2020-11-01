//
//  AuctionDetailBreak.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/25.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation

struct AuctionDetailBreak {
    var id: Int
    var start_date: String
    var end_date: String
    var end_bidding_rm: String?
    var pic_custodian: String?
    var custodian_bank: String?
    var portfolio:String
    var portfolio_short: String
    var fund_type: String
    var investment_range_start: Double
    var investment_range_end: Double
    var period : String
    var auction_name: String
    var previous_interest_rate: Double
    var revision_rate_admin: String
    var last_bid_rate: Double?
    var status: String
    var view: Int
    var message: String
    var breakable_policy: String?
    var policy_notes : String?
    var previous_maturity_date: String
    var previous_issue_date: String
    var break_maturity_date:String?
    var notes:String
}
