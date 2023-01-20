//
//  ImageCache.swift
//  Recipes
//
//

import UIKit

extension UIImageView {

    func load(url: URL?,
              placeholder: UIImage? = UIImage(systemName: "fork.knife"),
              cache: URLCache = URLCache.shared) {
        
        guard let url = url else {
            self.image = placeholder
            return
        }
        
        let request = URLRequest(url: url)
        
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
            
        } else {
            
            self.image = placeholder
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, _) in
                if let data = data,
                   let response = response,
                   ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300,
                   let image = UIImage(data: data) {
                    
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }).resume()
        }
    }
}
