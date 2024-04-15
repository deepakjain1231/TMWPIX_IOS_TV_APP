//
//  LoginAPI.swift
//  TMWPIX
//
//  Created by Apple on 11/08/2022.
//

import Foundation
import Alamofire


class SignupAPI{
    
    static func registerNewUser(parameters: Parameters, delegate: SignUpViewController){
        
        let params = ["nome" : "test123",
                      "cpf" : "1657435701486",
                      "rg" : "3f9b7d853e407cc1159077ad82b0fb1d",
                      "dataNasc" : "d41d8cd98f00b204e9800998ecf8427e",
                      "rua" : "ios",
                      "numero" : "1",
                      "bairro" : "t",
                      "cep" : "APP123",
                      "cidade" : "aa2dd11aad8d9664a4cd9ac33b49caa9",
                      "estado" : "7f3e54b720a6f34e",
                      "plano" : "sdk_google_atv_x86",
                      "email" : "apple@gmail.com",
                      "creditNumber" : "apple",
                      "creditMonth" : "apple",
                      "creditYear" : "apple",
                      "cvv" : "apple"]
        
        AF.request(Constants.baseUrl+Constants.API_METHOD_SIGNUP, method: .post, parameters: params)
            .response{ response in
                
                if let data = response.data {
                    print(data)
                    print(response.result)
                    do {
                        delegate.loadingIndicator.stopAnimating()
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        
                        let profileData = dictonary!["profiles"]
                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                            for aDic in arrayOfDic{
#if TARGET_OS_IOS
                                let userInfo = TMWPIX.UserInfo.getInstance()
#else
                                let userInfo = TMWPIXtvOS.UserInfo.getInstance()
#endif
                                
                                if let Email = aDic["email"] as? String{
                                    print(Email)//print price of each dic
                                    userInfo!.email = Email
                                }
                                
                                if let Pass = aDic["senha"] as? String{
                                    print(Pass)//print price of each dic
                                    userInfo!.password = Pass
                                }
                            }
                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
    
    }
}
