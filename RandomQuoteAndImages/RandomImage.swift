//
//  RandomImage.swift
//  RandomQuoteAndImages
//
//  Created by Karlos Aguirre Zaragoza on 15/03/23.
//

import Foundation

struct RandomImage: Decodable {
    let image: Data
    let quote: Quote
}

struct Quote: Decodable {
    let content: String
}
