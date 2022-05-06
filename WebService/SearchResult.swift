//
//  SearchResult.swift
//  WebService
//
//  Created by Luis Fernando Cuevas Cuauhtle on 19/4/22.
//

import Foundation

struct SearchResult: Codable{
    let results: [SearchItem]
    
    enum CodingKeys: String,CodingKey {
        case results
    }
}
