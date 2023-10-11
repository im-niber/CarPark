import UIKit

final class MyMenuViewController: BaseViewController {
    
    private lazy var usageRecordTitle: UIButton = {
        let view = UIButton()
        view.setTitle("이용 기록", for: .normal)
        view.tintColor = .black
        view.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override func configureHierarchy() {
        self.view.addSubview(usageRecordTitle)
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            usageRecordTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            usageRecordTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "마이페이지"
        self.navigationItem.titleView?.tintColor = .black
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }

}
