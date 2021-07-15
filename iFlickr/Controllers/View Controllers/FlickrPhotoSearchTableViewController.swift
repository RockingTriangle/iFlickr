//
//  FlickrPhotoSearchTableViewController.swift
//  iFlickr
//
//  Created by Mike Conner on 7/13/21.
//

import UIKit

class FlickrPhotoSearchTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    var controller = PhotoController()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: - Functions
    func configureViews() {
        controller.delegate = self
        searchBar.delegate = self
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? PhotoDetailViewController else { return }
            let photo = controller.photos[indexPath.row]
            destinationVC.photo = photo
        }
    }
    
} // End of class

// MARK: - Tableview delegate and datasource methods
extension FlickrPhotoSearchTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        controller.photos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }
        
        cell.photoImageView.image = nil
        
        cell.photo = controller.photos[indexPath.row]
        
        return cell
    }
    
} // End of extension

// MARK: - UISearchBar delegate methods
extension FlickrPhotoSearchTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        self.searchBar.endEditing(true)
        
        NetworkManager.shared.searchTerm = text
        controller.getPhotos()
    }
    
} // End of extension

// MARK: - ReloadTableViewProtocol method
extension FlickrPhotoSearchTableViewController: ReloadTableViewProtocol {
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.controller.photos.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            } else {
                let alert = UIAlertController(title: "Sorry", message: "There were no results, please try a new search term.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
        }
    }
    
} // End of extension
