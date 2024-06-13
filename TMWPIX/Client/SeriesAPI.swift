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

        
        //    http://api.tmwpix.com/series?appversion=1.3&user=&infantil=1&time=1660154482322&hash=6baa622fa569f0b38fdb011c7a788c0f&dtoken=d41d8cd98f00b204e9800998ecf8427e&os=android&operator=1&tipo=t&usrtoken=APP123&hashtoken=72f331591291c68712c87796f13bad45
        
        AF.request(Constants.baseUrl+Constants.API_METHOD_SERIES_NEW+queryParams, method: .get)
            .response{ response in
                
                if let data = response.data {
                    print(data)
                    print(response.result)
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        
                        guard let seriesData = dictonary?["contents"] else { return }

                        if let arrayOfDic = seriesData as? [Dictionary<String,AnyObject>]{
                            var series: [Series] = []
                            for aDic in arrayOfDic{
                                let data = Series()
                                
                                if let id = aDic["id"] as? Int{
                                    data.id = id
                                }
                                
                                if let name = aDic["nome"] as? String{
                                    data.name = name
                                }
                                if let image = aDic["capa"] as? String{
                                    data.image = image
                                }
                                if let category = aDic["categorias"] as? String{
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
    
    //    func getSeriesSeasonData(){
    //        let params = ["serieid" : "46",
    //                      "user" : "",
    //                      "time" : "1657390028215",
    //                      "hash" : "6b44ce6d55fb47f49a08c4ed436be469",
    //                      "dtoken" : "d41d8cd98f00b204e9800998ecf8427e",
    //                      "os" : "ios",
    //                      "tipo" : "t",
    //                      "usrtoken" : "APP123",
    //                      "hashtoken" : "fc427b261087b109867e42961ca645ce",
    //                      "device_id" : "7f3e54b720a6f34e",
    //                      "device_name" : "sdk_google_atv_x86",
    //                      "platform" : "apple",
    //                      "appversion" : "1.3.1"]
    //
    //        AF.request(Constants.baseUrl+Constants.API_METHOD_SEASONS, parameters: params)
    //            .response{ [self] response in
    //
    //                if let data = response.data {
    //                    print(data)
    //                    print(response.result)
    //                    do {
    //                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
    //
    //                        let profileData = dictonary!["seasons"]
    //                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
    //                            for aDic in arrayOfDic{
    //                                let Season = SeasonData()
    //                                if let id = aDic["id"] as? String{
    //                                    print(id)
    //                                    Season.id = id
    //                                }
    //
    //                                if let name = aDic["name"] as? String{
    //                                    print(name)
    //                                    Season.name = name
    //                                }
    //
    //                                if let year = aDic["year"] as? String{
    //                                    print(year)
    //                                    Season.year = year
    //                                }
    //
    //                                if let series_id = aDic["series_id"] as? String{
    //                                    print(series_id)
    //                                    Season.series_id = series_id
    //                                }
    //                                self.SeriseSeasonData.append(contentsOf: [Season])
    //                            }
    //                        }
    //
    //                    } catch let error as NSError {
    //                        print(error)
    //                    }
    //                }
    //            }
    //    }
    //
    //
    
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
        
        AF.request(Constants.baseUrl+Constants.API_METHOD_SERIEINFO, parameters: params)
            .response{ response in
                
                if let data = response.data {
                    print(data)
                    print(response.result)
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
    
    func getRealAluguelData(email: String,
                            confirma: String,
                            cpf: String,
                            client_id: String,
                            serie_id: String,
                            user: String,
                            time: String,
                            hash: String,
                            dtoken: String,
                            tipo: String,
                            usrtoken: String,
                            hashtoken:String
    ){
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
                      "hashtoken" : hashtoken
        ]
        
        AF.request(Constants.baseUrl+Constants.API_METHOD_ALUGASERIE, parameters: params)
            .response{ [self] response in
                
                if let data = response.data {
                    print(data)
                    print(response.result)
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
    func getOpenEpisodeData(){
        let userProfile = UserProfile.getInstance()
        let params = ["id" : "950",
                      "perfis" : "\(userProfile?.id ?? 13349)",
                      "user" : "",
                      "time" : "1657390028215",
                      "hash" : "6b44ce6d55fb47f49a08c4ed436be469",
                      "dtoken" : "d41d8cd98f00b204e9800998ecf8427e",
                      "os" : "ios",
                      "operator" : "1",
                      "tipo" : "t",
                      "usrtoken" : "APP123",
                      "hashtoken" : "fc427b261087b109867e42961ca645ce",
                      "device_id" : "7f3e54b720a6f34e",
                      "device_name" : "sdk_google_atv_x86",
                      "platform" : "apple",
                      "appversion" : "1.3.1"]
        
        
        AF.request(Constants.baseUrl+Constants.API_METHOD_EPISODEINFOFULL, parameters: params)
            .response{ [self] response in
                
                if let data = response.data {
                    print(data)
                    print(response.result)
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        let data = OpenEpisode()
                        //------- Epidoe Data ----------------------
                        let episodeData = dictonary!["episode"]
                        if let arrayOfDic = episodeData as? [Dictionary<String,AnyObject>]{
                            for aDic in arrayOfDic{
                                if let id = aDic["id"] as? String{
                                    print(id)
                                    data.episode?.id = id
                                }
                                if let number = aDic["number"] as? String{
                                    print(number)
                                    data.episode?.number = number
                                }
                                if let name = aDic["name"] as? String{
                                    print(name)
                                    data.episode?.name = name
                                }
                                if let url = aDic["url"] as? String{
                                    print(url)
                                    data.episode?.url = url
                                }
                                if let duration = aDic["duration"] as? String{
                                    print(duration)
                                    data.episode?.duration = duration
                                }
                                if let serie_id = aDic["serie_id"] as? String{
                                    print(serie_id)
                                    data.episode?.serie_id = serie_id
                                }
                                
                                if let starttime = aDic["starttime"] as? String{
                                    print(starttime)
                                    data.episode?.starttime = starttime
                                }
                            }
                        } // close bracket of episode dict
                        
                        //----------- Extra Data ------------------
                        
                        let extraData = dictonary!["extra"]
                        if let arrayOfEtra = extraData as? [Dictionary<String,AnyObject>]{
                            for aDic in arrayOfEtra{
                                if let legenda = aDic["legenda"] as? String{
                                    print(legenda)
                                    data.extra?.audios = legenda
                                }
                                if let audios = aDic["audios"] as? String{
                                    print(audios)
                                    data.extra?.audios = audios
                                }
                            }
                        } // close bracket of extra data
                        
                        //--------- Subtitles data ------------
                        
                        let subtitleData = dictonary!["subtitles"]
                        if let arrayOfDic = subtitleData as? [Dictionary<String,AnyObject>]{
                            for aDic in arrayOfDic{
                                if let id = aDic["id"] as? String{
                                    print(id)
                                    data.subtitles?.id = id
                                }
                                if let idioma = aDic["idioma"] as? String{
                                    print(idioma)
                                    data.subtitles?.idioma = idioma
                                }
                                
                                if let siglaidioma = aDic["siglaidioma"] as? String{
                                    print(siglaidioma)
                                    data.subtitles?.siglaidioma = siglaidioma
                                }
                                if let arquivo = aDic["arquivo"] as? String{
                                    print(arquivo)
                                    data.subtitles?.arquivo = arquivo
                                }
                                if let codificacao = aDic["codificacao"] as? String{
                                    print(codificacao)
                                    data.subtitles?.codificacao = codificacao
                                }
                            }
                        } // close bracket of Subtitle data
                        
                        //--------- Audio data ------------
                        
                        let audioData = dictonary!["audio"]
                        if let arrayOfDic = audioData as? [Dictionary<String,AnyObject>]{
                            for aDic in arrayOfDic{
                                if let id = aDic["id"] as? String{
                                    print(id)
                                    data.subtitles?.id = id
                                }
                                if let idioma = aDic["idioma"] as? String{
                                    print(idioma)
                                    data.subtitles?.idioma = idioma
                                }
                                
                                if let siglaidioma = aDic["siglaidioma"] as? String{
                                    print(siglaidioma)
                                    data.subtitles?.siglaidioma = siglaidioma
                                }
                                if let map = aDic["map"] as? String{
                                    print(map)
                                    data.subtitles?.arquivo = map
                                }
                            }
                        } // close bracket of Subtitle data
                        
                        self.OpenEpisodeData.append(contentsOf: [data])
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
    }
    
    
    
}
