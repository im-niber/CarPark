import UIKit

final class FavoriteParkViewController: UIViewController {

    var parks: [Item] = []
    
    private lazy var bottomSheetPanStartingTopConstant: CGFloat = 0
    
    private(set) lazy var notFavoriteParkView: UILabel = {
        let label = UILabel()
        label.text = "즐겨찾기한 주차장이 없습니다."
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .gray
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var tableView: UITableView = {
        let vc = UITableView()
        
        vc.delegate = self
        vc.dataSource = self
        vc.translatesAutoresizingMaskIntoConstraints = false
        
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        layout()
        setUpTableView()
        configureGesture()
    }
    
    private func layout() {
        view.addSubview(notFavoriteParkView)
        
        NSLayoutConstraint.activate([
            notFavoriteParkView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notFavoriteParkView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        
        tableView.layer.cornerRadius = 20
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 10.0
        tableView.sectionHeaderHeight = 35
        
        tableView.register(ParkTitleCell.self, forCellReuseIdentifier: ParkTitleCell.identifier)
        tableView.register(FavoriteParksHeaderView.self, forHeaderFooterViewReuseIdentifier: FavoriteParksHeaderView.identifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func hiddenViewCheck() {
        if parks.count == 0 {
            notFavoriteParkView.isHidden = false
            tableView.isHidden = true
        }
        else {
            notFavoriteParkView.isHidden = true
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
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FavoriteParksHeaderView.identifier) as? FavoriteParksHeaderView else { return nil }
        
        headerView.delegate = self
        return headerView
    }
}

extension FavoriteParkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? ParkTitleCell else { return }
        cell.didTap?()
    }
}

extension FavoriteParkViewController: FavoriteParksHeaderViewDelegate {
    func didTapAllDelete() {
        UserDefault.shared.allDeleteFavoriteParks()
        tableView.reloadData()
        notFavoriteParkView.isHidden = false
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
