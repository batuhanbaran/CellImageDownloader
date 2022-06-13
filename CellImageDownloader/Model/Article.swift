//
//  Article.swift
//  NewsApp
//
//  Created by Batuhan Baran on 28.03.2022.
//

import Foundation

struct Article: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}
