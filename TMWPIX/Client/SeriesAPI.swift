//
//  SeriesAPI.swift
//  TMWPIX
//
//  Created by Apple on 16/08/2022.
//

import Foundation

import Alamofire

class SeriesAPI{
    var SeriesInfoData: [SeriesInfo] = []
    var SeriesEpisodeData: [SeriesEpisode] = []
    var RealAluguelData: [RealAluguel] = []
    
    var OpenEpisodeData: [OpenEpisode] = []
    
    
    static func getSeriesData(delegate: SeriesViewController){
        let userInfo = UserInfo.getInstance()
        let userProfile = UserProfile.getInstance()
        let userToken: String = userInfo?.token ?? ""

        let params: [String:String] = [
            "user" : "",
            "infantil": "\(userProfile?.infantil ?? 0)",
            "time" : utils.getTime(),
            "hash" : utils.getHash(),
            "dtoken" : utils.getDToken(),
            "os" : "ios",//utils.getOperatingSystem(),
            "operator" : "1",
            "tipo" : "t",
            "usrtoken" : userToken,
            "token" : userToken,
            "hashtoken" : utils.getHashToken(token: userToken),
            "appversion" : utils.getAppVersion()]
        
        
        let queryParams = params.getQueryItems()

        let str_url = Constants.baseUrl+Constants.API_METHOD_SERIES_NEW+queryParams
        AF.request(str_url, method: .get)
            .response{ response in
                
                if let data = response.data {
                    print(data)
                    debugPrint("API====>>>\(str_url)\n\nParam=====>>\(params)\n\nResult=====>>\(response.result)")
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        
                        guard let seriesData = dictonary?["series"] else { return }

                        if let arrayOfDic = seriesData as? [Dictionary<String,AnyObject>]{
                            var series: [Series] = []
                            for aDic in arrayOfDic{
                                let data = Series()
                                
                                if let id = aDic["id"] as? Int{
                                    data.id = id
                                }
                                
                                if let name = aDic["name"] as? String{
                                    data.name = name
                                }
                                if let image = aDic["image"] as? String{
                                    data.image = image
                                }
                                if let category = aDic["category"] as? String{
                                    data.category = category
                                }
                                                   
                                if let aluguel = aDic["aluguel"] as? Int{
                                    data.aluguel = aluguel
                                }
                               
                                series.append(contentsOf: [data])
                            }
                            delegate.handleSeriesData(series: series)
                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                } else {
                    getSeriesData(delegate: delegate)
                }
            }
    }
    
    //======= Series Info API ==============
    
    static func getSeriesInfoData(serieid: String, delegate: MovieDetailViewController){
        let userInfo = UserInfo.getInstance()
        let params = ["id" : serieid,
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
        
        
        let str_url = Constants.baseUrl+Constants.API_METHOD_SERIEINFO
        AF.request(str_url, parameters: params)
            .response{ response in
                
                if let data = response.data {
                    print(data)
                    debugPrint("API====>>>\(str_url)\n\nParam=====>>\(params)\n\nResult=====>>\(response.result)")
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        let series: Series = Series()
                        let seriesData = dictonary!["series"]
                        if let arrayOfDic = seriesData as? [Dictionary<String,AnyObject>]{
                            for aDic in arrayOfDic{
                                if let id = aDic["id"] as? Int{
                                    series.id = id
                                }
                                
                                if let name = aDic["name"] as? String{
                                    series.name = name
                                }
                                
                                if let trailer = aDic["trailer"] as? String{
                                    series.trailer = trailer
                                }
                                
                                if let year = aDic["year"] as? Int{
                                    series.year = year
                                }
                                
                                if let parental_control = aDic["parental_control"] as? String{
                                    print(parental_control)
                                    series.parental_control = parental_control
                                }
                                if let description = aDic["description"] as? String{
                                    print(description)
                                    series.description = description
                                }
                                if let image = aDic["image"] as? String{
                                    print(image)
                                    series.image = image
                                }
                                if let created = aDic["created"] as? String{
                                    print(created)
                                    series.created = created
                                }
                                if let category = aDic["category"] as? Int{
                                    print(category)
                                    series.category = category.description
                                }
                                if let aluguel = aDic["aluguel"] as? Int{
                                    print(aluguel)
                                    series.aluguel = aluguel
                                }
                                if let preco = aDic["preco"] as? Int{
                                    print(preco)
                                    series.preco = preco
                                }
                                if let alugado = aDic["alugado"] as? Int{
                                    print(alugado)
                                    series.alugado = alugado
                                }
                                if let restoaluguel = aDic["restoaluguel"] as? Int{
                                    print(restoaluguel)
                                    series.restoaluguel = restoaluguel
                                }
                                if let finalaluguel = aDic["finalaluguel"] as? Int{
                                    print(finalaluguel)
                                    series.finalaluguel = finalaluguel
                                }
                                if let lastEpisode = aDic["lastEpisode"] as? Int{
                                    print(lastEpisode)
                                    series.lastEpisode = lastEpisode
                                }
                                if let classificacao = aDic["classificacao"] as? String{
                                    print(classificacao)
                                    series.classificacao = classificacao
                                }
                                
                            }
                            delegate.seriesInfoResponseHandler(series: series)
                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
    }
    
    static func getSeasonData(serieid: String, delegate: MovieDetailViewController){
        let userInfo = UserInfo.getInstance()
        let params = ["serieid" : serieid,
                      "user" : "",
                      "time" : utils.getTime(),
                      "hash" : utils.getHash(),
                      "dtoken" : utils.getDToken(),
                      "os" : "ios",//utils.getOperatingSystem(),
                      "operator" : "1",
                      "tipo" : "t",
                      "usrtoken" : userInfo?.token!,
                      "hashtoken" : utils.getHashToken(token: (userInfo?.token!)!),
                      "device_id" : utils.getDeviceId(),
                      "device_name" : utils.getDeviceName(),
                      "platform" : utils.getPlatform(),
                      "appversion" : utils.getAppVersion()]
        
        AF.request(Constants.baseUrl+Constants.API_METHOD_SEASONS, parameters: params)
            .response{ response in
                
                if let data = response.data {
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        
                        let profileData = dictonary!["seasons"]
                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                            
                            var seasonData: [SeasonData] = [SeasonData]()
                            for aDic in arrayOfDic{
                                var dic_season: SeasonData = SeasonData()
                                
                                if let id = aDic["id"] as? Int {
                                    dic_season.id = id
                                }
                                
                                if let name = aDic["name"] as? String{
                                    dic_season.name = name
                                }
                                
                                if let year = aDic["year"] as? Int{
                                    dic_season.year = year
                                }
                                
                                if let series_id = aDic["series_id"] as? Int{
                                    dic_season.series_id = series_id
                                }
                                seasonData.append(dic_season)
                            }
                            delegate.seasonResponseHandler(season: seasonData)
                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
    }
    
    //======= Series Fetch Episode ============
    
    static func getSeriesEpisodeData(seasonid: String, delegate: MovieDetailViewController){
        let userInfo = UserInfo.getInstance()
        let params = ["seasonid" : seasonid,
                      "user" : "",
                      "time" : utils.getTime(),
                      "hash" : utils.getHash(),
                      "dtoken" : utils.getDToken(),
                      "os" : "ios",//utils.getOperatingSystem(),
                      "operator": "1",
                      "tipo" : "t",
                      "usrtoken" : userInfo?.token!,
                      "hashtoken" : utils.getHashToken(token: (userInfo?.token!)!),
                      "device_id" : utils.getDeviceId(),
                      "device_name" : utils.getDeviceName(),
                      "platform" : utils.getPlatform(),
                      "appversion" : utils.getAppVersion()]
        
        AF.request(Constants.baseUrl+Constants.API_METHOD_EPISODES, parameters: params)
            .response{ response in
                
                if let data = response.data {
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        
                        let profileData = dictonary!["episodes"]
                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                            
                            var episodeData: [SeriesEpisode] = []
                            for aDic in arrayOfDic{
                                let episode = SeriesEpisode()
                                if let id = aDic["id"] as? Int{
                                    episode.id = id
                                }
                                
                                if let number = aDic["number"] as? Int{
                                    episode.number = number
                                }
                                
                                if let name = aDic["name"] as? String{
                                    episode.name = name
                                }
                                
                                if let url = aDic["url"] as? String{
                                    episode.url = url
                                }
                                
                                if let duration = aDic["duration"] as? String{
                                    episode.duration = duration
                                }
                                
                                if let temporadas_id = aDic["temporadas_id"] as? Int{
                                    episode.temporadas_id = temporadas_id
                                }
                                if let serieid = aDic["serieid"] as? Int{
                                    episode.serieid = serieid
                                }
                                if let aluguel = aDic["aluguel"] as? Int{
                                    episode.aluguel = aluguel
                                }
                                if let preco = aDic["preco"] as? Int{
                                    episode.preco = preco
                                }
                                if let alugado = aDic["alugado"] as? Int{
                                    episode.alugado = alugado
                                }
                                if let restoaluguel = aDic["restoaluguel"] as? Int{
                                    episode.restoaluguel = restoaluguel
                                }
                                if let finalaluguel = aDic["finalaluguel"] as? Int{
                                    episode.finalaluguel = finalaluguel
                                }
                                episodeData.append(contentsOf: [episode])
                            }
                            delegate.episodeResponseHandler(episodeData: episodeData)
                            
                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
    }
    
    
    //===== Real Aluguel ========
    
    func getRealAluguelData(email: String, confirma: String, cpf: String, client_id: String, serie_id: String, user: String, time: String, hash: String, dtoken: String, tipo: String, usrtoken: String, hashtoken:String){
        let params = ["email" : email,
                      "confirma" : confirma,
                      "cpf" : cpf,
                      "cliente_id" : client_id,
                      "serie_id" : serie_id,
                      "user" : user,
                      "time" : time,
                      "hash" : hash,
                      "dtoken" : dtoken,
                      "os" : utils.getOperatingSystem(),
                      "operator" : "1",
                      "tipo" : tipo,
                      "usrtoken" : usrtoken,
                      "hashtoken" : hashtoken]
        
        let str_url = Constants.baseUrl+Constants.API_METHOD_ALUGASERIE
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
                                let data = RealAluguel()
                                if let code = aDic["code"] as? String{
                                    print(code)
                                    data.code = code
                                }
                                
                                if let message = aDic["message"] as? String{
                                    print(message)
                                    data.message = message
                                }
                                
                                self.RealAluguelData.append(contentsOf: [data])
                            }
                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
    }
    
    
    //======== Opejn Episode ========
    static func getOpenEpisodeData(episode_id: String, completion: @escaping (OpenEpisode) -> Void) {
        let userProfile = UserProfile.getInstance()
        
        let str_URl = Constants.baseUrl+Constants.API_METHOD_EPISODEINFOFULL + "?id=\(episode_id)&time=1657435701486&os=ios&operator=1&tipo=t&usrtoken=\(UserInfo.getInstance()?.token ?? "")&perfis=\(userProfile?.id ?? 13349)"
        
        AF.request(str_URl, parameters: nil).response { [self] response in
            if let data = response.data {
                print(data)
                print(response.result)
                do {
                    let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                    
                    let series_Data = OpenEpisode()

                    //------- Epidoe Data ----------------------
                    let episodeData = dictonary!["episode"]
                    if let arrayOfDic = episodeData as? [Dictionary<String,AnyObject>]{
                        for aDic in arrayOfDic {
                            series_Data.episode = Episode()
                            
                            if let id = aDic["id"] as? String{
                                series_Data.episode?.id = id
                            }
                            if let number = aDic["number"] as? String{
                                series_Data.episode?.number = number
                            }
                            if let name = aDic["name"] as? String{
                                series_Data.episode?.name = name
                            }
                            if let urlString = aDic["url"] as? String {
                                if urlString.contains("play.m3u8") {
                                    let newUrlString = urlString.replacingOccurrences(of: "play.m3u8", with: "playapple.m3u8")
                                    series_Data.episode?.url = newUrlString
                                } else {
                                    series_Data.episode?.url = urlString
                                }
                            }
                            if let duration = aDic["duration"] as? String{
                                series_Data.episode?.duration = duration
                            }
                            if let serie_id = aDic["serie_id"] as? String{
                                series_Data.episode?.serie_id = serie_id
                            }
                            if let starttime = aDic["starttime"] as? Int{
                                series_Data.episode?.starttime = "\(starttime)"
                            }
                            if let starttime = aDic["starttime"] as? String{
                                series_Data.episode?.starttime = starttime
                            }
                        }
                    } // close bracket of episode dict
                    
                    //----------- Extra Data ------------------
                    
                    let extraData = dictonary!["extra"]
                    if let arrayOfEtra = extraData as? [Dictionary<String,AnyObject>]{
                        for aDic in arrayOfEtra {
                            series_Data.extra = Extra()
                            
                            if let legenda = aDic["legenda"] as? String{
                                print(legenda)
                                series_Data.extra?.audios = legenda
                            }
                            if let audios = aDic["audios"] as? String{
                                print(audios)
                                series_Data.extra?.audios = audios
                            }
                        }
                    } // close bracket of extra data
                    
                    //--------- Subtitles data ------------
                    
                    let subtitleData = dictonary!["subtitles"]
                    if let arrayOfDic = subtitleData as? [Dictionary<String,AnyObject>]{
                        for aDic in arrayOfDic {
                            series_Data.subtitles = Subtitles()
                            
                            if let id = aDic["id"] as? String{
                                series_Data.subtitles?.id = id
                            }
                            if let idioma = aDic["idioma"] as? String{
                                series_Data.subtitles?.idioma = idioma
                            }
                            if let siglaidioma = aDic["siglaidioma"] as? String{
                                series_Data.subtitles?.siglaidioma = siglaidioma
                            }
                            if let arquivo = aDic["arquivo"] as? String{
                                series_Data.subtitles?.arquivo = arquivo
                            }
                            if let codificacao = aDic["codificacao"] as? String{
                                series_Data.subtitles?.codificacao = codificacao
                            }
                        }
                    } // close bracket of Subtitle data
                    
                    //--------- Audio data ------------
                    
                    let audioData = dictonary!["audio"]
                    if let arrayOfDic = audioData as? [Dictionary<String,AnyObject>]{
                        for aDic in arrayOfDic{
                            series_Data.subtitles = Subtitles()
                            
                            if let id = aDic["id"] as? String{
                                series_Data.subtitles?.id = id
                            }
                            if let idioma = aDic["idioma"] as? String{
                                series_Data.subtitles?.idioma = idioma
                            }
                            if let siglaidioma = aDic["siglaidioma"] as? String{
                                series_Data.subtitles?.siglaidioma = siglaidioma
                            }
                            if let map = aDic["map"] as? String{
                                series_Data.subtitles?.arquivo = map
                            }
                        }
                    } // close bracket of Subtitle data
                    completion(series_Data)
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
    
    
    
}
