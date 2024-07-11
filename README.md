# PoqAppTech

## 🎯 Project Overview

### App Overview
**Name:** PoqAppTech
**Full Name:** GitHub Repositories App
**Platform:** iOS
**Framework:** UIKit
**Language:** Swift
**Architectural pattern:** MVVM + Coordinator
**Libraries:** only Native - UIKit and Foundation

### App Features
Two Screens:
1. **MainRepo Screen:**
   - Displays a scrollable list of repositories from the "square" organization on GitHub.
   - Each repository shows the name and description.

2. **DetailRepo Screen:**
   - Shows detailed information about a selected repository.
   - Includes the repository name and avatar.
   - The avatar image animates and turns around.
   - The name is displayed using a custom font (Ubuntu-font.ttf) with a shadow effect.

### App Development Approach
Followed the MVVM (Model-View-ViewModel) + Coordinator architecture.
Only Native Libraries implementation to avoid dependencies
Focus on test coverage for better reliability and reusability.
Designed for easy extension by different developers in the future.

### Data Source

- **API Used:** Open API from GitHub
- **URL:** [https://api.github.com/orgs/square/repos](https://api.github.com/orgs/square/repos)

### Network Manager Class

- **URLSession**
- Utilizes the Open API to fetch data from the GitHub API.
- Implements two methods:
  - `makeRequest(with:expecting:completion:)`: Performs a network request to fetch and decode data from a specified URL.
  - `fetchImage(with:completion:)`: Fetches an image asynchronously from a specified URL using URLSession.

### NetworkManagerProtocol

- Defines the methods for fetching JSON data and images from a URL.
- Acts as the interface between ViewModels and the Network Manager.

### Data Models

- **RepoModel:**
  - A struct that conforms to the Decodable protocol.
  - Represents the information about a repository fetched from the server.

### Data Binding

- Data binding from ViewModel to ViewController is achieved using closures.
- Provides a seamless connection between the ViewModel and the Network Service.

### Failure States

- Enum Constants for Failure States:
  - `invalidURL`: Represents an invalid URL.
  - `invalidData`: Represents invalid or corrupt data.
  - `generalMessage`: Represents a general failure or error state.

### Unit Tests

- In Unit Tests for ViewModels, verifies the successful fetch of git repositories by setting up mock data, asserting the received repository values, and waiting for the updateView closure to be called.

### UI Tests

- In UI Tests, testing the display of a table view, the existence of the first cell in the table view, and the interaction with a table view cell in a UI test using XCTest.

### Requirements

- iOS 15+
- Supporting destination: iPhone
- Orientation: Portrait

### 🚀 Technologies

👩‍💻 The following tools were used in The Project:

* Swift
* UIKit
* MVVM + Coordinator
* SOLID
* DI (Initializer Injection)
* Binding (with closures)
* Handling of loading and failure states
* UI programmatically
* AutoLayout (with Anchors)
* UITableView
* UIStackView
* URLSession
* GCD
* NSAttributedString
* UIViewAnimation
* Unit Tests
* UI Tests
