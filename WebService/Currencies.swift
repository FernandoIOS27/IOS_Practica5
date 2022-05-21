//
//  Currencies.swift
//  WebService
//
//  Created by Luis Fernando Cuevas Cuauhtle on 21/5/22.
//

import Foundation


struct Currencies: Codable {
    
    let currencyData: [Currencydata]
    
    enum CodingKeys: String, CodingKey {
        
        case currencyData
        
    }
    
}
