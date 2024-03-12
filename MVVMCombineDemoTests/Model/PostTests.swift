//
//  PostTests.swift
//  MVVMCombineDemoTests
//
//  Created by Vicky Prajapati on 09/03/24.
//

import Foundation
import XCTest
@testable import MVVMCombineDemo

class PostTests: XCTestCase {

    func testPostDecoding() {
        // Given
        let json = """
        {
            "userId": 1,
            "id": 1,
            "title": "Test Post",
            "body": "This is a test post."
        }
        """
        let jsonData = json.data(using: .utf8)!
        
        // When
        do {
            let post = try JSONDecoder().decode(Post.self, from: jsonData)
            
            // Then
            XCTAssertEqual(post.userId, 1)
            XCTAssertEqual(post.id, 1)
            XCTAssertEqual(post.title, "Test Post")
            XCTAssertEqual(post.body, "This is a test post.")
        } catch {
            XCTFail("Failed to decode Post: \(error)")
        }
    }
    
    func testPostEquality() {
        // Given
        let post1 = Post(userId: 1, id: 1, title: "Test Post", body: "This is a test post.")
        let post2 = Post(userId: 1, id: 1, title: "Test Post", body: "This is a test post.")
        
        // Then
        XCTAssertEqual(post1, post2)
    }
    
    func testPostInitialization() {
        // Given
        let userId: Int? = 1
        let id: Int? = 1
        let title: String? = "Test Post"
        let body: String? = "This is a test post."
        
        // When
        let post = Post(userId: userId, id: id, title: title, body: body)
        
        // Then
        XCTAssertEqual(post.userId, userId)
        XCTAssertEqual(post.id, id)
        XCTAssertEqual(post.title, title)
        XCTAssertEqual(post.body, body)
    }
}
