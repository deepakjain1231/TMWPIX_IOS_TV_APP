//
//  Constants.swift
//  TMWPIX
//
//  Created by Apple on 115/08/2022.
//
import UIKit


//IN CONFIG "ENABLE ALUGUEL"
/// This will help you change some settings for the app
class Constants {
    static let baseUrl: String = "http://api.tmwpix.com"
    
    //Api Methods
    static let API_METHOD_LOGIN: String = "/profiles"  // Done
    static let API_METHOD_SIGNUP: String = "/cliente/cadastro"  // Done
    static let API_METHOD_PROFILEDELETE: String = "/profiledelete"  // Done
    static let API_METHOD_PROFILEADD: String = "/profileadd"  // Done
    static let API_METHOD_HOME: String = "/anuncios/applista" // Done
    static let API_METHOD_SERIES: String = "/series" // Done
    static let API_METHOD_RECENTMOVIES: String = "/movies/recents" // Done
    static let API_METHOD_CATEGORIES_MOVIES: String = "/categories/movies" // Done
    static let API_METHOD_NOWPLAYING: String = "/channels/nowplaying" // Done
    static let API_METHOD_CHANNELS: String = "/channels3" // Done
    static let API_METHOD_SEASONS: String = "/serie/seasons"  //Done
    static let API_METHOD_USERINFO: String = "/user/info" //Done
    static let API_METHOD_SERIEINFO: String = "/serieinfo" // Done
    static let API_METHOD_EPISODES: String = "/serie/episodes" // Done
    static let API_METHOD_EPISODEINFOFULL: String = "/serie/episodeinfofull"// Done
    static let API_METHOD_ALUGASERIE: String = "/alugaserie"// Done
    static let API_METHOD_RADIOS: String = "/radios" // Done
    static let API_METHOD_EPGMINNOW: String = "/channels/returnepgminnow" // In Process
    static let API_METHOD_TIMENOW: String = "/channels/currentTimeNow"// Done
    static let API_METHOD_COBRANCAS: String = "/user/cobrancas" // Done
    static let API_METHOD_UPDATEALUGUELBOX: String = "/user/updateAluguelBox" // Done
    static let API_METHOD_MOVIEINFOFULL: String = "/movieinfofull" // Done
    static let API_METHOD_TICKET: String = "/ticket" //Done /
    static let API_METHOD_ERRORTICKET: String = "/sendticket" //Done /
    static let API_METHOD_TICKETSTATUS: String = "/ticket" //Done /
//    static let API_METHOD_MOVIEINFOFULL: String = "/movieinfofull"
    static let API_METHOD_GET_MOBILE_INFO: String = "/user/contactinfo"
    static let API_METHOD_LOGOUT: String = "/user/logout"
    
    
    static let API_METHOD_MOVIES_NEW: String = "/movies/recents"
    static let API_METHOD_SERIES_NEW: String = "/series"

    static let API_METHOD_LOG_FILM_TIME: String = "/log/logplayer"
    static let API_METHOD_CLOSE_ACCOUNT: String = "/conta/cancelamento"
    
    
    
    
    
    
    
    
    /// This is the AdMob Interstitial ad id
    static let adMobAdID: String = "ca-app-pub-9224997816212910/6306676529"
    static let adMobHomeBannerAdId: String = "ca-app-pub-9224997816212910/7455117958"
    static let adMobCategoryBannerAdId: String = "ca-app-pub-9224997816212910/7306427226"
    
    //smartlook sdk ID
    static let smartlookSDKId: String = "f368e8df21e7b6558547bf00d7a388744db9d082"
    
    
    /// Number of times the main screen appears before showing an ad
    static let mainScreenAdsFrequency: Int = 3
    
    /// This represents all categories in the app
    static let categories: [[String: NSNumber]] = [
        ["Build": 0], ["Basic": 0], ["Blush": 0], ["Food": 0],
        ["Awesome": 0], ["Elegant": 0], ["Activities": 0], ["Winter": 0], ["Animals": 1], ["Insects": 1], ["Props": 1], ["Rings": 1], ["Business": 1], ["Family": 1], ["Wedding": 1], ["Quotes": 1], ["Social Media": 1], ["Halloween": 1], ["Thanks Giving": 1], ["Pirates": 1], ["Super Hero": 1], ["Travel": 1]
    ]
}
