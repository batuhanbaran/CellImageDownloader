//
//  CellImageDownloaderManager.swift
//  CellImageDownloader
//
//  Created by Batuhan Baran on 13.06.2022.
//

import UIKit

protocol CellImageDownloaderManagerProtocol: AnyObject {
    func fetchImage(from url: String, _ completion: @escaping (UIImage?) -> Void)
    func cancelTask()
}

final class CellImageDownloaderManager: CellImageDownloaderManagerProtocol {
    private init() {}
    
    static let shared = CellImageDownloaderManager()
    
    private let cacheKeys = NSCache<NSString,UIImage>()
    private let mainQueue: DispatchQueue = DispatchQueue.main
    private var task: URLSessionTask!
    
    func fetchImage(from imageUrl: String, _ completion: @escaping (UIImage?) -> Void) {
        if let imageFromCacheManager = object(imageUrl) {
            completion(imageFromCacheManager)
        } else {
            guard imageUrl.isValidURL, let url = URL(string: imageUrl) else {
                completion(nil)
                return
            }

            task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self else { return }
                
                guard let data = data else {
                    self.mainQueue.async {
                        completion(nil)
                    }
                    
                    return
                }

                self.mainQueue.async {
                    guard let image = UIImage(data: data) else {
                        completion(nil)
                        return
                    }
                    
                    self.setObject(with: (imageUrl: imageUrl, image: image))
                    completion(image)
                }
            }
            
            task.resume()
        }
    }
    
    func cancelTask() {
        switch task.state {
        case .running, .suspended:
            task.cancel()
        default:
            break
        }
    }
    
    private func setObject(with keys: (imageUrl: String, image: UIImage)) {
        guard object(keys.imageUrl) == nil else { return }
        cacheKeys.setObject(keys.image, forKey: NSString(string: keys.imageUrl))
    }
    
    private func object(_ key: String) -> UIImage? {
        return cacheKeys.object(forKey: NSString(string: key)) ?? nil
    }
}

fileprivate extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    
    var addingPercentEncoding: String {
        guard let queryAllowedStr = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return self }
        return queryAllowedStr
    }
}
