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
        return false
    }
    
    func getRealAlugual(){
        SeriesApi.getRealAluguelData(email: "sdfas", confirma: "asdf", cpf: "b sa", client_id: "asdf", serie_id: "Sad", user: "safdas", time: "Sadas", hash: "sdad", dtoken: "sad", tipo: "sadf", usrtoken: "asdf", hashtoken: "asdfas")
    }
    
    
    // from get current time API
    func getCurrentTime(){
        epgApi.getTimeData()
    }
    
    //from config getcobrancas API
    func getCobrancas(){
        configAPI.getCobrancasData()
    }
    
    // From enable aluguel
    func getEnableAlugual(){
        configAPI.getEnableAluguelData(time: "asd", hash: "asd", dtoken: "asd", tipo: "asd", usrtoken: "asd", hashtoken: "asd")
    }
    
    // From Movie => Start3
    func getMovieTickets(){
        movieApi.getTicketsData()
    }
    
    //from Movie => Start2
    func getMovieInfo(){
        movieApi.getMovieInfoData()
    }
}

