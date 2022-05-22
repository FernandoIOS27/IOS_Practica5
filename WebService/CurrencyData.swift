//
//  CurrenciesRate.swift
//  WebService
//
//  Created by Luis Fernando Cuevas Cuauhtle on 21/5/22.
//

import Foundation

struct Currencydata: Codable{
    
    let code: String
    let symbol: String
    let rate: String
    let description: String
    let rate_float: Float
    
    enum CodingKeys: String, CodingKey {
        
        case code
        case symbol
        case rate
        case description
        case rate_float
        
    }
    
}
