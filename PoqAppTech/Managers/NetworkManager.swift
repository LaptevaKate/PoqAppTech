//
//  NetworkManager.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import Foundation

protocol NetworkManagerProtocol {
    
    func makeRequest<T: Decodable>(
        with url: URL,
        expecting: T.Type ,
        completion: @escaping(Result<T, NetworkError>) -> Void
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
}
