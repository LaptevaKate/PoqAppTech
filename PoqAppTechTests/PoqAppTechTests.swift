//
//  PoqAppTechTests.swift
//  PoqAppTechTests
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import XCTest
@testable import PoqAppTech

import XCTest
@testable import PoqAppTech

final class PoqAppTechTests: XCTestCase {
    
    var viewModel: RepoViewModel!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUpWithError() throws {
        mockNetworkManager = MockNetworkManager()
        viewModel = RepoViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockNetworkManager = nil
    }
    
    func testFetchGitRepos_Success() {
        let expectation = XCTestExpectation(description: "Fetch git repos success")
        mockNetworkManager.mockRepos = [RepoModel(name: "Repo1", description: "Description1", owner: Owner(avatarURL: "MOKOwner"))]
        
        viewModel.updateView = { repos in
            XCTAssertEqual(repos.count, 1)
            XCTAssertEqual(repos.first?.name, "Repo1")
            expectation.fulfill()
        }

        viewModel.fetchGitRepos()
        
        wait(for: [expectation], timeout: 1.0)
    }
}
