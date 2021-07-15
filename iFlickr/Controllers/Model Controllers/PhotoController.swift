//
//  PhotoController.swift
//  iFlickr
//
//  Created by Mike Conner on 7/13/21.
//

protocol ReloadTableViewProtocol {
    func reloadTableView()
}

import UIKit

final class PhotoController {
    
    // MARK: - Properties
    var photos: [Photo] = []
    var delegate: ReloadTableViewProtocol?
        
    // MARK: - Functions
    func getPhotos() {
        photos.removeAll()
        NetworkManager.shared.searchPhotos { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                self.photos = photos
            case .failure(let error):
                switch error {
                case .noData:
                    self.photos = []
                default:
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n\(error)")
                }
            }
            self.delegate?.reloadTableView()
        }
    }
    
} // End of class
