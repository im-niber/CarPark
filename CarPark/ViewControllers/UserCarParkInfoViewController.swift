import UIKit

final class UserCarParkInfoViewController: BaseViewController {
    
    private let userParkData: UserPark
    private let images: [UIImage]
    
    private lazy var mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = userParkData.userNickname + "님의 공유주차장"
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        
        return view
    }()
    
    private lazy var imageScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var imageStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 15
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
        let view = UILabel()
        view.text = userParkData.startTime + " ~ " + userParkData.endTime
        view.font = .systemFont(ofSize: 14, weight: .regular)
        
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = userParkData.description
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.translatesAutoresizingMaskIntoConstraints = false
    
        return view
    }()
    
    private lazy var messageBtn: UIButton = {
        let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let image = UIImage(systemName: "ellipsis.message", withConfiguration: imageConfig)
        
        view.setImage(image, for: .normal)
        
        view.setTitleColor(.white, for: .focused)
        view.tintColor = .white
        view.backgroundColor = .orange
        
        view.layer.cornerRadius = 22
        
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(userParkData: UserPark, images: [UIImage]) {
        self.userParkData = userParkData
        self.images = images
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(DividerView())
        
        for i in 0..<images.count {
            imageStackView.addArrangedSubview(confiureImageView(image: images[i], tag: i))
        }
        imageScrollView.addSubview(imageStackView)
        mainStackView.addArrangedSubview(imageScrollView)
        
        mainStackView.addArrangedSubview(DividerView())
        mainStackView.addArrangedSubview(timeLabel)
        mainStackView.addArrangedSubview(DividerView())
        mainStackView.addArrangedSubview(descriptionLabel)
        
        view.addSubview(messageBtn)
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            imageScrollView.heightAnchor.constraint(equalToConstant: 110),
            imageScrollView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            imageStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
            
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            messageBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            messageBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -32),
            messageBtn.heightAnchor.constraint(equalToConstant: 44),
            messageBtn.widthAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func confiureImageView(image: UIImage, tag: Int) -> UIImageView {
        let thumbnail = image.preparingThumbnail(of: CGSize(width: 100, height: 100))
        
        let view = UIImageView(image: thumbnail)
        view.tag = tag
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showOriginalImage(_:)))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true

        return view
    }
    
    @objc func showOriginalImage(_ gesture: UITapGestureRecognizer) {
        let showImageVC = ImagePageViewController()
        showImageVC.contentImages = images
        showImageVC.modalPresentationStyle = .fullScreen
        
        present(showImageVC, animated: true)
    }
}

