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
        
        let params = ["user" : "",
                      "time" : utils.getTime(),
                      "hash" : utils.getHash(),
                      "dtoken" : utils.getDToken(),
                      "os" : "ios",
                      "operator" : "1",
                      "tipo" : "t",
                      "usrtoken" : token,
                      "hashtoken" : utils.getHashToken(token: token),
                      "device_id" : "f3e54b720a6f34e",//utils.getDeviceId(),
                      "device_name" : utils.getDeviceName(),
                      "platform" : utils.getPlatform(),
                      "appversion" : "1.3.1"]
        
//        user=&time=1657435701486&hash=3f9b7d853e407cc1159077ad82b0fb1d&dtoken=d41d8cd98f00b204e9800998ecf8427e&os=android&operator=1&tipo=t&usrtoken=APP1234&hashtoken=aa2dd11aad8d9664a4cd9ac33b49caa9&device_id=7f3e54b720a6f34e&device_name=sdk_google_atv_x86&platform=android&appversion=1.3.1
        
        AF.request(Constants.baseUrl+Constants.API_METHOD_LOGIN, parameters: params)
            .response{response in
                let data = response.data
                if let data = response.data {
                    print(data)
                    print(response.result)
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        
                        let profileData = dictonary!["profiles"]
                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                            let userInfo = UserInfo.getInstance()
                            for aDic in arrayOfDic{
                                
                                //                                    print(aDic)//print each of the dictionaries
                                if let Email = aDic["email"] as? String{
                                    print(Email)//print price of each dic
                                    userInfo?.email = Email
                                }
                                
                                if let Pass = aDic["senha"] as? String{
                                    print(Pass)//print price of each dic
                                    userInfo?.password = Pass
                                }
                                
                                if let client_id = aDic["client_id"] as? Int{
                                    userInfo?.client_id = client_id
                                }
                            }
                            userInfo?.isLogin = true
                            userInfo?.token = token
                            userInfo?.saveUserInfo()
                            delegate.loginResponseHandler(userInfo: userInfo!, errorMessage: "")
                        }else{
                            let userInfo = UserInfo.getInstance()
                            userInfo?.isLogin = false
                            userInfo?.saveUserInfo()
                            let error = dictonary!["error"]
                            delegate.loginResponseHandler(userInfo: userInfo!, errorMessage: error!["message"] as! String)
                        }
                        
                    } catch let error as NSError {
                        print(error)
                        let userInfo = UserInfo.getInstance()
                        userInfo?.isLogin = false
                        userInfo?.saveUserInfo()
                        delegate.loginResponseHandler(userInfo: userInfo!, errorMessage: "")
                    }
                }
            }
    }
    
    func getLoginFirstTimeData(){
        
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
        
        AF.request(Constants.baseUrl+Constants.API_METHOD_LOGIN, parameters: params)
            .response{ response in
                
                if let data = response.data {
                    print(data)
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
            
            AF.request(Constants.baseUrl+Constants.API_METHOD_LOGIN, parameters: params)
                .response{ [self] response in
                    
                    if let data = response.data {
                        print(data)
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
}
