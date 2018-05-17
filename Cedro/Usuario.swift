//
//  Usuario.swift
//  Cedro
//
//  Created by Gustavo Gomes de Oliveira on 17/05/2018.
//  Copyright © 2018 Gustavo Gomes de Oliveira. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class Usuario: NSObject {
    
    func salvaUsuario(token: String) -> Bool {
        return KeychainWrapper.standard.set(token as! String, forKey: Constantes.token) &&
            KeychainWrapper.standard.set(self.tfEmailUsuario.text!, forKey: Constantes.emailUsuario) &&
            KeychainWrapper.standard.set(self.tfSenha.text!, forKey: Constantes.senhaUsuario)
    }
    
    func recuperaEmailUsuario() -> String {
        return KeychainWrapper.standard.string(forKey: Constantes.emailUsuario)!
    }
    
    func recuperaSenhaUsuario() -> String {
        return KeychainWrapper.standard.string(forKey: Constantes.senhaUsuario)!
    }
}
