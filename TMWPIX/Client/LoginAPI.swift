//
//  LoginAPI.swift
//  TMWPIX
//
//  Created by Apple on 11/08/2022.
//

import Foundation
import Alamofire


class LoginAPI{
    
    static func getLoginFirstTimeData(token: String, delegate: ViewController){

        let str_hashToken = utils.getHashToken(token: token)
        let strURL = Constants.baseUrl+Constants.API_METHOD_LOGIN + "?appversion=\(utils.getAppVersion())&device_name=\(utils.getDeviceName())&hashtoken=\(str_hashToken)&usrtoken=\(token)&hash=\(utils.getHash())&user=&tipo=t&platform=\(utils.getPlatform())&time=\(utils.getTime())&os=ios&dtoken=\(utils.getDToken())&operator=1&device_id=\(utils.getDeviceId())"

        AF.request(strURL, method: .get, parameters: nil).response { response in
            if let data = response.data {
                debugPrint("API====>>>\(strURL)\n\nResult=====>>\(response.result)")
                do {
                    let dictonary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                    var profiles: [UserProfile] = []
                    
                    let profileData = dictonary!["profiles"]
                    if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                        let userInfo = UserInfo.getInstance()
                        for aDic in arrayOfDic {
                            let User = UserProfile()
                            if let id = aDic["id"] as? Int {
                                User.id = id
                            }
                            
                            if let name = aDic["name"] as? String{
                                User.name = name
                            }
                            
                            if let client_id = aDic["client_id"] as? Int{
                                User.client_id = client_id
                            }
                            
                            if let infantil = aDic["infantil"] as? Int{
                                User.infantil = infantil
                            }
                            
                            if let cpf = aDic["cpf"] as? String{
                                User.cpf = cpf
                            }
                            
                            if let email = aDic["email"] as? String{
                                User.email = email
                            }
                            
                            if let password = aDic["password"] as? String{
                                User.password = password
                            }
                            if let AluguelGratisRestante = aDic["AluguelGratisRestante"] as? Int{
                                User.AluguelGratisRestante = AluguelGratisRestante
                            }
                            
                            if let senha = aDic["senha"] as? String{
                                User.senha = senha
                            }
                            profiles.append(contentsOf: [User])
                        }
                                
                        userInfo?.isLogin = true
                        userInfo?.token = token
                        userInfo?.saveUserInfo()
                        delegate.loginResponseHandler(userInfo: userInfo!, errorMessage: "", profileData: profiles)
                    }else{
                        let userInfo = UserInfo.getInstance()
                        userInfo?.isLogin = false
                        userInfo?.saveUserInfo()
                        let error = dictonary!["error"]
                        delegate.loginResponseHandler(userInfo: userInfo!, errorMessage: error!["message"] as! String, profileData: nil)
                    }
                    
                } catch let error as NSError {
                    print(error)
                    let userInfo = UserInfo.getInstance()
                    userInfo?.isLogin = false
                    userInfo?.saveUserInfo()
                    delegate.loginResponseHandler(userInfo: userInfo!, errorMessage: "", profileData: nil)
                }
            }
        }
    }
    
    func getLoginFirstTimeData(token: String, delegate: ViewController){
        
        let str_hashToken = utils.getHashToken(token: token)
        let strURL = Constants.baseUrl+Constants.API_METHOD_LOGIN + "?appversion=\(utils.getAppVersion())&device_name=\(utils.getDeviceName())&hashtoken=\(str_hashToken)&usrtoken=\(token)&hash=\(utils.getHash())&user=&tipo=t&platform=\(utils.getPlatform())&time=\(utils.getTime())&os=ios&dtoken=\(utils.getDToken())&operator=1&device_id=\(utils.getDeviceId())"

        AF.request(strURL, method: .get, parameters: nil)
            .response{ response in
                
                if let data = response.data {
                    
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        
                        let profileData = dictonary!["profiles"]
                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                            for aDic in arrayOfDic{
#if TARGET_OS_IOS
                                let userInfo = TMWPIX.UserInfo.getInstance()
#else
                                let userInfo = TMWPIXtvOS.UserInfo.getInstance()
#endif
                                
                                //                                    print(aDic)//print each of the dictionaries
                                if let Email = aDic["email"] as? String{
                                    print(Email)//print price of each dic
                                    userInfo!.email = Email
                                }
                                
                                if let Pass = aDic["senha"] as? String{
                                    print(Pass)//print price of each dic
                                    userInfo!.password = Pass
                                }
                                //                                self.UserInfo.append(contentsOf: [User])
                            }
                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
        
        
        func getLoginSecondTimeData(){
            let params = ["user" : "",
                          "time" : "1657435701486",
                          "hash" : "3f9b7d853e407cc1159077ad82b0fb1d",
                          "dtoken" : "d41d8cd98f00b204e9800998ecf8427e",
                          "os" : "ios",
                          "operator" : "1",
                          "tipo" : "t",
                          "usrtoken" : "APP123",
                          "hashtoken" : "aa2dd11aad8d9664a4cd9ac33b49caa9",
                          "device_id" : "7f3e54b720a6f34e",
                          "device_name" : "sdk_google_atv_x86",
                          "platform" : "apple",
                          "appversion" : "1.3.1"]
            
            let str_url = Constants.baseUrl+Constants.API_METHOD_LOGIN
            AF.request(str_url, parameters: params)
                .response{ [self] response in
                    
                    if let data = response.data {
                        print(data)
                        debugPrint("API====>>>\(str_url)\n\nParam=====>>\(params)\n\nResult=====>>\(response.result)")
                        print(response.result)
                        do {
                            let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                            
                            let profileData = dictonary!["profiles"]
                            if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                                for aDic in arrayOfDic{
#if TARGET_OS_IOS
                                    let userInfo = TMWPIX.UserInfo.getInstance()
#else
                                    let userInfo = TMWPIXtvOS.UserInfo.getInstance()
#endif
                                    
                                    //                                    print(aDic)//print each of the dictionaries
                                    if let Email = aDic["email"] as? String{
                                        print(Email)//print price of each dic
                                        userInfo?.email = Email
                                    }
                                    
                                    if let Pass = aDic["senha"] as? String{
                                        print(Pass)//print price of each dic
                                        userInfo?.password = Pass
                                    }
                                    //                                    self.UserInfo.append(contentsOf: [User])
                                }
                            }
                            
                        } catch let error as NSError {
                            print(error)
                        }
                    }
                    
                }
        }
    }
    
    
    static func getMobileNumbers_Data(delegate: ViewController){
        
        let str_URL = Constants.baseUrl + Constants.API_METHOD_GET_MOBILE_INFO
        
        AF.request(str_URL, method: .get, parameters: nil).response{response in
            if let data = response.data {
                print(data)
                print(response.result)
                do {
                    let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [[String: Any]]
                    
                    let contactData = Contact_Info_Model()
                    
                    if let arrayOfDic = dictonary as? [Dictionary<String,AnyObject>] {

                        contactData.contactInfo = [ContactInfo]()
                        
                        for aDic in arrayOfDic {
                            let contact = ContactInfo()
                            
                            if let id = aDic["id"] as? Int {
                                contact.id = id
                            }
                            if let ddd = aDic["ddd"] as? String {
                                contact.ddd = ddd
                            }
                            if let numero = aDic["numero"] as? String {
                                contact.numero = numero
                            }
                            if let ativo = aDic["ativo"] as? Int {
                                contact.ativo = ativo
                            }
                            contactData.contactInfo?.append(contact)
                        }
                        delegate.contact_information_ResponseHandler(contactInfo: contactData, errorMessage: "")
                    }
                    else {
                        delegate.contact_information_ResponseHandler(contactInfo: contactData, errorMessage: "")
                    }
                } catch let error as NSError {
                    print(error)
                    let contactData = Contact_Info_Model()
                    delegate.contact_information_ResponseHandler(contactInfo: contactData, errorMessage: "")
                }
            }
        }
    }
}
