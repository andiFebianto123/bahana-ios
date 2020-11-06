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
    func setDataFail()
}

class AuctionDetailConfirmationPresenter {
    
    private var delegate: AuctionDetailConfirmationDelegate?
    
    init(delegate: AuctionDetailConfirmationDelegate){
        self.delegate = delegate
    }
    
    func confirm(_ id: Int, _ type: String, _ isAccepted: Bool, _ maturityDate: String?, _ bidId: Int?) {
        var url = "api/v1/"
        let parameters: Parameters = [
            "is_accepted": isAccepted ? "yes" : "no",
            "request_maturity_date": maturityDate != nil ? maturityDate! : ""
        ]
        switch type {
            case "auction":
                url += "auction/\(id)/confirm/\(bidId!)"
            case "direct-auction":
                url += "direct-auction/\(id)/confirm"
            case "break":
                url += "break/\(id)/confirm"
            case "rollover":
                url += "rollover/\(id)/confirm"
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
                print(response)
                self.delegate?.setDataFail()
            }
        }
    }
    
    
    func reviseAuction(_ id: Int, _ rate: String?) {
        var revisionRate: Double?
        if rate != nil {
            let dbl = Double(rate!)
            let dbl_ = dbl!
            revisionRate = dbl_
        }
        
        let parameters: Parameters = [
            "revision_rate": revisionRate != nil ? revisionRate! : ""
        ]
        
        Alamofire.request(WEB_API_URL + "api/v1/direct-auction/\(id)/revision", method: .post, parameters: parameters, headers: getHeaders(auth: true)).responseString { response in
            if response.response?.mimeType == "application/json" {
                let res = JSON.init(parseJSON: response.result.value!)
                print(res)
                if response.response?.statusCode == 200 {
                    self.delegate?.isConfirmed(true, res["message"].stringValue)
                } else {
                    self.delegate?.isConfirmed(false, res["message"].stringValue)
                }
            } else {
                print(response)
                self.delegate?.setDataFail()
            }
        }
    }
}