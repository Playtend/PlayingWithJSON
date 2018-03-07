//
//  ImageCollectionViewCell.swift
//  PlayingWithJSON
//
//  Created by Christopher Taylor on 3/6/18.
//  Copyright © 2018 Christopher Taylor. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var currImageURL = URL(string:"")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = contentView.bounds
        imageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // reset upon scrolling off screen so we don't set a stale download as our image
        currImageURL = URL(string:"")
    }
    
    
    // MARK - Image Fetching
    
    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        currImageURL = url
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                // confirm that the download url is still the current url for this cell
                if url == self.currImageURL {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
    }
}
