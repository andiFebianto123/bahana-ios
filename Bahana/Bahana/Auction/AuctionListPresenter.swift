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
    //func setData(_ data: )
}

class AuctionListPresenter {
    
    private var delegate: AuctionListDelegate?
    
    init(delegate: AuctionListDelegate){
        self.delegate = delegate
    }
    
    func getAuction(_ status: String, _ type: String) {
        // Get auction
        Alamofire.request(WEB_API_URL + "api/v1/all-auction?status=\(status)", method: .get, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 401 {
                    self.delegate?.openLoginPage()
                } else {
                    let result = JSON(response.result.value!)
                    print(result)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getAuctionHistory(_ status: String, _ type: String) {
        // Get auction history
        Alamofire.request(WEB_API_URL + "api/v1/all-auction-history?status=\(status)", method: .get, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                print(result)
            case .failure(let error):
                print(error)
            }
        }
    }
}


