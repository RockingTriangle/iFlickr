//
//  PhotoTableViewCell.swift
//  iFlickr
//
//  Created by Mike Conner on 7/13/21.
//

import UIKit

final class PhotoTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!

    // MARK: - Properties
    var photo: Photo? {
        didSet {
            guard let link = photo?.media.m else { return }
            loadPhoto(with: link)
        }
    }
    
    // MARK: - Functions
    private func loadPhoto(with link: String) {
        guard let photo = photo else { return }
        NetworkManager.shared.downloadPhotos(fromMedia: photo.media.m) { image in
            DispatchQueue.main.async {
                if let image = image {
                    self.imageTitleLabel.text = photo.title
                    self.photoImageView.image = image
                } else {
                    self.photoImageView.image = UIImage(named: "noImage")
                }
            }
        }
    }
    
} // End of class
