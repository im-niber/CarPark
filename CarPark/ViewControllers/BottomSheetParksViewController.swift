import UIKit

final class BottomSheetParksViewController: BaseViewController {

    private var parks: [Item] = []
    private var isShowFavorite = true
    private var filterState: FilterParkHeaderView.State = .distance
    
    private lazy var bottomSheetPanStartingTopConstant: CGFloat = 0
    
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var nothingView: NothingParkView = {
        let view = NothingParkView(frame: .zero)
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
        view.addSubview(nothingView)
        NSLayoutConstraint.activate([
            nothingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nothingView.topAnchor.constraint(equalTo: view.topAnchor),
            nothingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nothingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
    
    func showFavoritePark() {
        self.nothingView.setTitle(msg: "즐겨찾기한 주차장이 없습니다.")
        self.parks = UserDefault.shared.favoriteParks?.data ?? []
        self.isShowFavorite = true
    }
    
    func showFilterView() {
        self.nothingView.setTitle(msg: "주변 주차장이 없습니다.")
        self.isShowFavorite = false
        self.setFilterParks(state: filterState)
        self.tableView.isHidden = false
        self.nothingView.isHidden = true
    }
    
    func reloadParkData() {
        self.tableView.reloadData()
    }
    
    func hiddenViewCheck() {
        if parks.count == 0 {
            nothingView.isHidden = false
            tableView.isHidden = true
        }
        else {
            nothingView.isHidden = true
            tableView.isHidden = false
        }
    }
}

extension BottomSheetParksViewController: UITableViewDataSource {
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

extension BottomSheetParksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? ParkTitleCell else { return }
        cell.didTap?()
    }
}

extension BottomSheetParksViewController: FilterParkHeaderViewDelegate {
    
    func setFilterParks(state: FilterParkHeaderView.State) {
        switch state {
        case .distance:
            filterState = .distance
            setDistancePark()
        case .money:
            filterState = .money
            setMoneyPark()
        }
    }
    
    private func setDistancePark() {
        tableView.reloadData()
        ParkDB.shared.$isShowParks
            .buffer(size: 10, prefetch: .byRequest, whenFull: .dropNewest)
            .sink { [weak self] newParks in
                self?.parks = newParks.map { $0.data }
                self?.tableView.reloadData()
            }
            .store(in: &cancellable)
    }
    
    private func setMoneyPark() {
        tableView.reloadData()
        ParkDB.shared.$isShowParks
            .buffer(size: 10, prefetch: .byRequest, whenFull: .dropNewest)
            .sink { [weak self] newParks in
                self?.parks = newParks.sorted { lhs, rhs in
                    Int(lhs.data.tenMin) ?? 0 < Int(rhs.data.tenMin) ?? 0
                }.map { $0.data }
                self?.tableView.reloadData()
            }
            .store(in: &cancellable)
    }
}

extension BottomSheetParksViewController: FavoriteParksHeaderViewDelegate {
    func didTapAllDelete() {
        UserDefault.shared.allDeleteFavoriteParks()
        tableView.reloadData()
        nothingView.isHidden = false
        tableView.isHidden = true
    }
}

extension BottomSheetParksViewController {
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
