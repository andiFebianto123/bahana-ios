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
                self.delegate?.setBanks(banks)
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
                        let firstIssuer = res["issuers"][0].arrayValue.first
                        let branch = BankBranch.init(id: String(res["id"].intValue), name: res["description"].stringValue, code: res["branch_code"].stringValue)
                        branchs.append(branch)
                    } else {
                        let branch = BankBranch.init(id: String(res["id"].intValue), name: res["branch_name"].stringValue, code: res["branch_code"].stringValue)
                        branchs.append(branch)
                    }
                }
                self.delegate?.setBankBranchs(branchs)
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
                options["bank_type"]?.append("")
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
                options["book"]?.append("")
                for b in result["buku"].arrayValue {
                    options["book"]?.append(b.stringValue)
                }
                
                // Sharia
                options["sharia"] = [String]()
                options["sharia"]?.append("")
                for s in result["sharia"].arrayValue {
                    options["sharia"]?.append(s.stringValue)
                }
                
                // Interest day count convertion
                options["interest_day_count_convertion"] = [String]()
                options["interest_day_count_convertion"]?.append("")
                for idcc in result["interest_day_count_convertion"].arrayValue {
                    options["interest_day_count_convertion"]?.append(idcc.stringValue)
                }
                
                // End date
                options["end_date"] = [String]()
                options["end_date"]?.append("")
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
                options["holiday_interest"]?.append("")
                for hi in result["holiday_interest"].arrayValue {
                    options["holiday_interest"]?.append(hi.stringValue)
                }
                
                self.delegate?.setOptions(options)
            case .failure(let error):
                self.delegate?.getDataFail()
            }
        }
    }
}
