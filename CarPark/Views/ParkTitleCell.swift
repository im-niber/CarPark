import UIKit
import NMapsMap

final class ParkTitleCell: UITableViewCell {
    
    var didTap: (() -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureConstraints() {
        self.contentView.addSubview(self.titleLabel)
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            self.titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            self.titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }

    func configure(text: String) {
        self.titleLabel.text = text
    }
    
    func setTapAction(_ vc: ViewController, _ item: Item) {
        didTap = { [weak vc] in
            guard let vc else { return }
            if let lng = Double(item.xCdnt), let lat = Double(item.yCdnt) {
                vc.NM.mapView.moveCamera(NMFCameraUpdate(position: NMFCameraPosition(NMGLatLng(lat: lat, lng: lng), zoom: 15)))
                
                guard let marker = ParkDB.shared.allMarkers.filter({ $0.data.pkNam == item.pkNam }).first else { return }
                
                let sheetVC: CarParkInfoViewController = UIStoryboard(name: "CarParkInfoView", bundle: nil).instantiateViewController(identifier: "CarParkInfoView") { coder in
                    let vc = CarParkInfoViewController(marker: marker, coder: coder)
                    return vc
                }
                
                if let presentationSheetVC = sheetVC.presentationController as? UISheetPresentationController {
                    presentationSheetVC.detents = [.medium(), .large()]
                    presentationSheetVC.prefersGrabberVisible = true
                    sheetVC.delegate = vc
                    vc.NM.mapView.becomeFirstResponder()
                    vc.present(sheetVC, animated: true)
                }
                
            } else {
                print("위도 경도 데이터 오류")
            }
            
            UserDefault.shared.setRecentParks(item: item)
        }
    }
}
