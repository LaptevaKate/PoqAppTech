//
//  RepoDetailsViewController.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import UIKit

final class RepoDetailsViewController: UIViewController {
    
    private lazy var repoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [repoImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    weak var coordinator: AppCoordinator?
    private var viewModel: RepoDetailsViewModel
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: RepoDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind(viewModel: viewModel)
        viewModel.getImage()
        rotateView(targetView: repoImageView, duration: 3)
    }
    
    private func bind(viewModel: RepoDetailsViewModel) {
        viewModel.getImageSuccess = { [weak self] image in
            self?.repoImageView.image = image
        }
    }
    private func rotateView(targetView: UIView, duration: Double) {
        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
            self.repoImageView.transform = self.repoImageView.transform.rotated(by: .pi)
            self.repoImageView.transform = self.repoImageView.transform.rotated(by: .pi)
        }, completion: nil)
        
    }
}

//MARK: - UI
private extension RepoDetailsViewController {
    func setupUI() {
        navigationItem.title = viewModel.repoTitle
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
