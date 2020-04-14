//
//  AuctionDetailDirectPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/25.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol AuctionDetailDirectDelegate {
    func setData(_ data: AuctionDetailDirect)
    func isPosted(_ isSuccess: Bool, _ message: String)
}

class AuctionDetailDirectPresenter {
    private var delegate: AuctionDetailDirectDelegate?
    
    init(delegate: AuctionDetailDirectDelegate){
        self.delegate = delegate
    }
    
    func getAuction(_ id: Int) {
        // Get auction
        
        Alamofire.request(WEB_API_URL + "api/v1/direct-auction/\(id)", method: .get, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 401 {
                    //self.delegate?.openLoginPage()
                } else {
                    let res = JSON(response.result.value!)
                    let auct = res["auction"]
                    //print(auct)
                    let id = auct["id"].intValue
                    let start_date = auct["start_date"].stringValue
                    let end_date = auct["end_date"].stringValue
                    let end_bidding_rm = auct["end_bidding_rm"].stringValue
                    let investment_range_start = auct["investment_range_start"].doubleValue
                    let investment_range_end = auct["investment_range_end"].doubleValue
                    let auction_name = auct["auction_name"].stringValue
                    let portfolio = auct["portfolio"].stringValue
                    let portfolio_short = auct["portfolio_short"].stringValue
                    let fund_type = auct["fund_type"].stringValue
                    let revision_rate_rm = auct["revision_rate_rm"] != JSON.null ? auct["revision_rate_rm"].stringValue : nil
                    let interest_rate = auct["interest_rate"].doubleValue
                    let notes = auct["notes"].stringValue
                    let pic_custodian = auct["pic_custodian"] != JSON.null ? auct["pic_custodian"].stringValue : nil
                    let custodian_bank = auct["custodian_bank"] != JSON.null ? auct["custodian_bank"].stringValue : nil
                    let period = auct["period"].stringValue
                    let status = auct["status"].stringValue
                    let message = auct["message"] != JSON.null ? auct["message"].stringValue : nil
                    let view = auct["view"].intValue
                    
                    var bilyets = [Bilyet]()
                    for bilyet in auct["bilyet"].arrayValue {
                        bilyets.append(Bilyet(quantity: bilyet["quantity"].doubleValue, issue_date: bilyet["issue_date"].stringValue, maturity_date: bilyet["maturity_date"].stringValue))
                    }
                    
                    
                    let auction = AuctionDetailDirect(id: id, start_date: start_date, end_date: end_date, end_bidding_rm: end_bidding_rm, investment_range_start: investment_range_start, investment_range_end: investment_range_end, auction_name: auction_name, portfolio: portfolio, portfolio_short: portfolio_short, fund_type: fund_type, revision_rate_rm: revision_rate_rm, interest_rate: interest_rate, notes: notes, pic_custodian: pic_custodian, custodian_bank: custodian_bank, period: period, bilyet: bilyets, status: status, message: message, view: view)
                    
                    self.delegate?.setData(auction)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
