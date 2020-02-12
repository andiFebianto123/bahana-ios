//
//  sharedCode.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/31.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire

//let WEB_API_URL = "http://localhost:8000/"
let WEB_API_URL = "http://192.168.1.25:8000/"

let primaryColor = UIColorFromHex(rgbValue: 0xd7181f)
let backgroundColor = UIColorFromHex(rgbValue: 0xeeeeee)
let titleLabelColor = UIColorFromHex(rgbValue: 0xaeaeae)

func setLocalData(_ data: [String:String]) {
    data.forEach {
        UserDefaults.standard.set($1, forKey: $0)
    }
}

func getLocalData(key: String) -> String {
    if let val = UserDefaults.standard.object(forKey: key) {
        return val as! String
    } else {
        return ""
    }
}

func isLoggedIn() -> Bool {
    if getLocalData(key: "user_id") != "" && getLocalData(key: "access_token") != "" {
        return true
    } else {
        return false
    }
}

func getAuthHeaders() -> HTTPHeaders {
    let token = getLocalData(key: "access_token")
    let headers: HTTPHeaders = [
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": "application/json",
        "Authorization": "Bearer \(token)"
    ]
    return headers
}

func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0) -> UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
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


extension UIViewController {
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
