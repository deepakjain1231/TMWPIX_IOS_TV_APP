//
//  ConfigAPI.swift
//  TMWPIX
//
//  Created by Apple on 15/08/2022.
//

import Foundation
import Alamofire

class ConfigAPI{
    
    var arrUser = [ConfigStart]()
    var Cobrancas:[Cobrancas] = []
    
    var AluguelBox:[Aluguel] = []
    static var isTokenCheck:Bool = false
    static func disableAluguel(delegate: ChangeRentalStatusViewController){
        
        let userInfo = UserInfo.getInstance()
        let params = [
            "user" : "",
            "podealugar": "0",
            "time" : utils.getTime(),
            "hash" : utils.getHash(),
            "dtoken" : utils.getDToken(),
            "os" : "ios",//utils.getOperatingSystem(),
            "operator" : "1",
            "tipo" : "t",
            "usrtoken" : userInfo?.token,
            "hashtoken" : utils.getHashToken(token: (userInfo?.token)!)]
        self.enableDisableCall(params: params, delegate: delegate)
    }
    static func enableAluguel(delegate: ChangeRentalStatusViewController){
        let userInfo = UserInfo.getInstance()
        let params = [
            "user" : "",
            "podealugar": "1",
            "time" : utils.getTime(),
            "hash" : utils.getHash(),
            "dtoken" : utils.getDToken(),
            "os" : "ios",//utils.getOperatingSystem(),
            "operator" : "1",
            "tipo" : "t",
            "usrtoken" : userInfo?.token,
            "hashtoken" : utils.getHashToken(token: (userInfo?.token)!)]
        self.enableDisableCall(params: params, delegate: delegate)
    }
    
    static func enableDisableCall(params:[String : Optional<String>], delegate: ChangeRentalStatusViewController){
        
        let str_url = Constants.baseUrl+Constants.API_METHOD_UPDATEALUGUELBOX
        AF.request(str_url, parameters: params)
            .response{ response in
                
                if let data = response.data {
                    print(data)
                    debugPrint("API====>>>\(str_url)\n\nParam=====>>\(params)\n\nResult=====>>\(response.result)")
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        print(dictonary as Any)
                        
                        if params["podealugar"] == "1" {
                            delegate.enableAluguelResponseHandler(errorMessage: "")
                        }else{
                            delegate.disableAluguelResponseHandler(errorMessage: "")
                        }

                        
                    } catch let error as NSError {
                        print(error)
                        if params["podealugar"] == "1" {
                            delegate.enableAluguelResponseHandler(errorMessage: "")
                        }else{
                            delegate.disableAluguelResponseHandler(errorMessage: "")
                        }
                    }
                } else{
                    if params["podealugar"] == "1" {
                        delegate.enableAluguelResponseHandler(errorMessage: "")
                    }else{
                        delegate.disableAluguelResponseHandler(errorMessage: "")
                    }
                }
            }
    }
    
    
    
    func getConfigStartData(){
        
        let userInfo = UserInfo.getInstance()
        let params = ["user" : "",
                      "time" : utils.getTime(),
                      "hash" : utils.getHash(),
                      "dtoken" : utils.getDToken(),
                      "os" : "ios",//utils.getOperatingSystem(),
                      "operator" : "1",
                      "tipo" : "t",
                      "usrtoken" : userInfo?.token,
                      "hashtoken" : utils.getHashToken(token: (userInfo?.token)!),
                      "device_id" : utils.getDeviceId(),
                      "device_name" : utils.getDeviceName(),
                      "platform" : utils.getPlatform(),
                      "appversion" : utils.getAppVersion()]
        
        AF.request(Constants.baseUrl+Constants.API_METHOD_USERINFO, parameters: params)
            .response{ [self] response in
                if let data = response.data {
                    ConfigAPI.isTokenCheck = true
                    do {
                        arrUser.removeAll()
                        let result = try JSONDecoder().decode([ConfigStart].self, from: data)
                        arrUser.append(contentsOf: result)
                        for i in arrUser {
                            appDelegate.str_cpfValue = i.cpf ?? ""
                            appDelegate.dic_UserData = i
                        }
                    } catch {
                        ConfigAPI.isTokenCheck = false
                        print(error)
                    }
                }
            }
    }// close bracket of config Start
    
    //========= Get Cobrancas =================
    func getCobrancasData(){
        let userInfo = UserInfo.getInstance()
        let params = [
            "user" : "",
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
        
        
        let str_url = Constants.baseUrl+Constants.API_METHOD_COBRANCAS
        AF.request(str_url, parameters: params)
            .response{ [self] response in
                
                if let data = response.data {
                    print(data)
                    debugPrint("API====>>>\(str_url)\n\nParam=====>>\(params)\n\nResult=====>>\(response.result)")
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        
                        let profileData = dictonary!["alugueis"]
                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                            for aDic in arrayOfDic{
#if TARGET_OS_IOS
                                let data = TMWPIX.Cobrancas()
#else
                                let data = TMWPIXtvOS.Cobrancas()
#endif
                                
                                if let nome = aDic["nome"] as? String{
                                    print(nome)
                                    data.nome = nome
                                }
                                
                                if let valor = aDic["valor"] as? String{
                                    print(valor)
                                    data.valor = valor
                                }
                                
                                if let datainicio = aDic["datainicio"] as? String{
                                    print(datainicio)
                                    data.datainicio = datainicio
                                }
                                
                                if let datafinal = aDic["datafinal"] as? String{
                                    print(datafinal)
                                    data.datafinal = datafinal
                                }
                                
                                self.Cobrancas.append(contentsOf: [data])
                            }
                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
    }// close bracket of
    
    
    //======= Update aluguel API ==========
    
    func getEnableAluguelData(
        time: String,
        hash: String,
        dtoken: String,
        tipo: String,
        usrtoken: String,
        hashtoken: String
    ){
        let params = ["podealugar" : "0",
                      "user" : "",
                      "time" : time,
                      "hash" : hash,
                      "dtoken" : dtoken,
                      "os" : utils.getOperatingSystem(),
                      "operator" : "1",
                      "tipo" : tipo,
                      "usrtoken" : usrtoken,
                      "hashtoken" : hashtoken
        ]
        
        
        let str_url = Constants.baseUrl+Constants.API_METHOD_UPDATEALUGUELBOX
        AF.request(str_url, parameters: params)
            .response{ [self] response in
                
                if let data = response.data {
                    print(data)
                    debugPrint("API====>>>\(str_url)\n\nParam=====>>\(params)\n\nResult=====>>\(response.result)")
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        
                        let profileData = dictonary!["error"]
                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                            for aDic in arrayOfDic{
#if TARGET_OS_IOS
                                let data = TMWPIX.Aluguel()
#else
                                let data = TMWPIXtvOS.Aluguel()
#endif
                                
                                if let code = aDic["code"] as? String{
                                    print(code)
                                    data.code = code
                                }
                                
                                if let message = aDic["message"] as? String{
                                    print(message)
                                    data.message = message
                                }
                                
                                
                                self.AluguelBox.append(contentsOf: [data])
                            }
                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
    } // Close Bracket of getFilmSeriesData
}


