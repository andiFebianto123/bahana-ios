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
                print(result)
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
    
    
    func reviseAuction(_ id: Int, _ rate: String?, _ maturityDate: String?) {
        // [REVISI]
//        var revisionRate: Double?
//        if rate != nil {
//            let dbl = Double(rate!)
//            let dbl_ = dbl!
//            revisionRate = dbl_
//        }
        // [REVISI]
//        let parameters: Parameters = [
//            "revision_rate": revisionRate != nil ? revisionRate! : ""
//        ]
        
        let parameters: Parameters = [
            "revision_rate": rate != nil ? rate! : "",
            "request_maturity_date": maturityDate != nil ? maturityDate! : ""
        ]
        
        Alamofire.request(WEB_API_URL + "api/v1/direct-auction/\(id)/revision", method: .post, parameters: parameters, headers: getHeaders(auth: true)).responseString { response in
            if response.response?.mimeType == "application/json" {
                let res = JSON.init(parseJSON: response.result.value!)
                print(res)
                if response.response?.statusCode == 200 {
                    self.delegate?.isConfirmed(true, res["message"].stringValue)
                } else {
                    let errorMessage = res["errors"]["revision_rate"][0] != JSON.null ? res["errors"]["revision_rate"][0].stringValue : res["message"].stringValue
                    self.delegate?.isConfirmed(false, errorMessage)
                }
            } else {
                print(response)
                self.delegate?.setDataFail()
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
            print("\(parameters)")
        //
    }
}
