//
//  RepoViewModel.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    func fetchGitRepos()
}


final class RepoViewModel: ViewModelDelegate {
    
    private weak var viewController: MainViewControllerProtocol?
    private var networkManager: NetworkManagerProtocol
    
    init(
        viewController: MainViewControllerProtocol,
        networkManager: NetworkManagerProtocol
    ) {
        self.viewController = viewController
        self.networkManager = networkManager
    }
    
    func fetchGitRepos() {
        let url = URL(string: NetworkConstant.url)
        
        networkManager.makeRequest(
            with: url,
            expecting: [RepositoryModel].self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let gitRepos):
                    viewController?.updateView(with: gitRepos)
                case .failure(let error):
                    viewController?.showErrorAlert(message: error.description)
                }
            }
    }
}
