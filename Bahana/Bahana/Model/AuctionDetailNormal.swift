//
//  AuctionDetailNormal.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/25.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation

struct AuctionDetailNormal {
    var id: Int
    var auction_name: String
    var start_date: String
    var end_date: String
    var end_bidding_rm: String
    var investment_range_start: Double
    var investment_range_end: Double?
    var notes: String
    var pic_custodian: String?
    var custodian_bank: String?
    var fund_type: String?
    var portfolio: String
    var portfolio_short: String
    var bids: [Bid]
    var view: Int
    var status: String
    var issue_date : String
    var details: [Detail]
    var allowed_rate: [String]
    var default_rate: DefaultRate
}

struct Bid {
    var id: Int
    var auction_header_id: Int
    var is_accepted: String
    var is_winner: String
    var interest_rate_idr: Double?
    var interest_rate_usd: Double?
    var interest_rate_sharia: Double?
    var used_investment_value: Double
    var bilyet: [Bilyet]
    var chosen_rate : String?
    var period: String
}

struct DefaultRate {
    var month_rate_1: Double?
    var month_rate_3: Double?
    var month_rate_6: Double?
    var month_rate_1_usd: Double?
    var month_rate_3_usd: Double?
    var month_rate_6_usd: Double?
    var month_rate_1_sharia: Double?
    var month_rate_3_sharia: Double?
    var month_rate_6_sharia: Double?
}

struct Detail {
    var auction_header_id: Int
    var td_period: Int
    var td_period_type: String
    var default_rate: Double
    var default_rate_usd: Double
    var default_rate_sharia: Double
}
