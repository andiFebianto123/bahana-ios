//
//  AuctionDetailRolloverMultifund.swift
//  Bahana
//
//  Created by RECTmedia MD102 on 02/06/21.
//  Copyright © 2021 Rectmedia. All rights reserved.
//

import Foundation

struct AuctionDetailRolloverMultifund {
    var id: Int
    var auction_name: String
    var start_date: String
    var end_date: String
    var fund_type: String
    var interest: String?
    var investment_range_approved: Double
    var investment_range_declined: Double
    var investment_range_start: Double
    var previous_interest_rate: Double
    var status: String
    var view: Int
    var message: String?
    var previous_maturity_date: String
    var previous_issue_date: String
    var period: String
    var breakable_policy: String?
    var last_bid_rate: Double?
    var issue_date: String
    var maturity_date: String?
    var notes: String
    var details: [DetailsRolloverMultifund]
    var is_pending_exists: Bool
}


struct DetailsRolloverMultifund {
    var portfolio: String
    var portfolio_id: Int
    var description: String
    var custodian_bank: String
    var status: String
    var bidder_security_history_id: [Int]
    var bilyet: String
}
