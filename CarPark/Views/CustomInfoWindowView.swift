import UIKit

final class CustomInfoWindowView: UIView {
    
    private lazy var personImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "person")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0, green: 100 / 255, blue: 188 / 255, alpha: 1)
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var disableImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "disabled")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var textLabel2: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0, green: 100 / 255, blue: 188 / 255, alpha: 1)
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.alpha = 0.8
        self.layer.cornerRadius = 10
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        self.addSubview(personImageView)
        self.addSubview(textLabel)
        self.addSubview(disableImageView)
        self.addSubview(textLabel2)
        
        NSLayoutConstraint.activate([
            personImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -8),
            personImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            personImageView.widthAnchor.constraint(equalToConstant: 10),
            personImageView.heightAnchor.constraint(equalToConstant: 10)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -8),
            textLabel.leadingAnchor.constraint(equalTo: personImageView.trailingAnchor, constant: 2),
        ])
        
        NSLayoutConstraint.activate([
            disableImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 8),
            disableImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            disableImageView.widthAnchor.constraint(equalToConstant: 10),
            disableImageView.heightAnchor.constraint(equalToConstant: 10)
        ])
        
        NSLayoutConstraint.activate([
            textLabel2.topAnchor.constraint(equalTo: disableImageView.topAnchor),
            textLabel2.leadingAnchor.constraint(equalTo: disableImageView.trailingAnchor, constant: 2),
        ])
    }
    
}
