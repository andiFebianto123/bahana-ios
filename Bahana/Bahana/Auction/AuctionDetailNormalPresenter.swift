//
//  AuctionDetailNormalPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/25.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol AuctionDetailNormalDelegate {
    func setData(_ data: AuctionDetailNormal)
}

class AuctionDetailNormalPresenter {
    private var delegate: AuctionDetailNormalDelegate?
    
    init(delegate: AuctionDetailNormalDelegate){
        self.delegate = delegate
    }
    
    func getAuction(_ id: Int) {
        // Get auction
        Alamofire.request(WEB_API_URL + "api/v1/auction/\(id)", method: .get, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 401 {
                    //self.delegate?.openLoginPage()
                } else {
                    let res = JSON(response.result.value!)
                    let auct = res["auction"]
                    
                    let id = auct["id"] != JSON.null ? auct["id"].intValue : nil
                    let auction_name = auct["auction_name"] != JSON.null ? auct["auction_name"].stringValue : nil
                    let start_date = auct["start_date"] != JSON.null ? auct["start_date"].stringValue : nil
                    let end_date = auct["end_date"] != JSON.null ? auct["end_date"].stringValue : nil
                    let end_bidding_rm = auct["end_bidding_rm"] != JSON.null ? auct["end_bidding_rm"].stringValue : nil
                    let investment_range_start = auct["investment_range_start"] != JSON.null ? auct["investment_range_start"].doubleValue : nil
                    let investment_range_end = auct["investment_range_end"] != JSON.null ? auct["investment_range_end"].doubleValue : nil
                    let notes = auct["notes"] != JSON.null ? auct["notes"].stringValue : nil
                    //let issue_date = auct["issue_date"] != JSON.null ? auct["issue_date"].stringValue : nil
                    let pic_custodian = auct["pic_custodian"] != JSON.null ? auct["pic_custodian"].stringValue : nil
                    let custodian_bank = auct["custodian_bank"] != JSON.null ? auct["custodian_bank"].stringValue : nil
                    let fund_type = auct["fund_type"] != JSON.null ? auct["fund_type"].stringValue : nil
                    let portfolio = auct["portfolio"] != JSON.null ? auct["portfolio"].stringValue : nil
                    let portfolio_short = auct["portfolio_short"] != JSON.null ? auct["portfolio_short"].stringValue : nil
                    let view = auct["view"] != JSON.null ? auct["view"].intValue : nil
                    let status = auct["status"] != JSON.null ? auct["status"].stringValue : nil
                    let issue_date = auct["issue_date"] != JSON.null ? auct["issue_date"].stringValue : nil
                    //let maturity_date = auct["maturity_date"] != JSON.null ? auct["maturity_date"].stringValue : nil
                    //let break_maturity_date = auct["break_maturity_date"] != JSON.null ? auct["break_maturity_date"].stringValue : nil
                    //let type = auct["type"] != JSON.null ? auct["type"].stringValue : nil
                    //let period = auct["period"] != JSON.null ? auct["period"].stringValue : nil
                    var bids = [Bid]()
                    for bid in auct["bids"].arrayValue {
                        let interest_rate_idr = bid["interest_rate_idr"] != JSON.null ? bid["interest_rate_idr"].doubleValue : nil
                        let interest_rate_usd = bid["interest_rate_usd"] != JSON.null ? bid["interest_rate_usd"].doubleValue : nil
                        let interest_rate_sharia = bid["interest_rate_syariah"] != JSON.null ? bid["interest_rate_syariah"].doubleValue : nil
                        let choosen_rate = bid["choosen_rate"] != JSON.null ? bid["choosen_rate"].stringValue : nil
                        
                        var bilyets = [Bilyet]()
                        for bilyet in bid["bilyet"].arrayValue {
                            bilyets.append(Bilyet(quantity: bilyet["quantity"].doubleValue, issue_date: bilyet["issue_date"].stringValue, maturity_date: bilyet["maturity_date"].stringValue))
                        }
                        
                        bids.append(Bid(id: bid["id"].intValue, auction_header_id: bid["auction_header_id"].intValue, is_accepted: bid["is_accepted"].stringValue, is_winner: bid["is_winner"].stringValue, interest_rate_idr: interest_rate_idr, interest_rate_usd: interest_rate_usd, interest_rate_sharia: interest_rate_sharia, used_investment_value: bid["used_investment_value"].doubleValue, bilyet: bilyets, choosen_rate: choosen_rate, period: bid["period"].stringValue))
                    }
                    
                    var details = [Detail]()
                    for detail in auct["details"].arrayValue {
                        details.append(Detail(auction_header_id: detail["auction_header_id"].intValue, td_period: detail["td_period"].intValue, td_period_type: detail["td_period_type"].stringValue, default_rate: detail["default_rate"].doubleValue, default_rate_usd: detail["default_rate_usd"].doubleValue, default_rate_sharia: detail["default_rate_syariah"].doubleValue))
                    }
                    
                    var allowedRates = [String]()
                    for allowedRate in auct["allowed_rate"].arrayValue {
                        allowedRates.append(allowedRate.stringValue)
                    }
                    
                    let defaultRate = DefaultRate(month_rate_1: auct["default_rate"]["month_rate_1"].doubleValue, month_rate_3: auct["default_rate"]["month_rate_3"].doubleValue, month_rate_6: auct["default_rate"]["month_rate_6"].doubleValue, month_rate_1_usd: auct["default_rate"]["month_rate_1_usd"].doubleValue, month_rate_3_usd: auct["default_rate"]["month_rate_3_usd"].doubleValue, month_rate_6_usd: auct["default_rate"]["month_rate_6_usd"].doubleValue, month_rate_1_sharia: auct["default_rate"]["month_rate_1_syariah"].doubleValue, month_rate_3_sharia: auct["default_rate"]["month_rate_3_syariah"].doubleValue, month_rate_6_sharia: auct["default_rate"]["month_rate_6_syariah"].doubleValue)
                    
                    let auction = AuctionDetailNormal(id: id!, auction_name: auction_name!, start_date: start_date!, end_date: end_date!, end_bidding_rm: end_bidding_rm!, investment_range_start: investment_range_start!, investment_range_end: investment_range_end!, notes: notes!, pic_custodian: pic_custodian, custodian_bank: custodian_bank, fund_type: fund_type!, portfolio: portfolio!, portfolio_short: portfolio_short!, bids: bids, view: view!, status: status!, issue_date: issue_date!, details: details, allowed_rate: allowedRates, default_rate: defaultRate)
                    
                    //print(result)
                    self.delegate?.setData(auction)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func saveAuction(_ id: Int) {
        let parameters: Parameters = [
            "bid[0][td_period]": ""
        ]
        
        Alamofire.request(WEB_API_URL + "api/v1/auction/\(id)/post", method: .post, parameters: parameters, headers: getAuthHeaders()).responseJSON { response in
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
