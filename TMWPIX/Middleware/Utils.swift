//
//  Utils.swift
//  TMWPIX
//
//  Created by Apple on 17/08/2022.
//

import Foundation
import UIKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

extension UIImageView {
    func loadImagefromUrl(urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

class utils{
    
    static func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
    
    static func getAppVersion() -> String{
        return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!
    }
    
    static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func UIColorFromRGBValue(red: CGFloat, green: CGFloat, blue:CGFloat) -> UIColor {
        return UIColor(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    static func getLocalTime() -> Date {
        let timestamp = Date().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = Date(timeIntervalSince1970: TimeInterval(myTimeInterval))
        return time
    }
    static func isCurrentTimeisInRange(startTime: String, endTime: String) -> Bool{
        let nowDateValue = getLocalTime()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let date1 = formatter.date(from: startTime)!
        let date2 = formatter.date(from: endTime)!
        
        if nowDateValue >= date1 &&
            nowDateValue <= date2
        {
            return true
        }else{
            return false
        }
        
    }
    static func getCurrentTimeDifferenceInMins() -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date1 = dateFormatter.date(from: dateFormatter.string(from: getLocalTime()))!

        let elapsedTime = getLocalTime().timeIntervalSince(date1)
        let hours = floor(elapsedTime / 60 / 60)
        let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
        let totalMins = minutes + (hours*60)
        
        return Int(totalMins)

    }
    static func getTimeDifferenceInMins(startTime: String, endTime: String) -> Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")

        var date1 = formatter.date(from: startTime)!
        let date2 = formatter.date(from: endTime)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date3 = dateFormatter.date(from: dateFormatter.string(from: getLocalTime()))!

        if date1 < date3 {
            date1 = date3
        }
        if date2 < date1 {
            var dayComponent    = DateComponents()
            dayComponent.day    = 1 // For removing one day (yesterday): -1
            let theCalendar     = Calendar.current
            let nextDate        = theCalendar.date(byAdding: dayComponent, to: getLocalTime())
            print("nextDate : \(nextDate)")

        }
        
        let elapsedTime = date2.timeIntervalSince(date1)
        
        // convert from seconds to hours, rounding down to the nearest hour
        let hours = floor(elapsedTime / 60 / 60)
        
        // we have to subtract the number of seconds in hours from minutes to get
        // the remaining minutes, rounding down to the nearest minute (in case you
        // want to get seconds down the road)
        let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
        let totalMins = minutes + (hours*60)
        
        return Int(totalMins)
        //            print("\(Int(hours)) hr and \(Int(minutes)) min")
        
    }
    static func getPlatform() -> String{
        return UIDevice.current.model
    }
    
    static func getDeviceName() -> String{
        return UIDevice.current.name
    }
    
    static func getDeviceId() -> String{
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    static func getOperatingSystem() -> String{
        return UIDevice.current.systemName
    }
    
    static func getTime() -> String{
        return String(format: "%f", Date().timeIntervalSinceReferenceDate)
    }
    
    static func getHash() -> String{
        let md5Data = utils.MD5(string: String(format: "%f", Date().timeIntervalSinceReferenceDate)+"*"+"")
        let hash =  md5Data.map { String(format: "%02hhx", $0) }.joined()
        return hash
    }
    
    static func getHashToken(token: String) -> String{
        let md5Data = utils.MD5(string: String(format: "%f", Date().timeIntervalSinceReferenceDate)+"*"+token)
        let hashToken =  md5Data.map { String(format: "%02hhx", $0) }.joined()
        return hashToken
    }
    static func getDToken() -> String{
        let md5Data = utils.MD5(string: "")
        let hash =  md5Data.map { String(format: "%02hhx", $0) }.joined()
        return hash
    }
    static func md5(string: String) -> String{
        let md5Data = utils.MD5(string: string)
        let hash =  md5Data.map { String(format: "%02hhx", $0) }.joined()
        return hash
    }
    static func getHomeButtonsBGColor() -> UIColor{
        return UIColor(white:0, alpha: 0.25)
    }
    
    static func showDestructiveAlert(message: String, presentationController: UIViewController){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }
        }))
        presentationController.present(alert, animated: true, completion: nil)
    }
    
    
    
}
