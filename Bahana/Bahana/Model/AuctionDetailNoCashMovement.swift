//
//  AuctionDetailNoCashMovement.swift
//  Bahana
//
//  Created by RECTmedia MD102 on 02/12/20.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation

struct AuctionDetailNoCashMovement {
    var id:Int
    var start_date:String
    var end_date:String
    var end_bidding_rm:String
    var ncm_type:String
    var investment_range_start:Double // new placement -> principal(bio) dan new placement ncm
    var interest_rate:Double
    var break_maturity_date:String
    var break_target_rate:Double?
    var notes:String
    var pic_custodian:String
    var custodian_bank:String
    var fund_type:String
    var portfolio:String
    var period:String // new placement -> tenor
    var ncm_change_status:String
    var bilyet:bilyetDetail
    var previous_transaction:previousTransactionDetail
    var revision_rate_rm: Double?
    var status: String
    var message: String?
    var view: Int
}

struct bilyetDetail{
    var quantity: Double
    var issue_date: String
    var maturity_date: String?
}

struct previousTransactionDetail{
    var quantity:Double // previous IDR or USD
    var issue_date: String
    var maturity_date: String?
    var coupon_rate: Double
    var transfer_ammount: Double // new placement -> trasnfer mature
    var period: String
}




