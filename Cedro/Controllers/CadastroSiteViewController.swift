//
//  CadastroSiteViewController.swift
//  Cedro
//
//  Created by Gustavo Gomes de Oliveira on 15/05/2018.
//  Copyright © 2018 Gustavo Gomes de Oliveira. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
import LocalAuthentication

class CadastroSiteViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfURL: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfSenha: UITextField!
    @IBOutlet weak var btnCadastraEditaSite: UIButton!
    
    var site: Site?
    
    override func viewDidLoad() {
     
        tfURL.delegate = self
        tfEmail.delegate = self
        tfSenha.delegate = self
        
        if(site != nil) {
            tfURL.text = site?.urlSite
            tfEmail.text = site?.emailSite
            tfSenha.text = site?.senhaSite
            btnCadastraEditaSite.setTitle("Editar site", for: .normal)
            self.enableTextField(enable: false)
        }
    }
    
    @IBAction func cadastrarSite(_ sender: UIButton) {
        if(self.site != nil) {
            KeychainWrapper.standard.removeObject(forKey: (self.site?.posicao)!)
            KeychainWrapper.standard.removeObject(forKey: (self.site?.urlSite)! + "email")
            KeychainWrapper.standard.removeObject(forKey: (self.site?.urlSite)! + "senha")
        }
        if((tfSenha.text?.count)! > 0 && (tfURL.text?.count)! > 0 && (tfSenha.text?.count)! > 0) {
            let site = Site()
            var numeroSites = 0
            let token = KeychainWrapper.standard.string(forKey: Constantes.token)
            if(token != nil) {
                
                let userDefaults = UserDefaults.standard
                
                if let highscore = userDefaults.value(forKey: "quantidadeSite") {
                    numeroSites = highscore as! Int
                }
                
                if(site.cadastrarSite(posicao: String(numeroSites), url: tfURL.text!) &&
                site.cadastrarSenhaSite(senha: tfSenha.text!, url: tfURL.text!) &&
                    site.cadastrarEmailSite(email: tfEmail.text!, url: tfURL.text!)) {
                     numeroSites = numeroSites + 1
                        userDefaults.setValue(numeroSites, forKey: "quantidadeSite")
                        userDefaults.synchronize()
                        navigationController?.popToRootViewController(animated: true)
                } else {
                    self.mostraAlerta(title: "Erro", message: "Falha ao cadastrar o site")
                }
            }
        } else {
            self.mostraAlerta(title: "Erro", message: "Por favor, certifique-se de que todos os campos estão preenchidos")
        }
    }
    
    @IBAction func deletaSite(_ sender: UIBarButtonItem) {
        if(site != nil) {
            let auth = LAContext()
            auth.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Insira a digital para deletar o site",
                reply: { [unowned self] (success, error) -> Void in
                    
                    if( success ) {
                        let removeSite: Bool = KeychainWrapper.standard.removeObject(forKey: (self.site?.posicao)!)
                        let removeUsuario: Bool = KeychainWrapper.standard.removeObject(forKey: (self.site?.urlSite)! + "email")
                        let removeSenha: Bool = KeychainWrapper.standard.removeObject(forKey: (self.site?.urlSite)! + "senha")
                        if(removeSite && removeUsuario && removeSenha) {
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }else {
                        self.mostraAlerta(title: "Erro", message: "Falha ao deletar o site")
                    }
            })
        }

    }
    
    @IBAction func editarSite(_ sender: UIBarButtonItem) {
        if(site != nil) {
            let auth = LAContext()
            auth.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Insira a digital para editar o site",
                reply: { [unowned self] (success, error) -> Void in
                    if( success ) {
                        self.enableTextField(enable: true)
                    }else {
                        self.mostraAlerta(title: "Erro", message: "Falha ao editar o site")
                    }
            })
        }
    }
    
    func enableTextField(enable: Bool) {
        DispatchQueue.main.async {
            self.tfURL.isEnabled = enable
            self.tfEmail.isEnabled = enable
            self.tfSenha.isEnabled = enable
            self.tfSenha.isSecureTextEntry = !enable
        }
    }
    
    func segueViewControllerAutenticacao(){
        
        if let loggedInVC = storyboard?.instantiateViewController(withIdentifier: "SiteCadastradoViewController") {
            DispatchQueue.main.async() { () -> Void in
                self.navigationController?.pushViewController(loggedInVC, animated: true)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

extension UIViewController {
    func mostraAlerta( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async() { () -> Void in
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}
