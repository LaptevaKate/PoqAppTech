//
//  PoqAppTechTests.swift
//  PoqAppTechTests
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import XCTest
@testable import PoqAppTech

final class PoqAppTechTests: XCTestCase {
    
    var viewModel: RepoViewModel!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUpWithError() throws {
        // This method is called before each test case.
        // It initializes the `mockNetworkManager` and `viewModel` to be used in the test.
        // The `mockNetworkManager` is a mock object that simulates networking behavior.
        // The `viewModel` is the view model being tested.
        // This allows setting up the necessary dependencies for the test case.
        mockNetworkManager = MockNetworkManager()
        viewModel = RepoViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDownWithError() throws {
        // This method is called after each test case.
        // It performs the necessary cleanup by resetting the `viewModel` and `mockNetworkManager` to nil.
        viewModel = nil
        mockNetworkManager = nil
    }
    
    func testFetchGitRepos_Success() {
        // This is a test case method that verifies the successful fetch of git repositories.
        // It creates an expectation to wait for an asynchronous operation to complete.
        let expectation = XCTestExpectation(description: "Fetch git repos success")
        // Set up the mock data for the network manager.
        // In this case, we mock the response with a single repository.
        mockNetworkManager.mockRepos = [RepoModel(name: "Repo1", description: "Description1", owner: Owner(avatarURL: "MOKOwner"))]
        // Set up the expectation for the `updateView` closure in the view model.
        // The closure is called when the repositories are updated.
        // It asserts that the received repositories match the expected values.
        viewModel.updateView = { repos in
            XCTAssertEqual(repos.count, 1)
            XCTAssertEqual(repos.first?.name, "Repo1")
            expectation.fulfill()
        }
        // Trigger the fetchGitRepos method in the view model.
        viewModel.fetchGitRepos()
        // Wait for the expectation to be fulfilled.
        // This ensures that the `updateView` closure is called and the assertions are executed.
        wait(for: [expectation], timeout: 1.0)
    }
}
