//
//  DetailBidder.swift
//  Bahana
//
//  Created by RECTmedia MD102 on 10/05/21.
//  Copyright © 2021 Rectmedia. All rights reserved.
//

import Foundation
struct DetailBidder {
    var view: Int
    var rate: String
    var tenor: String
    var total_investment: String
    var detail_portfolio: [DetailPortfolio]
}

struct DetailPortfolio {
    var portfolio_id: Int
    var portfolio: String
    var nab_id: Int?
    var description: String
    var custodian_bank: String
    var bilyet: String
    var status: String
}
