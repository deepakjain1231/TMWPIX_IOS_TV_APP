//
//  EPGAPI.swift
//  TMWPIX
//
//  Created by Apple on 17/08/2022.
//

import Foundation
import Alamofire

class EPGAPI{
    var TimeData: [Time] = []
   
    
    func getTimeData(){
        let params = [""]
        
        let str_url = Constants.baseUrl+Constants.API_METHOD_TIMENOW
        AF.request(str_url, parameters: params)
            .response{ [self] response in
                
                if let data = response.data {
                    print(data)
                    debugPrint("API====>>>\(str_url)\n\nParam=====>>\(params)\n\nResult=====>>\(response.result)")
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        
                        let profileData = dictonary!["date"]
                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                            for aDic in arrayOfDic{
                                let data = Time()
                                if let Day = aDic["Day"] as? String{
                                    print(Day)
                                    data.Day = Day
                                }
                                
                                if let Month = aDic["Month"] as? String{
                                    print(Month)
                                    data.Month = Month
                                }
                                
                                if let Year = aDic["Year"] as? String{
                                    print(Year)
                                    data.Year = Year
                                }
                                
                                if let Hour = aDic["Hour"] as? String{
                                    print(Hour)
                                    data.Hour = Hour
                                }
                                if let Minute = aDic["Minute"] as? String{
                                    print(Minute)
                                    data.Minute = Minute
                                }
                                if let Seconds = aDic["Seconds"] as? String{
                                    print(Seconds)
                                    data.Seconds = Seconds
                                }
                                if let Date = aDic["Date"] as? String{
                                    print(Date)
                                    data.Date = Date
                                }
                                
                                
                                self.TimeData.append(contentsOf: [data])
                            }
                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
    } // Close bracket of Time API
    
    
    
    // =============== EPG API ============
    static func getEPGData(delegate: EPGViewController){
        
        let userInfo = UserInfo.getInstance()
        
        let params = [
            "user" : "",
            "time" : utils.getTime(),
            "hash" : utils.getHash(),
            "dtoken" : utils.getDToken(),
            "os" : "ios",
            "operator" : "1",
            "tipo" : "t",
            "usrtoken" : userInfo?.token!,
            "hashtoken" : utils.getHashToken(token: (userInfo?.token!)!),
            "device_id" : utils.getDeviceId(),
            "device_name" : utils.getDeviceName(),
            "platform" : "apple",
            "appversion" : utils.getAppVersion()]
        
        
//                  `http://api.tmwpix.com/channels/returnepgminnow?user=${objectUserToken.usr}&time=${objectUserToken.time}&hash=${objectUserToken.hash}&dtoken=${objectUserToken.pass}&os=android&operator=1&tipo=${objectUserToken.loginType}&usrtoken=${objectUserToken.usrtoken}&hashtoken=${objectUserToken.hashtoken}`,


        AF.request(Constants.baseUrl+Constants.API_METHOD_EPGMINNOW, parameters: params)
            .response{ response in
                var epgData = [EPGInfo]()
                if let data = response.data {
                    print(response)
                    print(response.data)
               
                    do {
                        let responseData = String(data: data, encoding: String.Encoding.utf8)
                        print(responseData)
                        
                        let result = try JSONDecoder().decode([EPGInfo].self, from: data)
                        epgData.append(contentsOf: result)
                        delegate.epgDataresponseHandler(epgData: epgData)
                    } catch {
                        utils.showDestructiveAlert(message: "it's connect error ...please check after sometime", presentationController: delegate)
                        delegate.loadingIndicator.stopAnimating()
                        print(error)
                    }
                    
                    
                    
//                    var EPGData: [EPG] = []
//                    do {
//                        let dictonary =  try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
//
//
//                        let data = EPG()
//                        let id = dictonary!["id"] as? Int
//                        data.id = id
//                        let nome = dictonary!["nome"]
//                        data.nome = nome as? String
//                        let regiao = dictonary!["regiao"]
//                        data.regiao = regiao as? String
//                        let podeAssistir = dictonary!["podeAssistir"]
//                        data.podeAssistir = podeAssistir as? Int
//                        let numero = dictonary!["numero"]
//                        data.numero = numero as? Int
//                        let url = dictonary!["url"]
//                        data.url = url as? String
//                        let image = dictonary!["image"]
//                        data.image = image as? String
//
//
//                        let profileData = dictonary!["program"]
//                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
//                            for aDic in arrayOfDic{
//
//                                if let title = aDic["title"] as? String{
//                                    print(title)
//                                    data.program!.title = title
//                                }
//
//                                if let id = aDic["id"] as? Int{
////                                    print(id)
//                                    data.program!.id = id
//                                }
//
//                                if let start = aDic["start"] as? String{
////                                    print(start)
//                                    data.program!.start = start
//                                }
//
//                                if let stop = aDic["stop"] as? String{
////                                    print(stop)
//                                    data.program!.stop = stop
//                                }
//                                if let descricao = aDic["descricao"] as? String{
////                                    print(descricao)
//                                    data.program!.descricao = descricao
//                                }
//                                if let TStart = aDic["TStart"] as? Int{
////                                    print(TStart)
//                                    data.program!.TStart = TStart
//                                }
//                                if let TStop = aDic["TStop"] as? Int{
////                                    print(TStop)
//                                    data.program!.TStop = TStop
//                                }
//
//                                EPGData.append(contentsOf: [data])
//                            }
//                            delegate.epgDataresponseHandler(epgData: EPGData)
//                        }
//
//                    } catch let error as NSError {
//                        print(error)
//                    }
                }
            }
    }
//
}
