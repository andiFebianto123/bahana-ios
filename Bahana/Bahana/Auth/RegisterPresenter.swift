//
//  RegisterPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/04.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol RegisterDelegate {
    func isRegisterSuccess(_ isSuccess: Bool, _ message: String)
}

class RegisterPresenter {
    
    private var delegate: RegisterDelegate?
    
    init(delegate: RegisterDelegate){
        self.delegate = delegate
    }
    
    func submit() {
        var lang = String()
        switch getLocalData(key: "language") {
        case "language_id":
            lang = "in"
        case "language_en":
            lang = "en"
        default:
            break
        }
        
        let url = "register?lang=\(lang)"
        
        let parameters: Parameters = [
            "fullname": getLocalData(key: "name"),
            "email": getLocalData(key: "email"),
            "phone": getLocalData(key: "phone"),
            "other_name": getLocalData(key: "pic_alternative"),
            "other_phone": getLocalData(key: "phone_alternative"),
            "parent_bank_id": getLocalData(key: "bank"),
            "bank_name": getLocalData(key: "bank_name"),
            "branch_id": getLocalData(key: "bank_branch"),
            "branch_name": getLocalData(key: "bank_branch_name"),
            "address": getLocalData(key: "bank_branch_address"),
            "bank_type": getLocalData(key: "bank_type"),
            "devisa": getLocalData(key: "foreign_exchange").lowercased(),
            "buku": getLocalData(key: "book"),
            "sharia": getLocalData(key: "sharia"),
            "interest_day_count_convertion": getLocalData(key: "interest_day_count_convertion"),
            "end_date": getLocalData(key: "end_date"),
            "return_start_date": getLocalData(key: "return_to_start_date").lowercased(),
            "holiday_interest": getLocalData(key: "holiday_interest"),
            "password": getLocalData(key: "password"),
            "re_password": getLocalData(key: "password_confirmation"),
            "breakable_policy": getLocalData(key: "idr_breakable_policy") != "" ? getLocalData(key: "idr_breakable_policy") : JSON.null,
            "breakable_policy_notes": getLocalData(key: "idr_breakable_policy_notes") != "" ? getLocalData(key: "idr_breakable_policy_notes") : JSON.null,
            "account_number": getLocalData(key: "idr_account_number") != "" ? getLocalData(key: "idr_account_number") : JSON.null,
            "account_name": getLocalData(key: "idr_account_name") != "" ? getLocalData(key: "idr_account_name") : JSON.null,
            "month_rate_1": getLocalData(key: "idr_month_rate_1") != "" ? getLocalData(key: "idr_month_rate_1") : JSON.null,
            "month_rate_3": getLocalData(key: "idr_month_rate_3") != "" ? getLocalData(key: "idr_month_rate_3") : JSON.null,
            "month_rate_6": getLocalData(key: "idr_month_rate_6") != "" ? getLocalData(key: "idr_month_rate_6") : JSON.null,
            "breakable_policy_usd": getLocalData(key: "usd_breakable_policy") != "" ? getLocalData(key: "usd_breakable_policy") : JSON.null,
            "breakable_policy_notes_usd": getLocalData(key: "usd_breakable_policy_notes") != "" ? getLocalData(key: "usd_breakable_policy_notes") : JSON.null,
            "account_number_usd": getLocalData(key: "usd_account_number") != "" ? getLocalData(key: "usd_account_number") : JSON.null,
            "account_name_usd": getLocalData(key: "usd_account_name") != "" ? getLocalData(key: "usd_account_name") : JSON.null,
            "month_rate_1_usd": getLocalData(key: "usd_month_rate_1") != "" ? getLocalData(key: "usd_month_rate_1") : JSON.null,
            "month_rate_3_usd": getLocalData(key: "usd_month_rate_3") != "" ? getLocalData(key: "usd_month_rate_3") : JSON.null,
            "month_rate_6_usd": getLocalData(key: "usd_month_rate_6") != "" ? getLocalData(key: "usd_month_rate_6") : JSON.null,
            "breakable_policy_syariah": getLocalData(key: "sharia_breakable_policy") != "" ? getLocalData(key: "sharia_breakable_policy") : JSON.null,
            "breakable_policy_notes_syariah": getLocalData(key: "sharia_breakable_policy_notes") != "" ? getLocalData(key: "sharia_breakable_policy_notes") : JSON.null,
            "account_number_syariah": getLocalData(key: "sharia_account_number") != "" ? getLocalData(key: "sharia_account_number") : JSON.null,
            "account_name_syariah": getLocalData(key: "sharia_account_name") != "" ? getLocalData(key: "sharia_account_name") : JSON.null,
            "month_rate_1_syariah": getLocalData(key: "sharia_month_rate_1") != "" ? getLocalData(key: "sharia_month_rate_1") : JSON.null,
            "month_rate_3_syariah": getLocalData(key: "sharia_month_rate_3") != "" ? getLocalData(key: "sharia_month_rate_3") : JSON.null,
            "month_rate_6_syariah": getLocalData(key: "sharia_month_rate_6") != "" ? getLocalData(key: "sharia_month_rate_6") : JSON.null
        ]
        //print(parameters)
        
        Alamofire.request(WEB_API_URL + "api/v1/\(url)", method: .post, parameters: parameters, headers: getHeaders()).responseString { response in
            if response.response?.mimeType == "application/json" {
                let result = JSON.init(parseJSON: response.result.value!)
                //print(result)
                if response.response?.statusCode == 200 {
                    self.delegate?.isRegisterSuccess(true, result["message"].stringValue)
                } else {
                    self.delegate?.isRegisterSuccess(false, result["message"].stringValue)
                }
            } else {
                print(response)
                self.delegate?.isRegisterSuccess(false, "")
            }
        }
    }
}
