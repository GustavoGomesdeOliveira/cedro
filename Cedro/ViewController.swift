//
//  ViewController.swift
//  Cedro
//
//  Created by Gustavo Gomes de Oliveira on 12/05/18.
//  Copyright © 2018 Gustavo Gomes de Oliveira. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cadastrar(_ sender: UIButton) {
        performSegue(withIdentifier: Constantes.segueCadastro, sender: self)
    }
    
    
    @IBAction func logar(_ sender: UIButton) {
        let auth = LAContext()
        var error:NSError?
        
        self.performSegue(withIdentifier: Constantes.segueLogar, sender: self)
        
//        guard auth.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
//            showAlertViewIfNoBiometricSensorHasBeenDetected()
//            self.performSegue(withIdentifier: "segue_logar", sender: self)
//            return
//        }
//
//        auth.evaluatePolicy(
//            .deviceOwnerAuthenticationWithBiometrics,
//            localizedReason: "Digital não reconhecida",
//            reply: { [unowned self] (success, error) -> Void in
//
//                if( success ) {
//                    self.navigateToAuthenticatedViewController()
//                }else {
//                    if let error = error {
//
//                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message: error.localizedDescription)
//                        self.performSegue(withIdentifier: "segue_logar", sender: self)
//                    }
//
//                }
//        })
    }
    
//    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
//
//        showAlertWithTitle(title: "Error", message: "This device does not have a TouchID sensor.")
//
//    }
    
    func showAlertViewAfterEvaluatingPolicyWithMessage( message:String ){
        
        showAlertWithTitle(title: "Error", message: message)
        
    }
    
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async() { () -> Void in
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
    }
        
    func navigateToAuthenticatedViewController(){
        
        if let loggedInVC = storyboard?.instantiateViewController(withIdentifier: "SiteCadastradoViewController") {
            
            DispatchQueue.main.async() { () -> Void in
                
                self.navigationController?.pushViewController(loggedInVC, animated: true)
                
            }
            
        }
        
    }

}

extension UIViewController {
    func hideKeyboard() {
        let tapDismissKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tapDismissKeyboard)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

