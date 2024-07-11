//
//  MainViewController.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import UIKit

final class RepoViewController: UIViewController {
    
    private var viewModel: RepoViewModel
    private var gitRepos: [RepoModel] = []
    weak var coordinator: AppCoordinator?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RepoTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
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
        setUpNavigationTitle()
        bind(viewModel: viewModel)
        setupUI()
        fetchData()
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
            let alert = UIAlertController(title: AlertErrorConstants.Text.errorTitle, message: message, preferredStyle: .alert)
            let retryAction = UIAlertAction(title: AlertErrorConstants.Text.errorActionTitle, style: .default) { [weak self] _ in
                self?.activityIndicator(isShow: true)
                self?.viewModel.fetchGitRepos()
            }
            alert.addAction(retryAction)
            self?.present(alert, animated: true, completion: nil)
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func activityIndicator(isShow: Bool) {
        isShow ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    @objc private func fetchData() {
        viewModel.fetchGitRepos()
    }
}

//MARK: - UI
private extension RepoViewController {
    private func setUpNavigationTitle() {
        title = MainScreenConstants.titleText
        navigationController?.navigationBar.backgroundColor = .purple
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func setupUI() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
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
    
    enum MainScreenConstants {
        static let titleText = "All Repos"
    }
}

// MARK: - UITableViewDataSource
extension RepoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RepoTableViewCell.self)
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor(red: 230/255,
                                           green: 230/255,
                                           blue: 250/255,
                                           alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.white
        }
        let gitRepo = gitRepos[indexPath.row]
        cell.configure(
            title: gitRepo.name,
            subtitle: gitRepo.description ?? AlertErrorConstants.Text.noDescriptionAvailable
        )
        cell.accessoryType = .disclosureIndicator
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
