//
//  ImageCache.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()

    private let cache: URLCache
    
    init() {
        cache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "imageCache")
    }
    
    func getImage(for url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        
        if let response = cache.cachedResponse(for: request),
           let image = UIImage(data: response.data) {
            return image
        }
        return nil
    }
    
    func cacheImage(_ image: UIImage, for url: URL) {
        guard let data = image.pngData(),
              let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "1.1", headerFields: nil) else {
            return
        }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        let request = URLRequest(url: url)
        cache.storeCachedResponse(cachedResponse, for: request)
    }
}
