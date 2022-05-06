//
//  ItemTableViewCell.swift
//  WebService
//
//  Created by Luis Fernando Cuevas Cuauhtle on 19/4/22.
//

// MARK: Celda de Elemento de Vista de Tabla - Music Item (SearchItem)

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    
   
    // Asignación de Textos a Labels
    func setUpWith(searchItem: SearchItem){
        
        // Cada celda tendrá un SearchItem
        descriptionLabel.numberOfLines = 0
        artistNameLabel.text = searchItem.artistName
        descriptionLabel.text = searchItem.description
        copyrightLabel.text = searchItem.copyright
        
        if let price = searchItem.price, let currency = searchItem.currency{
            priceLabel.text = "\(price) \(currency)"
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
