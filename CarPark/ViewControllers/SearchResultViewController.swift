import UIKit
import NMapsMap

final class SearchResultViewController: UIViewController {
    
    var parks: [Park]
    var recommendParks: [Park]
    
    let NM: NMFNaverMapView
    
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(parks: [Park], recommendParks: [Park], NM: NMFNaverMapView) {
        self.parks = parks
        self.recommendParks = recommendParks
        self.NM = NM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 5.0
        tableView.sectionHeaderHeight = 30
        
        tableView.register(ParkTitleCell.self, forCellReuseIdentifier: ParkTitleCell.identifier)
        tableView.register(SearchResultHeaderView.self, forHeaderFooterViewReuseIdentifier: SearchResultHeaderView.identifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
 
}

extension SearchResultViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return parks.count }
        if section == 1 { return recommendParks.count }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ParkTitleCell.identifier, for: indexPath) as? ParkTitleCell else { return UITableViewCell()}
        guard let parentVC = self.parent as? ViewController else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            let item = parks[indexPath.row]
            cell.configure(text: item.pkNam)
            cell.setTapAction(parentVC, item)
            return cell
        case 1:
            let item = recommendParks[indexPath.row]
            cell.configure(text: item.pkNam)
            cell.setTapAction(parentVC, item)
            return cell
        default:
            return UITableViewCell()
        }
      
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0, let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchResultHeaderView.identifier) as? SearchResultHeaderView {
            headerView.setSearchLogData()
            headerView.delegate = self
            return headerView
        }
        
        if section == 1, let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchResultHeaderView.identifier) as? SearchResultHeaderView {
            headerView.setRecommendParks()
            return headerView
        }

        return nil
    }
}

extension SearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ParkTitleCell else { return }
        cell.didTap?()
    }
}

extension SearchResultViewController: SearchResultHeaderViewDelegate {
    func didTapAllDelete() {
        UserDefault.shared.allDeleteRecentParks()
        parks = []
        tableView.reloadData()
    }
}
