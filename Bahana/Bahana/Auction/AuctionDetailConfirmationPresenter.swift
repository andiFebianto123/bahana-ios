//
//  AuctionDetailConfirmationPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/10.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol AuctionDetailConfirmationDelegate {
    func isConfirmed(_ isConfirmed: Bool, _ message: String)
}

class AuctionDetailConfirmationPresenter {
    
    private var delegate: AuctionDetailConfirmationDelegate?
    
    init(delegate: AuctionDetailConfirmationDelegate){
        self.delegate = delegate
    }
    
    func confirm(_ id: Int, _ type: String) {
        var url = "api/v1/"
        let paramaters: Parameters = [
            "is_accepted": "", // yes or no
            "request_maturity_date": "" //date
        ]
        switch type {
            case "AUCTION":
                url += "auction/\(id)/confirm/\(getLocalData(key: "user_id"))"
            case "DIRECT AUCTION":
                url += "direct-auction/\(id)/confirm"
            case "BREAK":
                url += "break/\(id)/confirm"
            case "ROLLOVER":
                url += "rollover/\(id)/confirm"
            default:
                break
        }
        
        Alamofire.request(WEB_API_URL + url, method: .get, parameters: paramaters, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                if response.response?.statusCode == 200 {
                    self.delegate?.isConfirmed(true, result["message"].stringValue)
                } else {
                    self.delegate?.isConfirmed(false, result["message"].stringValue)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
