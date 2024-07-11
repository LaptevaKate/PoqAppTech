//
//  NetworkManager.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import Foundation
import UIKit

/// A protocol defining the requirements for a network manager.
protocol NetworkManagerProtocol {
    
    /// Makes a network request and decodes the response into the specified type.
    ///
    /// - Parameters:
    ///   - url: The URL for the network request.
    ///   - expecting: The type to decode the response into.
    ///   - completion: A closure to be called once the request is completed, providing the result.
    func makeRequest<T: Decodable>(
        with url: URL,
        expecting: T.Type ,
        completion: @escaping(Result<T, NetworkError>) -> Void
    )
    
    /// Fetches an image from the specified URL.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to fetch.
    ///   - completion: A closure to be called once the image is fetched, providing the result.
    func fetchImage(
        with url: URL,
        completion: @escaping(Result<UIImage, NetworkError>) -> Void
    )
}

final class NetworkManager: NetworkManagerProtocol {
    
    /// Makes a network request with the given URL and decodes the response into the specified type.
    ///
    /// - Parameters:
    ///   - url: The URL for the network request.
    ///   - expecting: The type to decode the response into.
    ///   - completion: A closure to be called once the request is completed, providing the result.
    func makeRequest<T: Decodable>(
        with url: URL,
        expecting: T.Type,
        completion: @escaping(Result<T, NetworkError>) -> Void
    ) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            let result: Result<T, NetworkError>
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let data = data, error == nil else {
                result = .failure(NetworkError.invalidData)
                return
            }
            do {
                let data = try JSONDecoder().decode(expecting, from: data)
                result = .success(data)
            } catch {
                result = .failure(NetworkError.generalMessage)
            }
        }
        task.resume()
    }
    
    /// Fetches an image from the specified URL.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to fetch.
    ///   - completion: A closure to be called once the image is fetched, providing the result.
    func fetchImage(
        with url: URL,
        completion: @escaping(Result<UIImage, NetworkError>) -> Void
    ) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            let result: Result<UIImage, NetworkError>
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                result = .failure(NetworkError.invalidData)
                return
            }
            
            result = .success(image)
        }
        task.resume()
    }
}
