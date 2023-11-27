import UIKit
import NMapsMap

final class SubmitParkViewController2: BaseViewController {
    
    private let chooseImages: [UIImage]

    private(set) lazy var NM: NMFNaverMapView = {
        let NM = NMFNaverMapView(frame: self.view.frame)
        NM.mapView.positionMode = .disabled
        NM.mapView.mapType = .navi
        NM.showZoomControls = false
        NM.showLocationButton = true
        let locationManager = CLLocationManager()
        
        NM.mapView.moveCamera(.init(scrollTo: .init(lat: locationManager.location?.coordinate.latitude ?? 0.0, lng: locationManager.location?.coordinate.longitude ?? 0.0)))
        
        return NM
    }()
    
    private lazy var centerImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "arrowtriangle.down.fill")
        view.tintColor = .link
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var presentBtn: UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("완료")
        
        titleAttr.font = .systemFont(ofSize: 17, weight: .heavy)
        config.attributedTitle = titleAttr
        config.attributedTitle?.foregroundColor = .white
        view.configuration = config

        view.backgroundColor = .link
        view.layer.cornerRadius = 25

        view.addTarget(self, action: #selector(presentNextVC), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(chooseImages: [UIImage]) {
        self.chooseImages = chooseImages
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        self.view.addSubview(NM)
        NM.addSubview(centerImageView)
        NM.addSubview(presentBtn)
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            NM.topAnchor.constraint(equalTo: view.topAnchor),
            NM.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            NM.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            NM.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            centerImageView.centerYAnchor.constraint(equalTo: NM.centerYAnchor),
            centerImageView.centerXAnchor.constraint(equalTo: NM.centerXAnchor),
            
            presentBtn.bottomAnchor.constraint(equalTo: NM.bottomAnchor,constant: -72),
            presentBtn.centerXAnchor.constraint(equalTo: NM.centerXAnchor),
            presentBtn.widthAnchor.constraint(equalToConstant: 200),
            presentBtn.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    
    @objc func presentNextVC() {
        let projection = NM.mapView.projection
        let centerCoordi = projection.latlng(from: NM.center)
        
        self.navigationController?.popViewController(animated: true)
        
        let submitVC = SubimtParkViewController3(images: chooseImages, lat: centerCoordi.lat, lng: centerCoordi.lng)
        self.navigationController?.pushViewController(submitVC, animated: true)
    }
}

