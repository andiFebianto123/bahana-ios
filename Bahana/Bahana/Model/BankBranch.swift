//
//  BankBranch.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/31.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

struct BankBranch {
    let id: String
    let name: String
    let code: String
    
    init(id:String, name:String, code: String) {
        self.id = id
        self.name = name
        self.code = code
    }
}

extension BankBranch: SearchableItem {
    func matchesSearchQuery(_ query: String) -> Bool {
        return name.uppercased().contains(query.uppercased())
    }
}

extension BankBranch: Equatable {
    static func ==(rhs: BankBranch, lhs: BankBranch) -> Bool {
        return rhs.id == lhs.id
    }
}

extension BankBranch: CustomStringConvertible {
    var description: String {
        return id
    }
}
