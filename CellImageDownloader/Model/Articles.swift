//
//  Articles.swift
//  NewsApp
//
//  Created by Batuhan Baran on 28.03.2022.
//

import Foundation

struct Articles: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}
