//
//  AuctionDetailPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/24.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol AuctionDetailDelegate {
    func setData(_ data: Auction, _ viewType: Int)
}

class AuctionDetailPresenter {
    
    private var delegate: AuctionDetailDelegate?
    
    init(delegate: AuctionDetailDelegate){
        self.delegate = delegate
    }
    
    func getAuction(_ status: String, _ type: String) {
        // Get auction
        Alamofire.request(WEB_API_URL + "api/v1/all-auction?status=\(status)", method: .get, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 401 {
                    //self.delegate?.openLoginPage()
                } else {
                    let auct = JSON(response.result.value!)
                    /*
                    let id = auct["id"] != JSON.null ? auct["id"].intValue : nil
                    let auction_name = auct["auction_name"] != JSON.null ? auct["auction_name"].stringValue : nil
                    let start_date = auct["start_date"] != JSON.null ? auct["start_date"].stringValue : nil
                    let end_date = auct["end_date"] != JSON.null ? auct["end_date"].stringValue : nil
                    let end_bidding_rm = auct["end_bidding_rm"] != JSON.null ? auct["end_bidding_rm"].stringValue : nil
                    let investment_range_start = auct["investment_range_start"] != JSON.null ? auct["investment_range_start"].doubleValue : nil
                    let investment_range_end = auct["investment_range_end"] != JSON.null ? auct["investment_range_end"].doubleValue : nil
                    let notes = auct["notes"] != JSON.null ? auct["notes"].stringValue : nil
                    let issue_date = auct["issue_date"] != JSON.null ? auct["issue_date"].stringValue : nil
                    let pic_custodian = auct["pic_custodian"] != JSON.null ? auct["pic_custodian"].stringValue : nil
                    let custodian_bank = auct["custodian_bank"] != JSON.null ? auct["custodian_bank"].stringValue : nil
                    let portfolio_short = auct["portfolio_short"] != JSON.null ? auct["portfolio_short"].stringValue : nil
                    let portfolio = auct["portfolio"] != JSON.null ? auct["portfolio"].stringValue : nil
                    let maturity_date = auct["maturity_date"] != JSON.null ? auct["maturity_date"].stringValue : nil
                    let break_maturity_date = auct["break_maturity_date"] != JSON.null ? auct["break_maturity_date"].stringValue : nil
                    let type = auct["type"] != JSON.null ? auct["type"].stringValue : nil
                    let status = auct["status"] != JSON.null ? auct["status"].stringValue : nil
                    let period = auct["period"] != JSON.null ? auct["period"].stringValue : nil
                    
                    let auction = Auction.init(id: id, auction_name: auction_name, start_date: start_date, end_date: end_date, end_bidding_rm: end_bidding_rm, investment_range_start: investment_range_start, investment_range_end: investment_range_end, notes: notes, issue_date: issue_date, pic_custodian: pic_custodian, custodian_bank: custodian_bank, portfolio_short: portfolio_short, portfolio: portfolio, maturity_date: maturity_date, break_maturity_date: break_maturity_date, type: type, status: status, period: period)
                    
                    //print(result)
                    self.delegate?.setData(auction, auct["view"].intValue)*/
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
