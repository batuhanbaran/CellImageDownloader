//
//  Utils.swift
//  NewsApp
//
//  Created by Batuhan Baran on 24.04.2022.
//

import Foundation

enum Utils {
    static func read(by fileName: String) -> Data? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else { return nil }
        return try? Data(contentsOf: URL(fileURLWithPath: path) as URL, options: .alwaysMapped)
    }
    
    static func getMockData<T: Decodable>(fileName: String) -> T? {
        if let data = self.read(by: fileName) {
            if let response = try? JSONDecoder().decode(T.self, from: data) {
                return response
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

enum MockDataUtil {
    static func getArticles() -> Articles? {
        guard let articles: Articles? = Utils.getMockData(fileName: "NewsApiMockResponse") else { return nil }
        return articles
    }
}
