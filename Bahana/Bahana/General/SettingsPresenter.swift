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
    func setProfile(_ name: String, _ email: String, _ phone: String)
    func isLogoutSuccess(_ isLoggedOut: Bool, _ message: String)
    func getDataFail()
    func openLoginPage()
}

class SettingsPresenter {
    
    private var delegate: SettingsDelegate?
    
    init(delegate: SettingsDelegate){
        self.delegate = delegate
    }
    
    func getProfile() {
        Alamofire.request(WEB_API_URL + "api/v1/me", method: .get, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                if response.response?.statusCode == 401 {
                    self.delegate?.openLoginPage()
                } else {
                    let name = result["fullname"].stringValue
                    let email = result["email"].stringValue
                    let phone = result["phone"].stringValue
                    self.delegate?.setProfile(name, email, phone)
                }
            case .failure(let error):
                print(error)
                self.delegate?.getDataFail()
            }
        }
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
                        "access_token": ""
                    ])
                    self.delegate?.isLogoutSuccess(true, result["message"].stringValue)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
