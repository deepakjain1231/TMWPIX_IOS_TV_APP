//
//  ConfigStart.swift
//  TMWPIX
//
//  Created by Apple on 15/08/2022.
//

import Foundation
struct ConfigStart : Codable {
    let name : String?
    let address : String?
    let email : String?
    let type : String?
    let created : String?
    let plano : String?
    let planoId : Int?
    let planoPreco : Double?
    let planoPerfis : Int?
    let planoAcessos : Int?
    let planoHD : String?
    let planoFullHD : String?
    let planoAluguelGratis : Int?
    let aluguelGratisRestante : Int?
    let podeAlugar : Int?
    let password : String?
    let token : String?
    let aluguelGratis : Int?
    let idCliente : Int?
    let cpf : String?
    let alugadosX : Int?
    let currentVersion : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case address = "address"
        case email = "email"
        case type = "type"
        case created = "created"
        case plano = "Plano"
        case planoId = "PlanoId"
        case planoPreco = "PlanoPreco"
        case planoPerfis = "PlanoPerfis"
        case planoAcessos = "PlanoAcessos"
        case planoHD = "PlanoHD"
        case planoFullHD = "PlanoFullHD"
        case planoAluguelGratis = "PlanoAluguelGratis"
        case aluguelGratisRestante = "AluguelGratisRestante"
        case podeAlugar = "PodeAlugar"
        case password = "Password"
        case token = "Token"
        case aluguelGratis = "AluguelGratis"
        case idCliente = "idCliente"
        case cpf = "cpf"
        case alugadosX = "AlugadosX"
        case currentVersion = "currentVersion"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        created = try values.decodeIfPresent(String.self, forKey: .created)
        plano = try values.decodeIfPresent(String.self, forKey: .plano)
        planoId = try values.decodeIfPresent(Int.self, forKey: .planoId)
        planoPreco = try values.decodeIfPresent(Double.self, forKey: .planoPreco)
        planoPerfis = try values.decodeIfPresent(Int.self, forKey: .planoPerfis)
        planoAcessos = try values.decodeIfPresent(Int.self, forKey: .planoAcessos)
        planoHD = try values.decodeIfPresent(String.self, forKey: .planoHD)
        planoFullHD = try values.decodeIfPresent(String.self, forKey: .planoFullHD)
        planoAluguelGratis = try values.decodeIfPresent(Int.self, forKey: .planoAluguelGratis)
        aluguelGratisRestante = try values.decodeIfPresent(Int.self, forKey: .aluguelGratisRestante)
        podeAlugar = try values.decodeIfPresent(Int.self, forKey: .podeAlugar)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        aluguelGratis = try values.decodeIfPresent(Int.self, forKey: .aluguelGratis)
        idCliente = try values.decodeIfPresent(Int.self, forKey: .idCliente)
        cpf = try values.decodeIfPresent(String.self, forKey: .cpf)
        alugadosX = try values.decodeIfPresent(Int.self, forKey: .alugadosX)
        currentVersion = try values.decodeIfPresent(String.self, forKey: .currentVersion)
    }

}
