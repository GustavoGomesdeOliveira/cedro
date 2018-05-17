//
//  LoginViewController.swift
//  Cedro
//
//  Created by Gustavo Gomes de Oliveira on 14/05/2018.
//  Copyright © 2018 Gustavo Gomes de Oliveira. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftKeychainWrapper
import LocalAuthentication

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfSenha: UITextField!
    var keyboardUp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfEmail.delegate = self
        tfSenha.delegate = self
    }
    
    @IBAction func loginTouchId(_ sender: UIButton) {
        let auth = LAContext()
        auth.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Insira a digital para realizar o login",
            reply: { [unowned self] (success, error) -> Void in
                if( success ) {
                    let usuario = Usuario()
                    let emailUsuario: String = usuario.recuperaEmailUsuario()
                    let senhaUsuario: String = usuario.recuperaEmailUsuario()
                    if(emailUsuario.count > 0 && senhaUsuario.count > 0) {
                        self.requestLogin(email: emailUsuario, senha: senhaUsuario)
                    } else {
                        self.mostraAlerta(title: "Erro", message: "Falha ao realizar o login, dados não cadastrados")
                    }
                }else {
                    self.mostraAlerta(title: "Erro", message: "Falha ao realizar o login com a digital")
                }
        })
    }
    
    @IBAction func logar(_ sender: UIButton) {
        if(tfEmail.text?.count != 0 && tfSenha.text?.count != 0) {
            requestLogin(email: tfEmail.text!, senha: tfSenha.text!)
        } else {
            self.mostraAlerta(title: "Erro", message: "Por favor, certifique-se que todos os campos estão preenchidos")
        }
        
    }
    
    func requestLogin(email: String, senha: String) {
        let parameters: Parameters = ["email":email, "password":senha]
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            ]
        
        
        Alamofire.request("https://dev.people.com.ai/mobile/api/v2/login",  method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            if response.result.value != nil {
                if let json = response.result.value{
                    let dict = json as! NSDictionary
                    if let token = dict["token"] {
                        if(KeychainWrapper.standard.set(token as! String, forKey: Constantes.token)) {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    } else {
                        self.mostraAlerta(title: "Erro", message: "Falha ao realizar o login")
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
