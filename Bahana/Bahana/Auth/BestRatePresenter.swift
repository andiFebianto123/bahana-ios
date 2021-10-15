//
//  BestRatePresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/02.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol BestRateDelegate {
    func setOptions(_ data: [String:[String]])
    func setData(_ data: [String: Any]?)
    func getDataFail()
    func isUpdateSuccess(_ isSuccess: Bool, _ message: String)
}

class BestRatePresenter {
    
    private var delegate: BestRateDelegate?
    
    init(delegate: BestRateDelegate){
        self.delegate = delegate
    }
    
    func getOptions() {
        Alamofire.request(WEB_API_URL + "api/v1/rm/options-create").responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                var options = [String:[String]]()
                
                // Breakable Policy
                options["breakable_policy"] = [String]()
                options["breakable_policy"]?.append("")
                for bp in result["breakable_policy"].arrayValue {
                    options["breakable_policy"]?.append(bp.stringValue)
                }
                
                self.delegate?.setOptions(options)
            case .failure( _):
                self.delegate?.getDataFail()
            }
        }
    }
    
    func getBasePlacement() {
        Alamofire.request(WEB_API_URL + "api/v1/base-placement", headers: getHeaders(auth: true)).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
//                let data: [String: Any] = [
//                    "sharia": result["sharia"] != JSON.null ? result["sharia"].stringValue : nil,
//                    "foreign_exchange": result["devisa"] != JSON.null ? result["devisa"].stringValue : nil,
//                    "breakable_policy": result["breakable_policy"] != JSON.null ? result["breakable_policy"].stringValue : nil,
//                    "breakable_policy_notes": result["breakable_policy_notes"] != JSON.null ? result["breakable_policy_notes"].stringValue : nil,
//                    "account_number": result["account_number"] != JSON.null ? result["account_number"].stringValue : nil,
//                    "account_name": result["account_name"] != JSON.null ? result["account_name"].stringValue : nil,
//                    "month_rate_1": result["month_rate_1"] != JSON.null ? self.removeTrailingZero(result["month_rate_1"].stringValue) : nil,
//                    "month_rate_3": result["month_rate_3"] != JSON.null ? self.removeTrailingZero(result["month_rate_3"].stringValue) : nil,
//                    "month_rate_6": result["month_rate_6"] != JSON.null ? self.removeTrailingZero(result["month_rate_6"].stringValue) : nil,
//                    "usd_breakable_policy": result["breakable_policy_usd"] != JSON.null ? result["breakable_policy_usd"].stringValue : nil,
//                    "usd_breakable_policy_notes": result["breakable_policy_notes_usd"] != JSON.null ? result["breakable_policy_notes_usd"].stringValue : nil,
//                    "usd_account_number": result["account_number_usd"] != JSON.null ? result["account_number_usd"].stringValue : nil,
//                    "usd_account_name": result["account_name_usd"] != JSON.null ? result["account_name_usd"].stringValue : nil,
//                    "usd_month_rate_1": result["month_rate_1_usd"] != JSON.null ? self.removeTrailingZero(result["month_rate_1_usd"].stringValue) : nil,
//                    "usd_month_rate_3": result["month_rate_3_usd"] != JSON.null ? self.removeTrailingZero(result["month_rate_3_usd"].stringValue) : nil,
//                    "usd_month_rate_6": result["month_rate_6_usd"] != JSON.null ? self.removeTrailingZero(result["month_rate_6_usd"].stringValue) : nil,
//                    "sharia_breakable_policy": result["breakable_policy_syariah"] != JSON.null ? result["breakable_policy_syariah"].stringValue : nil,
//                    "sharia_breakable_policy_notes": result["breakable_policy_notes_syariah"] != JSON.null ? result["breakable_policy_notes_syariah"].stringValue : nil,
//                    "sharia_account_number": result["account_number_syariah"] != JSON.null ? result["account_number_syariah"].stringValue : nil,
//                    "sharia_account_name": result["account_name_syariah"] != JSON.null ? result["account_name_syariah"].stringValue : nil,
//                    "sharia_month_rate_1": result["month_rate_1_syariah"] != JSON.null ? self.removeTrailingZero(result["month_rate_1_syariah"].stringValue) : nil,
//                    "sharia_month_rate_3": result["month_rate_3_syariah"] != JSON.null ? self.removeTrailingZero(result["month_rate_3_syariah"].stringValue) : nil,
//                    "sharia_month_rate_6": result["month_rate_6_syariah"] != JSON.null ? self.removeTrailingZero(result["month_rate_6_syariah"].stringValue) : nil
//                ]
                
                let data: [String: Any] = [
                    "sharia": result["sharia"] != JSON.null ? result["sharia"].stringValue : nil,
                "foreign_exchange": result["devisa"] != JSON.null ? result["devisa"].stringValue : nil,
                "breakable_policy": result["breakable_policy"] != JSON.null ? result["breakable_policy"].stringValue : nil,
                "breakable_policy_notes": result["breakable_policy_notes"] != JSON.null ? result["breakable_policy_notes"].stringValue : nil,
                "account_number": result["account_number"] != JSON.null ? result["account_number"].stringValue : nil,
                "account_name": result["account_name"] != JSON.null ? result["account_name"].stringValue : nil,
                "month_rate_1": result["month_rate_1"] != JSON.null ? self.removeTrailingZero(result["month_rate_1"].stringValue) : nil,
                "month_rate_3": result["month_rate_3"] != JSON.null ? self.removeTrailingZero(result["month_rate_3"].stringValue) : nil,
                "month_rate_6": result["month_rate_6"] != JSON.null ? self.removeTrailingZero(result["month_rate_6"].stringValue) : nil,
                "usd_breakable_policy": result["breakable_policy_usd"] != JSON.null ? result["breakable_policy_usd"].stringValue : nil,
                "usd_breakable_policy_notes": result["breakable_policy_notes_usd"] != JSON.null ? result["breakable_policy_notes_usd"].stringValue : nil,
                "usd_account_number": result["account_number_usd"] != JSON.null ? result["account_number_usd"].stringValue : nil,
                "usd_account_name": result["account_name_usd"] != JSON.null ? result["account_name_usd"].stringValue : nil,
                "usd_month_rate_1": result["month_rate_1_usd"] != JSON.null ? self.removeTrailingZero(result["month_rate_1_usd"].stringValue) : nil,
                "usd_month_rate_3": result["month_rate_3_usd"] != JSON.null ? self.removeTrailingZero(result["month_rate_3_usd"].stringValue) : nil,
                "usd_month_rate_6": result["month_rate_6_usd"] != JSON.null ? self.removeTrailingZero(result["month_rate_6_usd"].stringValue) : nil,
                "sharia_breakable_policy": result["breakable_policy_syariah"] != JSON.null ? result["breakable_policy_syariah"].stringValue : nil,
                "sharia_breakable_policy_notes": result["breakable_policy_notes_syariah"] != JSON.null ? result["breakable_policy_notes_syariah"].stringValue : nil,
                "sharia_account_number": result["account_number_syariah"] != JSON.null ? result["account_number_syariah"].stringValue : nil,
                "sharia_account_name": result["account_name_syariah"] != JSON.null ? result["account_name_syariah"].stringValue : nil,
                "sharia_month_rate_1": result["month_rate_1_syariah"] != JSON.null ? self.removeTrailingZero(result["month_rate_1_syariah"].stringValue) : nil,
                "sharia_month_rate_3": result["month_rate_3_syariah"] != JSON.null ? self.removeTrailingZero(result["month_rate_3_syariah"].stringValue) : nil,
                "sharia_month_rate_6": result["month_rate_6_syariah"] != JSON.null ? self.removeTrailingZero(result["month_rate_6_syariah"].stringValue) : nil
            ]
                
                self.delegate?.setData(data)
            case .failure(let error):
                self.delegate?.getDataFail()
            }
        }
    }
    
    func updateBasePlacement(_ data: [String: String]) {
        let parameters: Parameters = [
            "breakable_policy": data["idr_breakable_policy"]!,
            "breakable_policy_notes": data["idr_breakable_policy_notes"]!,
            "account_number": data["idr_account_number"]!,
            "account_name": data["idr_account_name"]!,
            "month_rate_1": data["idr_month_rate_1"] != "" ? data["idr_month_rate_1"]! : "",
            "month_rate_3": data["idr_month_rate_3"] != "" ? data["idr_month_rate_3"]! : "",
            "month_rate_6": data["idr_month_rate_6"] != "" ? data["idr_month_rate_6"]! : "",
            "breakable_policy_usd": data["usd_breakable_policy"]!,
            "breakable_policy_notes_usd": data["usd_breakable_policy_notes"]!,
            "account_number_usd": data["usd_account_number"]!,
            "account_name_usd": data["usd_account_name"]!,
            "month_rate_1_usd": data["usd_month_rate_1"] != "" ? data["usd_month_rate_1"]! : "",
            "month_rate_3_usd": data["usd_month_rate_3"] != "" ? data["usd_month_rate_3"]! : "",
            "month_rate_6_usd": data["usd_month_rate_6"] != "" ? data["usd_month_rate_6"]! : "",
            "breakable_policy_syariah": data["sharia_breakable_policy"]!,
            "breakable_policy_notes_syariah": data["sharia_breakable_policy_notes"]!,
            "account_number_syariah": data["sharia_account_number"]!,
            "account_name_syariah": data["sharia_account_name"]!,
            "month_rate_1_syariah": data["sharia_month_rate_1"] != "" ? data["sharia_month_rate_1"]! : "",
            "month_rate_3_syariah": data["sharia_month_rate_3"] != "" ? data["sharia_month_rate_3"]! : "",
            "month_rate_6_syariah": data["sharia_month_rate_6"] != "" ? data["sharia_month_rate_6"]! : "",
        ]
        
        Alamofire.request(WEB_API_URL + "api/v1/base-placement/update", method: .post, parameters: parameters, headers: getHeaders(auth: true)).responseString { response in
            if response.response?.mimeType == "application/json" {
                let result = JSON.init(parseJSON: response.result.value!)
                if response.response?.statusCode == 200 {
                    self.delegate?.isUpdateSuccess(true, localize("update_best_rate_success"))
                } else {
                    self.delegate?.isUpdateSuccess(false, result["message"].stringValue)
                }
            } else {
                self.delegate?.getDataFail()
            }
        }
    }
    
    func removeTrailingZero(_ num: String) -> String {
        var newNumber = num
        
        var count = Int()
        for (idx, i) in newNumber.enumerated().reversed() {
            if i == "0" || i == "." {
                count += 1
            } else {
                break
            }
        }
        newNumber.removeLast(count)
        
        return newNumber
    }
}
