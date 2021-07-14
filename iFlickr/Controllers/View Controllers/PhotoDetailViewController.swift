//
//  PhotoDetailViewController.swift
//  iFlickr
//
//  Created by Mike Conner on 7/13/21.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mediaLabel: UILabel!
    @IBOutlet weak var dateTakenLabel: UILabel!
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    // MARK: - Properties
    var photo: Photo? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Functions
    func updateViews() {
        guard let photo = photo else { return }
        titleLabel.text = "Title: \(photo.title)"
        mediaLabel.text = "Media: \(photo.media.m)"
        dateTakenLabel.text = "Date Taken: \(convertDateToDisplayString(dateString: photo.dateTaken))"
        publishedLabel.text = "Published Date: \(convertDateToDisplayString(dateString: photo.published))"
        tagsLabel.text = "Tags: \(photo.tags)"
    }
    
    /// Helper function for displaying dates
    func convertDateToDisplayString(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return "Not available"
    }

} // End of class


