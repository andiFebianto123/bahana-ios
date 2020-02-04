//
//  Bank.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/31.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

struct Bank {
    let id: String
    let name: String
    let code: String
    
    init(id:String, name:String, code: String) {
        self.id = id
        self.name = name
        self.code = code
    }
}

extension Bank: SearchableItem {
    func matchesSearchQuery(_ query: String) -> Bool {
        return name.uppercased().contains(query.uppercased())
    }
}

extension Bank: Equatable {
    static func ==(rhs: Bank, lhs: Bank) -> Bool {
        return rhs.id == lhs.id
    }
}

extension Bank: CustomStringConvertible {
    var description: String {
        return id
    }
}
