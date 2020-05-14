//
//  AuctionListPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/06.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol AuctionListDelegate {
    func openLoginPage()
    func setData(_ data: [Auction], _ page: Int)
    func getDataFail()
    func setDate(_ date: Date)
}

class AuctionListPresenter {
    
    private var delegate: AuctionListDelegate?
    
    init(delegate: AuctionListDelegate){
        self.delegate = delegate
    }
    
    func getAuction(_ filter: [String: String], lastId: Int? = nil, lastDate: String? = nil, _ page: Int) {
        // Get auction
        var url = String()
        switch filter["type"] {
        case localize("all").uppercased():
            url += "all-auction?"
        case localize("auction").uppercased():
            url += "auction?"
        case localize("direct_auction").uppercased():
            url += "direct-auction?"
        case localize("break").uppercased():
            url += "break?"
        case localize("rollover").uppercased():
            url += "rollover?"
        case localize("mature").uppercased():
            url += "mature-auction?"
        default:
            url += "all-auction?"
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
        
        // Add status parameter
        if filter["status"] != nil && filter["status"] != "" {
            url += "status=\(filter["status"]!)&"
        }
        
        // Add type parameter
        if filter["type"] != nil && filter["type"] != "" {
            url += "type=\(filter["type"]!.replacingOccurrences(of: " ", with: "%20"))&"
        }
        
        // Pagination
        if lastId != nil && lastDate != nil {
            let date = lastDate!.replacingOccurrences(of: " ", with: "%20")
            let pageUrl = "last_id=\(lastId!)&last_date=\(date)&"
            url += pageUrl
        }
        //print(url)
        Alamofire.request(WEB_API_URL + "api/v1/" + url, method: .get, headers: getHeaders(auth: true)).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 401 {
                    self.delegate?.openLoginPage()
                } else {
                    let result = JSON(response.result.value!)
                    //print(result)
                    
                    let serverDate = convertStringToDatetime(result["date"].stringValue)
                    self.delegate?.setDate(serverDate!)
                    
                    var auctions = [Auction]()
                    for auct in result["auctions"].arrayValue {
                        let id = auct["id"].intValue
                        let auction_name = auct["auction_name"].stringValue
                        let portfolio = auct["portfolio"].stringValue
                        let portfolio_short = auct["portfolio_short"].stringValue
                        let investment_range_start = auct["investment_range_start"].doubleValue
                        let investment_range_end = auct["investment_range_end"].doubleValue
                        let start_date = auct["start_date"].stringValue
                        let end_date = auct["end_date"].stringValue
                        let break_maturity_date = auct["break_maturity_date"] != JSON.null ? auct["break_maturity_date"].stringValue : nil
                        let pic_custodian = auct["pic_custodian"] != JSON.null ? auct["pic_custodian"].stringValue : nil
                        let custodian_bank = auct["custodian_bank"] != JSON.null ? auct["custodian_bank"].stringValue : nil
                        let type = auct["type"].stringValue
                        let status = auct["status"].stringValue
                        var maturity_date: String?
                        if type == "auction" || type == "direct-auction" {
                            maturity_date = auct["end_bidding_rm"] != JSON.null ? auct["end_bidding_rm"].stringValue : nil
                        } else {
                            maturity_date = auct["maturity_date"] != JSON.null ? auct["maturity_date"].stringValue : nil
                        }
                        let period = auct["period"].stringValue
                        
                        let auction = Auction(id: id, auction_name: auction_name, portfolio: portfolio, portfolio_short: portfolio_short, pic_custodian: pic_custodian, custodian_bank: custodian_bank, investment_range_start: investment_range_start, investment_range_end: investment_range_end, start_date: start_date, end_date: end_date, break_maturity_date: break_maturity_date, maturity_date: maturity_date, period: period, type: type, status: status)
                        auctions.append(auction)
                    }
                    
                    self.delegate?.setData(auctions, page)
                }
            case .failure(let error):
                print(error)
                self.delegate?.getDataFail()
            }
        }
    }
    
    func getAuctionHistory(_ filter: [String: String], lastId: Int? = nil, lastDate: String? = nil, lastType: String? = nil, _ page: Int) {
        // Get auction history
        var url = String()
        switch filter["type"] {
        case localize("all").uppercased():
            url += "all-auction-history?"
        case localize("auction").uppercased():
            url += "auction-history?"
        case localize("direct_auction").uppercased():
            url += "direct-auction-history?"
        case localize("break").uppercased():
            url += "break-history?"
        case localize("rollover").uppercased():
            url += "rollover-history?"
        case localize("mature").uppercased():
            url += "mature-history?"
        default:
            url += "all-auction-history?"
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
        
        // Add status parameter
        if filter["status"] != nil && filter["status"] != "" {
            url += "status=\(filter["status"]!)&"
        }
        
        // Add type parameter
        if filter["type"] != nil && filter["type"] != "" {
            url += "type=\(filter["type"]!.replacingOccurrences(of: " ", with: "%20"))&"
        }
        
        // Pagination
        if lastId != nil && lastDate != nil && lastType != nil {
            let date = lastDate!.replacingOccurrences(of: " ", with: "%20")
            let pageUrl = "last_id=\(lastId!)&last_date=\(date)&last_type_auction=\(lastType!)&"
            url += pageUrl
        }
        //print(url)
        Alamofire.request(WEB_API_URL + "api/v1/" + url, method: .get, headers: getHeaders(auth: true)).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 401 {
                    self.delegate?.openLoginPage()
                } else {
                    let result = JSON(response.result.value!)
                    //print(result)
                    
                    let serverDate = convertStringToDatetime(result["date"].stringValue)
                    self.delegate?.setDate(serverDate!)
                    
                    var auctions = [Auction]()
                    for auct in result["auctions"].arrayValue {
                        let id = auct["id"].intValue
                        let auction_name = auct["auction_name"].stringValue
                        let portfolio = auct["portfolio"].stringValue
                        let portfolio_short = auct["portfolio_short"].stringValue
                        let investment_range_start = auct["investment_range_start"].doubleValue
                        let investment_range_end = auct["investment_range_end"].doubleValue
                        let start_date = auct["start_date"].stringValue
                        let end_date = auct["end_date"].stringValue
                        let break_maturity_date = auct["break_maturity_date"] != JSON.null ? auct["break_maturity_date"].stringValue : nil
                        let pic_custodian = auct["pic_custodian"] != JSON.null ? auct["pic_custodian"].stringValue : nil
                        let custodian_bank = auct["custodian_bank"] != JSON.null ? auct["custodian_bank"].stringValue : nil
                        let type = auct["type"].stringValue
                        let status = auct["status"].stringValue
                        let maturity_date = auct["maturity_date"] != JSON.null ? auct["maturity_date"].stringValue : nil
                        let period = auct["period"].stringValue
                        
                        let auction = Auction(id: id, auction_name: auction_name, portfolio: portfolio, portfolio_short: portfolio_short, pic_custodian: pic_custodian, custodian_bank: custodian_bank, investment_range_start: investment_range_start, investment_range_end: investment_range_end, start_date: start_date, end_date: end_date, break_maturity_date: break_maturity_date, maturity_date: maturity_date, period: period, type: type, status: status)
                        auctions.append(auction)
                    }
                    
                    self.delegate?.setData(auctions, page)
                }
            case .failure(let error):
                print(error)
                self.delegate?.getDataFail()
            }
        }
    }
}
