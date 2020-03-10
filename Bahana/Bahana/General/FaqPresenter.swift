//
//  FaqPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/10.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol FaqDelegate {
    func setData(_ data: [String])
}

class FaqPresenter {
    private var delegate: FaqDelegate?
    
    init(delegate: FaqDelegate){
        self.delegate = delegate
    }
    
    func getData() {
        Alamofire.request(WEB_API_URL + "api/v1/question", method: .get, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                if response.response?.statusCode == 401 {
                    //
                } else {
                    print(result)
                    //var faqs = [NotificationModel]()
                    for faq in result.arrayValue {
                        let id = faq["id"].intValue
                        let question = faq["question"] != JSON.null ? faq["question"].stringValue : nil
                        let answer = faq["answer"] != JSON.null ? faq["answer"].stringValue : nil
                        
                        /*
                        let notificationData = nData(type: type, sub_type: sub_type, id: id, portfolio: portfolio, issue_date: issue_date, maturity_date: maturity_date, quantity: qty, coupon_rate: coupon_rate, period: period, title_in: title_in, message_in: message_in)
                        let notification = NotificationModel(id: notify["id"].stringValue, title: notify["title"].stringValue, message: notify["message"].stringValue, data: notificationData, is_read: notify["is_read"].intValue, created_at: notify["created_at"].stringValue, available_at: notify["available_at"].stringValue)
                        notifications.append(notification)*/
                    }
                    let faqs = [
                        "abc", "def"
                    ]
                    self.delegate?.setData(faqs)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
