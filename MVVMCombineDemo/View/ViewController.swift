//
//  ViewController.swift
//  MVVMCombineDemo
//
//  Created by Vicky Prajapati on 07/03/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    let viewModel = PostsViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPost()
    }
    
    private func fetchPost() {
        viewModel.fetchPosts()
        
        viewModel.$posts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] posts in
                print("Received \(posts?.count ?? 0) posts")
                // Handle posts updates
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    // Show error in UI
                    print("Error: \(error)")
                }
            }
            .store(in: &cancellables)
    }
    
//    private func fetchData() {
//        viewModel.fetchAllData()
//        
//        viewModel.$posts
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] posts in
//                print("Received \(posts?.count ?? 0) posts")
//                // Handle posts updates
//                self?.tableView.reloadData()
//            }
//            .store(in: &cancellables)
//        
//        viewModel.$comments
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] comments in
//                print("Received \(comments?.count ?? 0) comments")
//                // Handle comments updates
//            }
//            .store(in: &cancellables)
//        
//        viewModel.$error
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] error in
//                if let error = error {
//                    // Show error in UI
//                    print("Error: \(error)")
//                }
//            }
//            .store(in: &cancellables)
//    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostListCell", for: indexPath) as? PostListCell else {
            return UITableViewCell()
        }
        if let post = viewModel.posts?[indexPath.row] {
            cell.lblPostTitle.text = post.title
        }
        return cell
    }
}
