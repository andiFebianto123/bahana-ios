//
//  AuctionDetailMaturePresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/26.
//  Copyright © 2020 Rectmedia. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON

protocol AuctionDetailMatureDelegate {
    func setData(_ data: AuctionDetailMature)
    func getDataFail(_ message: String?)
    //func isPosted(_ isSuccess: Bool, _ message: String)
    func setDataMultifund(_ data: AuctionDetailMatureMultifund)
    func openLoginPage()
}

class AuctionDetailMaturePresenter {
    private var delegate: AuctionDetailMatureDelegate?
    
    init(delegate: AuctionDetailMatureDelegate){
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
        Alamofire.request(WEB_API_URL + "api/v1/mature-auction/\(id)?lang=\(lang)", method: .get, headers: getHeaders(auth: true)).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 401 {
                    self.delegate?.openLoginPage()
                } else if response.response?.statusCode == 404 {
                    let res = JSON(response.result.value!)
                    self.delegate?.getDataFail(res["message"].stringValue)
                } else {
                    let res = JSON(response.result.value!)
                    let auct = res
                    //print(res)
                    let id = auct["id"].intValue
                    let auction_name = auct["auction_name"].stringValue
                    let quantity = auct["quantity"].doubleValue
                    let pic_custodian = auct["pic_custodian"] != JSON.null ? auct["pic_custodian"].stringValue : nil
                    let custodian_bank = auct["custodian_bank"] != JSON.null ? auct["custodian_bank"].stringValue : nil
                    let portfolio = auct["portfolio"].stringValue
                    let period = auct["period"].stringValue
                    let issue_date = auct["issue_date"].stringValue
                    let status = auct["status"].stringValue
                    let maturity_date = auct["maturity_date"] != JSON.null ? auct["maturity_date"].stringValue : nil
                    let coupon_rate = auct["coupon_rate"].doubleValue
                    let notes = auct["notes"].stringValue
                    
                    let auction = AuctionDetailMature(id: id, auction_name: auction_name, quantity: quantity, portfolio: portfolio, pic_custodian: pic_custodian, custodian_bank: custodian_bank, status: status, issue_date: issue_date, maturity_date: maturity_date!, coupon_rate: coupon_rate, period: period, notes:notes)
                    
                    self.delegate?.setData(auction)
                }
            case .failure(let error):
                print(error)
                self.delegate?.getDataFail(nil)
            }
        }
    }
    
    func getAuctionMultifund(_ id: Int) {
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
        Alamofire.request(WEB_API_URL + "api/v1/mature-multifund-auction/\(id)?lang=\(lang)", method: .get, headers: getHeaders(auth: true)).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 401 {
                    self.delegate?.openLoginPage()
                } else if response.response?.statusCode == 404 {
                    let res = JSON(response.result.value!)
                    self.delegate?.getDataFail(res["message"].stringValue)
                } else {
                    let res = JSON(response.result.value!)
                    let auct = res
                    //print(res)
                    let id = auct["id"].intValue
                    let auction_name = auct["auction_name"].stringValue
                    // let quantity = auct["quantity"].doubleValue
                    let created_at = auct["created_at"].stringValue
                    let updated_at = auct["updated_at"].stringValue
                    let tenor = auct["tenor"].stringValue
                    
                    // let pic_custodian = auct["pic_custodian"] != JSON.null ? auct["pic_custodian"].stringValue : nil
                    // let custodian_bank = auct["custodian_bank"] != JSON.null ? auct["custodian_bank"].stringValue : nil
                    // let portfolio = auct["portfolio"].stringValue
                    let period = auct["period"].stringValue
                    let coupon_rate = auct["coupon_rate"].doubleValue
                    let fund_type = auct["fund_type"].stringValue
                    
                    // let issue_date = auct["issue_date"].stringValue
                    let status = auct["status"].stringValue
                    // let maturity_date = auct["maturity_date"] != JSON.null ? auct["maturity_date"].stringValue : nil
                    let total_investment = auct["total_investment"].stringValue
                    let notes = auct["notes_auction"].stringValue
                    var details = [AuctionDetailMatureMultifundDetails]()
                    
                    for detail in auct["details"].arrayValue {
                        var transaction_id = [Int]()
                        for id_transaction in detail["transaction_id"].arrayValue {
                            transaction_id.append(id_transaction.intValue)
                        }
                        let detail_ = AuctionDetailMatureMultifundDetails(
                            portfolio: detail["portfolio"].stringValue,
                            description: detail["description"].stringValue,
                            custodian_bank: detail["custodian_bank"].stringValue,
                            bilyet: detail["bilyet"].stringValue,
                            transaction_id: transaction_id
                        )
                        details.append(detail_)
                    }
                    
                    
                    let auction = AuctionDetailMatureMultifund(
                        id: id,
                        auction_name: auction_name,
                        created_at: created_at,
                        updated_at: updated_at,
                        tenor: tenor,
                        period: period,
                        coupon_rate: coupon_rate,
                        fund_type: fund_type,
                        status: status,
                        details: details,
                        total_investment: total_investment,
                        notes_auction: notes
                    )
                    
                    self.delegate?.setDataMultifund(auction)
                }
            case .failure(let error):
                print(error)
                self.delegate?.getDataFail(nil)
            }
        }
    }
}
