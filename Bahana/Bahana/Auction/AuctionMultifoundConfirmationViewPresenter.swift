//
//  AuctionMultifoundConfirmationViewPresenter.swift
//  Bahana
//
//  Created by RECTmedia MD102 on 10/05/21.
//  Copyright © 2021 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
protocol AuctionMultifundDetailConfirmationDelegate {
    func openLoginPage()
    func getDataFail(_ message: String?)
    func setData(_ data: DetailBidder)
    func getData()
    func isConfirmed(_ isConfirmed: Bool, _ message: String)
}

class AuctionMultifoundConfirmationViewPresenter {
    private var delegate: AuctionMultifundDetailConfirmationDelegate?
    init(delegate: AuctionMultifundDetailConfirmationDelegate){
        self.delegate = delegate
    }
    func getDetailBidder(_ id: Int, _ idBid: Int){
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
        
        Alamofire.request(WEB_API_URL + "api/v1/multi-fund-auction/\(id)/detail-bidder/\(idBid)?lang=\(lang)", method: .get, headers: getHeaders(auth: true)).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 401 {
                    self.delegate?.openLoginPage()
                } else if response.response?.statusCode == 404 {
                    let res = JSON(response.result.value!)
                    self.delegate?.getDataFail(res["message"].stringValue)
                } else {
                    let res = JSON(response.result.value!)
                    let bid = res["detail"]
                    // print(bid)
                    var portfolioDetails = [DetailPortfolio]()
                    for portfolio in bid["detail_portfolio"].arrayValue {
                        portfolioDetails.append(DetailPortfolio(portfolio_id: portfolio["portfolio_id"].intValue, portfolio: portfolio["portfolio"].stringValue, description: portfolio["description"].stringValue, custodian_bank: portfolio["custodian_bank"].stringValue, bilyet: portfolio["bilyet"].stringValue, status: portfolio["status"].stringValue))
                    }
                    let detailBidder = DetailBidder(view: bid["view"].intValue, rate: bid["rate"].stringValue, tenor: bid["tenor"].stringValue, total_investment: bid["total_investment"].stringValue, detail_portfolio: portfolioDetails)
                    
                    self.delegate?.setData(detailBidder)
                }
            case .failure(let error):
                print(error)
                self.delegate?.getDataFail(nil)
            }
        }
    }
    
    func confirmBtn(portfolio_details:[AuctionStackPlacement], id_auction:Int, id_bidder: Int, _ is_accept:String){
        var parameters = Parameters()
        var url = "api/v1/"
        parameters.updateValue(is_accept, forKey: "is_accepted")
        var idx: Int = 0
        for (i, port) in portfolio_details.enumerated() {
            if port.checkBox {
                parameters.updateValue(port.portfolioLabel.text!, forKey: "portfolio[\(idx)][portfolio]")
                parameters.updateValue(port.id, forKey: "portfolio[\(idx)][portfolio_id]")
                idx += 1
            }
        }
        print(parameters)
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
        url += "multi-fund-auction/\(id_auction)/confirm-winner/\(id_bidder)"
        url += "?lang=\(lang)"
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
                self.delegate?.getDataFail(nil)
            }
        }
        
    }
}
