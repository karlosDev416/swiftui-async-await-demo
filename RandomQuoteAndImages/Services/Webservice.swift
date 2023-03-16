//
//  Webservice.swift
//  RandomQuoteAndImages
//
//  Created by Karlos Aguirre Zaragoza on 15/03/23.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidImage(Int)
    case decodingError
}

class Webservice {
    
    func getRandomImages(ids: [Int]) async throws -> [RandomImage] {
        var randomImages: [RandomImage] = []
        try await withThrowingTaskGroup(of: (Int, RandomImage).self, body: { group in
            for id in ids {
                group.addTask { [self] in
                    return (id, try await getRandomImage(id: id))
                }
            }
            
            for try await (_, randomImage) in group {
                randomImages.append(randomImage)
            }
        })
        
        return randomImages
    }
    
    func getRandomImage(id: Int) async throws -> RandomImage {
        guard let url = Constants.Urls.getRandomImageUrl() else {
            throw NetworkError.badUrl
        }
        
        guard let randomQuoteUrl = Constants.Urls.randomQuoteUrl else {
            throw NetworkError.badUrl
        }
        
        async let (imageData, _) = URLSession.shared.data(from: url)
        async let (randomQuoteData, _) = URLSession.shared.data(from: randomQuoteUrl)
        
        guard let quote = try? await JSONDecoder().decode(Quote.self, from: randomQuoteData) else {
            throw NetworkError.decodingError
        }
        return try await RandomImage(image: imageData, quote: quote)
    }
}
