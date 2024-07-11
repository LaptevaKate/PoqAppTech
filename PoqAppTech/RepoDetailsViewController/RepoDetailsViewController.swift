//
//  RepoDetailsViewController.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import UIKit

final class RepoDetailsViewController: UIViewController {
    
    weak var coordinator: AppCoordinator?
    private var viewModel: RepoDetailsViewModel
    
    // MARK: - Components
    private lazy var repoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [repoNameLabel, repoImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = CGFloat(DetailScreenConstants.stackViewSpacing)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let repoNameLabel = UILabel()
    
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
        rotateView(targetView: repoImageView, duration: DetailScreenConstants.rotateViewDuration)
        backButtonToRepoTapped()
    }
    
    private func backButtonToRepoTapped() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: DetailScreenConstants.backButtonImageName),for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, 
                             action: #selector(backButtonTapped),
                             for: .touchUpInside)
        let customBackButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = customBackButton
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func bind(viewModel: RepoDetailsViewModel) {
        viewModel.getImageSuccess = { [weak self] image in
            self?.repoImageView.image = image
        }
    }
    private func rotateView(targetView: UIView, duration: Double) {
        UIView.animate(withDuration: duration,
                       delay: DetailScreenConstants.rotateViewDurationDelay,
                       options: [],
                       animations: {
            self.repoImageView.transform = self.repoImageView.transform.rotated(by: .pi)
            self.repoImageView.transform = self.repoImageView.transform.rotated(by: .pi)
        }, completion: nil)
    }
}

//MARK: - UI and Constants
private extension RepoDetailsViewController {
    func setupUI() {
        navigationItem.title = DetailScreenConstants.titleText
        setupAttributedText()
        view.backgroundColor = .customColorPurple
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupAttributedText() {
        let shadow = NSShadow()
        shadow.shadowBlurRadius = DetailScreenConstants.radiusForShadowBlur
        shadow.shadowColor = UIColor.darkGray
        shadow.shadowOffset = .init(
            width: DetailScreenConstants.setShadowOffWidth,
            height: DetailScreenConstants.setShadowOffWidth)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(
                name: DetailScreenConstants.fontName,
                size: DetailScreenConstants.fontSize)!,
            .shadow: shadow
        ]
        
        let fullString = DetailScreenConstants.labelText + viewModel.repoTitle
        let attributedString = NSMutableAttributedString(
            string: fullString,
            attributes: attributes)
        
        if let range = (fullString as NSString).range(of: viewModel.repoTitle) as NSRange? {
            attributedString.addAttribute(
                .foregroundColor,
                value: UIColor.red,
                range: range)
        }
        
        repoNameLabel.attributedText = attributedString
    }
    
    enum DetailScreenConstants {
        static let stackViewSpacing = 40
        static let backButtonImageName = "arrowshape.backward.fill"
        static let rotateViewDuration: Double = 3
        static let rotateViewDurationDelay: Double = 0.0
        static let titleText = "Detail Repos"
        static let radiusForShadowBlur: CGFloat = 5
        static let setShadowOffWidth = 2
        static let setShadowOffHight = 5
        static let fontName = "Ubuntu-Bold"
        static let fontSize = 18.0
        static let labelText = "Detail Repo Name is "
    }
}
