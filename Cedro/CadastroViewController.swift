//
//  CadastroViewController.swift
//  Cedro
//
//  Created by Gustavo Gomes de Oliveira on 13/05/2018.
//  Copyright © 2018 Gustavo Gomes de Oliveira. All rights reserved.
//

import Foundation
import UIKit
import PasswordTextField
import Alamofire
import SwiftKeychainWrapper

class CadastroViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tfNomeUsuario: UITextField!
    @IBOutlet weak var tfEmailUsuario: UITextField!
    @IBOutlet weak var tfSenha: PasswordTextField!
    
    var keyboardUp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfNomeUsuario.delegate = self
        tfEmailUsuario.delegate = self
        tfSenha.delegate = self
        hideKeyboard()
        
        let validation = RegexRule(regex: "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$&*]).{10,}$", errorMessage: "Por favor, insira uma senha de no mínimo 10 caracteres, contendo uma letra, um número e um caracter especial.")
        
        tfSenha.validationRule = validation

    }
    
    @IBAction func cadastrar(_ sender: UIButton) {
        if tfSenha.isInvalid(){
            self.mostraAlerta(title: "Erro", message: tfSenha.errorMessage())
        } else if(tfNomeUsuario.text?.count == 0 || tfEmailUsuario.text?.count == 0) {
            self.mostraAlerta(title: "Erro", message: "Por favor, cetifique-se que todos os campos estão preenchidos")
        } else {
            let parameters: Parameters = ["email":tfEmailUsuario.text! as String, "name":tfNomeUsuario.text! as String, "password":tfSenha.text! as String]
            let headers: HTTPHeaders = [
                "content-type": "application/json",
            ]
        
            Alamofire.request("https://dev.people.com.ai/mobile/api/v2/register", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
        
                    if let json = response.result.value{
                        let dict = json as! NSDictionary
                        if let token = dict["token"] {
                            let ususario = Usuario()
                            if(usuario.salvaUsuario(token)) {
                                self.navigationController?.popToRootViewController(animated: true)
                            } else {
                                self.mostraAlerta(title: "Erro", message: "Falha ao salvar o usuário")
                            }
                        }
                    }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
