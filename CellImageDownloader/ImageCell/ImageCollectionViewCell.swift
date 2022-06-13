//
//  ImageCollectionViewCell.swift
//  CellImageDownloader
//
//  Created by Batuhan Baran on 13.06.2022.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        newsImageView.layer.cornerRadius = 12
    }

    func configure(url: String) {
        guard let url = URL(string: url) else { return }
        self.newsImageView.kf.setImage(with: url, completionHandler: nil)
    }
    
    override func prepareForReuse() {
        newsImageView.kf.cancelDownloadTask()
    }
}
