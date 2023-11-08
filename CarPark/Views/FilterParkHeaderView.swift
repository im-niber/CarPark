import UIKit

protocol FilterParkHeaderViewDelegate: AnyObject {
    func setFilterParks(state: FilterParkHeaderView.State)
}

final class FilterParkHeaderView: UITableViewHeaderFooterView {
    
    enum State {
        case distance, money
    }
    
    weak var delegate: FilterParkHeaderViewDelegate?
    
    private lazy var titleLabel: UIButton = {
        let view = UIButton()
        view.setTitle("거리순", for: .normal)
        view.setTitleColor(.black, for: .selected)
        view.setTitleColor(.lightGray, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        view.addTarget(self, action: #selector(distancePark), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var titleLabel2: UIButton = {
        let view = UIButton()
        view.setTitle("금액순", for: .normal)
        view.setTitleColor(.black, for: .selected)
        view.setTitleColor(.lightGray, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        view.addTarget(self, action: #selector(moneyPark), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

     override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        titleLabel.isSelected = true
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        self.addSubview(titleLabel)
        self.addSubview(titleLabel2)
        
        NSLayoutConstraint.activate([
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 72),
            
            self.titleLabel2.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.titleLabel2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -72)
        
        ])
        
    }
    
    @objc func distancePark() {
        titleLabel.isSelected = true
        titleLabel2.isSelected = false
        delegate?.setFilterParks(state: .distance)

    }
    @objc func moneyPark() {
        titleLabel.isSelected = false
        titleLabel2.isSelected = true
        delegate?.setFilterParks(state: .money)
    }
}
