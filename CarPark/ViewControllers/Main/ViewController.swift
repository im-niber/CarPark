import UIKit
import NMapsMap

final class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    private(set) var parks: [Item] = []
    private(set) var clusterParks: [(Item, Int)] = []
    private(set) var partnerParks: [Item] = []
    
    var driving: Bool = false
    
    private(set) lazy var pathOverlay: NMFPath = {
        let path = NMFPath()
        path.color = .link
        path.outlineWidth = 1
        path.width = 10
        path.patternIcon = NMFOverlayImage(name: "route_path_arrow")
        path.patternInterval = 15

        return path
    }()

    private(set) var bottomSheetViewTopConstraint: NSLayoutConstraint!

    private(set) lazy var searchResultViewController: SearchResultViewController = {
        let vc = SearchResultViewController(parks: [], recommendParks: [], NM: self.NM)
        vc.view.isHidden = true
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    private(set) lazy var favoriteParksViewController: FavoriteParkViewController = {
        let vc = FavoriteParkViewController()
        vc.view.isHidden = true
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    private(set) lazy var zoomButton: NMFZoomControlView = {
        let view = NMFZoomControlView(frame: CGRect(x: 0, y: 0, width: 50, height: 90))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.mapView = self.NM.mapView
        
        return view
    }()

    private(set) lazy var NM: NMFNaverMapView = {
        let NM = NMFNaverMapView(frame: self.view.frame)
        NM.mapView.positionMode = .disabled
        NM.mapView.mapType = .navi
        NM.mapView.addCameraDelegate(delegate: self)
        NM.showZoomControls = false
        NM.showLocationButton = true
        
        return NM
    }()
    
    private lazy var containerSearchBarView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .white
        view.axis = .vertical
        view.distribution = .fill
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "찾으시는 장소를 입력해주세요."
        view.searchBarStyle = .minimal
        
        view.showsSearchResultsButton = true
        view.delegate = self
   
        return view
    }()
    
    private lazy var favoriteParksBtn: UIButton = {
        let view = UIButton(configuration: .plain())
        view.tintColor = .black
        view.setTitle("⭐️ 즐겨찾기", for: .normal)
        
        view.setTitleColor(.darkText ,for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14, weight: .light)
        view.backgroundColor = .white
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        view.addTarget(self, action: #selector(showFavoriteVC), for: .touchUpInside)
        
        view.layer.cornerRadius = 12
        view.setTitleShadowColor(.black, for: .selected)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var drivingView: DrivingView = {
        let view = DrivingView()
        view.delegate = self
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setLocation(locationManager: locationManager)
        setParks()
        setMarker()
        getClusterParks()
        configureHierarchy()
        layout()
    }
    
    private func configureHierarchy() {
        self.addChild(searchResultViewController)
        self.addChild(favoriteParksViewController)
    }
    
    /// 뷰의 자식 추가, 레이아웃 설정
    private func layout() {
        self.view.addSubview(NM)
        self.containerSearchBarView.addArrangedSubview(searchBar)
        
        self.NM.addSubview(containerSearchBarView)
        self.NM.addSubview(zoomButton)
        self.NM.addSubview(favoriteParksBtn)
        self.NM.addSubview(searchResultViewController.view)
        self.NM.addSubview(favoriteParksViewController.view)
        self.NM.addSubview(drivingView)
        
        bottomSheetViewTopConstraint = self.favoriteParksViewController.view.topAnchor.constraint(equalTo: self.view.centerYAnchor)
        
        NSLayoutConstraint.activate([
            self.containerSearchBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
            self.containerSearchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            self.containerSearchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            self.searchResultViewController.view.topAnchor.constraint(equalTo: containerSearchBarView.bottomAnchor, constant: 10),
            self.searchResultViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.searchResultViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.searchResultViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomSheetViewTopConstraint,
            self.favoriteParksViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.favoriteParksViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.favoriteParksViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.zoomButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            self.zoomButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -88)
        ])
        
        NSLayoutConstraint.activate([
            self.favoriteParksBtn.topAnchor.constraint(equalTo: self.containerSearchBarView.bottomAnchor, constant: 8),
            self.favoriteParksBtn.leadingAnchor.constraint(equalTo: self.containerSearchBarView.leadingAnchor, constant: 4),
        ])
        
        NSLayoutConstraint.activate([
            drivingView.topAnchor.constraint(equalTo: view.topAnchor),
            drivingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            drivingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            drivingView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.23)
        ])
    }
    
}

extension ViewController {
    @objc func showFavoriteVC() {
        self.favoriteParksViewController.parks = UserDefault.shared.favoriteParks?.data ?? []
        favoriteParksViewController.tableView.reloadData()
        self.favoriteParksViewController.hiddenViewCheck()
        
        self.favoriteParksViewController.view.isHidden.toggle()
    }
}

// MARK: 데이터를 설정하는 함수 extension
extension ViewController {
    func setParks() {
        parks = ParkDB.shared.data
        partnerParks = ParkDB.shared.partnerParks
    }
    
    func setMarker() {
        ParkDB.shared.setMarker(vc: self)
    }
    
    func getClusterParks() {
        clusterParks = ParkDB.shared.clusterItems()
    }
}
