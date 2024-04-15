//
//  HomeAPI.swift
//  TMWPIX
//
//  Created by Apple on 11/08/2022.
//

import Foundation
import Alamofire

class HomeAPI{
    
    static func getHomeBackgroundData(delegate: HomeViewController){
        let params = ["device_id" : utils.getDeviceId(),
                      "device_name" : utils.getDeviceName(),
                      "platform" : utils.getPlatform(),
                      "appversion" : utils.getAppVersion()]
        
        AF.request(Constants.baseUrl+Constants.API_METHOD_HOME, parameters: params)
            .response{ response in
                
                if let data = response.data {
                    print(data)
                    print(response.result)
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        
                        let profileData = dictonary!["promocoes"]
                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                            var homeData: [Home] = []
                            for aDic in arrayOfDic{
                                let Home = Home()
                                if let numero = aDic["numero"] as? Int{
//                                    print(numero)
                                    Home.numero = numero
                                }
                                
                                if let arquivoreal = aDic["arquivoreal"] as? String{
//                                    print(arquivoreal)
                                    Home.arquivoreal = arquivoreal
                                }
                                
                                if let url = aDic["url"] as? String{
//                                    print(url)
                                    Home.url = url
                                }
                                
                                if let duracao = aDic["duracao"] as? Int{
//                                    print(duracao)
                                    Home.duracao = duracao
                                }
                                homeData.append(contentsOf: [Home])
                                
                            }
                            delegate.homeResponseHandler(homeData: homeData)
                            
                        }
                        
                    } catch let error as NSError {
                        print(error)
                        delegate.homeResponseHandler(homeData: [Home]())
                    }
                }
            }
    }
    
}

