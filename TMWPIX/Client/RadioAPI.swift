//
//  RadioAPI.swift
//  TMWPIX
//
//  Created by Apple on 17/08/2022.
//

import Foundation
import Alamofire

class RadioAPI{
    
    // ===== work start from here  ==========
    static func getRadioData(delegate: RadioViewController){
        
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
            "platform" : utils.getPlatform(),
            "appversion" : utils.getAppVersion()]
        
        
        AF.request(Constants.baseUrl+Constants.API_METHOD_RADIOS, parameters: params)
            .response{ response in
                
                if let data = response.data {
                    print(data)
                    print(response.result)
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        
                        let profileData = dictonary!["radios"]
                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                            var RadioData: [Radio] = []
                            for aDic in arrayOfDic{
                                let data = Radio()
                                if let id = aDic["id"] as? Int{
                                    print(id)
                                    data.id = id
                                }
                                
                                if let name = aDic["name"] as? String{
                                    print(name)
                                    data.name = name
                                }
                                
                                if let category = aDic["category"] as? Int{
                                    print(category)
                                    data.category = category
                                }
                                
                                if let image = aDic["image"] as? String{
                                    print(image)
                                    data.image = image
                                }
                                if let url = aDic["url"] as? String{
                                    print(url)
                                    data.url = url
                                }
                                if let description = aDic["description"] as? String{
                                    print(description)
                                    data.description = description
                                }
                                if let midiatype = aDic["midiatype"] as? String{
                                    print(midiatype)
                                    data.midiatype = midiatype
                                }
                                RadioData.append(contentsOf: [data])
                            }
                            delegate.RadioResponseHandler(RadioData: RadioData)
                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
    }
    
}
