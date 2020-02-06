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
            "fullname": getProfileForm(key: "name"),
            "email": getProfileForm(key: "email"),
            "phone": getProfileForm(key: "phone"),
            "other_name": getProfileForm(key: "pic_alternative"),
            "other_phone": getProfileForm(key: "phone_alternative"),
            "parent_bank_id": getProfileForm(key: "bank"),
            "bank_name": getProfileForm(key: "bank_name"),
            "branch_id": getProfileForm(key: "bank_branch"),
            "branch_name": getProfileForm(key: "bank_branch_name"),
            "address": getProfileForm(key: "bank_branch_address"),
            "bank_type": getProfileForm(key: "bank_type"),
            "devisa": getProfileForm(key: "foreign_exchange"),
            "buku": getProfileForm(key: "book"),
            "sharia": getProfileForm(key: "sharia"),
            "interest_day_count_convertion": getProfileForm(key: "interest_day_count_convertion"),
            "end_date": getProfileForm(key: "end_date"),
            "return_start_date": getProfileForm(key: "return_to_start_date"),
            "holiday_interest": getProfileForm(key: "holiday_interest"),
            "password": getProfileForm(key: "password"),
            "password_confirmation": getProfileForm(key: "password_confirmation"),
            "breakable_policy": getProfileForm(key: "idr_breakable_policy"),
            "breakable_policy_notes": getProfileForm(key: "idr_breakable_policy_notes"),
            "account_number": getProfileForm(key: "idr_account_number"),
            "account_name": getProfileForm(key: "idr_account_name"),
            "month_rate_1": getProfileForm(key: "idr_month_rate_1"),
            "month_rate_3": getProfileForm(key: "idr_month_rate_3"),
            "month_rate_6": getProfileForm(key: "idr_month_rate_6"),
            "breakable_policy_usd": getProfileForm(key: "usd_breakable_policy"),
            "breakable_policy_notes_usd": getProfileForm(key: "usd_breakable_policy_notes"),
            "account_number_usd": getProfileForm(key: "usd_account_number"),
            "account_name_usd": getProfileForm(key: "usd_account_name"),
            "month_rate_1_usd": getProfileForm(key: "usd_month_rate_1"),
            "month_rate_3_usd": getProfileForm(key: "usd_month_rate_3"),
            "month_rate_6_usd": getProfileForm(key: "usd_month_rate_6"),
            "breakable_policy_syariah": getProfileForm(key: "sharia_breakable_policy"),
            "breakable_policy_notes_syariah": getProfileForm(key: "sharia_breakable_policy_notes"),
            "account_number_syariah": getProfileForm(key: "sharia_account_number"),
            "account_name_syariah": getProfileForm(key: "sharia_account_name"),
            "month_rate_1_syariah": getProfileForm(key: "sharia_month_rate_1"),
            "month_rate_3_syariah": getProfileForm(key: "sharia_month_rate_3"),
            "month_rate_6_syariah": getProfileForm(key: "sharia_month_rate_6"),
            
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
}
