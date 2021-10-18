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
    func getDataFail(_ message: String?)
    func setDate(_ date: Date)
    func isPosted(_ isSuccess: Bool, _ message: String)
    func openLoginPage()
}

class AuctionDetailNormalPresenter {
    private var delegate: AuctionDetailNormalDelegate?
    
    init(delegate: AuctionDetailNormalDelegate){
        self.delegate = delegate
    }
    
    func getAuction(_ id: Int, _ multifoundauction: Bool) {
        // Lang
        var lang = String()
        switch getLocalData(key: "language") {
        case "language_id":
            lang = "in"
        case "language_en":
            lang = "en"
        default:
            break
        }
        
        var api = WEB_API_URL + "api/v1/auction/\(id)?lang=\(lang)"
        if(multifoundauction == true){
            // jika berjenis multifound
            api = WEB_API_URL + "api/v1/multi-fund-auction/\(id)?lang=\(lang)"
        }
        // Get auction
        Alamofire.request(api, method: .get, headers: getHeaders(auth: true)).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 401 {
                    self.delegate?.openLoginPage()
                } else if response.response?.statusCode == 404 {
                    let res = JSON(response.result.value!)
                    self.delegate?.getDataFail(res["message"].stringValue)
                } else {
                    let res = JSON(response.result.value!)
                    //print(res)
                    
                    let serverDate = convertStringToDatetime(res["date"].stringValue)
                    self.delegate?.setDate(serverDate!)
                    
                    let auct = res["auction"]
                    
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
                    //let view = 2
                    let status = auct["status"].stringValue
                    let issue_date = auct["issue_date"].stringValue
                    
                    var bids = [Bid]()
                    for bid in auct["bids"].arrayValue {
                        let interest_rate_idr = bid["interest_rate_idr"] != JSON.null ? bid["interest_rate_idr"].doubleValue : nil
                        let interest_rate_usd = bid["interest_rate_usd"] != JSON.null ? bid["interest_rate_usd"].doubleValue : nil
                        let interest_rate_sharia = bid["interest_rate_syariah"] != JSON.null ? bid["interest_rate_syariah"].doubleValue : nil
                        let chosen_rate = bid["choosen_rate"] != JSON.null ? bid["choosen_rate"].stringValue : nil
                        let investment_value = bid["investment_value"] != JSON.null ? bid["investment_value"].doubleValue : nil
                        
                        var bilyets = [Bilyet]()
                        for bilyet in bid["bilyet"].arrayValue {
                            bilyets.append(Bilyet(quantity: bilyet["quantity"].doubleValue, issue_date: bilyet["issue_date"].stringValue, maturity_date: bilyet["maturity_date"].stringValue))
                        }
                        
                        var is_requested:Int? = nil
                        if multifoundauction {
                            is_requested = bid["is_requested"].intValue
                        }
                        
                        bids.append(Bid(id: bid["id"].intValue, auction_header_id: bid["auction_header_id"].intValue, is_accepted: bid["is_accepted"].stringValue, is_winner: bid["is_winner"].stringValue, interest_rate_idr: interest_rate_idr, interest_rate_usd: interest_rate_usd, interest_rate_sharia: interest_rate_sharia, used_investment_value: bid["used_investment_value"].doubleValue, bilyet: bilyets, chosen_rate: chosen_rate, period: bid["period"].stringValue, is_requested: is_requested, investment_value: investment_value))
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
                    
                    self.delegate?.setData(auction)
                }
            case .failure(let error):
                print(error)
                self.delegate?.getDataFail(nil)
            }
        }
    }
    
    func saveAuction(_ id: Int, _ bids: [Bid], _ placement: String, isMultifound: Bool) {
        var parameters = Parameters()
        
        for (idx, _) in bids.enumerated() {
            // Untuk jumlah period menggunakan id
            _ =
            parameters.updateValue(bids[idx].id, forKey: "bid[\(idx)][td_period]")
            parameters.updateValue(bids[idx].period, forKey: "bid[\(idx)][td_period_type]")
            parameters.updateValue(bids[idx].interest_rate_idr != nil ? bids[idx].interest_rate_idr! : "", forKey: "bid[\(idx)][rate_idr]")
            parameters.updateValue(bids[idx].interest_rate_usd != nil ? bids[idx].interest_rate_usd! : "", forKey: "bid[\(idx)][rate_usd]")
            parameters.updateValue(bids[idx].interest_rate_sharia != nil ? bids[idx].interest_rate_sharia! : "", forKey: "bid[\(idx)][rate_syariah]")
            parameters.updateValue(placement, forKey: "bid[\(idx)][max_placement]")
        }
        var api = WEB_API_URL + "api/v1/auction/\(id)/post"
        if(isMultifound == true){
            api = WEB_API_URL + "api/v1/multi-fund-placement/\(id)/post"
        }
        
        //print(parameters)
        
        Alamofire.request(api, method: .post, parameters: parameters, headers: getHeaders(auth: true)).responseString { response in
            if response.response?.mimeType == "application/json" {
                let res = JSON.init(parseJSON: response.result.value!)
                if response.response?.statusCode == 200 {
                    self.delegate?.isPosted(true, res["message"].stringValue)
                } else {
                    self.delegate?.isPosted(false, res["message"].stringValue)
                }
            } else {
                print(response)
                self.delegate?.getDataFail(nil)
            }
        }
    }
    func saveAuctionChangeMaturityDateMultifund(id:Int, bid_id:Int, date:String?){
        var parameters = Parameters()
        parameters.updateValue(date ?? "", forKey: "request_maturity_date")
        let url = WEB_API_URL + "/api/v1/multi-fund-auction/\(id)/post-request-maturity-date/\(bid_id)"
        Alamofire.request(url, method: .post, parameters: parameters, headers: getHeaders(auth: true)).responseString { response in
            if response.response?.mimeType == "application/json" {
                let res = JSON.init(parseJSON: response.result.value!)
                if response.response?.statusCode == 200 {
                    self.delegate?.isPosted(true, res["message"].stringValue)
                } else {
                    self.delegate?.isPosted(false, res["message"].stringValue)
                }
            } else {
                print(response)
                self.delegate?.getDataFail(nil)
            }
        }
    }
}
