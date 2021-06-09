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
//let WEB_API_URL = "http://192.168.8.105:8000/"
//let WEB_API_URL = "http://157.245.192.5/bahana/public/"
//let WEB_API_URL = "https://dams.bahanatcw.com/"
//let WEB_API_URL = "http://192.168.43.51/dams2/public/"

let WEB_API_URL = "http://localhost/dams2/public/"

let APP_STORE_URL = "https://itunes.apple.com/id/app/dams/id123456?mt=8"

// Colors
let primaryColor = UIColorFromHex(rgbValue: 0xd7181f)
let backgroundColor = UIColorFromHex(rgbValue: 0xeeeeee)
let titleLabelColor = UIColorFromHex(rgbValue: 0xa7a7a7)
let accentColor = UIColorFromHex(rgbValue: 0xffc74d)
let blueColor = UIColorFromHex(rgbValue: 0x3e99ff)
let darkGreyColor = UIColorFromHex(rgbValue: 0x3f3f3f)
let darkRedColor = UIColorFromHex(rgbValue: 0x8b171a)
let darkYellowColor = UIColorFromHex(rgbValue: 0x9b870c)
let greenColor = UIColorFromHex(rgbValue: 0x87cc62)
let hintColor = UIColorFromHex(rgbValue: 0x000000)
let lightGreenColor = UIColorFromHex(rgbValue: 0x90ee90)
let primaryDarkColor = UIColorFromHex(rgbValue: 0xc0151c)
let lightGreyColor = UIColorFromHex(rgbValue: 0xd3d3d3)
let lightRedColor = UIColorFromHex(rgbValue: 0xfee1e1)
let yellowColor = UIColorFromHex(rgbValue: 0xfac906)

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

func localize(_ key: String, _ defaultLang: String? = nil) -> String {
    var lang = String()
    switch getLocalData(key: "language") {
    case "language_id":
        lang = "id"
    case "language_en":
        lang = "en"
    default:
        break
    }
    lang = defaultLang != nil ? defaultLang! : lang
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

func getHeaders(auth: Bool = false) -> HTTPHeaders {
    var headers: HTTPHeaders!
    if auth {
        let token = getLocalData(key: "access_token")
        headers = [
            "X-Requested-With": "XMLHttpRequest",
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json",
            "Authorization": "Bearer \(token)"
        ]
    } else {
        headers = [
            "X-App-Version": "1.0",
            "X-App-Version-Ios": getAppVersion(),
            "X-Requested-With": "XMLHttpRequest"
        ]
    }
    
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
    date.locale = Locale(identifier: "en_US_POSIX")
    date.dateFormat = "yyyy-MM-dd"
    let time = date.date(from: str)
    //date.dateFormat = "MM"
    //print(date.string(from: time!))
    return time
}

func convertStringToDatetime(_ str: String?) -> Date? {
    if str != nil {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_US_POSIX")
        date.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = date.date(from: str!)
        return time
    } else {
        return nil
    }
}

func convertDateToString(_ date: Date?, format: String = "dd MM yy") -> String? {
    if date != nil {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        //str.dateFormat = "yyyy-MM-dd"
        var newDate = String()
        let formats = format.components(separatedBy: " ")
        for (idx, f) in formats.enumerated() {
            formatter.dateFormat = f
            var str = formatter.string(from: date!)
            
            if f == "MM" {
                switch str {
                case "01":
                    str = localize("january")
                case "02":
                    str = localize("february")
                case "03":
                    str = localize("march")
                case "04":
                    str = localize("april")
                case "05":
                    str = localize("may")
                case "06":
                    str = localize("june")
                case "07":
                    str = localize("july")
                case "08":
                    str = localize("august")
                case "09":
                    str = localize("september")
                case "10":
                    str = localize("october")
                case "11":
                    str = localize("november")
                case "12":
                    str = localize("december")
                default:
                    break
                }
            }
            
            if idx == formats.count - 1 {
                newDate += "\(str)"
            } else {
                newDate += "\(str) "
            }
        }
        return newDate
    } else {
        return nil
    }
}

func convertTimeToString(_ date: Date?) -> String? {
    if date != nil {
        let str = DateFormatter()
        str.locale = Locale(identifier: "en_US_POSIX")
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
    str.locale = Locale(identifier: "en_US_POSIX")
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

func toRp(_ number: Double) -> String{
//    let symbols = DecimalFormatSymbols(Locale.US)
//    let formatter = DecimalFormat("#,###.###", symbols)
//    return formatter.format(number)
    var formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "en_US")
//    formatter.numberStyle = .currency
    formatter.numberStyle = NumberFormatter.Style.decimal
    formatter.groupingSeparator = "."
    return formatter.string(from: NSNumber(value: number)) ?? ""
}

func toIdrBio(_ number: Double) -> String {
    let newNumber = number / 1000000000
    //return toRp(newNumber)
//    let numToStr = newNumber.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", newNumber) : String(newNumber)
    // return numToStr
    return toRp(newNumber)
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
    Alamofire.request(WEB_API_URL + "api/v1/notification/unread", method: .get, headers: getHeaders(auth: true)).responseJSON { response in
        switch response.result {
        case .success:
            let result = JSON(response.result.value!)
            completion(result["count"].intValue)
        case .failure(let error):
            print(error)
        }
    }
}

func isAppUpdateAvailable(completion: @escaping (_ isUpdateAvailable: Bool) -> Void) {
    Alamofire.request(WEB_API_URL + "api/v1/version", method: .post, headers: getHeaders()).responseJSON { response in
        switch response.result {
        case .success:
            let result = JSON(response.result.value!)
            let update = result["update_ios"].stringValue
            if update.lowercased() == "yes" {
                completion(true)
            } else if update.lowercased() == "no" {
                completion(false)
            }
        case .failure(let error):
            print(error)
            completion(false)
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


func getSafeAreaInset(_ pos: String) -> CGFloat {
    var topPadding: CGFloat = 20
    var bottomPadding: CGFloat = 0
    if #available(iOS 11.0, *) {
        let window = UIApplication.shared.keyWindow
        topPadding = (window?.safeAreaInsets.top)!
        bottomPadding = (window?.safeAreaInsets.bottom)!
    }
    
    if pos == "top" {
        return topPadding
    } else if pos == "bottom" {
        return bottomPadding
    } else {
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

func isEmailValid(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
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

extension Notification.Name {
    static let languageChanged = Notification.Name("LanguageChanged")
    static let refreshAuctionDetail = Notification.Name("AuctionDetailRefresh")
}
