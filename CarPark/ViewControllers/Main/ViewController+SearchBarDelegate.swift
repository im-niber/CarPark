import UIKit

// MARK: - SearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchResultViewController.parks = UserDefault.shared.recentParks?.data ?? []
        searchResultViewController.recommendParks = ParkDB.shared.setRecommendParks(lat: self.locationManager.location?.coordinate.latitude ?? -1, lng: self.locationManager.location?.coordinate.longitude ?? -1)
        searchResultViewController.tableView.sectionHeaderHeight = 30
        searchResultViewController.tableView.reloadData()
        searchResultViewController.view.isHidden = false
        return true
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchResultViewController.view.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResultViewController.recommendParks = []
        searchResultViewController.parks = ParkDB.shared.data.filter { item in
            item.pkNam.localizedStandardContains(searchText) && item.xCdnt != "-"
        }
        if searchText == "" {
            searchResultViewController.tableView.sectionHeaderHeight = 30
            searchResultViewController.parks = UserDefault.shared.recentParks?.data ?? []
            searchResultViewController.recommendParks = ParkDB.shared.setRecommendParks(lat: self.locationManager.location?.coordinate.latitude ?? -1, lng: self.locationManager.location?.coordinate.longitude ?? -1)
        }
        else { searchResultViewController.tableView.sectionHeaderHeight = 0 }
        searchResultViewController.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchResultViewController.view.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchResultViewController.view.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchResultViewController.view.isHidden = true
    }
    
}
