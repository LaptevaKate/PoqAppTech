//
//  MainViewController.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func updateView(with gitRepos: [RepositoryModel])
    func showErrorAlert(message: String)
}

final class MainViewController: UIViewController {
    
    private enum Constants {
        enum Text {
            static let noDescriptionAvailable: String = "No description available"
            static let errorTitle: String = "Error"
            static let errorActionTitle: String = "Retry"
        }
    }
    
    private var viewModel: RepoViewModel?
    private var gitRepos: [RepositoryModel] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomTableViewCell.self)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        setupTableView()
        setupViewWithData()
        setupRefreshControl()
        activityIndicator(isShow: true)
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
        viewModel?.fetchGitRepos()
    }
    
    private func setupViewWithData() {
        viewModel?.fetchGitRepos()
    }
}

// MARK: - MainViewControllerProtocol

extension MainViewController: MainViewControllerProtocol {
    
    func updateView(with gitRepos: [RepositoryModel]) {
        self.gitRepos = gitRepos
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.activityIndicator(isShow: false)
        }
    }
    
    func showErrorAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: Constants.Text.errorTitle, message: message, preferredStyle: .alert)
            let retryAction = UIAlertAction(title: Constants.Text.errorActionTitle, style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.activityIndicator(isShow: true)
                self.viewModel?.fetchGitRepos()
            }
            alert.addAction(retryAction)
            self.present(alert, animated: true, completion: nil)
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(CustomTableViewCell.self)
        let gitRepo = gitRepos[indexPath.row]
        cell.configure(
            title: gitRepo.name,
            subtitle: gitRepo.description ?? Constants.Text.noDescriptionAvailable
        )
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
