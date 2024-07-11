//
//  NetworkManager.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import Foundation
import UIKit

protocol NetworkManagerProtocol {
    
    func makeRequest<T: Decodable>(
        with url: URL,
        expecting: T.Type ,
        completion: @escaping(Result<T, NetworkError>) -> Void
    )
    
    func fetchImage(
        with url: URL,
        completion: @escaping(Result<UIImage, NetworkError>) -> Void
    )
}

final class NetworkManager: NetworkManagerProtocol {
    
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
