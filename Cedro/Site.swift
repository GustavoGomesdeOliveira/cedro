//
//  Site.swift
//  Cedro
//
//  Created by Gustavo Gomes de Oliveira on 15/05/2018.
//  Copyright © 2018 Gustavo Gomes de Oliveira. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import Alamofire
class Site: NSObject {
    
    var urlSite: String!
    var posicao: String!
    var emailSite: String!
    var senhaSite: String!
    var imgSite: UIImage!
    
    func cadastrarSite(posicao: String, url: String) -> Bool{
        return KeychainWrapper.standard.set(url, forKey: posicao)
    }
    
    func cadastrarSenhaSite(senha: String, url: String) -> Bool {
        return KeychainWrapper.standard.set(senha, forKey: url + "senha")
    }
    
    func cadastrarEmailSite(email: String, url: String) -> Bool {
        return KeychainWrapper.standard.set(email, forKey: url + "email")
    }
    
    func recuperarURLSite(posicao: String) -> String {
        self.posicao = posicao
        if let retrievedString: String = KeychainWrapper.standard.string(forKey: posicao) {
            return retrievedString
        } else {
            return Constantes.semSite
        }
    }
    
    func recuperarSenhaSite(posicao: String, url: String)  -> String {
        let retrievedString: String? = KeychainWrapper.standard.string(forKey: url + "senha")
        return retrievedString!
    }
    
    func recuperarEmailSite(posicao: String, url: String)  -> String {
        let retrievedString: String? = KeychainWrapper.standard.string(forKey: url + "email")
        return retrievedString!
    }
    
    func recuperaSiteIMG(token: String) {
        let headers: HTTPHeaders = [
            "authorization": token,
            ]
        Alamofire.request("https://dev.people.com.ai/mobile/api/v2/logo/" + urlSite,  method: .get, headers: headers).response{ (response) in
            if response.data != nil{
                self.imgSite = UIImage(data: response.data!)!
                NotificationCenter.default.post(name: .reloadTableViewListaSite, object: nil)
            }
        }
    }
}
