//
//  ForgotPasswordPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/05.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol ForgotPasswordDelegate {
    func isSubmitSuccess(_ isSuccess: Bool, _ message: String)
}

class ForgotPasswordPresenter {
    
    private var delegate: ForgotPasswordDelegate?
    
    init(delegate: ForgotPasswordDelegate){
        self.delegate = delegate
    }
    
    func submit(_ email: String) {
        var lang = String()
        switch getLocalData(key: "language") {
        case "language_id":
            lang = "in"
        case "language_en":
            lang = "en"
        default:
            break
        }
        
        Alamofire.request(WEB_API_URL + "api/v1/forgot-password?email=\(email)&lang=\(lang)", method: .post, headers: getHeaders()).responseJSON { response in
            if response.response?.mimeType == "application/json" {
                let result = JSON(response.result.value!)
                if response.response?.statusCode == 200 {
                    self.delegate?.isSubmitSuccess(true, result["message"].stringValue)
                } else {
                    self.delegate?.isSubmitSuccess(false, result["message"].stringValue)
                }
            } else {
                print(response)
                self.delegate?.isSubmitSuccess(false, localize("information"))
            }
        }
    }
}
