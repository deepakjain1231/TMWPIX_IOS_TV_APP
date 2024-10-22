//
//  Movie.swift
//  TMWPIX
//
//  Created by Apple on 17/08/2022.
//

import Foundation

class Movie{
    var movies: Movies?
    var extra: Extra?
    var subtitles: Subtitles?
    var audio: Audio?
}

class Movies{
    var id: String?
    var name: String?
    var trailer: String?
    var year: String?
    var duration: String?
    var parental_control: String?
    var description: String?
    var image: String?
    var url: String?
    var created: String?
    var category: String?
    var aluguel: String?
    var preco: String?
    var alugado: String?
    var restoaluguel: String?
    var finalaluguel: String?
    var classificacao: String?
    var background: String?
    var precoaluguel: String?
    var starttime: Int?
}


class Contact_Info_Model{
    var contactInfo: [ContactInfo]?
}

class ContactInfo {
    var id: Int?
    var ddd: String?
    var numero: String?
    var ativo: Int?
}



