//
//  NotificationPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/09.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol NotificationDelegate {
    func setData(_ data: [NotificationModel], _ page: Int)
    func isMarkAsRead(_ isRead: Bool)
    func getDataFail()
}

class NotificationPresenter {
    private var delegate: NotificationDelegate?
    
    init(delegate: NotificationDelegate){
        self.delegate = delegate
    }
    
    func getData(lastId: Int? = nil, lastDate: String? = nil, _ page: Int) {
        var url = "notification?"
        
        if lastId != nil && lastDate != nil {
            let date = lastDate!.replacingOccurrences(of: " ", with: "%20")
            url += "last_id=\(lastId!)&last_date=\(date)&"
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
        url += "lang=\(lang)&"
        
        // print(url)
        Alamofire.request(WEB_API_URL + "api/v1/" + url, method: .get, headers: getHeaders(auth: true)).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                if response.response?.statusCode == 401 {
                    
                } else {
                    var notifications = [NotificationModel]()
                    //print(result)
                    for notify in result.arrayValue {
                        let id = notify["data"]["id"].intValue
                        let type = notify["data"]["type"] != JSON.null ? notify["data"]["type"].stringValue : nil
                        let sub_type = notify["data"]["sub_type"] != JSON.null ? notify["data"]["sub_type"].stringValue : nil
                        let portfolio = notify["data"]["portfolio"] != JSON.null ? notify["data"]["portfolio"].stringValue : nil
                        let issue_date = notify["data"]["issue_date"] != JSON.null ? notify["data"]["issue_date"].stringValue : nil
                        let maturity_date = notify["data"]["maturity_date"] != JSON.null ? notify["data"]["maturity_date"].stringValue : nil
                        let qty = notify["data"]["quantity"] != JSON.null ? notify["data"]["quantity"].doubleValue : nil
                        let coupon_rate = notify["data"]["coupon_rate"] != JSON.null ? notify["data"]["coupon_rate"].doubleValue : nil
                        let period = notify["data"]["period"] != JSON.null ? notify["data"]["period"].stringValue : nil
                        let title_in = notify["data"]["title_in"] != JSON.null ? notify["data"]["title_in"].stringValue : nil
                        let message_in = notify["data"]["message_in"] != JSON.null ? notify["data"]["message_in"].stringValue : nil
                        
                        let notificationData = nData(type: type, sub_type: sub_type, id: id, portfolio: portfolio, issue_date: issue_date, maturity_date: maturity_date, quantity: qty, coupon_rate: coupon_rate, period: period, title_in: title_in, message_in: message_in)
                        let notification = NotificationModel(id: notify["id"].intValue, title: notify["title"].stringValue, message: notify["message"].stringValue, data: notificationData, is_read: notify["is_read"].intValue, created_at: notify["created_at"].stringValue, available_at: notify["available_at"].stringValue)
                        notifications.append(notification)
                    }
                    
                    self.delegate?.setData(notifications, page)
                }
            case .failure(let error):
                print(error)
                self.delegate?.getDataFail()
            }
        }
    }
    
    func markAsRead(_ id: Int) {
        Alamofire.request(WEB_API_URL + "api/v1/notification/\(id)/read", method: .post, headers: getHeaders(auth: true)).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                //print(result)
                //let message = result["message"].stringValue
                if response.response?.statusCode == 200 {
                    self.delegate?.isMarkAsRead(true)
                } else {
                    self.delegate?.isMarkAsRead(false)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func markAllAsRead() {
        Alamofire.request(WEB_API_URL + "api/v1/notification/read", method: .post, headers: getHeaders(auth: true)).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                //print(result)
                //let message = result["message"].stringValue
                if response.response?.statusCode == 200 {
                    self.delegate?.isMarkAsRead(true)
                } else {
                    self.delegate?.isMarkAsRead(false)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
