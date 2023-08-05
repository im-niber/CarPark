import UIKit

final class JoinViewController: BaseViewController {
    
    private let viewModel: JoinViewModel
    
    var textFieldBottom: CGFloat = 0.0
    
    init(viewModel: JoinViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let idLabel = UILabel()
    private let idTextField = UITextField()
    
    private let nicknameLabel = UILabel()
    private let nicknameTextField = UITextField()
    
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    private let emailCheckLabel = UILabel()
    
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    
    private let passwordLabel2 = UILabel()
    private let passwordTextField2 = UITextField()
    private let checkPasswordLabel = UILabel()
    
    private let joinButton: UIButton = {
        let button = UIButton(configuration: .filled())
        
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.setTitleColor(.gray, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(joinAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setDefaultComponent()
        configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setDefaultComponent() {
        [idLabel, nicknameLabel, emailLabel, passwordLabel, passwordLabel2].forEach {
            $0.font = .systemFont(ofSize: 14, weight: .regular)
            $0.textColor = .darkGray
        }
        
        [idTextField, nicknameTextField, emailTextField, passwordTextField, passwordTextField2].forEach {
            $0.borderStyle = .roundedRect
            $0.font = .systemFont(ofSize: 14, weight: .regular)
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.clearButtonMode = .always
            $0.returnKeyType = .done
            $0.delegate = self
        }
        
        [emailCheckLabel, checkPasswordLabel].forEach {
            $0.font = .systemFont(ofSize: 10, weight: .regular)
            $0.textColor = .systemRed
            $0.isHidden = true
        }
    }
    
    override func bind() {
        viewModel.$verifys.sink { [weak self] verifys in
            self?.checkJoinBtn(verifys: verifys)
        }.store(in: &cancellable)
    }
    
    override func configureHierarchy() {
        view.addSubview(mainStackView)
        view.addSubview(joinButton)
        
        [idLabel, idTextField, nicknameLabel, nicknameTextField, emailLabel, emailTextField, emailCheckLabel, passwordLabel, passwordTextField, passwordLabel2, passwordTextField2, checkPasswordLabel].forEach {
            mainStackView.addArrangedSubview($0)
        }
    }
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -250),
        ])
        
        NSLayoutConstraint.activate([
            joinButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 32),
            joinButton.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            joinButton.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            joinButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configure() {
        idLabel.text = "아이디"
        idTextField.placeholder = "아이디를 입력해주세요"
        
        nicknameLabel.text = "닉네임"
        nicknameTextField.placeholder = "닉네임을 입력해주세요"

        emailLabel.text = "이메일"
        emailTextField.placeholder = "이메일을 입력해주세요"

        passwordLabel.text = "비밀번호"
        passwordTextField.placeholder = "비밀번호를 입력해주세요"
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.isSecureTextEntry = true
        
        passwordLabel2.text = "비밀번호 확인"
        passwordTextField2.placeholder = "동일한 비밀번호를 입력해주세요"
        passwordTextField2.textContentType = .oneTimeCode
        passwordTextField2.isSecureTextEntry = true
        
        emailCheckLabel.text = "올바른 이메일 형식을 입력해주세요"
        checkPasswordLabel.text = "비밀번호가 같지 않습니다"
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if textFieldBottom <= self.view.frame.height - keyboardSize.height - 100 {
                return
            }
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
       if self.view.frame.origin.y != 0 {
           self.view.frame.origin.y = 0
       }
   }
}

extension JoinViewController {
    private func checkJoinBtn(verifys: JoinViewModel.VerifyTuple) {
        if viewModel.checkJoinBtn(with: verifys) {
            joinButton.isSelected = true
        }
        else { joinButton.isSelected = false }
    }
    
    @objc func joinAction() {
        if joinButton.isSelected {
            viewModel.joinAction(id: idTextField.text, pw: passwordTextField2.text, email: emailTextField.text, nickname: nicknameTextField.text)
            self.dismiss(animated: true)
        }
    }
}

extension JoinViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldBottom = textField.frame.origin.y + textField.frame.height
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == idTextField {
            viewModel.checkid(textField.text != "")
        }
        
        if textField == nicknameTextField {
            viewModel.checkNickname(textField.text != "")
        }
        
        if textField == emailTextField {
            let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            if viewModel.checkEmail(NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: textField.text)) {
                emailCheckLabel.isHidden = true
            }
            else { emailCheckLabel.isHidden = false }
        }
        
        if textField == passwordTextField2 {
            if viewModel.checkPassword(textField.text == passwordTextField.text) {
                checkPasswordLabel.isHidden = true
            }
            else { checkPasswordLabel.isHidden = false }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
