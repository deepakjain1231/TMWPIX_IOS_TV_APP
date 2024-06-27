//
//  ProfileAPI.swift
//  TMWPIX
//
//  Created by Apple on 18/08/2022.
//

import Foundation
import Alamofire


class ProfileAPI{
    
//    static var UserInfo: [UserProfile] = []
    
    static func getProfileData(delegate: ProfileViewController){
        let userInfo = UserInfo.getInstance()
        let params = ["user" : "",
                      "time" : utils.getTime(),
                      "hash" : utils.getHash(),
                      "dtoken" : utils.getDToken(),
                      "os" : "ios",
                      "operator" : "1",
                      "tipo" : "t",
                      "usrtoken" : userInfo?.token,
                      "hashtoken" : utils.getHashToken(token: (userInfo?.token)!),
                      "device_id" : utils.getDeviceId(),
                      "device_name" : utils.getDeviceName(),
                      "platform" : utils.getPlatform(),
                      "appversion" : utils.getAppVersion()]
        
        
        AF.request(Constants.baseUrl+Constants.API_METHOD_LOGIN, parameters: params)
            .response{  response in
                
                if let data = response.data {
                    print(data)
                    print(response.result)
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        var profiles: [UserProfile] = []
                        let profileData = dictonary!["profiles"]
                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                            for aDic in arrayOfDic{
                                let User = UserProfile()
                                
                                if let id = aDic["id"] as? Int{
                                    //                                    print(id)
                                    User.id = id
                                }
                                
                                if let name = aDic["name"] as? String{
                                    //                                    print(name)
                                    User.name = name
                                }
                                if let client_id = aDic["client_id"] as? Int{
                                    //                                    print(client_id)
                                    User.client_id = client_id
                                }
                                if let infantil = aDic["infantil"] as? Int{
                                    //                                    print(infantil)
                                    User.infantil = infantil
                                }
                                if let cpf = aDic["cpf"] as? String{
                                    //                                    print(cpf)
                                    User.cpf = cpf
                                }
                                if let email = aDic["email"] as? String{
                                    //                                    print(email)
                                    User.email = email
                                }
                                if let password = aDic["password"] as? String{
                                    //                                    print(password)
                                    User.password = password
                                }
                                if let AluguelGratisRestante = aDic["AluguelGratisRestante"] as? Int{
                                    //                                    print(AluguelGratisRestante)
                                    User.AluguelGratisRestante = AluguelGratisRestante
                                }
                                if let senha = aDic["senha"] as? String{
                                    //                                    print(senha)
                                    User.senha = senha
                                }
                                
                                profiles.append(contentsOf: [User])
                            }
                            delegate.ProfileResponseHandler(profileData: profiles)
                        }
                        
                    } catch let error as NSError {
                        print(error)
                        getProfileData(delegate: delegate)
                    }
                } else {
                    getProfileData(delegate: delegate)
                }
            }
    }
    
    static func removeProfile(profileId: String, delegate: ProfileViewController){
        let userInfo = UserInfo.getInstance()
        let params = ["user" : "",
                      "time" : utils.getTime(),
                      "hash" : utils.getHash(),
                      "dtoken" : utils.getDToken(),
                      "id" : profileId,
                      "os" : "ios",
                      "operator" : "1",
                      "tipo" : "t",
                      "usrtoken" : userInfo?.token,
                      "hashtoken" : utils.getHashToken(token: (userInfo?.token)!),
                      "device_id" : utils.getDeviceId(),
                      "device_name" : utils.getDeviceName(),
                      "platform" : utils.getPlatform(),
                      "appversion" : utils.getAppVersion()]
        
        
        AF.request(Constants.baseUrl+Constants.API_METHOD_PROFILEDELETE, parameters: params)
            .response{  response in
                
                if let data = response.data {
                    print(data)
                    print(response.result)
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        let profileStatus = dictonary!["success"] as! String
                            if profileStatus == "Profile is successfully deleted" {
                                delegate.deleteProfileResponseHandler(errorMessage: "")
                            }else{
                                let error = dictonary!["error"]
                                delegate.deleteProfileResponseHandler(errorMessage: error!["message"] as! String)
                            }
                        }catch let error as NSError {
                            print(error)
                        }
                        
                    }
            }
        
    }
    
    static func addProfile(status: String, infantil: Int, password: String, name: String, delegate: EditProfileViewController) {
        
        let userInfo = UserInfo.getInstance()
        
        let methodString = "/profileadd?user=\("")&time=\(utils.getTime())&hash=\(utils.getHash())&dtoken=\(utils.getDToken())&os=\("ios")&operator=1&tipo=\("t")&usrtoken=\(userInfo?.token! ?? "")&hashtoken=\(utils.getHashToken(token: (userInfo?.token)!))"
        
        var params = ["senha": "",
                      "nome" : name.trimed(),
                      "status" : "ativo",
                      "infantil" :"\(infantil)",
                      "clientes_id" : "\(userInfo?.client_id ?? 0)"]
        
        if password != "" {
            params["senha"] = utils.md5(string: password)
        }
        
        AF.request(Constants.baseUrl+methodString,method: .post, parameters: params)
            .response{  response in
                
                if let data = response.data {
                    print(data)
                    print(response.result)
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        let profileStatus = dictonary!["success"] as! String
                        if profileStatus == "Registration is successful" {
                            delegate.addProfileResponseHandler(errorMessage: "")
                        }else{
                            let error = dictonary!["error"]
                            delegate.addProfileResponseHandler(errorMessage: error!["message"] as! String)
                        }
                    }catch let error as NSError {
                        print(error)
                    }
                }
            }
    }
    
    static func editProfile(status: String, infantil: Int, password: String, name: String, delegate: EditProfileViewController) {
        
        let userInfo = UserInfo.getInstance()
        let userProfile = UserProfile.getInstance()
        
        let str_time = utils.getTime()
        let str_hash = utils.getHash()
        let str_dtoken = utils.getDToken()
        let str_usrtoken = userInfo?.token ?? ""
        let str_hashtoken = utils.getHashToken(token: str_usrtoken)
        let str_profile_id = userProfile?.id ?? 0
        let str_clientID = userInfo?.client_id ?? 0
        let str_password = utils.md5(string: password)
        
        let str_url = Constants.baseUrl + "/profileedit?user=&time=\(str_time)&hash=\(str_hash)&dtoken=\(str_dtoken)&os=ios&operator=1&tipo=t&usrtoken=\(str_usrtoken)&hashtoken=\(str_hashtoken)&id=\(str_profile_id)"

        var params = ["status": "ativo",
                      "infantil": infantil,
                      "nome": name.trimed(),
                      "senha": str_password,
                      "clientes_id": "\(str_clientID)"] as [String : Any]
        
        if password == "" {
            params["senha"] = ""
        }
        
        AF.request(str_url, method: .post, parameters: params).response{  response in
                
                if let data = response.data {
                    print(data)
                    print(response.result)
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        let profileStatus = dictonary?["success"] as? String ?? ""
                        if profileStatus != "" {
                            delegate.addProfileResponseHandler(errorMessage: "")
                        }else{
                            let error = dictonary?["error"]
                            let str_msg = error?["message"] as? String ?? "Somehing went wrong, please try again"
                            delegate.editProfileResponseHandler(errorMessage: str_msg)
                        }
                    }catch let error as NSError {
                        print(error)
                    }
                    
                }
            }
    }
}
