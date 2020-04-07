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
}

class TransactionListPresenter {
    
    private var delegate: TransactionListDelegate?
    
    init(delegate: TransactionListDelegate){
        self.delegate = delegate
    }
    
    func getTransaction(_ filter: [String: String], lastId: Int? = nil, _ page: Int) {
        // Get transaction
        var url = "transaction?"
        
        // Fund parameter
        if filter["portfolio"] != nil {
            url += "portfolio=\(filter["portfolio"]!.replacingOccurrences(of: " ", with: "%20"))&"
        }
        
        // Status parameter
        //if status == "ACC" || status == "REJ" || status == "NEC" {
        url += "status=\(filter["status"]!.replacingOccurrences(of: " ", with: "%20"))&"
        //}
        
        // Issue date parameter
        if filter["issue_date"] != nil {
            url += "issue_date=\(filter["issue_date"]!.replacingOccurrences(of: " ", with: "%20"))&"
        }
        
        // Maturity date parameter
        if filter["maturity_date"] != nil {
            url += "maturity_date=\(filter["maturity_date"]!.replacingOccurrences(of: " ", with: "%20"))&"
        }
        
        // Issue date parameter
        if filter["break_date"] != nil {
            url += "break_date=\(filter["break_date"]!.replacingOccurrences(of: " ", with: "%20"))&"
        }
        
        // Outstanding parameter
        if filter["outstanding"] != nil {
            url += "outstanding=\(filter["outstanding"]!)"
        }
        
        // Pagination
        if lastId != nil {
            let pageUrl = "last_id=\(lastId!)&"
            url += pageUrl
        }
        
        Alamofire.request(WEB_API_URL + "api/v1/" + url, method: .get, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 401 {
                    //self.delegate?.openLoginPage()
                } else {
                    let result = JSON(response.result.value!)
                    //print(result)
                    var transactions = [Transaction]()
                    for trans in result.arrayValue {
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
                    self.delegate?.setData(transactions, page)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
