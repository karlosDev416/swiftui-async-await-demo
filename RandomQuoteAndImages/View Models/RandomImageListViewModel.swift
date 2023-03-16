//
//  RandomImageListViewModel.swift
//  RandomQuoteAndImages
//
//  Created by Karlos Aguirre Zaragoza on 15/03/23.
//

import UIKit

@MainActor
class RandomImageListViewModel: ObservableObject {
    
    @Published var randomImages: [RandomImageViewModel] = []
    
    func getRandomImages(ids: [Int]) async {
        let webservice = Webservice()
        randomImages = []
        do {
            try await withThrowingTaskGroup(of: (Int, RandomImage).self, body: { group in
                for id in ids {
                    group.addTask {
                        return (id, try await webservice.getRandomImage(id: id))
                    }
                }
                for try await (_, randomImage) in group {
                    randomImages.append(RandomImageViewModel(randomImage: randomImage))
                }
            })
        } catch {
            print(error)
        }
    }
}

struct RandomImageViewModel:Identifiable {
    
    let id = UUID()
    fileprivate let randomImage:RandomImage
    
    var image: UIImage? {
        UIImage(data: randomImage.image)
    }
    
    var quote: String? {
        randomImage.quote.content
    }
}
