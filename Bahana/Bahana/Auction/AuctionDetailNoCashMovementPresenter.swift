//
//  AuctionDetailNoCashMovementPresenter.swift
//  Bahana
//
//  Created by RECTmedia MD102 on 02/12/20.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol AuctionDetailNoCashMovementDelegate {
    func setData(_ data: AuctionDetailNoCashMovement)
    func getDataFail(_ message: String?)
    func openLoginPage()
    func setDataBETA()
    func setDate(_ date: Date)
    func isConfirmed(_ isConfirmed: Bool, _ message: String)
    func setDataFail()
}

class AuctionDetailNoCashMovementPresenter{
    private var delegate: AuctionDetailNoCashMovementDelegate!
    init(delegate:AuctionCashMovementViewController){
        self.delegate = delegate
    }
    
    func getAuction(_ id:Int){
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
        Alamofire.request(WEB_API_URL + "api/v1/no-cash-movement/\(id)?lang=\(lang)", method: .get, headers: getHeaders(auth: true)).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 401 {
                    self.delegate?.openLoginPage()
                } else if response.response?.statusCode == 404 {
                    let res = JSON(response.result.value!)
                    self.delegate?.getDataFail(res["message"].stringValue)
                } else {
                    let res = JSON(response.result.value!)
                    let serverDate = convertStringToDatetime(res["date"].stringValue)
                    self.delegate?.setDate(serverDate!)
                    
                    let auct = res["auction"]
                    let id:Int = auct["id"].intValue
                    let start_date:String = auct["start_date"].stringValue
                    let end_date:String = auct["end_date"].stringValue
                    let end_bidding_rm:String = auct["end_bidding_rm"].stringValue
                    let ncm_type:String = auct["ncm_type"].stringValue
                    let investment_range_start:Double = auct["investment_range_start"].doubleValue
                    let interest_rate:Double = auct["interest_rate"].doubleValue
                    let break_maturity_date:String = auct["break_maturity_date"].stringValue
                    let break_target_rate:Double? = auct["break_target_rate"] != JSON.null ? auct["break_target_rate"].doubleValue : nil
                    let notes:String = auct["notes"].stringValue
                    let pic_custodian:String = auct["pic_custodian"] != JSON.null ? auct["pic_custodian"].stringValue : "-"
                    let custodian_bank:String = auct["custodian_bank"] != JSON.null ? auct["custodian_bank"].stringValue : "-"
                    let fund_type:String = auct["fund_type"].stringValue
                    let portfolio:String = auct["portfolio"].stringValue
                    let period:String = auct["period"].stringValue
                    let ncm_change_status:String = auct["ncm_change_status"].stringValue
                    
                   var bilyet:bilyetDetail
                   var previous_transaction:previousTransactionDetail
                    
                    let revision_rate_rm: Double? = auct["revision_rate_rm"] != JSON.null ? auct["revision_rate_rm"].doubleValue : nil
                    let status: String = auct["status"].stringValue
                    let message: String? = auct["message"] != JSON.null ? auct["message"].stringValue : nil
                    let view: Int = auct["view"].intValue
                    
                    let bil_quantity: Double = auct["bilyet"][0]["quantity"].doubleValue
                    let bil_issue_date: String = auct["bilyet"][0]["issue_date"].stringValue
                    let bil_maturity_date: String? = auct["bilyet"][0]["maturity_date"] != JSON.null ? auct["bilyet"][0]["maturity_date"].stringValue : nil
                    
                    bilyet = bilyetDetail(quantity: bil_quantity, issue_date: bil_issue_date, maturity_date: bil_maturity_date)
                    
                    let prev_quantity:Double = auct["previous_transaction"]["quantity"].doubleValue
                    let prev_issue_date: String = auct["previous_transaction"]["issue_date"].stringValue
                    let prev_maturity_date: String? = auct["previous_transaction"]["maturity_date"] != JSON.null ? auct["previous_transaction"]["maturity_date"].stringValue : nil
                    let prev_coupon_rate: Double = auct["previous_transaction"]["coupon_rate"].doubleValue
                    let prev_transfer_ammount: Double = auct["previous_transaction"]["transfer_ammount"].doubleValue
                    let prev_period: String = auct["previous_transaction"]["previous_period"].stringValue
                    let auction_name: String = auct["auction_name"].stringValue
                    
                    previous_transaction = previousTransactionDetail(quantity: prev_quantity, issue_date: prev_issue_date, maturity_date: prev_maturity_date, coupon_rate: prev_coupon_rate, transfer_ammount: prev_transfer_ammount, period: prev_period)
                    
                    let data:AuctionDetailNoCashMovement = AuctionDetailNoCashMovement(id: id, start_date: start_date, end_date: end_date, end_bidding_rm: end_bidding_rm, ncm_type: ncm_type, investment_range_start: investment_range_start, interest_rate: interest_rate, break_maturity_date: break_maturity_date, break_target_rate: break_target_rate, notes: notes, pic_custodian: pic_custodian, custodian_bank: custodian_bank, fund_type: fund_type, portfolio: portfolio, period: period, ncm_change_status: ncm_change_status, bilyet: bilyet, previous_transaction: previous_transaction, revision_rate_rm: revision_rate_rm, status: status, message: message, view: view, auction_name: auction_name)
                    
                    self.delegate?.setData(data)
                    
            }
            case .failure(let error):
                print(error)
                self.delegate?.getDataFail(nil)
            }
        }
    }
    func reviseAuctionNcm(_ id:Int, _ rate:String?, ncmType:String, rateBreak:String? ,date:String?){
            var parameters: Parameters = [
                    "revision_rate": rate != "" ? Double(rate!)! : "",
                    "request_maturity_date": date != nil ? date! : ""
            ]
        if ncmType == "break" {
            parameters = [
                "revision_rate": rate != "" ? Double(rate!)! : "",
                "revision_rate_break": Double(rateBreak!)!,
                "request_maturity_date": date != nil ? date! : ""
            ]
        }
        Alamofire.request(WEB_API_URL + "api/v1/no-cash-movement/\(id)/revision", method: .post, parameters: parameters, headers: getHeaders(auth: true)).responseString { response in
                if response.response?.mimeType == "application/json" {
                    let res = JSON.init(parseJSON: response.result.value!)
                    if response.response?.statusCode == 200 {
                        self.delegate?.isConfirmed(true, res["message"].stringValue)
                    } else {
                        self.delegate?.isConfirmed(false, res["message"].stringValue)
                    }
                } else {
//                    print(response)
                    self.delegate?.setDataFail()
                }
            }
            // print("\(parameters)")
        //
    }
    func confirm(_ id: Int, _ type: String, _ isAccepted: Bool, _ maturityDate: String?) {
        var url = "api/v1/"
        let parameters: Parameters = [
            "is_accepted": isAccepted ? "yes" : "no",
            "request_maturity_date": maturityDate != nil ? maturityDate! : ""
        ]
        switch type {
            case "direct-auction":
                url += "direct-auction/\(id)/confirm"
            case "break":
                url += "break/\(id)/confirm"
            case "rollover":
                url += "rollover/\(id)/confirm"
            case "ncm-auction":
                url += "no-cash-movement/\(id)/confirm"
            default:
                break
        }
        
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
        url += "?lang=\(lang)"
        //print(url)
        Alamofire.request(WEB_API_URL + url, method: .post, parameters: parameters, headers: getHeaders(auth: true)).responseString { response in
            if response.response?.mimeType == "application/json" {
                let result = JSON.init(parseJSON: response.result.value!)
                //print(result)
                if response.response?.statusCode == 200 {
                    self.delegate?.isConfirmed(true, result["message"].stringValue)
                } else {
                    self.delegate?.isConfirmed(false, result["message"].stringValue)
                }
            } else {
                self.delegate?.setDataFail()
            }
        }
    }
}
