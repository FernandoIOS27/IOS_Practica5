//
//  ItemTableViewCell.swift
//  WebService
//
//  Created by Luis Fernando Cuevas Cuauhtle on 2/5/22.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    func setUpWith(searchItem: SearchItem){
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = searchItem.description
        
        artistNameLabel.text = searchItem.artistName
        
        copyrightLabel.text = searchItem.copyright
        if let price = searchItem.price, let currency = searchItem.currency {
            priceLabel.text = "\(price) \(currency)"}
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
