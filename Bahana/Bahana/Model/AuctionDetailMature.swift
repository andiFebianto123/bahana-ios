//
//  AuctionDetailMature.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/26.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation

struct AuctionDetailMature {
    var id: Int
    var auction_name: String
    var quantity: Double
    var portfolio: String
    var pic_custodian: String?
    var custodian_bank: String?
    var status: String
    var issue_date: String
    var maturity_date: String
    var coupon_rate: Double
    var period: String
    var notes:String
}

struct AuctionDetailMatureMultifund {
    var id: Int
    var auction_name: String
    var created_at: String
    var updated_at: String
    var tenor: String
    var period: String
    var coupon_rate: Double
    var fund_type: String
    var status: String
    var details: [AuctionDetailMatureMultifundDetails]
    var total_investment: String
    var notes_auction: String
}

struct AuctionDetailMatureMultifundDetails {
    var portfolio: String
    var description: String
    var custodian_bank: String
    var bilyet: String
    var transaction_id: [Int]
}
