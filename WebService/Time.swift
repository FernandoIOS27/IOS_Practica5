//
//  SearchItem.swift
//  WebService
//
//  Created by Luis Fernando Cuevas Cuauhtle on 19/4/22.
//

import Foundation

// Codable es el Motor de Base de Datos de Swift

struct Time: Codable {
    let updated: String
    let updatedISO: String
    let updateduk: String
    
    enum CodingKeys: String, CodingKey {
        case updated
        case updatedISO
        case updateduk
    }
}
