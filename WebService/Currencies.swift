//
//  Currencies.swift
//  WebService
//
//  Created by Luis Fernando Cuevas Cuauhtle on 21/5/22.
//

import Foundation


struct Currencies: Codable {
    
    let USD: Currencydata
    let GBP: Currencydata
    let EUR: Currencydata
    
    enum CodingKeys: String, CodingKey {
        
        case USD
        case GBP
        case EUR
        
    }
    
}
