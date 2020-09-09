//
//  ContactPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/10.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol ContactDelegate {
    func setData(_ data: [Contact])
    func getDataFail()
    func openLoginPage()
}

class ContactPresenter {
    private var delegate: ContactDelegate?
    
    init(delegate: ContactDelegate){
        self.delegate = delegate
    }
    
    func getData() {
        Alamofire.request(WEB_API_URL + "api/v1/contacts", method: .get).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                if response.response?.statusCode == 401 {
                    self.delegate?.openLoginPage()
                } else {
                    var contacts = [Contact]()
                    for contact in result.arrayValue {
                        let name = contact["name"].stringValue
                        let phone = contact["phone"].stringValue
                        let position = contact["position"].stringValue
                        contacts.append(Contact(name: name, phone: phone, position: position))
                    }
                    
                    self.delegate?.setData(contacts)
                }
            case .failure(let error):
                print(error)
                self.delegate?.getDataFail()
            }
        }
    }
}
