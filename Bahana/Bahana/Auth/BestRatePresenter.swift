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
    func getDataFail()
    func setData(_ data: [String: Any]?)
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
            case .failure(let error):
                self.delegate?.getDataFail()
            }
        }
    }
    
    func getBasePlacement() {
        Alamofire.request(WEB_API_URL + "api/v1/base-placement", headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                let data: [String: Any] = [
                    "sharia": result["sharia"] != JSON.null ? result["sharia"].stringValue : nil,
                    "foreign_exchange": result["devisa"] != JSON.null ? result["devisa"].stringValue : nil,
                    "breakable_policy": result["breakable_policy"] != JSON.null ? result["breakable_policy"].stringValue : nil,
                    "breakable_policy_notes": result["breakable_policy_notes"] != JSON.null ? result["breakable_policy_notes"].stringValue : nil,
                    "account_number": result["account_number"] != JSON.null ? result["account_number"].stringValue : nil,
                    "account_name": result["account_name"] != JSON.null ? result["account_name"].stringValue : nil,
                    "month_rate_1": result["month_rate_1"] != JSON.null ? result["month_rate_1"].doubleValue : nil,
                    "month_rate_3": result["month_rate_3"] != JSON.null ? result["month_rate_3"].doubleValue : nil,
                    "month_rate_6": result["month_rate_6"] != JSON.null ? result["month_rate_6"].doubleValue : nil,
                    "usd_breakable_policy": result["breakable_policy_usd"] != JSON.null ? result["breakable_policy_usd"].stringValue : nil,
                    "usd_breakable_policy_notes": result["breakable_policy_notes_usd"] != JSON.null ? result["breakable_policy_notes_usd"].stringValue : nil,
                    "usd_account_number": result["account_number_usd"] != JSON.null ? result["account_number_usd"].stringValue : nil,
                    "usd_account_name": result["account_name_usd"] != JSON.null ? result["account_name_usd"].stringValue : nil,
                    "usd_month_rate_1": result["month_rate_1_usd"] != JSON.null ? result["month_rate_1_usd"].doubleValue : nil,
                    "usd_month_rate_3": result["month_rate_3_usd"] != JSON.null ? result["month_rate_3_usd"].doubleValue : nil,
                    "usd_month_rate_6": result["month_rate_6_usd"] != JSON.null ? result["month_rate_6_usd"].doubleValue : nil,
                    "sharia_breakable_policy": result["breakable_policy_syariah"] != JSON.null ? result["breakable_policy_syariah"].stringValue : nil,
                    "sharia_breakable_policy_notes": result["breakable_policy_notes_syariah"] != JSON.null ? result["breakable_policy_notes_syariah"].stringValue : nil,
                    "sharia_account_number": result["account_number_syariah"] != JSON.null ? result["account_number_syariah"].stringValue : nil,
                    "sharia_account_name": result["account_name_syariah"] != JSON.null ? result["account_name_syariah"].stringValue : nil,
                    "sharia_month_rate_1": result["month_rate_1_syariah"] != JSON.null ? result["month_rate_1_syariah"].doubleValue : nil,
                    "sharia_month_rate_3": result["month_rate_3_syariah"] != JSON.null ? result["month_rate_3_syariah"].doubleValue : nil,
                    "sharia_month_rate_6": result["month_rate_6_syariah"] != JSON.null ? result["month_rate_6_syariah"].doubleValue : nil
                ]
                
                self.delegate?.setData(data)
            case .failure(let error):
                self.delegate?.getDataFail()
            }
        }
    }
    
    func updateBasePlacement(_ data: [String: Any]) {
        let parameters: Parameters = [
            "breakable_policy": data["idr_breakable_policy"] as! String,
            "breakable_policy_notes": data["idr_breakable_policy_notes"] as! String,
            "account_number": data["idr_account_number"] as! String,
            "account_name": data["idr_account_name"] as! String,
            "month_rate_1": data["idr_month_rate_1"] as! Double,
            "month_rate_3": data["idr_month_rate_3"] as! Double,
            "month_rate_6": data["idr_month_rate_6"] as! Double,
            "breakable_policy_usd": data["usd_breakable_policy"] as! String,
            "breakable_policy_notes_usd": data["usd_breakable_policy_notes"] as! String,
            "account_number_usd": data["usd_account_number"] as! String,
            "account_name_usd": data["usd_account_name"] as! String,
            "month_rate_1_usd": data["usd_month_rate_1"] as! Double,
            "month_rate_3_usd": data["usd_month_rate_3"] as! Double,
            "month_rate_6_usd": data["usd_month_rate_6"] as! Double,
            "breakable_policy_syariah": data["sharia_breakable_policy"] as! String,
            "breakable_policy_notes_syariah": data["sharia_breakable_policy_notes"] as! String,
            "account_number_syariah": data["sharia_account_number"] as! String,
            "account_name_syariah": data["sharia_account_name"] as! String,
            "month_rate_1_syariah": data["sharia_month_rate_1"] as! Double,
            "month_rate_3_syariah": data["sharia_month_rate_3"] as! Double,
            "month_rate_6_syariah": data["sharia_month_rate_6"] as! Double,
        ]
        
        Alamofire.request(WEB_API_URL + "api/v1/base-placement/update", method: .post, parameters: parameters, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                if response.response?.statusCode == 200 {
                    self.delegate?.isUpdateSuccess(true, "Update sukses")
                } else {
                    self.delegate?.isUpdateSuccess(false, result["message"].stringValue)
                }
            case .failure(let error):
                self.delegate?.getDataFail()
            }
        }
    }
}
