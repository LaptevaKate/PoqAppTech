//
//  NerworkError.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidData
    case generalMessage
    
    var description: String {
        switch self {
        case .invalidURL:
            "Invalid URL"
        case .invalidData:
            "Invalid Data"
        case .generalMessage:
            "Something went wrong"
        }
    }
}
