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
                    //print(auct)
                    
                    let id = auct["id"].intValue
                    let auction_name = auct["auction_name"].stringValue
                    let start_date = auct["start_date"].stringValue
                    let end_date = auct["end_date"].stringValue
                    let end_bidding_rm = auct["end_bidding_rm"].stringValue
                    let investment_range_start = auct["investment_range_start"].doubleValue
                    let investment_range_end = auct["investment_range_end"] != JSON.null ? auct["investment_range_end"].doubleValue : nil
                    let notes = auct["notes"].stringValue
                    
                    let pic_custodian = auct["pic_custodian"] != JSON.null ? auct["pic_custodian"].stringValue : nil
                    let custodian_bank = auct["custodian_bank"] != JSON.null ? auct["custodian_bank"].stringValue : nil
                    let fund_type = auct["fund_type"] != JSON.null ? auct["fund_type"].stringValue : nil
                    let portfolio = auct["portfolio"].stringValue
                    let portfolio_short = auct["portfolio_short"].stringValue
                    let view = auct["view"].intValue
                    let status = auct["status"].stringValue
                    let issue_date = auct["issue_date"].stringValue
                    
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
                    
                    let auction = AuctionDetailNormal(id: id, auction_name: auction_name, start_date: start_date, end_date: end_date, end_bidding_rm: end_bidding_rm, investment_range_start: investment_range_start, investment_range_end: investment_range_end, notes: notes, pic_custodian: pic_custodian, custodian_bank: custodian_bank, fund_type: fund_type, portfolio: portfolio, portfolio_short: portfolio_short, bids: bids, view: view, status: status, issue_date: issue_date, details: details, allowed_rate: allowedRates, default_rate: defaultRate)
                    
                    //print(result)
                    self.delegate?.setData(auction)
                }
            case .failure(let error):
                print(error)
            }
        }
        /*
        let fundType = ""
        let bilyet1 = [Bilyet(quantity: 10000000, issue_date: "2019-12-18 00:00:00", maturity_date: "2020-02-18 00:00:00")]
        let bilyet2 = [Bilyet(quantity: 5000000, issue_date: "2019-12-18 00:00:00", maturity_date: "2020-01-07 00:00:00"), Bilyet(quantity: 5000000, issue_date: "2019-12-18 00:00:00", maturity_date: "2020-01-07 00:00:00")]
        let bilyet3 = [Bilyet(quantity: 10000000, issue_date: "2019-12-18 00:00:00", maturity_date: "2020-03-18 00:00:00")]
        let bids = [
            Bid(id: 56, auction_header_id: 42, is_accepted: "yes", is_winner: "yes", interest_rate_idr: 2.79, interest_rate_usd: nil, interest_rate_sharia: nil, used_investment_value: 10000000, bilyet: bilyet1, choosen_rate: "IDR", period: "2 months"),
            Bid(id: 57, auction_header_id: 42, is_accepted: "yes", is_winner: "yes", interest_rate_idr: 1.5, interest_rate_usd: nil, interest_rate_sharia: 1, used_investment_value: 10000000, bilyet: bilyet2, choosen_rate: "Syariah", period: "20 days"),
            Bid(id: 58, auction_header_id: 42, is_accepted: "yes", is_winner: "yes", interest_rate_idr: 2.79, interest_rate_usd: nil, interest_rate_sharia: nil, used_investment_value: 10000000, bilyet: bilyet3, choosen_rate: "IDR", period: "3 months")
        ]
        let details = [Detail(auction_header_id: 42, td_period: 3, td_period_type: "month", default_rate: 0, default_rate_usd: 0, default_rate_sharia: 0)]
        let allowedRates = ["IDR", "Syariah"]
        let defaultRate = DefaultRate(month_rate_1: 5.25, month_rate_3: 2, month_rate_6: 2, month_rate_1_usd: 4, month_rate_3_usd: 2.5, month_rate_6_usd: 2, month_rate_1_sharia: 2, month_rate_3_sharia: 1.1, month_rate_6_sharia: 3)
        let auction = AuctionDetailNormal(id: 42, auction_name: "NP.BDL.181219", start_date: "2019-12-18 15:40:00", end_date: "2019-12-18 18:40:00", end_bidding_rm: "2019-12-18 17:40:00", investment_range_start: 20000000000, investment_range_end: 30000000000, notes: "Mohon crosscheck instruksi dari Ops & Custody. Jatuh tempo di hari Sabtu/Minggu, bunga berjalan dibayarkan on bilyet.", pic_custodian: nil, custodian_bank: nil, fund_type: fundType, portfolio: "BDL (RD BAHANA DANA LIKUID)", portfolio_short: "BDL", bids: bids, view: 1, status: "ACC", issue_date: "2019-12-18 00:00:00", details: details, allowed_rate: allowedRates, default_rate: defaultRate)
        
        self.delegate?.setData(auction)
         */
    }
    
    func saveAuction(_ id: Int, _ bids: [Bid], _ placement: String) {
        var parameters: Parameters!
        
        for (idx, bid) in bids.enumerated() {
            // Untuk jumlah period menggunakan id
            parameters.updateValue(bids[idx].id, forKey: "bid[\(idx)][td_period]")
            parameters.updateValue(bids[idx].period, forKey: "bid[\(idx)][td_period_type]")
            parameters.updateValue(bids[idx].interest_rate_idr!, forKey: "bid[\(idx)][rate_idr]")
            parameters.updateValue(bids[idx].interest_rate_usd!, forKey: "bid[\(idx)][rate_usd]")
            parameters.updateValue(bids[idx].interest_rate_sharia!, forKey: "bid[\(idx)][rate_syariah]")
            parameters.updateValue(placement, forKey: "bid[\(idx)][max_placement]")
        }
        print(parameters)
        print(bids)
        print(placement)
        /*
        Alamofire.request(WEB_API_URL + "api/v1/auction/\(id)/post", method: .post, parameters: parameters, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                let res = JSON(response.result.value!)
                print(res["message"])
                //self.delegate.
            case .failure(let error):
                print(error)
            }
        }*/
    }
}
