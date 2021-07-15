//
//  NetworkManager.swift
//  iFlickr
//
//  Created by Mike Conner on 7/13/21.
//

import UIKit

final class NetworkManager {
    
    // MARK: - Shared Instance
    static let shared = NetworkManager()
    
    // MARK: - Properties
    private let cache = NSCache<NSString, UIImage>()
    var searchTerm: String?
    var url: URL? {
        guard var searchTerm = searchTerm else { return nil }
        searchTerm = cleanSearchTerm(searchTerm)
        let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne?tagmode=any&format=json&nojsoncallback=1&tags=\(searchTerm)"
        print(baseURL)
        if let url = URL(string: baseURL) {
            return url
        }
        return nil
    }
    
    func cleanSearchTerm(_ searchTerm: String) -> String {
        var string = searchTerm.replacingOccurrences(of: " ", with: ",")
        while string.contains(",,") {
            string = string.replacingOccurrences(of: ",,", with: ",")
        }
        return string
    }
    
    // MARK: - Functions
    func searchPhotos(completion: @escaping (Result<[Photo], NetworkError>) -> ()) {
        
        guard let url = url else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
                print("Error in \(#function) : \(error.localizedDescription) \n---\n\(error)")
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200  {
                completion(.failure(.non200Response(response)))
                print("Invalid response from server: \(response.description)")
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(Photos.self, from: data)
                decodedResponse.items.isEmpty ? completion(.failure(.noData)) : completion(.success(decodedResponse.items))
            } catch {
                completion(.failure(.unableToDecode))
            }
        }.resume()
        
    } // End of searchPhotos function
    
    func downloadPhotos(fromMedia media: String, completion: @escaping (UIImage?) -> Void) {
        
        let cacheKey = NSString(string: media)
        
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
        }
        
        guard let url = URL(string: media) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil)
                print("Error in \(#function) : \(error.localizedDescription) \n---\n\(error)")
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200  {
                completion(nil)
                print("Invalid response from server: \(response.description)")
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }.resume()
        
    } // End of downloadPhotos function
    
} // End of class
