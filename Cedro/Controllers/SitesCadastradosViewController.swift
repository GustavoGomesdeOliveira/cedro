//
//  SitesCadastradosViewController.swift
//  Cedro
//
//  Created by Gustavo Gomes de Oliveira on 13/05/2018.
//  Copyright © 2018 Gustavo Gomes de Oliveira. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class SitesCadastradosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var listaDeSites: Array<Site> = []
    var siteParaEdicao: Site!
    var token: String?
    @IBOutlet weak var tableViewSites: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewSites.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataTableView(notification:)), name: .reloadTableViewListaSite, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        token = KeychainWrapper.standard.string(forKey: Constantes.token)
        if(token != nil) {
            recuperaSites()
        }
    }
    
    func recuperaSites() {
        var contador = 0
        var quantidadeSites = 0
        listaDeSites.removeAll()
        let userDefaults = UserDefaults.standard
        
        if let highscore = userDefaults.value(forKey: Constantes.quantidadeSite) {
            quantidadeSites = highscore as! Int
        }
        
        while contador <= quantidadeSites {
            let site = Site()
            
            site.urlSite =  site.recuperarURLSite(posicao: String(contador))
            if(site.urlSite != Constantes.semSite) {
                site.emailSite =  site.recuperarEmailSite(posicao: String(contador), url: site.urlSite)
                site.senhaSite =  site.recuperarSenhaSite(posicao: String(contador), url: site.urlSite)
                listaDeSites.append(site)
                site.recuperaSiteIMG(token: self.token!)
            }
            contador = contador + 1
        }
    }
    
    @objc func reloadDataTableView(notification: NSNotification) {
        DispatchQueue.main.async {
            self.tableViewSites.reloadData()
        }
    }
    
    @IBAction func segueAdicionarSite(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constantes.segueAdicionarSite, sender: self)
    }
    
    @IBAction func segueCadastroLogin(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constantes.segueCadastroLogin, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == Constantes.segueAdicionarSite && siteParaEdicao != nil) {
            let cadastroSiteVC = segue.destination as! CadastroSiteViewController
            cadastroSiteVC.site = siteParaEdicao
            siteParaEdicao = nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaDeSites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSite", for: indexPath) as! SiteTableViewCell
        cell.imgSite.image = nil
        let site = listaDeSites[indexPath.row]
        cell.lblNomeSite.text = site.urlSite
        cell.lblEmailUsuario.text = site.emailSite
        if(site.imgSite != nil) {
            cell.activityIndicatorCarregandoImagem.stopAnimating()
            cell.imgSite.image = site.imgSite
            cell.imgSite.layer.cornerRadius = cell.imgSite.frame.size.width / 2;
            cell.imgSite.clipsToBounds = true;
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.siteParaEdicao = listaDeSites[indexPath.row]
        performSegue(withIdentifier: Constantes.segueAdicionarSite, sender: self)
    }
}

extension Notification.Name {
    static let reloadTableViewListaSite = Notification.Name(Constantes.reloadTableViewListaSite)
}
