//
//  ChannelAPI.swift
//  TMWPIX
//
//  Created by Apple on 17/08/2022.
//

import Foundation
import Alamofire

class ChannelAPI{
    
    
    static func getNowPlayingData(id: String, delegate: MediaViewController){
        let userInfo = UserInfo.getInstance()
        let userProfile = UserProfile.getInstance()
        let params = ["id" : id,
                      "perfis_id" : "\(userProfile?.id ?? 13349)",
                      "user" : "",
                      "time" : utils.getTime(),
                      "hash" : utils.getHash(),
                      "dtoken" : utils.getDToken(),
                      "os" : "ios",//utils.getOperatingSystem()
                      "operator" : "1",
                      "tipo" : "t",
                      "usrtoken" : userInfo?.token,
                      "hashtoken" : utils.getHashToken(token: (userInfo?.token)!),
                      "page" : "tv",
                      "device_id" : utils.getDeviceId(),
                      "device_name" : utils.getDeviceName(),
                      "platform" : utils.getPlatform(),
                      "appversion" : utils.getAppVersion()]
        
        AF.request(Constants.baseUrl+Constants.API_METHOD_NOWPLAYING, parameters: params)
            .response{ response in
                
                if let data = response.data {
                    print(data)
                    print(response.result)
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        
                        let profileData = dictonary!["prog"]
                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                            
                            var NowPlay: [NowPlaying] = []
                            
                            for aDic in arrayOfDic{
                                let data = NowPlaying()
                                if let agoratitulo = aDic["agoratitulo"] as? String{
                                    //                                    print(agoratitulo)
                                    data.agoratitulo = agoratitulo
                                }
                                
                                if let agorastart = aDic["agorastart"] as? String{
                                    //                                    print(agorastart)
                                    data.agorastart = agorastart
                                }
                                
                                if let agorastop = aDic["agorastop"] as? String{
                                    //                                    print(agorastop)
                                    data.agorastop = agorastop
                                }
                                
                                if let agorafalt = aDic["agorafalt"] as? Int{
                                    //                                    print(agorafalt)
                                    data.agorafalt = agorafalt
                                }
                                if let total = aDic["total"] as? Int{
                                    //                                    print(total)
                                    data.total = total
                                }
                                if let descricao = aDic["descricao"] as? String{
                                    //                                    print(descricao)
                                    data.descricao = descricao
                                }
                                if let depoistitulo = aDic["depoistitulo"] as? String{
                                    //                                    print(depoistitulo)
                                    data.depoistitulo = depoistitulo
                                }
                                if let depoisstart = aDic["depoisstart"] as? String{
                                    //                                    print(depoisstart)
                                    data.depoisstart = depoisstart
                                }
                                if let depoisstop = aDic["depoisstop"] as? String{
                                    //                                    print(depoisstop)
                                    data.depoisstop = depoisstop
                                }
                                if let depoisfalt = aDic["depoisfalt"] as? Int{
                                    //                                    print(depoisfalt)
                                    data.depoisfalt = depoisfalt
                                }
                                NowPlay.append(contentsOf: [data])
                            }
                            
                            delegate.channelPlayingResponseHandler(playingData: NowPlay)

                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
    }// close bracket getHomeBackgroundData
    
    
    //======= Get channel API ==========
    static func getChannelData(delegate: ChannelViewController){
        let userInfo = UserInfo.getInstance()
        let params = [
            "user" : "",
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
        
        AF.request(Constants.baseUrl+Constants.API_METHOD_CHANNELS, parameters: params)
            .response{ response in
                
                if let data = response.data {
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                        
                        let profileData = dictonary!["channels"]
                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                            var channels: [Channel] = []
                            for aDic in arrayOfDic{
                                let data = Channel()
                                if let id = aDic["id"] as? Int{
                                    data.id = id
                                }
                                if let name = aDic["name"] as? String{
                                    data.name = name
                                }
                                if let url = aDic["url"] as? String{
                                    data.url = url
                                }
                                if let description = aDic["description"] as? String{
                                    data.description = description
                                }
                                if let crypto = aDic["crypto"] as? Int{
                                    data.crypto = crypto
                                }
                                if let image = aDic["image"] as? String{
                                    data.image = image
                                }
                                if let midiatype = aDic["midiatype"] as? String{
                                    data.midiatype = midiatype
                                }
                                if let publico = aDic["publico"] as? Int{
                                    data.publico = publico
                                }
                                if let regiao = aDic["regiao"] as? String{
                                    data.regiao = regiao
                                }
                                if let podeAssistir = aDic["podeAssistir"] as? Int{
                                    data.podeAssistir = podeAssistir
                                }
                                if let overlayImage = aDic["overlayImage"] as? String{
                                    data.overlayImage = overlayImage
                                }
                                if let number = aDic["number"] as? Int{
                                    data.number = number
                                }
                                channels.append(contentsOf: [data])
                            }
                            delegate.channelResponseHandler(ChannelData: channels)
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                } else {
                    getChannelData(delegate: delegate)
                }
            }
    }// close bracket getHomeBackgroundData
    
}
