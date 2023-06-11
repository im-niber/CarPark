import UIKit

final class JoinViewController: UIViewController {
    
    private var verifyID = false {
        didSet { checkJoinBtn() }
    }
    
    private var verifyNickname = false {
        didSet { checkJoinBtn() }
    }
    
    private var verifyEmail = false {
        didSet { checkJoinBtn() }
    }
    
    private var verifyPassword = false {
        didSet { checkJoinBtn() }
    }
    
    var textFieldBottom: CGFloat = 0.0
    
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
        view.backgroundColor = .white
        self.hideKeyboardWhenTappedAround()
        setDefaultComponent()
        configureHierarchy()
        configureConstraints()
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
    
    private func configureHierarchy() {
        view.addSubview(mainStackView)
        view.addSubview(joinButton)
        
        [idLabel, idTextField, nicknameLabel, nicknameTextField, emailLabel, emailTextField, emailCheckLabel, passwordLabel, passwordTextField, passwordLabel2, passwordTextField2, checkPasswordLabel].forEach {
            mainStackView.addArrangedSubview($0)
        }
    }
    
    private func configureConstraints() {
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
    private func checkJoinBtn() {
        if self.verifyEmail && self.verifyPassword && verifyNickname && verifyID {
            joinButton.isSelected = true
        }
        else { joinButton.isSelected = false }
    }
    
    @objc func joinAction() {
        if joinButton.isSelected {
            UserDefault.shared.setLogin(id: idTextField.text!, nickname: nicknameTextField.text!)
            
            let parameter: [String : Any] = [
                "user_ID" : idTextField.text ?? "",
                "user_PW" : passwordTextField2.text ?? "",
                "user_Email" : emailTextField.text ?? "",
                "user_Name" : nicknameTextField.text ?? ""
            ]
            
            NetworkManager.shared.push(with: APIConstants.joinURL, parameter: parameter) { result in
                
                if result != .success {
                    UserDefault.shared.setLogout()
                    print("회원가입 오류")
                }
            }
            
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
            if textField.text != "" {
                verifyID = true
            }
            else { verifyID = false }
        }
        
        if textField == nicknameTextField {
            if textField.text != "" {
                verifyNickname = true
            }
            else { verifyNickname = false }
        }
        
        if textField == emailTextField {
            let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            if NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: textField.text) {
                verifyEmail = true
                emailCheckLabel.isHidden = true
            }
            else {
                verifyEmail = false
                emailCheckLabel.isHidden = false
            }
        }
        
        if textField == passwordTextField2 {
            if textField.text != passwordTextField.text {
                checkPasswordLabel.isHidden = false
                verifyPassword = false
            }
            else {
                verifyPassword = true
                checkPasswordLabel.isHidden = true
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}