//
//  FaqPresenter.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/10.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol FaqDelegate {
    func setData(_ data: [Faq])
}

class FaqPresenter {
    private var delegate: FaqDelegate?
    
    init(delegate: FaqDelegate){
        self.delegate = delegate
    }
    
    func getData() {
        Alamofire.request(WEB_API_URL + "api/v1/question", method: .get, headers: getAuthHeaders()).responseJSON { response in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                if response.response?.statusCode == 401 {
                    //
                } else {
                    var faqs = [Faq]()
                    for faq in result.arrayValue {
                        let id = faq["id"].intValue
                        let question = faq["question"].stringValue
                        let answer = faq["answer"].stringValue
                        let topic_id = faq["topic_id"].intValue
                        let topic = Topic(id: faq["topic"]["id"].intValue, name: faq["topic"]["name"].stringValue)
                        
                        faqs.append(Faq(id: id, topic_id: topic_id, question: question, answer: answer, topic: topic))
                    }
                    
                    self.delegate?.setData(faqs)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
