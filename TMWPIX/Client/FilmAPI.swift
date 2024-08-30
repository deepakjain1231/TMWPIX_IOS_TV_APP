//
//  FilmAPI.swift
//  TMWPIX
//
//  Created by Apple on 17/08/2022.
//

import Foundation

import Alamofire

class FilmAPI{
    
    //    func getConfigStartData(time:String,hash:String, dtoken:String, os:String, usrtoken:String, hashtoken:String){
    //        let params = ["appversion" : "1.3",
    //                      "user" : "",
    //                      "perfil" : "13349",
    //                      "infantil" : "1",
    //                      "time" : time,
    //                      "hash" : hash,
    //                      "dtoken" : dtoken,
    //                      "os" : os,
    //                      "operator" : "1",
    //                      "tipo" : "t",
    //                      "usrtoken" : usrtoken,
    //                      "hashtoken" : hashtoken,
    //        ]
    //
    //        AF.request(Constants.baseUrl+Constants.API_METHOD_RECENTMOVIES, parameters: params)
    //            .response{ [self] response in
    //                if let data = response.data {
    //                    do {
    //                        let result = try JSONDecoder().decode([FetchMovies].self, from: data)
    //                        arrMovies.append(contentsOf: result)
    //                        for i in arrMovies{
    //                            print(i.movies! as String)
    //                        }
    //                    } catch {
    //                        print(error)
    //                    }
    //                }
    //            }
    //    }// close braket of getConfigStartData
    //
    
    
    // fetch film Series
    static func getFilmSeriesData(delegate: SeriesViewController){
        let userInfo = UserInfo.getInstance()
        let userProfile = UserProfile.getInstance()
        let userToken: String = userInfo?.token ?? ""
        
        let params: [String: String] = ["appversion" : utils.getAppVersion(),
                                        "user" : "",
                                        "perfil" : "\(userProfile?.id ?? 0)",
                                        "infantil" : "\(userProfile?.infantil ?? 0)",
                                        "time" : utils.getTime(),
                                        "hash" : utils.getHash(),
                                        "dtoken" : utils.getDToken(),
                                        "os" : "ios",//utils.getOperatingSystem(),
                                        "operator" : "1",
                                        "tipo" : "t",
                                        "token" : userToken,
                                        "usrtoken" : userToken,

                                        "hashtoken" : utils.getHashToken(token: (userToken))]
        
        let queryParams = params.getQueryItems()
        
        AF.request(Constants.baseUrl+Constants.API_METHOD_MOVIES_NEW+queryParams,method: .get).response{  response in
            if let data = response.data {
                do {
                    let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                    
                    guard let profileData = dictonary?["contents"] else { return }
                    if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                        
                        var filmData:[FilmSeries] = []
                        for aDic in arrayOfDic{
                            let data = FilmSeries()
                           
            
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
//                            if let parental_control = aDic["parental_control"] as? String{
//                                data.parental_control = parental_control
//                            }
//                            if let midiatype = aDic["midiatype"] as? String{
//                                data.midiatype = midiatype
//                            }
                            if let aluguel = aDic["aluguel"] as? Int{
                                data.aluguel = aluguel
                            }
//                            if let novidade = aDic["novidade"] as? Int{
//                                data.novidade = novidade
//                            }
//                            
//                            if let preco = aDic["preco"] as? Int{
//                                data.preco = preco
//                            }
                            filmData.append(contentsOf: [data])
                        }
                        
                        delegate.handleFilmSeriesData(films: filmData)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            } else {
                getFilmSeriesData(delegate: delegate)
            }
        }
    } // Close Bracket of getFilmSeriesData
    
    
    //======== Fetch Film Series ==============
    //    func getSeriesData(user: String,
    //                           time: String,
    //                           hash: String,
    //                           dtoken: String,
    //                           usrtoken: String,
    //                           hashtoken: String
    //    ){
    //        let params = ["appversion" : "1.3",
    //                      "user" : user,
    //                      "infantil" : "1",
    //                      "time" : time,
    //                      "hash" : hash,
    //                      "dtoken" : dtoken,
    //                      "time" : time,
    //                      "hash" : hash,
    //                      "dtoken" : dtoken,
    //                      "os" : utils.getOperatingSystem(),
    //                      "operator" : "1",
    //                      "tipo" : "t",
    //                      "usrtoken" : usrtoken,
    //                      "hashtoken" : hashtoken
    //        ]
    //
    //        AF.request(Constants.baseUrl+Constants.API_METHOD_ALUGASERIE, parameters: params)
    //            .response{ [self] response in
    //
    //                if let data = response.data {
    //                    print(data)
    //                    print(response.result)
    //                    do {
    //                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
    //
    //                        let profileData = dictonary!["error"]
    //                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
    //                            for aDic in arrayOfDic{
    //                                let data = FilmSeries()
    //
    //                                if let id = aDic["id"] as? Int{
    ////                                    print(code)
    //                                    data.id = id
    //                                }
    //
    //                                if let name = aDic["name"] as? String{
    ////                                    print(code)
    //                                    data.name = name
    //                                }
    //                                if let image = aDic["image"] as? String{
    ////                                    print(code)
    //                                    data.image = image
    //                                }
    //                                if let category = aDic["category"] as? Int{
    ////                                    print(code)
    //                                    data.category = category
    //                                }
    //                                if let parental_control = aDic["parental_control"] as? String{
    ////                                    print(code)
    //                                    data.parental_control = parental_control
    //                                }
    //                                if let midiatype = aDic["midiatype"] as? String{
    ////                                    print(code)
    //                                    data.midiatype = midiatype
    //                                }
    //                                if let aluguel = aDic["aluguel"] as? Int{
    ////                                    print(code)
    //                                    data.aluguel = aluguel
    //                                }
    //                                if let novidade = aDic["novidade"] as? Int{
    ////                                    print(code)
    //                                    data.novidade = novidade
    //                                }
    //
    //                                if let preco = aDic["preco"] as? Int{
    //                                    print(preco)
    //                                    data.preco = preco
    //                                }
    //
    //                                self.fetchFilmSeries.append(contentsOf: [data])
    //                            }
    //                        }
    //
    //                    } catch let error as NSError {
    //                        print(error)
    //                    }
    //                }
    //            }
    //    } // Close Bracket of getFilmSeriesData
    
    
    
    //======== Fetch Film Catagories ==============
    static func getFilmCategoryData(delegate: CategoryViewController){
        let userInfo = UserInfo.getInstance()
        
        let params = [
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
        
        
        let str_url = Constants.baseUrl+Constants.API_METHOD_CATEGORIES_MOVIES
        AF.request(str_url, parameters: params)
            .response{response in
                
                if let data = response.data {
                    print(data)
                    debugPrint("API====>>>\(str_url)\n\nParam=====>>\(params)\n\nResult=====>>\(response.result)")
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
                        
                        let profileData = dictonary!["categories"]
                        if let arrayOfDic = profileData as? [Dictionary<String,AnyObject>]{
                            var categoryData:[Catagory] = []
                            for aDic in arrayOfDic{
                                let data = Catagory()
                                if let id = aDic["id"] as? Int{
                                    print(id)
                                    data.id = id
                                }
                                
                                if let nome = aDic["nome"] as? String{
                                    print(nome)
                                    data.nome = nome
                                }
                                categoryData.append(contentsOf: [data])
                            }
                            delegate.handleCategoryData(category: categoryData)
                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
    } // Close Bracket of getFilmSeriesData
    
    //======== Opejn Movie Full Info ========
    static func getMovieInfoData(delegate: DetailsFilmViewController){
        let userProfile = UserProfile.getInstance()
        let params = ["id" : "\(delegate.FilmID ?? "")",
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
        
        let str_url = Constants.baseUrl+Constants.API_METHOD_MOVIEINFOFULL + "?id=\(delegate.FilmID ?? "")&time=1657435701486&os=ios&operator=1&tipo=t&usrtoken=\(UserInfo.getInstance()?.token ?? "")&perfis=\(userProfile?.id ?? 13349)"
        
        AF.request(str_url, parameters: nil).response{ [self] response in
                
                if let data = response.data {
                    print(data)
                    debugPrint("API====>>>\(str_url)\n\nParam=====>>\(params)\n\nResult=====>>\(response.result)")
                    do {
                        let dictonary =  try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:AnyObject]
#if TARGET_OS_IOS
                        let movieData = TMWPIX.Movie()
#else
                        let movieData = TMWPIXtvOS.Movie()
#endif
                        
                        //------- Epidoe Data ----------------------
                        let moviesData = dictonary!["movies"]
                        if let arrayOfDic = moviesData as? [Dictionary<String,AnyObject>]{
                            for aDic in arrayOfDic{
                                movieData.movies = Movies()
                                if let id = aDic["id"] as? String {
                                    movieData.movies?.id = id
                                }
                                if let id = aDic["id"] as? Int {
                                    movieData.movies?.id = "\(id)"
                                }
                                if let name = aDic["name"] as? String {
                                    movieData.movies?.name = name
                                }
                                if let trailer = aDic["trailer"] as? String {
                                    movieData.movies?.trailer = trailer
                                }
                                if let year = aDic["year"] as? String {
                                    movieData.movies?.year = year
                                }
                                if let year = aDic["year"] as? Int {
                                    movieData.movies?.year = "\(year)"
                                }
                                if let duration = aDic["duration"] as? String {
                                    movieData.movies?.duration = duration
                                }
                                if let parental_control = aDic["parental_control"] as? String {
                                    movieData.movies?.parental_control = parental_control
                                }
                                if let description = aDic["description"] as? String {
                                    movieData.movies?.description = description
                                }
                                if let image = aDic["image"] as? String {
                                    movieData.movies?.image = image
                                }
                                if let urlString = aDic["url"] as? String {
                                                                    if urlString.contains("play.m3u8") {
                                                                        let newUrlString = urlString.replacingOccurrences(of: "play.m3u8", with: "playapple.m3u8")
                                                                        movieData.movies?.url = newUrlString
                                                                    } else {
                                                                        movieData.movies?.url = urlString
                                                                    }
                                                                }
                                if let created = aDic["created"] as? String {
                                    movieData.movies?.created = created
                                }
                                if let category = aDic["category"] as? String {
                                    movieData.movies?.category = category
                                }
                                if let aluguel = aDic["aluguel"] as? String {
                                    movieData.movies?.aluguel = aluguel
                                }
                                if let aluguel = aDic["aluguel"] as? Int {
                                    movieData.movies?.aluguel = "\(aluguel)"
                                }
                                if let preco = aDic["preco"] as? String {
                                    movieData.movies?.preco = preco
                                }
                                if let preco = aDic["preco"] as? Double {
                                    movieData.movies?.preco = "\(preco)"
                                }
                                if let alugado = aDic["alugado"] as? String {
                                    movieData.movies?.alugado = alugado
                                }
                                if let alugado = aDic["alugado"] as? Int {
                                    movieData.movies?.alugado = "\(alugado)"
                                }
                                if let restoaluguel = aDic["restoaluguel"] as? String {
                                    movieData.movies?.restoaluguel = restoaluguel
                                }
                                if let finalaluguel = aDic["finalaluguel"] as? String {
                                    movieData.movies?.finalaluguel = finalaluguel
                                }
                                if let classificacao = aDic["classificacao"] as? String {
                                    movieData.movies?.classificacao = classificacao
                                }
                                if let background = aDic["background"] as? String {
                                    movieData.movies?.background = background
                                }
                                if let precoaluguel = aDic["precoaluguel"] as? String {
                                    movieData.movies?.precoaluguel = precoaluguel
                                }
                                if let starttime = aDic["starttime"] as? String {
                                    movieData.movies?.starttime = starttime
                                }
                            }
                        } // close bracket of movies dict
                        
                        //----------- Extra Data ------------------
                        
                        let extraData = dictonary!["extra"]
                        if let arrayOfEtra = extraData as? [Dictionary<String,AnyObject>]{
                            for aDic in arrayOfEtra{
                                movieData.extra = Extra()
                                if let legenda = aDic["legenda"] as? String{
                                    print(legenda)
                                    movieData.extra?.audios = legenda
                                }
                                if let audios = aDic["audios"] as? String{
                                    print(audios)
                                    movieData.extra?.audios = audios
                                }
                            }
                        } // close bracket of extra data
                        
                        //--------- Subtitles data ------------
                        
                        let subtitleData = dictonary!["subtitles"]
                        if let arrayOfDic = subtitleData as? [Dictionary<String,AnyObject>]{
                            for aDic in arrayOfDic{
                                movieData.subtitles = Subtitles()
                                if let id = aDic["id"] as? String{
                                    print(id)
                                    movieData.subtitles?.id = id
                                }
                                if let idioma = aDic["idioma"] as? String{
                                    print(idioma)
                                    movieData.subtitles?.idioma = idioma
                                }
                                
                                if let siglaidioma = aDic["siglaidioma"] as? String{
                                    print(siglaidioma)
                                    movieData.subtitles?.siglaidioma = siglaidioma
                                }
                                if let arquivo = aDic["arquivo"] as? String{
                                    print(arquivo)
                                    movieData.subtitles?.arquivo = arquivo
                                }
                                if let codificacao = aDic["codificacao"] as? String{
                                    print(codificacao)
                                    movieData.subtitles?.codificacao = codificacao
                                }
                            }
                        } // close bracket of Subtitle data
                        
                        //--------- Audio data ------------
                        
                        let audioData = dictonary!["audio"]
                        if let arrayOfDic = audioData as? [Dictionary<String,AnyObject>]{
                            for aDic in arrayOfDic{
                                movieData.audio = Audio()
                                
                                if let id = aDic["id"] as? String {
                                    movieData.audio?.id = id
                                }
                                if let idioma = aDic["idioma"] as? String {
                                    movieData.audio?.idioma = idioma
                                }
                                if let siglaidioma = aDic["siglaidioma"] as? String {
                                    movieData.audio?.siglaidioma = siglaidioma
                                }
                                if let map = aDic["map"] as? String {
                                    movieData.audio?.map = map
                                }
                            }
                        } // close bracket of Subtitle data
                        
                        delegate.handleFilmInfoData(movie: movieData)
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
    }
    
    static func reportError(delegate: ErrorResolvedViewController, completion: @escaping ([String: Any]?) -> Void) {
        let userInfo = UserInfo.getInstance()
        let userProfile = UserProfile.getInstance()
        
        let str_url = Constants.baseUrl+Constants.API_METHOD_ERRORTICKET
        
        let params = ["descricao"       : "\(delegate.tfError.text)",
                      "setor"           : "filmes",
                      "idconteudo"      : delegate.FilmID,
                      "clientes_id"     : "\(userInfo?.client_id)",
                      "perfis_id"       : "\(userProfile?.id ?? 13349)",
                      "user"            : "",
                      "time"            : "1657390028215",
                      "hash"            : "6b44ce6d55fb47f49a08c4ed436be469",
                      "dtoken"          : userInfo?.password,
                      "os"              : "ios",
                      "operator"        : "1",
                      "tipo"            : "t",
                      "usrtoken"        : userInfo?.token,
                      "hashtoken"       : "fc427b261087b109867e42961ca645ce",
                      "page"            : "movie"]
        
        var request = URLRequest(url: URL(string: "\(str_url)?descricao=\(delegate.tfError.text ?? "")&setor=filmes&idconteudo=\(delegate.FilmID ?? "")&clientes_id=\(userInfo?.client_id ?? 0)&perfis_id=\(userProfile?.id ?? 13349)&user=&time=1657390028215&hash=6b44ce6d55fb47f49a08c4ed436be469&dtoken=\(userInfo?.password ?? "")&os=ios& operator=1&tipo=t&usrtoken=\(userInfo?.token ?? "")&hashtoken=fc427b261087b109867e42961ca645ce&page=movie")!,timeoutInterval: 60.0)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let str_response = String(data: data, encoding: .utf8) ?? ""
            let dict_response = self.convertToDictionary(text: str_response)
            debugPrint(dict_response)
            completion(dict_response)
            delegate.handleErrorReport(success: true)
        }
        task.resume()
    }
    
    
    static func check_report_Status(film_id: String, completion: @escaping (String) -> Void) {
        let userInfo = UserInfo.getInstance()
        let userProfile = UserProfile.getInstance()
        
        let str_URL = Constants.baseUrl+Constants.API_METHOD_TICKETSTATUS
        
        let params = ["idconteudo": film_id,
                      "cliente_id": "\(userInfo?.client_id ?? 0)",
                      "tipoconteudo": "filmes",
                      "perfis": "\(userProfile?.id ?? 13349)",
                      "user": "",
                      "time": "1657390028215",
                      "hash": "6b44ce6d55fb47f49a08c4ed436be469",
                      "dtoken": "\(userInfo?.password ?? "")",
                      "os": "ios",
                      "operator": "1",
                      "tipo": "t",
                      "usrtoken": userInfo?.token,
                      "hashtoken": "fc427b261087b109867e42961ca645ce"]
        
        var request = URLRequest(url: URL(string: "\(str_URL)?idconteudo=\(film_id)&cliente_id=\(userInfo?.client_id ?? 0)&tipoconteudo=filmes&perfis=\(userProfile?.id ?? 13349)&user=&time=1657390028215&hash=6b44ce6d55fb47f49a08c4ed436be469&dtoken=\(userInfo?.password ?? "")&os=ios&operator=1&tipo=t&usrtoken=\(userInfo?.token ?? "")&hashtoken=fc427b261087b109867e42961ca645ce")!,timeoutInterval: 60.0)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            var str_response = String(data: data, encoding: .utf8) ?? ""
            str_response = str_response.replacingOccurrences(of: "\\", with: "")
            str_response = str_response.replacingOccurrences(of: "\"", with: "")
            completion(str_response)
        }
        task.resume()
    }
    
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension [String:String] {
     func getQueryItems() -> String {
        var components = URLComponents()
        print(components.url!)
         components.queryItems = self.map {
            URLQueryItem(name: $0, value: $1)
        }
        return (components.url?.absoluteString)!
    }
}
