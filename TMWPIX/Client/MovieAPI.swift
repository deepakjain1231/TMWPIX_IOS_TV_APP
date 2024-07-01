//
//  MovieAPI.swift
//  TMWPIX
//
//  Created by Apple on 11/08/2022.
//

import Foundation
import Alamofire

class MovieAPI{
    var Ticket:[Ticket] = []
    var movieData: [Movie] = []
    
    func getTicketsData(){
        
        let userProfile = UserProfile.getInstance()
        //=-------------=
        let params = ["idconteudo" : "1228",
                      "cliente_id" : "14685",
                      "tipoconteudo" : "filmes",
                      "perfis" : "\(userProfile?.id ?? 13349)",
                      "user" : "",
                      "time" : utils.getTime(),
                      "hash" : utils.getHash(),
                      "dtoken" : utils.getDToken(),
                      "os" : utils.getOperatingSystem(),
                      "operator" : "1",
                      "tipo" : "t",
                      "usrtoken" : "APP123",
                      "hashtoken" : utils.getHashToken(token: "APP123"),
                      "device_id" : utils.getDeviceId(),
                      "device_name" : utils.getDeviceName(),
                      "platform" : utils.getPlatform(),
                      "appversion" : utils.getAppVersion()]
        //=-------------=
        let str_url = Constants.baseUrl+Constants.API_METHOD_TICKET
        
        AF.request(str_url, parameters: params)
            .response{ [self] response in
                
                if let data = response.data {
                    print(data)
                    debugPrint("API====>>>\(str_url)\n\nParam=====>>\(params)\n\nResult=====>>\(response.result)")
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        
                        let profileData = dictonary!["profiles"]
                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                            for aDic in arrayOfDic{
                                #if TARGET_OS_IOS
                                    let Tiket = TMWPIX.Ticket()
                                #else
                                    let Tiket = TMWPIXtvOS.Ticket()
                                #endif
                                
                            
                                if let erro = aDic["erro"] as? String{
                                    print(erro)
                                    Tiket.erro = erro
                                }
                                
                                
                                self.Ticket.append(contentsOf: [Tiket])
                            }
                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
    }// Close Braket of function
    
    
    //======== Movie ==========
    
    
    func getMovieInfoData(){
        let userProfile = UserProfile.getInstance()
        let params = ["id" : "1228",
                      "perfis" : "\(userProfile?.id ?? 13349)",
                      "user" : "",
                      "time" : "1657390028215",
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
        
        let str_url = Constants.baseUrl+Constants.API_METHOD_EPISODEINFOFULL
        AF.request(str_url, parameters: params)
            .response{ [self] response in
                
                if let data = response.data {
                    print(data)
                    debugPrint("API====>>>\(str_url)\n\nParam=====>>\(params)\n\nResult=====>>\(response.result)")
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        #if TARGET_OS_IOS
                            let data = TMWPIX.Movie()
                        #else
                            let data = TMWPIXtvOS.Movie()
                        #endif
                        
                        
                        //------- Epidoe Data ----------------------
                        let episodeData = dictonary!["episode"]
                        if let arrayOfDic = episodeData as? [Dictionary<String,AnyObject>]{
                            for aDic in arrayOfDic{
                                if let id = aDic["id"] as? String{
                                    print(id)
                                    data.movies?.id = id
                                }
                                if let name = aDic["name"] as? String{
                                    print(name)
                                    data.movies?.name = name
                                }
                                if let trailer = aDic["trailer"] as? String{
                                    print(trailer)
                                    data.movies?.trailer = trailer
                                }
                                if let year = aDic["year"] as? String{
                                    print(year)
                                    data.movies?.year = year
                                }
                                if let duration = aDic["duration"] as? String{
                                    print(duration)
                                    data.movies?.duration = duration
                                }
                                if let parental_control = aDic["parental_control"] as? String{
                                    print(parental_control)
                                    data.movies?.parental_control = parental_control
                                }
                                
                                if let description = aDic["description"] as? String{
                                    print(description)
                                    data.movies?.description = description
                                }
                                if let image = aDic["image"] as? String{
                                    print(image)
                                    data.movies?.image = image
                                }
                                if let url = aDic["url"] as? String{
                                    print(url)
                                    data.movies?.url = url
                                }
                                if let created = aDic["created"] as? String{
                                    print(created)
                                    data.movies?.created = created
                                }
                                if let category = aDic["category"] as? String{
                                    print(category)
                                    data.movies?.category = category
                                }
                                if let aluguel = aDic["aluguel"] as? String{
                                    print(aluguel)
                                    data.movies?.aluguel = aluguel
                                }
                                if let preco = aDic["preco"] as? String{
                                    print(preco)
                                    data.movies?.preco = preco
                                }
                                if let alugado = aDic["alugado"] as? String{
                                    print(alugado)
                                    data.movies?.alugado = alugado
                                }
                                if let restoaluguel = aDic["restoaluguel"] as? String{
                                    print(restoaluguel)
                                    data.movies?.restoaluguel = restoaluguel
                                }
                                if let finalaluguel = aDic["finalaluguel"] as? String{
                                    print(finalaluguel)
                                    data.movies?.finalaluguel = finalaluguel
                                }
                                if let classificacao = aDic["classificacao"] as? String{
                                    print(classificacao)
                                    data.movies?.classificacao = classificacao
                                }
                                if let background = aDic["background"] as? String{
                                    print(background)
                                    data.movies?.background = background
                                }
                                if let precoaluguel = aDic["precoaluguel"] as? String{
                                    print(precoaluguel)
                                    data.movies?.precoaluguel = precoaluguel
                                }
                                if let starttime = aDic["starttime"] as? String{
                                    print(starttime)
                                    data.movies?.starttime = starttime
                                }
                                
                            }
                        } // close bracket of Movies dict
                        
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
                        //
                        //                        let subtitleData = dictonary!["subtitles"]
                        //                        if let arrayOfDic = subtitleData as? [Dictionary<String,AnyObject>]{
                        //                            for aDic in arrayOfDic{
                        //                                if let id = aDic["id"] as? String{
                        //                                    print(id)
                        //                                    data.subtitles?.id = id
                        //                                }
                        //                                if let idioma = aDic["idioma"] as? String{
                        //                                    print(idioma)
                        //                                    data.subtitles?.idioma = idioma
                        //                                }
                        //
                        //                                if let siglaidioma = aDic["siglaidioma"] as? String{
                        //                                    print(siglaidioma)
                        //                                    data.subtitles?.siglaidioma = siglaidioma
                        //                                }
                        //                                if let arquivo = aDic["arquivo"] as? String{
                        //                                    print(arquivo)
                        //                                    data.subtitles?.arquivo = arquivo
                        //                                }
                        //                                if let codificacao = aDic["codificacao"] as? String{
                        //                                    print(codificacao)
                        //                                    data.subtitles?.codificacao = codificacao
                        //                                }
                        //                            }
                        //                        } // close bracket of Subtitle data
                        //
                        //                        //--------- Audio data ------------
                        //
                        //                        let audioData = dictonary!["audio"]
                        //                        if let arrayOfDic = audioData as? [Dictionary<String,AnyObject>]{
                        //                            for aDic in arrayOfDic{
                        //                                if let id = aDic["id"] as? String{
                        //                                    print(id)
                        //                                    data.subtitles?.id = id
                        //                                }
                        //                                if let idioma = aDic["idioma"] as? String{
                        //                                    print(idioma)
                        //                                    data.subtitles?.idioma = idioma
                        //                                }
                        //
                        //                                if let siglaidioma = aDic["siglaidioma"] as? String{
                        //                                    print(siglaidioma)
                        //                                    data.subtitles?.siglaidioma = siglaidioma
                        //                                }
                        //                                if let map = aDic["map"] as? String{
                        //                                    print(map)
                        //                                    data.subtitles?.arquivo = map
                        //                                }
                        //                            }
                        //                        } // close bracket of Subtitle data
                        
                        self.movieData.append(contentsOf: [data])
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
    }
    
}

