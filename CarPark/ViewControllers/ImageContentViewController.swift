import UIKit

final class ImageContentViewController: BaseViewController {
    
    let image: UIImage
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = self.image
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        self.view.addSubview(imageView)
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

}
