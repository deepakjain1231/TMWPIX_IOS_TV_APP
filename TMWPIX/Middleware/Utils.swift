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

class utils {
    
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



class FocusableImageView: UIImageView {
    
    override var canBecomeFocused: Bool {
        return true
    }

    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {}
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.isFocused {
            // Change appearance when focused (e.g., increase size, change border color)
            self.layer.borderWidth = 5.0
            self.layer.borderColor = UIColor.fromHex(hexString: "#DE003F").cgColor
        } else {
            // Reset appearance when unfocused
            self.layer.borderWidth = 0.0
        }
    }
}

class FocusableImgView_NotSelected: UIImageView {
    
    override var canBecomeFocused: Bool {
        return true
    }

    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {}
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.isFocused {
            // Change appearance when focused (e.g., increase size, change border color)
            self.layer.borderWidth = 0.0
        } else {
            // Reset appearance when unfocused
            self.layer.borderWidth = 0.0
        }
    }
}


class FocusableView: UIView {
    
    override var canBecomeFocused: Bool {
        return true
    }

    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {}
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.isFocused {
            // Change appearance when focused (e.g., increase size, change border color)
            self.layer.borderWidth = 2.0
            self.layer.borderColor = UIColor.fromHex(hexString: "#DE003F").cgColor
        } else {
            // Reset appearance when unfocused
            self.layer.borderWidth = 0.0
        }
    }
}

class Focusable_NormarView: UIView {
    
    override var canBecomeFocused: Bool {
        return true
    }

    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {}
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.isFocused {
            // Change appearance when focused (e.g., increase size, change border color)
            self.layer.borderWidth = 0.0
            self.layer.borderColor = UIColor.clear.cgColor
        } else {
            // Reset appearance when unfocused
            self.layer.borderWidth = 0.0
        }
    }
}


class Focusable_Button: UIButton {
    override var canBecomeFocused: Bool {
        return true
    }

    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {}
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.isFocused {
            // Change appearance when focused (e.g., increase size, change border color)
            self.layer.borderWidth = 2.0
            self.layer.borderColor = UIColor.white.cgColor
            self.backgroundColor = AppColor.app_Light_RedColor
            self.layer.cornerRadius = 8
        } else {
            // Reset appearance when unfocused
            self.layer.cornerRadius = 8
            self.layer.borderWidth = 0.0
            self.backgroundColor = AppColor.app_Dark_RedColor
        }
    }
}

class Focusable_TextField: UITextField {
    override var canBecomeFocused: Bool {
        return true
    }

    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {}
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.isFocused {
            // Change appearance when focused (e.g., increase size, change border color)
            self.layer.borderWidth = 5.0
            self.layer.borderColor = AppColor.app_YelloColor.cgColor
            self.layer.cornerRadius = 8
        } else {
            // Reset appearance when unfocused
            self.layer.cornerRadius = 8
            self.layer.borderWidth = 0.0
        }
    }
}


class Focusable_BackButton: UIButton {
    
    override var canBecomeFocused: Bool {
        return true
    }

    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {}
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.isFocused {
            self.layer.borderWidth = 2.0
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.cornerRadius = 12
            
        } else {
            // Reset appearance when unfocused
            self.layer.borderWidth = 0.0
            self.layer.cornerRadius = 0
        }
    }
}

class Focusable_WhileBG_Button: UIButton {
    
    override var canBecomeFocused: Bool {
        return true
    }

    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {}
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.isFocused {
            self.layer.borderWidth = 2.0
            self.layer.borderColor = AppColor.app_Dark_RedColor.cgColor
            self.layer.cornerRadius = 12
            
        } else {
            // Reset appearance when unfocused
            self.layer.borderWidth = 0.0
            self.layer.cornerRadius = 0
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }
}


class Focusable_HomeButton: UIButton {
    
    override var canBecomeFocused: Bool {
        return true
    }

    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {}
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let arr_views = context.previouslyFocusedView?.superview?.superview?.subviews {
            for selected_view in arr_views {
                if (selected_view as? UIView)?.tag == 101 {
                    (selected_view as? UIView)?.isHidden = false
                }
                
                if (selected_view as? UIView)?.tag == 102 {
                    self.layer.borderWidth = 0.0
                    self.layer.borderColor = UIColor.clear.cgColor
                }
            }
        }
        
        if self.isFocused {
            // Change appearance when focused (e.g., increase size, change border color)
            if let arr_views = self.superview?.superview?.subviews {
                for selected_view in arr_views {
                    if (selected_view as? UIView)?.tag == 101 {
                        (selected_view as? UIView)?.isHidden = true
                    }
                    
                    if (selected_view as? UIView)?.tag == 102 {
                        self.layer.borderWidth = 4.0
                        self.layer.borderColor = UIColor.white.cgColor
                        self.layer.cornerRadius = 20
                    }
                }
            }
            
            
        } else {
            // Reset appearance when unfocused
            self.layer.borderWidth = 0.0
        }
    }
}

class Focusable_Label_Temp: UILabel {
    
    override var canBecomeFocused: Bool {
        return true
    }

    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {}
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if self.isFocused {
            // Change appearance when focused (e.g., increase size, change border color)
        } else {
            // Reset appearance when unfocused
        }
    }
}



struct AppColor {
    static let app_Dark_RedColor = #colorLiteral(red: 0.8705882353, green: 0, blue: 0.2470588235, alpha: 1) //DE003F
    static let app_Light_RedColor = #colorLiteral(red: 0.6352941176, green: 0.2039215686, blue: 0.1803921569, alpha: 1) //DE003F
    static let app_YelloColor = #colorLiteral(red: 0.9490196078, green: 0.662745098, blue: 0.231372549, alpha: 1) //DE003F
}


extension String {

    func isValidMobile() -> Bool {
        let PHONE_REGEX = "^[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    func isValidPassword(digit: Int = 7) -> Bool {
        //Minimum six characters, at least one letter and one number
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d].{\(digit),}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }

    
    func isValidString(value:String?) -> Bool {
         return value == "" || value == nil
    }
    
    func checkAcceptableValidation(AcceptedCharacters:String) -> Bool {
        let cs = NSCharacterSet(charactersIn: AcceptedCharacters).inverted
        let filtered = self.components(separatedBy: cs).joined(separator: "")
        if self != filtered{
            return false
        }
        return true
    }
    
    func byaddingLineHeight(linespacing:CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = linespacing  // Whatever line spacing you want in points
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    func trimed() -> String{
       return  self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}




class Focusable_CloseLarge_Button: UIButton {
    
    override var canBecomeFocused: Bool {
        return true
    }

    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {}
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        let lbl = UILabel.init(frame: CGRect.init(x: self.frame.width - 150, y: 0, width: 150, height: self.frame.height))
        lbl.tag = 200

        if self.isFocused {
            self.addSubview(lbl)
            lbl.layer.borderWidth = 2.0
            lbl.layer.borderColor = UIColor.white.cgColor
            lbl.layer.cornerRadius = 12
            
        } else {
            // Reset appearance when unfocused
            for subviewss in self.subviews {
                if (subviewss as? UILabel)?.tag == 200 {
                    (subviewss as? UILabel)?.removeFromSuperview()
                }
            }
            
            //lbl.layer.borderWidth = 0.0
            //lbl.layer.cornerRadius = 0
        }
    }
}


extension DispatchQueue {
    
    public func asyncDeduped(target: AnyObject, after delay: TimeInterval, execute work: @escaping @convention(block) () -> Void) {
        let dedupeIdentifier = DispatchQueue.dedupeIdentifierFor(target)
        if let existingWorkItem = DispatchQueue.workItems.removeValue(forKey: dedupeIdentifier) {
            existingWorkItem.cancel()
            NSLog("Deduped work item: \(dedupeIdentifier)")
        }
        let workItem = DispatchWorkItem {
            DispatchQueue.workItems.removeValue(forKey: dedupeIdentifier)
            for ptr in DispatchQueue.weakTargets.allObjects {
                if dedupeIdentifier == DispatchQueue.dedupeIdentifierFor(ptr as AnyObject) {
                    work()
                    NSLog("Ran work item: \(dedupeIdentifier)")
                    break
                }
            }
        }
        DispatchQueue.workItems[dedupeIdentifier] = workItem
        DispatchQueue.weakTargets.addPointer(Unmanaged.passUnretained(target).toOpaque())
        asyncAfter(deadline: .now() + delay, execute: workItem)
    }
}


// MARK: - Static Properties for De-Duping
private extension DispatchQueue {
    static var workItems = [AnyHashable : DispatchWorkItem]()
    static var weakTargets = NSPointerArray.weakObjects()
    static func dedupeIdentifierFor(_ object: AnyObject) -> String {
        return "\(Unmanaged.passUnretained(object).toOpaque())." + String(describing: object)
    }
}



class FocusableView_forBackButton: UIView {
    
    override var canBecomeFocused: Bool {
        return true
    }

    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {}
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.isFocused {
            // Change appearance when focused (e.g., increase size, change border color)
            if let arr_views = context.nextFocusedView?.subviews {
                if arr_views.first?.tag == 100 {
                    arr_views.first?.layer.cornerRadius = 8
                    arr_views.first?.layer.borderWidth = 2.0
                    arr_views.first?.layer.borderColor = UIColor.white.cgColor
                }
            }
        } else {
            // Reset appearance when unfocused
            self.layer.borderWidth = 0.0
            if let arr_views = context.previouslyFocusedView?.subviews {
                if arr_views.first?.tag == 100 {
                    arr_views.first?.layer.borderWidth = 0
                }
            }
        }
    }
}



class Focusable_Enable_Diable_Button: UIButton {
    override var canBecomeFocused: Bool {
        return true
    }

    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {}
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.isFocused {
            // Change appearance when focused (e.g., increase size, change border color)
            self.layer.borderWidth = 2.0
            self.layer.borderColor = UIColor.white.cgColor
            self.backgroundColor = AppColor.app_Light_RedColor
            self.layer.cornerRadius = 8
        } else {
            // Reset appearance when unfocused
            let userInfo = UserInfo.getInstance()
            
            self.layer.cornerRadius = 8
            self.layer.borderWidth = 0.0
            if userInfo?.podeAlugar == true {
                self.backgroundColor = AppColor.app_Dark_RedColor
            }
            else {
                self.backgroundColor = AppColor.app_Dark_RedColor.withAlphaComponent(0.6)
            }
        }
    }
}
