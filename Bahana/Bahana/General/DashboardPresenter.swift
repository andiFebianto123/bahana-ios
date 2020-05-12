//
//  DashboardPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/25.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol DashboardDelegate {
    func setData(_ data: [String: Any?])
    func getDataFail()
    func openLoginPage()
}

class DashboardPresenter {
    private var delegate: DashboardDelegate?
    
    init(delegate: DashboardDelegate){
        self.delegate = delegate
    }
    
    func getData() {
        Alamofire.request(WEB_API_URL + "api/v1/home", method: .get, headers: getHeaders(auth: true)).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                if response.response?.statusCode == 401 {
                    self.delegate?.openLoginPage()
                } else {
                    let data: [String: Any?] = [
                        "completed": result["completed"].intValue,
                        "ongoing": result["ongoing"].intValue,
                        "confirmation": result["confirmation"].intValue,
                        "latest_completed": nil,
                        "latest_bid": nil,
                        "info_base_placement": result["info_base_placement"].boolValue
                    ]
                    
                    self.delegate?.setData(data)
                }
            case .failure(let error):
                print(error)
                self.delegate?.getDataFail()
            }
        }
    }
}
