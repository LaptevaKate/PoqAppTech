//
//  RepoDetailsViewModel.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import UIKit

final class RepoDetailsViewModel {
    // DI (Initializer Injection)
    private var networkManager: NetworkManagerProtocol
    private let repo: RepoModel

    init(repo: RepoModel, networkManager: NetworkManagerProtocol) {
        self.repo = repo
        self.networkManager = networkManager
    }
    
    var getImageSuccess: ((UIImage) -> Void)?
    var repoTitle: String {
        return repo.name
    }
    
    func getImage() {
        guard let url = URL(string: repo.owner.avatarURL) else { return }
        
        networkManager.fetchImage(
            with: url) { [weak self] result in
                switch result {
                case .success(let image):
                    self?.getImageSuccess?(image)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
