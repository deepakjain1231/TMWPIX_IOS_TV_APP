//
//  OpenEpisode.swift
//  TMWPIX
//
//  Created by Apple on 17/08/2022.
//

import Foundation

class OpenEpisode{
    var episode : Episode?
    var extra: Extra?
    var subtitles: Subtitles?
    var audio: Audio?
}

class Episode{
    var id : String?
    var number : String?
    var name : String?
    var url : String?
    var duration : String?
    var serie_id : String?
    var starttime : String?
}

class Extra{
    var legenda : String?
    var audios : String?
}

class Subtitles{
    var id : String?
    var idioma : String?
    var siglaidioma : String?
    var arquivo : String?
    var codificacao : String?
}

class Audio{
    var id : String?
    var idioma : String?
    var siglaidioma : String?
    var map : String?
}
