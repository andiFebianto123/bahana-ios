//
//  sharedCode.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/31.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation

let WEB_API_URL = "http://localhost:8000/"
//let WEB_API_URL = "http://192.168.0.100:8000/"

func saveProfileForm(_ data: [String:String]) {
    for arr in data {
        //array.k
        //UserDefaults.standard.set(value, forKey: key)
    }
}

func getProfileForm(key: String) -> String {
    if let val = UserDefaults.standard.object(forKey: key) {
        return val as! String
    } else {
        return ""
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
