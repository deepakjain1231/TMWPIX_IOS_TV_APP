//
//  LoginMiddleware.swift
//  TMWPIX
//
//  Created by Apple on 12/08/2022.
//

import Foundation

import UIKit

class Middlewares{
    
    var loginAPI = LoginAPI()
    var configAPI = ConfigAPI()
    //    var homeApi = HomeAPI()
    var SeriesApi = SeriesAPI()
    var FilmApi = FilmAPI()
    var ChannelApi = ChannelAPI()
    var RadioApi = RadioAPI()
    var epgApi = EPGAPI()
    var movieApi = MovieAPI()
    var profileData = ProfileAPI()
    
    // ============ Integratable Methods =============
    
    func isValidUser(email:String, password:String) -> Bool{
        loginAPI.getLoginFirstTimeData()
//        for data in loginAPI.UserInfo{
//            if(data.Email == email && data.Password == password){
//                return true
//            }
//        }
        return false
    }
    
    
//    // ----- From Home background Data
//    func getHomeData() -> [String]{
//        var ImageUrl: [String] = []
//        for url in HomeAPI.HomeData{
//            ImageUrl.append(url.url!)
//            //            print(url.url!)
//        }
//        return ImageUrl
//    }
    
//    ß
    
    // --------- From fetch radio API -----------
//    func getRadioData() ->([String],[String],[String]){
//        var RadioName: [String] = []
//        var Disc: [String] = []
//        var image: [String] = []
//        for data in RadioAPI.RadioData{
//            RadioName.append(data.name!)
//            Disc.append(data.description!)
//            image.append(data.image!)
//            //            print(data.name!)
//        }
//        return (RadioName,Disc,image)
//    }
    
    //===================================
    
    
    
    //====== Series API calls ===
    func getSeriesSeasonData(){
//        SeriesApi.getSeriesSeasonData()
//        for data in SeriesApi.SeriseSeasonData{
//            print(data.id)
//            print(data.name)
//            print(data.year)
//            print(data.series_id)
//        }
    }
    
    
    func getSeriesInfoData(){
//        SeriesApi.getSeriesInfoData()
//        for data in SeriesApi.SeriesInfoData{
//            print(data.id)
//            print(data.name)
//            print(data.trailer)
//            print(data.year)
//            print(data.parental_control)
//            print(data.description)
//            print(data.image)
//            print(data.created)
//            print(data.category)
//            print(data.aluguel)
//            print(data.preco)
//            print(data.alugado)
//            print(data.restoaluguel)
//            print(data.finalaluguel)
//            print(data.lastEpisode)
//            print(data.classificacao)
//            print(data.lastUrl)
//        }
    }
    
    
    func getSeriesEpisode(){
//        SeriesApi.getSeriesEpisodeData()
//        for data in SeriesApi.SeriesEpisodeData{
//            print(data.id)
//            print(data.number)
//            print(data.name)
//            print(data.url)
//            print(data.duration)
//            print(data.temporadas_id)
//        }
    }
    
    
    func getRealAlugual(){
        SeriesApi.getRealAluguelData(email: "sdfas", confirma: "asdf", cpf: "b sa", client_id: "asdf", serie_id: "Sad", user: "safdas", time: "Sadas", hash: "sdad", dtoken: "sad", tipo: "sadf", usrtoken: "asdf", hashtoken: "asdfas")
//        for data in SeriesApi.RealAluguelData{
//            print(data.code)
//            print(data.message)
            
//        }
    }
    
    
    func getOpenEpisode(){
        SeriesApi.getOpenEpisodeData()
//        for data in SeriesApi.OpenEpisodeData{
//            print(data.episode?.id)
//            print(data.extra?.legenda)
//            print(data.subtitles?.id)
//            print(data.audio?.idioma)
//        }
    }
    
    
//    func fetchRecentMovies(){
//        FilmApi.getConfigStartData(time: "dsfa", hash: "Dfsa", dtoken: "dasf", os: "dsaf", usrtoken: "dsaf", hashtoken: "ads")
////        for data in FilmApi.arrMovies{
////            print(data.movies)
////        }
//    }
    
    
//    func fetchFilmSeries(){
//        FilmApi.getFilmSeriesData(user: "sad", time: "asd", hash: "sad", dtoken: "sad", usrtoken: "sad", hashtoken: "sad")
////        for data in FilmApi.fetchFilmSeries{
////            print(data.message)
////        }
//    }
    
    
    func fetchFilmCategory(){
//        FilmApi.getFilmCategoryData()
//        for data in FilmApi.FilmCategory{
//            print(data.id)
//        }
    }
    
    
    func NowPlaying(){
//        ChannelApi.getNowPlayingData()
//        for data in ChannelApi.NowPlay{
//            print(data.agorastart)
//        }
    }
    
    
    
    
    
    
    // from get current time API
    func getCurrentTime(){
        epgApi.getTimeData()
//        for data in epgApi.TimeData{
//            print(data.Date)
//        }
    }
    
    //from config getcobrancas API
    func getCobrancas(){
        configAPI.getCobrancasData()
//        for data in configAPI.Cobrancas{
//            print(data.nome)
//        }
    }
    
    // From enable aluguel
    func getEnableAlugual(){
        configAPI.getEnableAluguelData(time: "asd", hash: "asd", dtoken: "asd", tipo: "asd", usrtoken: "asd", hashtoken: "asd")
//        for data in configAPI.AluguelBox{
//            print(data.code)
//        }
    }
    
    // From Movie => Start3
    func getMovieTickets(){
        movieApi.getTicketsData()
//        for data in movieApi.Ticket{
//            print(data.erro)
//        }
    }
    
    //from Movie => Start2
    func getMovieInfo(){
        movieApi.getMovieInfoData()
//        for data in movieApi.movieData{
//            print(data.movies?.category)
//        }
    }
}

