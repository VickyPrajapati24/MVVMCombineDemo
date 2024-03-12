//
//  Comment.swift
//  MVVMCombineDemo
//
//  Created by Vicky Prajapati on 07/03/24.
//

import Foundation

struct Comment: Codable, Equatable {
    let postId: Int?
    let id: Int?
    let name: String?
    let email: String?
    let body: String?

    enum CodingKeys: String, CodingKey {
        case postId, id, name, email, body
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        postId = try container.decodeIfPresent(Int.self, forKey: .postId)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        body = try container.decodeIfPresent(String.self, forKey: .body)
    }
    
    init(postId: Int?, id: Int?, name: String?, email: String?, body: String?) {
        self.postId = postId
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
}
