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
    func isRegisterSuccess(_ isSuccess: Bool)
}

class RegisterPresenter {
    
    private var delegate: RegisterDelegate?
    
    init(delegate: RegisterDelegate){
        self.delegate = delegate
    }
    
    func submit() {
        let lang = "in"
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
            "devisa": getLocalData(key: "foreign_exchange"),
            "buku": getLocalData(key: "book"),
            "sharia": getLocalData(key: "sharia"),
            "interest_day_count_convertion": getLocalData(key: "interest_day_count_convertion"),
            "end_date": getLocalData(key: "end_date"),
            "return_start_date": getLocalData(key: "return_to_start_date"),
            "holiday_interest": getLocalData(key: "holiday_interest"),
            "password": getLocalData(key: "password"),
            "password_confirmation": getLocalData(key: "password_confirmation"),
            "breakable_policy": getLocalData(key: "idr_breakable_policy"),
            "breakable_policy_notes": getLocalData(key: "idr_breakable_policy_notes"),
            "account_number": getLocalData(key: "idr_account_number"),
            "account_name": getLocalData(key: "idr_account_name"),
            "month_rate_1": getLocalData(key: "idr_month_rate_1"),
            "month_rate_3": getLocalData(key: "idr_month_rate_3"),
            "month_rate_6": getLocalData(key: "idr_month_rate_6"),
            "breakable_policy_usd": getLocalData(key: "usd_breakable_policy"),
            "breakable_policy_notes_usd": getLocalData(key: "usd_breakable_policy_notes"),
            "account_number_usd": getLocalData(key: "usd_account_number"),
            "account_name_usd": getLocalData(key: "usd_account_name"),
            "month_rate_1_usd": getLocalData(key: "usd_month_rate_1"),
            "month_rate_3_usd": getLocalData(key: "usd_month_rate_3"),
            "month_rate_6_usd": getLocalData(key: "usd_month_rate_6"),
            "breakable_policy_syariah": getLocalData(key: "sharia_breakable_policy"),
            "breakable_policy_notes_syariah": getLocalData(key: "sharia_breakable_policy_notes"),
            "account_number_syariah": getLocalData(key: "sharia_account_number"),
            "account_name_syariah": getLocalData(key: "sharia_account_name"),
            "month_rate_1_syariah": getLocalData(key: "sharia_month_rate_1"),
            "month_rate_3_syariah": getLocalData(key: "sharia_month_rate_3"),
            "month_rate_6_syariah": getLocalData(key: "sharia_month_rate_6"),
            
        ]
        Alamofire.request(WEB_API_URL + "api/v1/register?lang=\(lang)", method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success:
                //let result = JSON(response.result.value!)
                self.delegate?.isRegisterSuccess(true)
            case .failure(let error):
                self.delegate?.isRegisterSuccess(false)
            }
        }
    }
    
    func resetRegisterData() {
        let data: [String: String] = [
            "name": "",
            "email": "",
            "phone": "",
            "pic_alternative": "",
            "phone_alternative": "",
            "bank": "",
            "bank_name": "",
            "bank_branch": "",
            "bank_branch_name": "",
            "bank_branch_address": "",
            "bank_type": "",
            "foreign_exchange": "",
            "book": "",
            "sharia": "",
            "interest_day_count_convertion": "",
            "end_date": "",
            "return_to_start_date": "",
            "holiday_interest": "",
            "password": "",
            "password_confirmation": "",
            "idr_breakable_policy": "",
            "idr_breakable_policy_notes": "",
            "idr_account_number": "",
            "idr_account_name": "",
            "idr_month_rate_1": "",
            "idr_month_rate_3": "",
            "idr_month_rate_6": "",
            "usd_breakable_policy": "",
            "usd_breakable_policy_notes": "",
            "usd_account_number": "",
            "usd_account_name": "",
            "usd_month_rate_1": "",
            "usd_month_rate_3": "",
            "usd_month_rate_6": "",
            "sharia_breakable_policy": "",
            "sharia_breakable_policy_notes": "",
            "sharia_account_number": "",
            "sharia_account_name": "",
            "sharia_month_rate_1": "",
            "sharia_month_rate_3": "",
            "sharia_month_rate_6": "",
        ]
        setLocalData(data)
    }
}
