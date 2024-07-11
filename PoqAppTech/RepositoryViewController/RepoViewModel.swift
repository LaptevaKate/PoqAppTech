//
//  RepoViewModel.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import Foundation

final class RepoViewModel {
    
    // DI (Initializer Injection)
    private var networkManager: NetworkManagerProtocol
    var updateView: (([RepoModel]) -> Void)?
    var showErrorAlert: ((String) -> Void)?
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchGitRepos() {
        guard let url = URL(string: NetworkConstant.url) else { return }
        
        networkManager.makeRequest(
            with: url,
            expecting: [RepoModel].self) { [weak self] result in
                switch result {
                case .success(let gitRepos):
                    self?.updateView?(gitRepos)
                case .failure(let error):
                    self?.showErrorAlert?(error.localizedDescription)
                }
            }
    }
}
