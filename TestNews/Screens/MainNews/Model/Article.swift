//
//  Article.swift
//  TestNews
//
//  Created by pttung5 on 12/08/2022.
//

import Foundation

// MARK: - ArticleEntity
struct ArticleEntity: Codable {
    let status: String
    let totalResults: Int?
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author, title, articleDescription: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String?
    let content: String

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}
