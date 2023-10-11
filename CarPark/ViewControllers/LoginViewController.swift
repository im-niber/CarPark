import UIKit

final class LoginViewController: UIViewController {
    
    private var verifyID = false {
        didSet { checkLoginBtn() }
    }
    
    private var verifyPassword = false {
        didSet { checkLoginBtn() }
    }
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var joinBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        self.hideKeyboardWhenTappedAround()
        checkLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        checkLogin()
    }
    
    private func setDelegate() {
        [idTextField, passwordTextField].forEach {
            $0?.delegate = self
        }
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        let vc = JoinViewController(viewModel: JoinViewModel())
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private func checkLogin() {
// 로그인 skip
//        if UserDefault.shared.checkLoggedIn() {
            self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.pushViewController(ViewController(), animated: false)
//        }
    }
    
    private func checkLoginBtn() {
        if verifyID && verifyPassword {
            loginBtn.isSelected = true
        }
        else { loginBtn.isSelected = false }
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        // 요 밑에 삭제하기 나중엔 return 까지
//        UserDefault.shared.setLogin(id: "test", nickname: "test")
//        let rootVC = ViewController()
//        let naviVC = UINavigationController(rootViewController: rootVC)
//
//        self.navigationController?.popToRootViewController(animated: true)
//        self.navigationController?.pushViewController(ViewController(), animated: false)
//
//        return
        
        if loginBtn.isSelected {
            let parameter: [String : Any] = [
                "user_ID" : idTextField.text!,
                "user_PW" : passwordTextField.text!
            ]
            
            NetworkManager.shared.request(with: APIConstants.loginURL, method: .post, parameter: parameter) { result in
                // MARK: 로그인 성공
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        UserDefault.shared.setLogin(id: self.idTextField.text ?? "", nickname: UserDefault.shared.getNickname())
                        self.navigationController?.popViewController(animated: true)
                        self.navigationController?.popViewController(animated: true)
//                        self.navigationController?.popToRootViewController(animated: false)
                        self.navigationController?.pushViewController(ViewController(), animated: false)
                        
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.global().async {
                        let alertVC = UIAlertController(title: nil, message: "아이디 또는 비밀번호를 확인 해주세요", preferredStyle: .alert)
                        let yesAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alertVC.addAction(yesAction)
                        DispatchQueue.main.async {
                            self.present(alertVC, animated: true)
                        }
                    }
                }
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == idTextField {
            if textField.text != "" { verifyID = true }
            else { verifyID = false }
        }
        
        if textField == passwordTextField {
            if textField.text != "" { verifyPassword = true }
            else { verifyPassword = false }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
