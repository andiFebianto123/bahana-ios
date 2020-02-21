//
//  Bid.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/21.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

struct Bid {
    let id: Int
    let status: String
    let tenor: String
    let interest_rate_idr: String?
    let interest_rate_usd: String?
    let interest_rate_sharia: String?
    
    init(id:Int, status:String, tenor: String, interest_rate_idr: String?, interest_rate_usd: String?, interest_rate_sharia: String?) {
        self.id = id
        self.status = status
        self.tenor = tenor
        self.interest_rate_idr = interest_rate_idr
        self.interest_rate_usd = interest_rate_usd
        self.interest_rate_sharia = interest_rate_sharia
    }
}
