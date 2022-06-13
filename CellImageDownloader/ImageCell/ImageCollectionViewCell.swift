//
//  ImageCollectionViewCell.swift
//  CellImageDownloader
//
//  Created by Batuhan Baran on 13.06.2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    
    var manager: CellImageDownloaderManagerProtocol?
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        newsImageView.layer.cornerRadius = 12
    }

    func configure(url: String, manager: CellImageDownloaderManagerProtocol) {
        self.manager = manager
        
        manager.fetchImage(from: url) { [weak self] image in
            self?.newsImageView.image = image
        }
    }
    
    override func prepareForReuse() {
        manager?.cancelTask()
        manager = nil
    }
}
