//
//  RepoViewModel.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import Foundation

final class RepoViewModel {
    
    private var networkManager: NetworkManagerProtocol
    var updateView: (([RepositoryModel]) -> Void)?
    var showErrorAlert: ((String) -> Void)?
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchGitRepos() {
        guard let url = URL(string: NetworkConstant.url) else { return }
        
        networkManager.makeRequest(
            with: url,
            expecting: [RepositoryModel].self) { [weak self] result in
                switch result {
                case .success(let gitRepos):
                    self?.updateView?(gitRepos)
                case .failure(let error):
                    self?.showErrorAlert?(error.localizedDescription)
                }
            }
    }
}
