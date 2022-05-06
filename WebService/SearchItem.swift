//
//  SearchItem.swift
//  WebService
//
//  Created by Luis Fernando Cuevas Cuauhtle on 19/4/22.
//

import Foundation

// Codable es el Motor de Base de Datos de Swift

struct SearchItem: Codable {
    let artistName: String
    let price: Double?
    let currency: String?
    let copyright: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case artistName // Si viene tal como hemos asignado el nombre lo dejamos así
        case price = "collectionPrice"
        case currency
        case copyright
        case description
    }
}
