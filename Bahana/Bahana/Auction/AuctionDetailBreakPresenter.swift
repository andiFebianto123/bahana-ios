//
//  AuctionDetailBreakPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/25.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol AuctionDetailBreakDelegate {
    func setData(_ data: AuctionDetailBreak)
}

class AuctionDetailBreakPresenter {
    private var delegate: AuctionDetailBreakDelegate?
    
    init(delegate: AuctionDetailBreakDelegate){
        self.delegate = delegate
    }
    
    func getAuction(_ id: Int) {
        // Get auction
        Alamofire.request(WEB_API_URL + "api/v1/break/\(id)", method: .get, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 401 {
                    //self.delegate?.openLoginPage()
                } else {
                    let res = JSON(response.result.value!)
                    let auct = res["auction"]
                    print(auct)
                    let id = auct["id"].intValue
                    let start_date = auct["start_date"].stringValue
                    let end_date = auct["end_date"].stringValue
                    let end_bidding_rm = auct["end_bidding_rm"].stringValue
                    let pic_custodian = auct["pic_custodian"] != JSON.null ? auct["pic_custodian"].stringValue : nil
                    let custodian_bank = auct["custodian_bank"] != JSON.null ? auct["custodian_bank"].stringValue : nil
                    let portfolio = auct["portfolio"].stringValue
                    let portfolio_short = auct["portfolio_short"].stringValue
                    let fund_type = auct["fund_type"].stringValue
                    let investment_range_start = auct["investment_range_start"].doubleValue
                    let investment_range_end = auct["investment_range_end"].doubleValue
                    let period = auct["period"].stringValue
                    let auction_name = auct["auction_name"].stringValue
                    let previous_interest_rate = auct["previous_interest_rate"].doubleValue
                    let revision_rate_admin = auct["revision_rate_admin"].stringValue
                    let last_bid_rate = auct["last_bid_rate"] != JSON.null ? auct["last_bid_rate"].doubleValue : nil
                    let status = auct["status"].stringValue
                    let view = auct["view"].intValue
                    let message = auct["message"].stringValue
                    let breakable_policy = auct["breakable_policy"] != JSON.null ? auct["breakable_policy"].stringValue : nil
                    let policyNotes = auct["policy_notes"].stringValue
                    let previous_maturity_date = auct["previous_maturity_date"].stringValue
                    let previous_issue_date = auct["previous_issue_date"].stringValue
                    let break_maturity_date = auct["break_maturity_date"] != JSON.null ? auct["break_maturity_date"].stringValue : nil
                    
                    let auction = AuctionDetailBreak(id: id, start_date: start_date, end_date: end_date, end_bidding_rm: end_bidding_rm, pic_custodian: pic_custodian, custodian_bank: custodian_bank, portfolio: portfolio, portfolio_short: portfolio_short, fund_type: fund_type, investment_range_start: investment_range_start, investment_range_end: investment_range_end, period: period, auction_name: auction_name, previous_interest_rate: previous_interest_rate, revision_rate_admin: revision_rate_admin, last_bid_rate: last_bid_rate, status: status, view: view, message: message, breakable_policy: breakable_policy, policy_notes: policyNotes, previous_maturity_date: previous_maturity_date, previous_issue_date: previous_issue_date, break_maturity_date: break_maturity_date)
                    
                    self.delegate?.setData(auction)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func saveAuction(_ id: Int) {
        let parameters: Parameters = [
            "rate": ""
        ]
        
        Alamofire.request(WEB_API_URL + "api/v1/break/\(id)/post", method: .post, parameters: parameters, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                let res = JSON(response.result.value!)
                print(res["message"])
                //self.delegate.
            case .failure(let error):
                print(error)
            }
        }
    }
}
