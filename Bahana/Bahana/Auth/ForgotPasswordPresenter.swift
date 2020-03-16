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
        let lang = "in"
        
        Alamofire.request(WEB_API_URL + "api/v1/forgot-password?email=\(email)&lang=\(lang)", method: .post).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                if response.response?.statusCode == 404 {
                    self.delegate?.isSubmitSuccess(false, result["message"].stringValue)
                } else {
                    self.delegate?.isSubmitSuccess(true, result["message"].stringValue)
                }
            case .failure(let error):
                self.delegate?.isSubmitSuccess(false, localize("information"))
                print(error)
            }
        }
    }
}
