//
//  AuctionDetailRolloverPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/25.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol AuctionDetailRolloverDelegate {
    func setData(_ data: AuctionDetailRollover)
    func getDataFail(_ message: String?)
    func setDate(_ date: Date)
    func isPosted(_ isSuccess: Bool, _ message: String)
    func openLoginPage()
    func hideLoading()
    func setDataWithMultifund(_ data: AuctionDetailRolloverMultifund)
}

class AuctionDetailRolloverPresenter {
    private var delegate: AuctionDetailRolloverDelegate?
    init(delegate: AuctionDetailRolloverDelegate){
        self.delegate = delegate
    }
    
    func getAuction(_ id: Int) {
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
        
        // Get auction
        print("URL : \(WEB_API_URL)api/v1/rollover/\(id)?lang=\(lang)")
        Alamofire.request(WEB_API_URL + "api/v1/rollover/\(id)?lang=\(lang)", method: .get, headers: getHeaders(auth: true)).responseJSON { response in
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
                    let start_date = auct["start_date"].stringValue
                    let end_date = auct["end_date"].stringValue
                    //let end_bidding_rm = auct["end_bidding_rm"].stringValue
                    let pic_custodian = auct["pic_custodian"] != JSON.null ? auct["pic_custodian"].stringValue : nil
                    let custodian_bank = auct["custodian_bank"] != JSON.null ? auct["custodian_bank"].stringValue : nil
                    let portfolio = auct["portfolio"].stringValue
                    let portfolio_short = auct["portfolio_short"].stringValue
                    //let fund_type = auct["fund_type"].stringValue
                    let investment_range_start = auct["investment_range_start"].doubleValue
                    //let investment_range_end = auct["investment_range_end"].doubleValue
                    let period = auct["period"].stringValue
                    let auction_name = auct["auction_name"].stringValue
                    let previous_interest_rate = auct["previous_interest_rate"].doubleValue
                    //let revision_rate_admin = auct["revision_rate_admin"].stringValue
                    let last_bid_rate = auct["last_bid_rate"] != JSON.null ? auct["last_bid_rate"].doubleValue : nil
                    let status = auct["status"].stringValue
                    let view = auct["view"].intValue
                    let message = auct["message"].stringValue
                    let previous_maturity_date = auct["previous_maturity_date"].stringValue
                    let previous_issue_date = auct["previous_issue_date"].stringValue
                    let issue_date = auct["issue_date"].stringValue
                    let maturity_date = auct["maturity_date"] != JSON.null ? auct["maturity_date"].stringValue : nil
                    let breakable_policy = auct["breakable_policy"] != JSON.null ? auct["breakable_policy"].stringValue : nil
                    let is_break = auct["is_break"].boolValue
                    let notes = auct["notes"].stringValue
                    let fund_type = auct["fund_type"].stringValue
                    
                    let auction = AuctionDetailRollover(id: id, start_date: start_date, end_date: end_date, pic_custodian: pic_custodian, custodian_bank: custodian_bank, portfolio: portfolio, portfolio_short: portfolio_short, investment_range_start: investment_range_start, period: period, auction_name: auction_name, previous_interest_rate: previous_interest_rate, last_bid_rate: last_bid_rate, status: status, view: view, message: message, previous_maturity_date: previous_maturity_date, previous_issue_date: previous_issue_date, issue_date: issue_date, maturity_date: maturity_date, breakable_policy: breakable_policy, is_break: is_break, notes:notes, fund_type: fund_type)
                    
                    self.delegate?.setData(auction)
                }
            case .failure(let error):
                print(error)
                self.delegate?.getDataFail(nil)
            }
        }
    }
    
    func getAuctionWithMultifund(_ id: Int){
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
        
        // Get auction
        Alamofire.request(WEB_API_URL + "api/v1/multi-fund-rollover/\(id)?lang=\(lang)", method: .get, headers: getHeaders(auth: true)).responseJSON { response in
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
                    let fund_type = auct["fund_type"].stringValue
                    let interest = auct["interest"] != JSON.null ? auct["interest"].stringValue : nil
                    let investment_range_approved = auct["investment_range_approved"].doubleValue
                    let investment_range_declined = auct["investment_range_declined"].doubleValue
                    let investment_range_start = auct["investment_range_start"].doubleValue
                    let previous_interest_rate = auct["previous_interest_rate"].doubleValue
                    let status = auct["status"].stringValue
                    let view = auct["view"].intValue
                    let message = auct["message"].stringValue
                    let previous_maturity_date = auct["previous_maturity_date"].stringValue
                    let previous_issue_date = auct["previous_issue_date"].stringValue
                    let period = auct["period"].stringValue
                    let breakable_policy = auct["breakable_policy"] != JSON.null ? auct["breakable_policy"].stringValue : nil
                    let last_bid_rate = auct["last_bid_rate"] != JSON.null ? auct["last_bid_rate"].doubleValue : nil
                    let issue_date = auct["issue_date"].stringValue
                    let maturity_date = auct["maturity_date"] != JSON.null ? auct["maturity_date"].stringValue : nil
                    let notes = auct["notes"].stringValue
                    // [REVISI WARNING]
                    // let date = auct["date"].stringValue
                    _ = auct["date"].stringValue
                    let is_pending_exists = auct["is_pending_exists"].boolValue
                    //let end_bidding_rm = auct["end_bidding_rm"].stringValue
                    // let pic_custodian = auct["pic_custodian"] != JSON.null ? auct["pic_custodian"].stringValue : nil
                    // let custodian_bank = auct["custodian_bank"] != JSON.null ? auct["custodian_bank"].stringValue : nil
                    // let portfolio = auct["portfolio"].stringValue
                    // let portfolio_short = auct["portfolio_short"].stringValue
                    //let fund_type = auct["fund_type"].stringValue
                    //let investment_range_end = auct["investment_range_end"].doubleValue
                    //let revision_rate_admin = auct["revision_rate_admin"].stringValue
                    
                    // let is_break = auct["is_break"].boolValue
                    
                    var details = [DetailsRolloverMultifund]()
                    for detail in auct["details"].arrayValue {
                        let portfolio = detail["portfolio"].stringValue
                        let portfolio_id = detail["portfolio_id"].intValue
                        let description = detail["description"].stringValue
                        let custodian_bank = detail["custodian_bank"].stringValue
                        let status = detail["status"].stringValue
                        let bilyet = detail["bilyet"].stringValue
                        var bidder_security_history_id = [Int]()
                        var new_nominal = [Int]()
                        
                        for bidder_security_history in detail["bidder_security_history_id"].arrayValue {
                            bidder_security_history_id.append(bidder_security_history.intValue)
                        }
                        
                        if detail["new_nominal"] != JSON.null {
                            for new_nominal_ in detail["new_nominal"].arrayValue {
                                // [REVISI WARNING]
//                                if (new_nominal_.intValue != nil) {
                                if (new_nominal_ != JSON.null) {
                                    // jika bukan null
                                    new_nominal.append(new_nominal_.intValue)
                                }else{
                                    new_nominal.append(0)
                                }
                            }
                        }
                        
                        let multifundDetail = DetailsRolloverMultifund(portfolio: portfolio, portfolio_id: portfolio_id, description: description, custodian_bank: custodian_bank, status: status, bidder_security_history_id: bidder_security_history_id, bilyet: bilyet, new_nominal: new_nominal)
                        details.append(multifundDetail)
                    }
                    
                    
                    let auction = AuctionDetailRolloverMultifund(
                        id:id,
                        auction_name: auction_name,
                        start_date: start_date,
                        end_date: end_date,
                        fund_type: fund_type,
                        interest: interest,
                        investment_range_approved: investment_range_approved,
                        investment_range_declined: investment_range_declined,
                        investment_range_start: investment_range_start,
                        previous_interest_rate: previous_interest_rate,
                        status: status,
                        view: view,
                        message: message,
                        previous_maturity_date: previous_maturity_date,
                        previous_issue_date: previous_issue_date,
                        period: period,
                        breakable_policy:breakable_policy,
                        last_bid_rate:last_bid_rate,
                        issue_date: issue_date,
                        maturity_date: maturity_date,
                        notes: notes,
                        details: details,
                        is_pending_exists: is_pending_exists)
                    
                    self.delegate?.setDataWithMultifund(auction)
                }
            case .failure(let error):
                print(error)
                self.delegate?.getDataFail(nil)
            }
        }
    }
    
    func saveAuction(_ id: Int, _ rate: Double) {
        let parameters: Parameters = [
            "rate": rate
        ]
        
        Alamofire.request(WEB_API_URL + "api/v1/rollover/\(id)/post", method: .post, parameters: parameters, headers: getHeaders(auth: true)).responseString { response in
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
        } // end Alamofire
    }
    
    func saveAuctionWithdate(_ id:Int, rate:Double, tgl:String){
        // ini adalah fungsi save auction baru jika terdapat parameter mature date
        let parameters: Parameters = [
            "rate": rate,
            "request_maturity_date":tgl
        ]
        
        Alamofire.request(WEB_API_URL + "api/v1/rollover/\(id)/post", method: .post, parameters: parameters, headers: getHeaders(auth: true)).responseString { response in
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
        } // end Alamofire
    }
    func saveAuctionForUSD(_ id:Int, rate:Double ,tgl:String?, new_nominal:Double){
        var parameters:Parameters
        if tgl != nil {
            parameters = [
                "rate":rate,
                "request_maturity_date":tgl!,
                "new_nominal":new_nominal
            ]
        }else{
            parameters = [
                "rate":rate,
                "new_nominal":new_nominal
            ]
        }
        Alamofire.request(WEB_API_URL + "api/v1/rollover/\(id)/post", method: .post, parameters: parameters, headers: getHeaders(auth: true)).responseString { response in
            if response.response?.mimeType == "application/json" {
                let res = JSON.init(parseJSON: response.result.value!)
                if response.response?.statusCode == 200 {
                    if res["status"] != JSON.null {
                        
                        self.delegate?.isPosted(false, res["message"].stringValue)
                        self.delegate?.hideLoading()
                    }else{
                        self.delegate?.isPosted(true, res["message"].stringValue)
                    }
        
                } else {
                    self.delegate?.isPosted(false, res["message"].stringValue)
                    self.delegate?.hideLoading()
                }
            } else {
                print(response)
                self.delegate?.getDataFail(nil)
            }
        } // end Alamofire
    }
    
    func saveAuctionforMultifund(id: Int, rate: Double, tgl:String?, detailsWinner:[AuctionStackPlacement], approved:String, fund_type:Int){
        var lang = String()
        switch getLocalData(key: "language") {
        case "language_id":
            lang = "in"
        case "language_en":
            lang = "en"
        default:
            break
        }
        var parameters = Parameters()
        parameters.updateValue(rate, forKey: "rate")
        parameters.updateValue("", forKey: "request_maturity_date")
        // [REVISI WARNING]
//        if tgl! != nil || tgl! != "" {
//            parameters.updateValue(tgl!, forKey: "request_maturity_date")
//        }
        if tgl != nil && tgl! != "" {
            parameters.updateValue(tgl!, forKey: "request_maturity_date")
        }
        for (idx, detailWinner) in detailsWinner.enumerated() {
            parameters.updateValue(detailWinner.portfolioLabel.text!, forKey: "portfolio[\(idx)][portfolio]")
            for (i, bidder_security) in detailWinner.bidder_security_history.enumerated() {
                parameters.updateValue(bidder_security, forKey: "portfolio[\(idx)][bidder_security_history_id][\(i)]")
                parameters.updateValue("", forKey: "portfolio[\(idx)][new_nominal][\(i)]")
            }
            if fund_type == 1 {
                // tipe USD
                for (u, nominalView) in detailWinner.stackPrincipal.arrangedSubviews.enumerated() {
                    let nominalView_ = nominalView as! AuctionPrincipalBilyetUsd
                    parameters.updateValue(nominalView_.fieldBilyet.text!, forKey: "portfolio[\(idx)][new_nominal][\(u)]")
                }
            }
        }
        parameters.updateValue(approved, forKey: "is_approved")
//        print(parameters)
                
        Alamofire.request(WEB_API_URL + "api/v1/multi-fund-rollover/\(id)/post?lang=\(lang)", method: .post, parameters: parameters, headers: getHeaders(auth: true)).responseString { response in
            if response.response?.mimeType == "application/json" {
                let res = JSON.init(parseJSON: response.result.value!)
                if response.response?.statusCode == 200 {
                    if res["status"] != JSON.null {

                        self.delegate?.isPosted(false, res["message"].stringValue)
                        self.delegate?.hideLoading()
                    }else{
                        self.delegate?.isPosted(true, res["message"].stringValue)
                    }

                } else {
                    self.delegate?.isPosted(false, res["message"].stringValue)
                    self.delegate?.hideLoading()
                }
            } else {
                print(response)
                self.delegate?.getDataFail(nil)
            }
        } // end Alamofire
    }
    
}
