//
//  LoginPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/05.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol LoginDelegate {
    func isLoginSuccess(_ isSuccess: Bool, _ message: String)
}

class LoginPresenter {
    
    private var delegate: LoginDelegate?
    
    init(delegate: LoginDelegate){
        self.delegate = delegate
    }
    
    func submit(_ email: String, _ password: String) {
        var lang = String()
        switch getLocalData(key: "language") {
        case "language_id":
            lang = "in"
        case "language_en":
            lang = "en"
        default:
            break
        }
        
        let parameters: Parameters = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(WEB_API_URL + "api/v1/login?lang=\(lang)", method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                if response.response?.statusCode == 401 {
                    self.delegate?.isLoginSuccess(false, result["message"].stringValue)
                } else {
                    self.saveLoginData(result)
                    self.delegate?.isLoginSuccess(true, localize("information"))
                }
            case .failure(let error):
                self.delegate?.isLoginSuccess(false, localize("information"))
                print(error)
            }
        }
    }
    
    func saveLoginData(_ jsonData: JSON) {
        let data: [String: String] = [
            "user_id": "\(jsonData["id"].intValue)",
            "access_token": jsonData["access_token"].stringValue
        ]
        setLocalData(data)
    }
}
