import UIKit

final class MyMenuViewController: BaseViewController {
    
    private lazy var menuStackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .white
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var usageRecordTitle: MenuButton = {
        let view = MenuButton()
        view.setTitle("이용 기록", for: .normal)
        view.addTarget(self, action: #selector(showRecordVC), for: .touchUpInside)
        
        return view
    }()

    private lazy var myInfoBtn: MenuButton = {
        let view = MenuButton()
        view.setTitle("정보 수정", for: .normal)
        view.addTarget(self, action: #selector(editMyInfo), for: .touchUpInside)
        
        return view
    }()
    
    override func configureConstraints() {
        self.view.addSubview(menuStackView)
        menuStackView.addArrangedSubview(usageRecordTitle)
        menuStackView.addArrangedSubview(DividerView())
        menuStackView.addArrangedSubview(myInfoBtn)
        
        NSLayoutConstraint.activate([
            menuStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            menuStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            menuStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "마이페이지"
        self.navigationItem.titleView?.tintColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }

}

extension MyMenuViewController {
    @objc func showRecordVC() {
        navigationController?.pushViewController(UsageRecordViewController(), animated: true)
    }
    
    @objc func editMyInfo() {
        print("edit")
    }
}
