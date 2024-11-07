//
//  UserInfo.swift
//  TMWPIX
//
//  Created by Apple on 15/08/2022.
//

import Foundation
import Alamofire

let kUserInfo = "UserInfo"
let kemail = "email"
let kpassword = "password"
let ktoken = "token"
let kclient_id = "client_id"
let kisLogin = "isLogin"
let kpodeAlugar = "podeAlugar"

class UserInfo: NSObject, NSCoding {

    var email : String?
    var password : String?
    var token : String?
    var client_id : Int?
    var isLogin = false
    var podeAlugar = false
    
    

    
    class func getInstance() -> UserInfo? {
//        if let data = UserDefaults.standard.object(forKey: kUserInfo) as? NSData {
//            return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? UserInfo
//        }
//        return UserInfo()
        if let data = UserDefaults.standard.object(forKey: kUserInfo) as? Data {
            do {
                if let savedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UserInfo {
                    return savedData
                } else {
                    return UserInfo()
                }
            } catch {
                return UserInfo()
            }
        }
        return UserInfo()
    }

    
    func saveUserInfo() {
//        let data = NSKeyedArchiver.archivedData(withRootObject: self)
//        UserDefaults.standard.set(data, forKey: kUserInfo)
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: kUserInfo)
        } catch {
            print("Couldn't save data")
        }
    }
    
    func removeUser() {
        let userInfo = UserInfo.getInstance()
        let userToken: String = userInfo?.token ?? ""
        
        let str_hashToken = utils.getHashToken(token: userToken)
        
        debugPrint("Token ====>>>\(token)")
        debugPrint("Token ====>>>\(userToken)")
        
        let strURL = Constants.baseUrl+Constants.API_METHOD_LOGOUT + "?hashtoken=\(str_hashToken)&usrtoken=\(userToken)&hash=\(utils.getHash())&user=&tipo=t&time=\(utils.getTime())&os=ios&dtoken=\(utils.getDToken())&operator=1&device_id=\(utils.getDeviceId())"

        AF.request(strURL, method: .get, parameters: nil).response { response in
            if let data = response.data {
                debugPrint("API====>>>\(strURL)\n\nResult=====>>\(response)")
               
            }
        }
        if email != nil { email = "" }
        if password != nil { password = "" }
        if token != nil { token = "" }
        if client_id != nil { client_id = 0 }
        if isLogin != nil { isLogin = false }
        if podeAlugar != nil { podeAlugar = false }
        if saveUserInfo != nil { saveUserInfo() }
    }
    
    
    func deleteUser() {
        let userInfo = UserInfo.getInstance()
        let userToken: String = userInfo?.token ?? ""
        
        let str_hashToken = utils.getHashToken(token: userToken)
        
        debugPrint("Token ====>>>\(token)")
        debugPrint("Token ====>>>\(userToken)")
        
        let strURL = "https://tmwpix.com/conta/cancelamento?os=ios&token=\(userToken)"

        AF.request(strURL, method: .get, parameters: nil).response { response in
            if let data = response.data {
                debugPrint("API====>>>\(strURL)\n\nResult=====>>\(response)")
               
            }
        }
        if email != nil { email = "" }
        if password != nil { password = "" }
        if token != nil { token = "" }
        if client_id != nil { client_id = 0 }
        if isLogin != nil { isLogin = false }
        if podeAlugar != nil { podeAlugar = false }
        if saveUserInfo != nil { saveUserInfo() }
    }
    
    //MARK: ecoding/decoding methods for custom objects
    required convenience init(coder decoder: NSCoder) {
        self.init()
        
        email = ""
        password = ""
        token = ""
        client_id = 0
        isLogin = false
        podeAlugar = false
        
        if let t_isLogin = decoder.decodeBool(forKey: kisLogin) as? Bool {
            self.isLogin = t_isLogin
        }
        if let t_podeAlugar = decoder.decodeBool(forKey: kpodeAlugar) as? Bool {
            self.podeAlugar = t_podeAlugar
        }
        if let t_email = decoder.decodeObject(forKey: kemail) as? String {
            self.email = t_email
        }
        if let t_password = decoder.decodeObject(forKey: kpassword) as? String {
            self.password = t_password
        }
        if let t_token = decoder.decodeObject(forKey: ktoken) as? String {
            self.token = t_token
        }
        if let t_client_id = decoder.decodeObject(forKey: kclient_id) as? Int {
            self.client_id = t_client_id
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.email, forKey: kemail)
        coder.encode(self.password, forKey: kpassword)
        coder.encode(self.isLogin, forKey: kisLogin)
        coder.encode(self.podeAlugar, forKey: kpodeAlugar)
        coder.encode(self.token, forKey: ktoken)
        coder.encode(self.client_id, forKey: kclient_id)
    }
}


