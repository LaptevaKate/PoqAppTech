//
//  MockNetworkService.swift
//  PoqAppTechTests
//
//  Created by Екатерина Лаптева on 11.07.24.
//

import UIKit
@testable import PoqAppTech
    
    final class MockNetworkManager: NetworkManagerProtocol {
        
        var shouldReturnError = false
        var mockRepos: [RepoModel] = []
        var mockImage: UIImage?
        
        func makeRequest<T>(with url: URL, expecting: T.Type, completion: @escaping (Result<T, PoqAppTech.NetworkError>) -> Void) where T : Decodable {
            if shouldReturnError {
                completion(.failure(NetworkError.generalMessage))
            } else {
                completion(.success(mockRepos as! T))
            }
        }
        
        func fetchImage(with url: URL, completion: @escaping (Result<UIImage, PoqAppTech.NetworkError>) -> Void) {
            if shouldReturnError {
                completion(.failure(NetworkError.generalMessage))
            } else if let image = mockImage {
                completion(.success(image))
            } else {
                completion(.failure(NetworkError.invalidData))
            }
        }
    }
