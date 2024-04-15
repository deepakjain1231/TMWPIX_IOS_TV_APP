//
//  UserProfile.swift
//  TMWPIX
//
//  Created by Apple on 18/08/2022.
//

import Foundation

let kUserProfile = "UserProfile"
let kp_id = "id"
let kp_name = "name"
let kp_client_id = "client_id"
let kp_infantil = "infantil"
let kp_cpf = "cpf"
let kp_email = "email"
let kp_password = "password"
let kp_AluguelGratisRestante = "AluguelGratisRestante"
let kp_senha = "senha"


class UserProfile: NSObject, NSCoding {
    var id: Int?
    var name: String?
    var client_id: Int?
    var infantil: Int?
    var cpf: String?
    var email: String?
    var password: String?
    var AluguelGratisRestante: Int?
    var senha: String?
    
    class func getInstance() -> UserProfile? {
        if let data = UserDefaults.standard.object(forKey: kUserProfile) as? NSData {
            return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? UserProfile
        }
        return UserProfile()
    }

    
    func saveUserProfile() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: kUserProfile)
    }
    
    func removeUser() {
        id = 0
        name = ""
        client_id = 0
        infantil = 0
        cpf = ""
        email = ""
        password = ""
        AluguelGratisRestante = 0
        senha = ""
    }
    
    //MARK: ecoding/decoding methods for custom objects
    required convenience init(coder decoder: NSCoder) {
        self.init()
        id = 0
        name = ""
        client_id = 0
        infantil = 0
        cpf = ""
        email = ""
        password = ""
        AluguelGratisRestante = 0
        senha = ""

        if let t_id = decoder.decodeObject(forKey: kp_id) as? Int {
            self.id = t_id
        }
        if let t_name = decoder.decodeObject(forKey: kp_name) as? String {
            self.name = t_name
        }
        if let t_client_id = decoder.decodeObject(forKey: kp_client_id) as? Int {
            self.client_id = t_client_id
        }
        if let t_infantil = decoder.decodeObject(forKey: kp_infantil) as? Int {
            self.infantil = t_infantil
        }
        if let t_cpf = decoder.decodeObject(forKey: kp_cpf) as? String {
            self.cpf = t_cpf
        }
        if let t_email = decoder.decodeObject(forKey: kp_email) as? String {
            self.email = t_email
        }
        if let t_AluguelGratisRestante = decoder.decodeObject(forKey: kp_AluguelGratisRestante) as? Int {
            self.AluguelGratisRestante = t_AluguelGratisRestante
        }
        if let t_senha = decoder.decodeObject(forKey: kp_senha) as? String {
            self.senha = t_senha
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: kp_id)
        coder.encode(self.name, forKey: kp_name)
        coder.encode(self.client_id, forKey: kp_client_id)
        coder.encode(self.infantil, forKey: kp_infantil)
        coder.encode(self.cpf, forKey: kp_cpf)
        coder.encode(self.email, forKey: kp_email)
        coder.encode(self.AluguelGratisRestante, forKey: kp_AluguelGratisRestante)
        coder.encode(self.senha, forKey: kp_senha)
    }

}
