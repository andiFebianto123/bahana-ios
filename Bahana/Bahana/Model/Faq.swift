//
//  Faq.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/10.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation

struct Faq {
    var id: Int
    var topic_id: Int
    var question: String
    var answer: String
    var topic: Topic
}

struct Topic {
    var id:Int
    var name : String
}
