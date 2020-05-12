//
//  TransactionListPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/12.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol TransactionListDelegate {
    func openLoginPage()
    func setData(_ data: [Transaction], _ page: Int)
    func setFunds(_ data: [String])
    func getDataFail()
}

class TransactionListPresenter {
    
    private var delegate: TransactionListDelegate?
    
    init(delegate: TransactionListDelegate){
        self.delegate = delegate
    }
    
    func getTransaction(_ filter: [String: String], lastId: Int? = nil, _ page: Int) {
        // Get transaction
        var url = "transaction-new?"
        
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
        url += "lang=\(lang)&"
        
        // Fund parameter
        if filter["portfolio"] != nil && filter["portfolio"] != "" && filter["portfolio"] != localize("all") {
            url += "portfolio=\(filter["portfolio"]!.replacingOccurrences(of: " ", with: "%20"))&"
        }
        
        // Status parameter
        if filter["status"] != nil && filter["status"] != "" {
            let status = filter["status"]!
            url += "status=\(status.replacingOccurrences(of: " ", with: "%20"))&"
        }
        
        // Issue date parameter
        if filter["issue_date"] != nil && filter["issue_date"] != "" {
            let issueDate = filter["issue_date"]!
            url += "issue_date=\(issueDate.replacingOccurrences(of: " ", with: "%20"))&"
        }
        
        // Maturity date parameter
        if filter["maturity_date"] != nil && filter["maturity_date"] != "" {
            let maturityDate = filter["maturity_date"]!
            url += "maturity_date=\(maturityDate.replacingOccurrences(of: " ", with: "%20"))&"
        }
        
        // Issue date parameter
        if filter["break_date"] != nil && filter["break_date"] != "" {
            let breakDate = filter["break_date"]!
            url += "break_date=\(breakDate.replacingOccurrences(of: " ", with: "%20"))&"
        }
        
        // Outstanding parameter
        if filter["outstanding"] != nil {
            url += "outstanding=\(filter["outstanding"]!)&"
        }
        
        // Pagination
        if lastId != nil {
            let pageUrl = "last_id=\(lastId!)&"
            url += pageUrl
        }
        //print(url)
        Alamofire.request(WEB_API_URL + "api/v1/" + url, method: .get, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 401 {
                    self.delegate?.openLoginPage()
                } else {
                    let result = JSON(response.result.value!)
                    //print(result)
                    var transactions = [Transaction]()
                    for trans in result["transactions"].arrayValue {
                        let id = trans["id"].intValue
                        let qty = trans["quantity"].doubleValue
                        let issue_date = trans["issue_date"].stringValue
                        let maturity_date = trans["maturity_date"].stringValue
                        let status = trans["status"].stringValue
                        let portfolio = trans["portfolio"].stringValue
                        let custodian_bank = trans["custodian_bank"] != JSON.null ? trans["custodian_bank"].stringValue : nil
                        let pic_custodian = trans["pic_custodian"] != JSON.null ? trans["pic_custodian"].stringValue : nil
                        let break_maturity_date = trans["break_maturity_date"] != JSON.null ? trans["break_maturity_date"].stringValue : nil
                        let coupon_rate = trans["coupon_rate"] != JSON.null ? trans["coupon_rate"].stringValue : nil
                        let break_coupon_rate = trans["break_coupon_rate"] != JSON.null ? trans["break_coupon_rate"].stringValue : nil
                        let period = trans["period"].stringValue
                        
                        let transaction = Transaction(id: id, quantity: qty, issue_date: issue_date, maturity_date: maturity_date, status: status, portfolio: portfolio, pic_custodian: pic_custodian, custodian_bank: custodian_bank, break_maturity_date: break_maturity_date, coupon_rate: coupon_rate, break_coupon_rate: break_coupon_rate, period: period)
                        
                        transactions.append(transaction)
                    }
                    
                    var funds = [String]()
                    funds.append(localize("all"))
                    for fund in result["portfolios"].arrayValue {
                        funds.append(fund.stringValue)
                    }
                    
                    self.delegate?.setFunds(funds)
                    
                    self.delegate?.setData(transactions, page)
                }
            case .failure(let error):
                print(error)
                self.delegate?.getDataFail()
            }
        }
    }
}
