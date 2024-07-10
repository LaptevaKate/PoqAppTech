//
//  NetworkManager.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import Foundation

protocol NetworkManagerProtocol {
    
    func makeRequest<T: Decodable>(
        with url: URL?,
        expecting: T.Type ,
        completion: @escaping(Result<T, NetworkError>) -> Void
    )
}

final class NetworkManager: NetworkManagerProtocol {
    
    func makeRequest<T: Decodable>(
        with url: URL?,
        expecting: T.Type,
        completion: @escaping(Result<T, NetworkError>) -> Void
    ) {
        guard let url = url else {
            return completion(.failure(NetworkError.invalidURL))
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return completion(.failure(NetworkError.invalidData))
            }
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(NetworkError.generalMessage))
            }
        }
        task.resume()
    }
}
