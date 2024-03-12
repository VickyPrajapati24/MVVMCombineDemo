//
//  PostsViewModel.swift
//  MVVMCombineDemo
//
//  Created by Vicky Prajapati on 07/03/24.
//
import Foundation
import Combine

class PostsViewModel {
    private var apiManager: APIManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var posts: [Post]?
    @Published var comments: [Comment]?
    @Published var error: APIError?
    
    init(apiManager: APIManagerProtocol = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    func fetchPosts() {
        apiManager.fetchData(method: .get, path: "/posts", headers: nil, parameters: nil)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished:
                    break
                }
            } receiveValue: { [weak self] (posts: [Post]) in
                self?.posts = posts
            }
            .store(in: &cancellables)
    }
    
    func fetchAllData() {
        let postsPublisher: AnyPublisher<[Post], APIError> = apiManager.fetchData(method: .get, path: "/posts", headers: nil, parameters: nil)
        let commentsPublisher: AnyPublisher<[Comment], APIError> = apiManager.fetchData(method: .get, path: "/comments", headers: nil, parameters: nil)
        
        // Combine the publishers and handle the result
        Publishers.Zip(postsPublisher, commentsPublisher)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("All API calls completed")
                case .failure(let error):
                    print("Error: \(error)")
                    self?.error = error
                }
            }, receiveValue: { [weak self] posts, comments in
                self?.posts = posts
                self?.comments = comments
            })
            .store(in: &cancellables)
    }
}
