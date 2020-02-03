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
            default:
                break
            }
        }
    }
}
