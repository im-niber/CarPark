import UIKit

final class FavoriteParkViewController: UIViewController {

    var parks: [Item] = []
    
    private lazy var bottomSheetPanStartingTopConstant: CGFloat = 0
    
    private lazy var favoritePakrView: FavoriteParkView = {
        let view = FavoriteParkView(frame: .zero)
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        layout()
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
    
    func reloadParkData() {
        self.favoritePakrView.tableView.reloadData()
    }
    
    func hiddenViewCheck() {
        if parks.count == 0 {
            favoritePakrView.notFavoriteParkView.isHidden = false
            favoritePakrView.tableView.isHidden = true
        }
        else {
            favoritePakrView.notFavoriteParkView.isHidden = true
            favoritePakrView.tableView.isHidden = false
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
        favoritePakrView.tableView.reloadData()
        favoritePakrView.notFavoriteParkView.isHidden = false
        favoritePakrView.tableView.isHidden = true
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
