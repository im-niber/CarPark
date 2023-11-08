import UIKit

final class FavoriteParkViewController: UIViewController {

    private var parks: [Item] = []
    private var isShowFavorite = true
    
    private lazy var bottomSheetPanStartingTopConstant: CGFloat = 0
    
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var favoritePakrView: FavoriteParkView = {
        let view = FavoriteParkView(frame: .zero)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        layout()
        setupTableView()
        configureGesture()
    }
    
    private func layout() {
        view.addSubview(favoritePakrView)
        NSLayoutConstraint.activate([
            favoritePakrView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoritePakrView.topAnchor.constraint(equalTo: view.topAnchor),
            favoritePakrView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoritePakrView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.layer.cornerRadius = 20
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 10.0
        tableView.sectionHeaderHeight = 35
        
        tableView.register(ParkTitleCell.self, forCellReuseIdentifier: ParkTitleCell.identifier)
        tableView.register(FavoriteParksHeaderView.self, forHeaderFooterViewReuseIdentifier: FavoriteParksHeaderView.identifier)
        tableView.register(FilterParkHeaderView.self, forHeaderFooterViewReuseIdentifier: FilterParkHeaderView.identifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setFavoritePark() {
        self.parks = UserDefault.shared.favoriteParks?.data ?? []
    }
    
    func showFilterView() {
        isShowFavorite = false
        tableView.isHidden = false
        favoritePakrView.isHidden = true
    }
    
    func reloadParkData() {
        self.tableView.reloadData()
    }
    
    func hiddenViewCheck() {
        isShowFavorite = true
        if parks.count == 0 {
            favoritePakrView.isHidden = false
            tableView.isHidden = true
        }
        else {
            favoritePakrView.isHidden = true
            tableView.isHidden = false
        }
    }
}

extension FavoriteParkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        parks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let parentVC = self.parent as? ViewController else { return UITableViewCell() }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ParkTitleCell.identifier, for: indexPath) as? ParkTitleCell else { return UITableViewCell() }
        
        let item = parks[indexPath.row]
        cell.configure(text: item.pkNam)
        cell.setTapAction(parentVC, item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isShowFavorite, let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FavoriteParksHeaderView.identifier) as? FavoriteParksHeaderView {
            
            headerView.delegate = self
            return headerView
        }
        
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FilterParkHeaderView.identifier) as? FilterParkHeaderView {
            
            headerView.delegate = self
            return headerView
        }
        
        return nil
    }
}

extension FavoriteParkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? ParkTitleCell else { return }
        cell.didTap?()
    }
}

extension FavoriteParkViewController: FilterParkHeaderViewDelegate {
    func setDistancePark() {
        parks = []
        tableView.reloadData()
    }
    
    func setMoneyPark() {
        parks = []
        tableView.reloadData()
    }
}

extension FavoriteParkViewController: FavoriteParksHeaderViewDelegate {
    func didTapAllDelete() {
        UserDefault.shared.allDeleteFavoriteParks()
        tableView.reloadData()
        favoritePakrView.isHidden = false
        tableView.isHidden = true
    }
}

extension FavoriteParkViewController {
    private func configureGesture() {
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)
    }

    // MARK: 바텀시트 뷰 제스쳐
    @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: view)
        
        guard let parentVC = self.parent as? ViewController else { return }
    
        switch panGestureRecognizer.state {
        case .began:
            bottomSheetPanStartingTopConstant = parentVC.bottomSheetViewTopConstraint.constant
        case .changed:
            if bottomSheetPanStartingTopConstant + translation.y < 0 { }
            else if bottomSheetPanStartingTopConstant + translation.y > UIScreen.main.bounds.height * 0.7 {
            }
            else {
                parentVC.bottomSheetViewTopConstraint.constant = bottomSheetPanStartingTopConstant + translation.y
            }
        case .ended:
            if parentVC.bottomSheetViewTopConstraint.constant > UIScreen.main.bounds.height * 0.2 {
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn) {
                    self.view.isHidden = true
                }
                parentVC.bottomSheetViewTopConstraint.constant = 0
            }
            else { defaultBottomView(vc: parentVC) }
        default:
            break
        }
    }
    
    func defaultBottomView(vc: ViewController) {
        vc.bottomSheetViewTopConstraint.constant = 0.0
    }
}
