//
//  TransactionDetailPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/10.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol TransactionDetailDelegate {
    func setData(_ data: Transaction)
    func openLoginPage()
}

class TransactionDetailPresenter {
    
    private var delegate: TransactionDetailDelegate?
    
    init(delegate: TransactionDetailDelegate){
        self.delegate = delegate
    }
    
    func getTransaction(_ id: Int) {
        // Get auction
        Alamofire.request(WEB_API_URL + "api/v1/transaction/\(id)", method: .get, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 401 {
                    self.delegate?.openLoginPage()
                } else {
                    let trans = JSON(response.result.value!)
                    
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
                    
                    self.delegate?.setData(transaction)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
