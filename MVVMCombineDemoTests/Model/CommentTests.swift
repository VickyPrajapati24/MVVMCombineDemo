//
//  CommentTests.swift
//  MVVMCombineDemoTests
//
//  Created by Vicky Prajapati on 09/03/24.
//

import Foundation
import XCTest
@testable import MVVMCombineDemo

class CommentTests: XCTestCase {

    func testCommentDecoding() {
        // Given
        let json = """
        {
            "postId": 1,
            "id": 1,
            "name": "John Doe",
            "email": "john@example.com",
            "body": "This is a test comment."
        }
        """
        let jsonData = json.data(using: .utf8)!
        
        // When
        do {
            let comment = try JSONDecoder().decode(Comment.self, from: jsonData)
            
            // Then
            XCTAssertEqual(comment.postId, 1)
            XCTAssertEqual(comment.id, 1)
            XCTAssertEqual(comment.name, "John Doe")
            XCTAssertEqual(comment.email, "john@example.com")
            XCTAssertEqual(comment.body, "This is a test comment.")
        } catch {
            XCTFail("Failed to decode Comment: \(error)")
        }
    }
    
    func testCommentEquality() {
        // Given
        let comment1 = Comment(postId: 1, id: 1, name: "John Doe", email: "john@example.com", body: "This is a test comment.")
        let comment2 = Comment(postId: 1, id: 1, name: "John Doe", email: "john@example.com", body: "This is a test comment.")
        
        // Then
        XCTAssertEqual(comment1, comment2)
    }
    
    func testCommentInitialization() {
        // Given
        let postId: Int? = 1
        let id: Int? = 1
        let name: String? = "John Doe"
        let email: String? = "john@example.com"
        let body: String? = "This is a test comment."
        
        // When
        let comment = Comment(postId: postId, id: id, name: name, email: email, body: body)
        
        // Then
        XCTAssertEqual(comment.postId, postId)
        XCTAssertEqual(comment.id, id)
        XCTAssertEqual(comment.name, name)
        XCTAssertEqual(comment.email, email)
        XCTAssertEqual(comment.body, body)
    }
}
