//
//  MainViewController.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import UIKit

final class RepoViewController: UIViewController {
    
    private enum Constants {
        enum Text {
            static let noDescriptionAvailable: String = "No description available"
            static let errorTitle: String = "Error"
            static let errorActionTitle: String = "Retry"
        }
    }
    
    private var viewModel: RepoViewModel
    private var gitRepos: [RepositoryModel] = []
    weak var coordinator: AppCoordinator?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RepoTableViewCell.self)
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    init(viewModel: RepoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All Repos"
        bind(viewModel: viewModel)
        addSubviews()
        setupConstraints()
        setupTableView()
        setupViewWithData()
        setupRefreshControl()
        activityIndicator(isShow: true)
    }
    
    private func bind(viewModel: RepoViewModel) {
        viewModel.updateView = { [weak self] repos in
            self?.gitRepos = repos
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
                self?.activityIndicator(isShow: false)
        }
        
        viewModel.showErrorAlert = { [weak self] message in
                let alert = UIAlertController(title: Constants.Text.errorTitle, message: message, preferredStyle: .alert)
                let retryAction = UIAlertAction(title: Constants.Text.errorActionTitle, style: .default) { [weak self] _ in
                    self?.activityIndicator(isShow: true)
                    self?.viewModel.fetchGitRepos()
                }
                alert.addAction(retryAction)
                self?.present(alert, animated: true, completion: nil)
                self?.refreshControl.endRefreshing()
            
        }
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.addSubview(refreshControl)
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func activityIndicator(isShow: Bool) {
        isShow ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        viewModel.fetchGitRepos()
    }
    
    private func setupViewWithData() {
        viewModel.fetchGitRepos()
    }
}

// MARK: - UITableViewDataSource

extension RepoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RepoTableViewCell.self)
        let gitRepo = gitRepos[indexPath.row]
        cell.configure(
            title: gitRepo.name,
            subtitle: gitRepo.description ?? Constants.Text.noDescriptionAvailable
        )
        return cell
    }
}

// MARK: - UITableViewDelegate

extension RepoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let repo = gitRepos[indexPath.row]
        coordinator?.showDetailScreen(with: repo)
    }
}
