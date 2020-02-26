//
//  AuctionListPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/06.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol AuctionListDelegate {
    func openLoginPage()
    func setData(_ data: [Auction])
}

class AuctionListPresenter {
    
    private var delegate: AuctionListDelegate?
    
    init(delegate: AuctionListDelegate){
        self.delegate = delegate
    }
    
    func getAuction(_ status: String, _ type: String, page: Int) {
        // Get auction
        var url = String()
        switch type {
        case "ALL":
            url += "all-auction"
        case "AUCTION":
            url += "auction"
        case "DIRECT AUCTION":
            url += "direct-auction"
        case "BREAK":
            url += "break"
        case "ROLLOVER":
            url += "rollover"
        default:
            url += "all-auction"
        }
        
        // Add status parameter
        if status == "ACC" || status == "REJ" || status == "NEC" {
            url += "?status=\(status)"
        }
        
        // Pagination
        if page > 1 {
            url += ""
        }
        
        Alamofire.request(WEB_API_URL + "api/v1/" + url, method: .get, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 401 {
                    //self.delegate?.openLoginPage()
                } else {
                    let result = JSON(response.result.value!)
                    
                    var auctions = [Auction]()
                    for auct in result["auctions"].arrayValue {
                        let id = auct["id"].intValue
                        let auction_name = auct["auction_name"].stringValue
                        let portfolio = auct["portfolio"].stringValue
                        let portfolio_short = auct["portfolio_short"].stringValue
                        let investment_range_start = auct["investment_range_start"].doubleValue
                        let investment_range_end = auct["investment_range_end"].doubleValue
                        let start_date = auct["start_date"].stringValue
                        let end_date = auct["end_date"].stringValue
                        let break_maturity_date = auct["break_maturity_date"] != JSON.null ? auct["break_maturity_date"].stringValue : nil
                        let pic_custodian = auct["pic_custodian"] != JSON.null ? auct["pic_custodian"].stringValue : nil
                        let custodian_bank = auct["custodian_bank"] != JSON.null ? auct["custodian_bank"].stringValue : nil
                        let type = auct["type"].stringValue
                        let status = auct["status"].stringValue
                        let maturity_date = auct["maturity_date"] != JSON.null ? auct["maturity_date"].stringValue : nil
                        let period = auct["period"].stringValue
                        
                        let auction = Auction(id: id, auction_name: auction_name, portfolio: portfolio, portfolio_short: portfolio_short, pic_custodian: pic_custodian, custodian_bank: custodian_bank, investment_range_start: investment_range_start, investment_range_end: investment_range_end, start_date: start_date, end_date: end_date, break_maturity_date: break_maturity_date, maturity_date: maturity_date, period: period, type: type, status: status)
                        auctions.append(auction)
                    }
                    
                    self.delegate?.setData(auctions)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getAuctionHistory(_ status: String, _ type: String, page: Int) {
        // Get auction history
        var url = String()
        switch type {
        case "ALL":
            url += "all-auction-history"
        case "AUCTION":
            url += "auction-history"
        case "DIRECT AUCTION":
            url += "direct-auction-history"
        case "BREAK":
            url += "break-history"
        case "ROLLOVER":
            url += "rollover-history"
        default:
            break
        }
        
        // Add status parameter
        if status == "ACC" || status == "REJ" || status == "NEC" {
            url += "?status=\(status)"
        }
        
        // Pagination
        if page > 1 {
            url += ""
        }
        
        Alamofire.request(WEB_API_URL + "api/v1/" + url, method: .get, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                //print(result)
            case .failure(let error):
                print(error)
            }
        }
    }
}
