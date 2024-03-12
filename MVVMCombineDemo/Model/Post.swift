//
//  Post.swift
//  MVVMCombineDemo
//
//  Created by Vicky Prajapati on 07/03/24.
//
import Foundation

struct Post: Codable, Equatable {
    let userId: Int?
    let id: Int?
    let title: String?
    let body: String?

    enum CodingKeys: String, CodingKey {
        case userId, id, title, body
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decodeIfPresent(Int.self, forKey: .userId)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        body = try container.decodeIfPresent(String.self, forKey: .body)
    }
    
    init(userId: Int?, id: Int?, title: String?, body: String?) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
}
