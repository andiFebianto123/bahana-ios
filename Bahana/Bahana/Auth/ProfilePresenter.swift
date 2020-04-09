//
//  ProfilePresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/31.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol ProfileDelegate {
    func setBanks(_ data: [Bank])
    func setBankBranchs(_ data: [BankBranch])
    func setOptions(_ data: [String:[String]])
    func getDataFail()
    func setData(_ data: [String: Any])
    func isUpdateSuccess(_ isSuccess: Bool, _ message: String)
}

class ProfilePresenter {
    
    private var delegate: ProfileDelegate?
    
    init(delegate: ProfileDelegate){
        self.delegate = delegate
    }
    
    func getBank() {
        Alamofire.request(WEB_API_URL + "api/v1/bank").responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                var banks = [Bank]()
                for res in result.arrayValue {
                    let bank = Bank.init(id: String(res["id"].intValue), name: res["bank_name"].stringValue, code: res["bank_code"].stringValue)
                    banks.append(bank)
                }
                self.delegate?.setBanks(banks.reversed())
            case .failure(let error):
                self.delegate?.getDataFail()
            }
        }
    }
    
    func getBankBranch(_ id: String) {
        Alamofire.request(WEB_API_URL + "api/v1/bank/\(id)/branch").responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                var branchs = [BankBranch]()
                for res in result.arrayValue {
                    if res["issuers"].arrayValue.count > 0 {
                        let firstIssuer = res["issuers"].arrayValue.first
                        let branch = BankBranch.init(id: String(res["id"].intValue), name: firstIssuer!["description"].stringValue, code: res["branch_code"].stringValue)
                        branchs.append(branch)
                    } else {
                        let branch = BankBranch.init(id: String(res["id"].intValue), name: res["branch_name"].stringValue, code: res["branch_code"].stringValue)
                        branchs.append(branch)
                    }
                }
                self.delegate?.setBankBranchs(branchs.reversed())
            case .failure(let error):
                self.delegate?.getDataFail()
            }
        }
    }
    
    func getOptions() {
        Alamofire.request(WEB_API_URL + "api/v1/rm/options-create").responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                var options = [String:[String]]()
                // Bank Type
                options["bank_type"] = [String]()
                for bt in result["bank_type"].arrayValue {
                    options["bank_type"]?.append(bt.stringValue)
                }
                
                // Devisa
                options["foreign_exchange"] = [
                    "Yes",
                    "No"
                ]
                
                // Book
                options["book"] = [String]()
                for b in result["buku"].arrayValue {
                    options["book"]?.append(b.stringValue)
                }
                
                // Sharia
                options["sharia"] = [String]()
                for s in result["sharia"].arrayValue {
                    options["sharia"]?.append(s.stringValue)
                }
                
                // Interest day count convertion
                options["interest_day_count_convertion"] = [String]()
                for idcc in result["interest_day_count_convertion"].arrayValue {
                    options["interest_day_count_convertion"]?.append(idcc.stringValue)
                }
                
                // End date
                options["end_date"] = [String]()
                for ed in result["end_date"].arrayValue {
                    options["end_date"]?.append(ed.stringValue)
                }
                
                // Return to start date
                options["return_to_start_date"] = [
                    "Yes",
                    "No"
                ]
                
                // Holiday interest
                options["holiday_interest"] = [String]()
                for hi in result["holiday_interest"].arrayValue {
                    options["holiday_interest"]?.append(hi.stringValue)
                }
                
                self.delegate?.setOptions(options)
            case .failure(let error):
                self.delegate?.getDataFail()
            }
        }
    }
    
    func getProfile() {
        Alamofire.request(WEB_API_URL + "api/v1/me", headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                
                let bank = result["bank"] != JSON.null ? Bank(id: result["bank"]["id"].stringValue, name: result["bank"]["bank_name"].stringValue, code: result["bank"]["bank_code"].stringValue) : nil
                var branch_name = result["branch"]["branch_name"].stringValue
                if result["branch"]["issuers"].arrayValue.count > 0 {
                    let issuers = result["branch"]["issuers"].arrayValue.first
                    branch_name = issuers!["description"].stringValue
                }
                let bank_branch = result["branch"] != JSON.null ? BankBranch(id: result["branch"]["id"].stringValue, name: branch_name, code: result["branch"]["branch_code"].stringValue) : nil
                let data: [String: Any] = [
                    "name": result["fullname"] != JSON.null ? result["fullname"].stringValue : nil,
                    "email": result["email"] != JSON.null ? result["email"].stringValue : nil,
                    "phone": result["phone"] != JSON.null ? result["phone"].stringValue : nil,
                    "pic_alternative": result["other_name"] != JSON.null ? result["other_name"].stringValue : nil,
                    "phone_alternative": result["other_phone"] != JSON.null ? result["other_phone"].stringValue : nil,
                    "bank": bank,
                    "bank_branch": bank_branch,
                    "address": result["address"] != JSON.null ? result["address"].stringValue : nil,
                    "bank_type": result["bank"]["parent"]["bank_type"] != JSON.null ? result["bank"]["parent"]["bank_type"].stringValue : nil,
                    "foreign_exchange": result["bank"]["parent"]["devisa"] != JSON.null ? result["bank"]["parent"]["devisa"].stringValue : nil,
                    "book": result["bank"]["parent"]["buku"] != JSON.null ? result["bank"]["parent"]["buku"].stringValue : nil,
                    "sharia": result["branch"]["sharia"] != JSON.null ? result["branch"]["sharia"].stringValue : nil,
                    "interest_day_count_convertion": result["branch"]["interest_day_count_convertion"] != JSON.null ? result["branch"]["interest_day_count_convertion"].stringValue : nil,
                    "end_date": result["branch"]["end_date"] != JSON.null ? result["branch"]["end_date"].stringValue : nil,
                    "return_to_start_date": result["branch"]["return_start_date"] != JSON.null ? result["branch"]["return_start_date"].stringValue : nil,
                    "holiday_interest": result["branch"]["holiday_interest"] != JSON.null ? result["branch"]["holiday_interest"].stringValue : nil,
                ]
                
                self.delegate?.setData(data)
            case .failure(let error):
                self.delegate?.getDataFail()
            }
        }
    }
    
    func updateProfile(_ data: [String: String]) {
        
        let parameters: Parameters = [
            "fullname": data["name"] as! String,
            "email": data["email"] as! String,
            "phone": data["phone"] as! String,
            "other_name": data["pic_alternative"] as! String,
            "other_phone": data["phone_alternative"] as! String,
            "parent_bank_id": data["bank"] as! String,
            "bank_name": data["bank_name"] as! String,
            "branch_id": data["bank_branch"] as! String,
            "branch_name": data["bank_branch_name"] as! String,
            "address": data["bank_branch_address"] as! String,
            "bank_type": data["bank_type"] as! String,
            "devisa": data["foreign_exchange"] as! String,
            "buku": data["book"] as! String,
            "sharia": data["sharia"] as! String,
            "interest_day_count_convertion": data["interest_day_count_convertion"] as! String,
            "end_date": data["end_date"] as! String,
            "return_start_date": data["return_to_start_date"] as! String,
            "holiday_interest": data["holiday_interest"] as! String,
            "password": data["password"] as! String,
            "password_confirmation": data["password_confirmation"] as! String,
        ]
        
        Alamofire.request(WEB_API_URL + "api/v1/me", method: .post, parameters: parameters, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                if response.response?.statusCode == 200 {
                    self.delegate?.isUpdateSuccess(true, localize("update_success"))
                } else {
                    self.delegate?.isUpdateSuccess(false, result["message"].stringValue)
                }
            case .failure(let error):
                self.delegate?.getDataFail()
            }
        }
    }
}
