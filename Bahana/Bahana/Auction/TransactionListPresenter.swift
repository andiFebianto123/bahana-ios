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
    func setData(_ data: [Transaction])
}

class TransactionListPresenter {
    
    private var delegate: TransactionListDelegate?
    
    init(delegate: TransactionListDelegate){
        self.delegate = delegate
    }
    
    func getTransaction(_ status: String, _ type: String) {
        // Get transaction
        var url = "transaction"
        // Add status parameter
        if status == "ACC" || status == "REJ" || status == "NEC" {
            url += "?status=\(status)"
        }
        Alamofire.request(WEB_API_URL + "api/v1/" + url, method: .get, headers: getAuthHeaders()).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                if response.response?.statusCode == 401 {
                    //self.delegate?.openLoginPage()
                } else {
                    let result = JSON(response.result.value!)
                    var transactions = [Transaction]()
                    for trans in result.arrayValue {
                        let id = trans["id"].intValue
                        let qty = trans["quantity"].doubleValue
                        let issue_date = trans["issue_date"].stringValue
                        let maturity_date = trans["maturity_date"].stringValue
                        let status = trans["status"].stringValue
                        let portfolio = trans["portfolio"].stringValue
                        let break_maturity_date = trans["break_maturity_date"] != JSON.null ? trans["break_maturity_date"].stringValue : nil
                        let coupon_rate = trans["coupon_rate"] != JSON.null ? trans["coupon_rate"].stringValue : nil
                        let break_coupon_rate = trans["break_coupon_rate"] != JSON.null ? trans["break_coupon_rate"].stringValue : nil
                        let period = trans["period"].stringValue
                        
                        let transaction = Transaction(id: id, quantity: qty, issue_date: issue_date, maturity_date: maturity_date, status: status, portfolio: portfolio, break_maturity_date: break_maturity_date, coupon_rate: coupon_rate, break_coupon_rate: break_coupon_rate, period: period)
                        
                        transactions.append(transaction)
                    }
                    self.delegate?.setData(transactions)
                    //print(result)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
