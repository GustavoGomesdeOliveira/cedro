//
//  SiteTableViewCell.swift
//  Cedro
//
//  Created by Gustavo Gomes de Oliveira on 13/05/2018.
//  Copyright © 2018 Gustavo Gomes de Oliveira. All rights reserved.
//

import UIKit

class SiteTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgSite: UIImageView!
    @IBOutlet weak var lblNomeSite: UILabel!
    @IBOutlet weak var lblEmailUsuario: UILabel!
    @IBOutlet weak var activityIndicatorCarregandoImagem: UIActivityIndicatorView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
