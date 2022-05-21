//
//  Currencies.swift
//  WebService
//
//  Created by Luis Fernando Cuevas Cuauhtle on 21/5/22.
//

import Foundation


struct Currencies: Codable {
    
    let USD: String
    let GBP: String
    let EUR: String
    
    enum CodingKeys: String, CodingKey{
        
        case USD
        case GBP
        case EUR
        
    }
    
}
