//
//  RepoDetailsViewController.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import UIKit

final class RepoDetailsViewController: UIViewController {
    weak var coordinator: AppCoordinator?
    let repo: RepositoryModel
    
    init(repo: RepositoryModel) {
        self.repo = repo
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = repo.name
        view.backgroundColor = .green
    }
}
