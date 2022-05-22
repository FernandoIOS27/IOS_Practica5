//
//  SearchResult.swift
//  WebService
//
//  Created by Luis Fernando Cuevas Cuauhtle on 19/4/22.
//

import Foundation

struct SearchResult: Codable{
    //let time: Time
    let disclaimer: String
    let chartName: String
    //let bpi: Currencies
    
    enum CodingKeys: String,CodingKey {
        
        //case time
        case disclaimer
        case chartName
        //case bpi
    }
}
