//
//  PostsViewModelTests.swift
//  MVVMCombineDemoTests
//
//  Created by Vicky Prajapati on 09/03/24.
//
import XCTest
import Combine
import Alamofire
@testable import MVVMCombineDemo

class ViewModelTests: XCTestCase {
    var viewModel: PostsViewModel!
    var apiManagerMock: APIManagerMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        apiManagerMock = APIManagerMock()
        viewModel = PostsViewModel(apiManager: apiManagerMock)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        apiManagerMock = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchAllDataSuccess() {
        // Given
        let posts = [Post(userId: 1, id: 1, title: "Post 1", body: "Body 1")]
        let comments = [Comment(postId: 1, id: 1, name: "Comment 1", email: "email@example.com", body: "Comment body")]
        apiManagerMock.postsResponse = Result.success(posts)
        apiManagerMock.commentsResponse = Result.success(comments)
        
        // When
        viewModel.fetchAllData()
        
        // Then
        let expectation = XCTestExpectation(description: "Fetch data completes")
        viewModel.$posts
            .sink { posts in
                XCTAssertNotNil(posts)
                XCTAssertEqual(posts, posts)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.$comments
            .sink { comments in
                XCTAssertNotNil(comments)
                XCTAssertEqual(comments, comments)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchAllDataFailure() {
        // Given
        apiManagerMock.postsResponse = Result.failure(APIError.customError("error"))
        apiManagerMock.commentsResponse = Result.failure(APIError.customError("error"))
        
        // When
        viewModel.fetchAllData()
        
        // Then
        let expectation = XCTestExpectation(description: "Fetch data completes")
        viewModel.$error
            .sink { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
}

// Mock implementation of the API manager for testing purposes
class APIManagerMock: APIManagerProtocol {
    var postsResponse: Result<[Post], APIError>?
    var commentsResponse: Result<[Comment], APIError>?
    
    func fetchData<T: Decodable>(
        method: HTTPMethod,
        path: String,
        headers: HTTPHeaders?,
        parameters: Parameters?
    ) -> AnyPublisher<T, APIError> {
        switch T.self {
        case is [Post].Type:
            guard let response = postsResponse else {
                fatalError("postsResponse not set")
            }
            return createPublisher(from: response) as! AnyPublisher<T, APIError>
        case is [Comment].Type:
            guard let response = commentsResponse else {
                fatalError("commentsResponse not set")
            }
            return createPublisher(from: response) as! AnyPublisher<T, APIError>
        default:
            fatalError("Unsupported type")
        }
    }
    
    private func createPublisher<T>(from result: Result<T, APIError>) -> AnyPublisher<T, APIError> {
        return Future<T, APIError> { promise in
            switch result {
            case .success(let value):
                promise(.success(value))
            case .failure(let error):
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
