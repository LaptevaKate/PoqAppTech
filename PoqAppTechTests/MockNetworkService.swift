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
            // This method mocks the network request for retrieving data from a given URL.
            // It takes the URL, the expected type of the response, and a completion closure as parameters.
            // If `shouldReturnError` flag is true, it returns a failure result with a general network error.
            // Otherwise, it returns a success result with the mock repositories as the response.
            if shouldReturnError {
                completion(.failure(NetworkError.generalMessage))
            } else {
                completion(.success(mockRepos as! T))
            }
        }
        
        func fetchImage(with url: URL, completion: @escaping (Result<UIImage, PoqAppTech.NetworkError>) -> Void) {
            // This method mocks the network request for retrieving an image from a given URL.
            // It takes the URL and a completion closure as parameters.
            // If `shouldReturnError` flag is true, it returns a failure result with a general network error.
            // If `mockImage` is set, it returns a success result with the mock image.
            // Otherwise, it returns a failure result with an invalid data error.
            if shouldReturnError {
                completion(.failure(NetworkError.generalMessage))
            } else if let image = mockImage {
                completion(.success(image))
            } else {
                completion(.failure(NetworkError.invalidData))
            }
        }
    }
