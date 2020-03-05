//
//  SettingsPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/03.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol SettingsDelegate {
    func isLogoutSuccess(_ isLoggedOut: Bool, _ message: String)
}

class SettingsPresenter {
    
    private var delegate: SettingsDelegate?
    
    init(delegate: SettingsDelegate){
        self.delegate = delegate
    }
    
    func logout() {
        Alamofire.request(WEB_API_URL + "api/v1/logout", method: .get, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                if response.response?.statusCode == 401 {
                    self.delegate?.isLogoutSuccess(false, result["message"].stringValue)
                } else {
                    setLocalData([
                        "user_id": "",
                        "access_token": "",
                        "name": "",
                        "email": "",
                        "phone": ""
                    ])
                    self.delegate?.isLogoutSuccess(true, result["message"].stringValue)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
