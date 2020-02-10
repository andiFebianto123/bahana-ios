//
//  Auction.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/10.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation

struct Auction {
    var id: Int?
    var auction_name: String?
    var start_date: String?
    var end_date: String?
    var end_bidding_rm: String?
    var investment_range_start: Double?
    var investment_range_end: Double?
    var issue_date: String?
    var pic_custodian: String?
    var custodian_bank: String?
    var portfolio_short: String?
    var portfolio: String?
    var maturity_date: String?
    var break_maturity_date: String?
    var type: String?
    var status: String?
    var period: String?
    
    init(id:Int?, auction_name: String?, start_date:String?, end_date: String?, end_bidding_rm: String?, investment_range_start: Double?, investment_range_end: Double?, issue_date: String?, pic_custodian: String?, custodian_bank: String?, portfolio_short: String?, portfolio: String?, maturity_date: String?, break_maturity_date: String?, type: String?, status: String?, period: String?) {
        self.id = id
        self.auction_name = auction_name
        self.start_date = start_date
        self.end_date = end_date
        self.end_bidding_rm = end_bidding_rm
        self.investment_range_start = investment_range_start
        self.investment_range_end = investment_range_end
        self.issue_date = issue_date
        self.pic_custodian = pic_custodian
        self.custodian_bank = custodian_bank
        self.portfolio_short = portfolio_short
        self.portfolio = portfolio
        self.maturity_date = maturity_date
        self.break_maturity_date = break_maturity_date
        self.type = type
        self.status = status
        self.period = period
    }
}


