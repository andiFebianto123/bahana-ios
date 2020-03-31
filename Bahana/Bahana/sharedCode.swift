//
//  sharedCode.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/31.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//let WEB_API_URL = "http://localhost:8000/"
//let WEB_API_URL = "http://192.168.1.25:8000/"
let WEB_API_URL = "http://159.65.15.108/bahana/public/"

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

func localize(_ key: String) -> String {
    var lang = String()
    switch getLocalData(key: "language") {
    case "language_id":
        lang = "id"
    case "language_en":
        lang = "en"
    default:
        break
    }
    let path = Bundle.main.path(forResource: lang, ofType: "lproj")
    let bundle = Bundle(path: path!)
    return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: "", comment: "")
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

func getAppVersion() -> String {
    return (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String)!
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

func convertStringToDate(_ str: String) -> Date? {
    let date = DateFormatter()
    date.dateFormat = "yyyy-MM-dd"
    let time = date.date(from: str)
    return time
}

func convertStringToDatetime(_ str: String?) -> Date? {
    if str != nil {
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = date.date(from: str!)
        return time
    } else {
        return nil
    }
}

func convertDateToString(_ date: Date?, format: String = "dd MMM yy") -> String? {
    if date != nil {
        let str = DateFormatter()
        //str.dateFormat = "yyyy-MM-dd"
        str.dateFormat = format
        let time = str.string(from: date!)
        return time
    } else {
        return nil
    }
}

func convertTimeToString(_ date: Date?) -> String? {
    if date != nil {
        let str = DateFormatter()
        //str.dateFormat = "yyyy-MM-dd"
        str.dateFormat = "HH:mm"
        let time = str.string(from: date!)
        return time
    } else {
        return nil
    }
}

func convertDatetimeToString(_ date: Date) -> String {
    let str = DateFormatter()
    str.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let time = str.string(from: date)
    return time
}

func calculateDateDifference(_ date1: Date, _ date2: Date) -> [String: Int] {
    let delta = date2.timeIntervalSince(date1)
    let time = Int(delta)
    let minutes = (time / 60) % 60
    let hours = (time / 3600)
    
    let resp: [String: Int] = [
        "hour": hours,
        "minute": minutes
    ]
    
    return resp
}

func toIdrBio(_ number: Double) -> String {
    let newNumber = number / 1000000000
    //return toRp(newNumber)
    let numToStr = newNumber.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", newNumber) : String(newNumber)
    return numToStr
}

func checkPercentage(_ number: Double) -> String {
    let numToStr = number.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", number) : String(number)
    return numToStr
}

/*
func toRp(_ number: Double) -> String {
    let formater = NumberFormatter()
    formater.groupingSeparator = "."
    formater.numberStyle = .decimal
    let formattedNumber = formater.string(from: Int(number))
    return formattedNumber
}
*/

func getUnreadNotificationCount(completion: @escaping (_ count: Int) -> Void) {
    Alamofire.request(WEB_API_URL + "api/v1/notification/unread", method: .get, headers: getAuthHeaders()).responseJSON { response in
        switch response.result {
        case .success:
            let result = JSON(response.result.value!)
            completion(result["count"].intValue)
        case .failure(let error):
            print(error)
        }
    }
}

func getDeviceScreenSize() -> Double {
    switch UIScreen.main.nativeBounds.height {
    case 1136:
        return 4
    case 1334:
        return 4.7
    case 1920, 2208:
        return 5.5
    case 2436:
        return 5.8
    case 1792:
        return 6.1
    case 2688:
        return 6.5
    default:
        return 0
    }
}

func getNavigationHeight() -> CGFloat {
    switch getDeviceScreenSize() {
    case 4, 4.7, 5.5:
        return 64
    default:
        return 84
    }
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

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
