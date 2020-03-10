//
//  AuctionDetailPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/24.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol AuctionDetailDelegate {
    func setData(_ data: Auction, _ viewType: Int)
}

class AuctionDetailPresenter {
    
    private var delegate: AuctionDetailDelegate?
    
    init(delegate: AuctionDetailDelegate){
        self.delegate = delegate
    }
}
