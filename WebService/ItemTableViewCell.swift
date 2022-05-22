//
//  ItemTableViewCell.swift
//  WebService
//
//  Created by Luis Fernando Cuevas Cuauhtle on 2/5/22.
//

// MARK: FRAMEWORKS

import UIKit

// MARK: MAIN CLASS

class ItemTableViewCell: UITableViewCell {
    
    // MARK: CELL LIFE CYCLE
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    // MARK: Outlets
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currentRateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var precisionRateLabel: UILabel!
    
    // MARK: FUNCTIONS
    
    func setUpCellWith(currency: Currencydata){
        
        currencyLabel.text = currency.code
        
        descriptionLabel.text = currency.description
        
        var symbol = currency.symbol
        
        html2string(text: &symbol)
        
        currentRateLabel.text = "\(String(symbol)) \(currency.rate)"
        
        precisionRateLabel.text = "\(currency.rate_float)"
    }

    func html2string(text: inout String){
        if text == "&#36;" {
            
            text = "$"
            
        } else {
            if text == "&pound;"{
                text = "￡"
                } else {
                    text = "€"
                }
            }
        }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
