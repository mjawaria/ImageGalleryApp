//
//  ImageViewModel.swift
//  ImageGalleryApp
//
//  Created by Mukul on 27/09/24.
//

import SwiftUI
import Combine

class ImageViewModel: ObservableObject {
    @Published var images: [ImageData] = []
    var cancellables = Set<AnyCancellable>()
    
    // Custom Image Cache
    var cache = NSCache<NSString, UIImage>()
    
    init() {
        fetchImages()
    }
    
    // Fetch image metadata
    func fetchImages() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [ImageData].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageData in
                self?.images = imageData
            }
            .store(in: &cancellables)
    }
    
    // Load image with cache
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: url as NSString) {
            completion(cachedImage)
            return
        }
        
        guard let imageUrl = URL(string: url) else { return }
        URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            // Cache the image
            self?.cache.setObject(image, forKey: url as NSString)
            completion(image)
        }.resume()
    }
}
