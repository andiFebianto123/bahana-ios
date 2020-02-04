//
//  TermsAndConditionsPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/31.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol TermsAndConditionsDelegate {
    func setData(_ data: String)
}

class TermsAndConditionsPresenter {
    private var delegate: TermsAndConditionsDelegate?
    
    init(delegate: TermsAndConditionsDelegate){
        self.delegate = delegate
    }
    
    func getTC() {
        Alamofire.request(WEB_API_URL + "api/v1/term-and-conditions").responseJSON { response in
            switch response.result {
            case .success:
                let title = "<div style='font-size: 24px;'><b>Dengan ini saya menyatakan bahwa :</b><br />"
                let result = JSON(response.result.value!)
                let checkbox = "<br /><input type='checkbox' name='agreement' style='transform: scale(2)'> Ya, saya menyetujui segala ketentuan yang telah ditetapkan.</div>"
                self.delegate?.setData(title + result["data"].stringValue + checkbox)
            default:
                break
            }
        }
    }
}
