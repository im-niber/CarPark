import Foundation
import Combine

final class JoinViewModel: ViewModelType {
    struct Input {
        let id: AnyPublisher<String, Never>
        let nickName: AnyPublisher<String, Never>
        let email: AnyPublisher<String, Never>
        let password: AnyPublisher<String, Never>
        let password2: AnyPublisher<String, Never>
    }
    
    struct Output {
        let emailIsValid: AnyPublisher<Bool, Never>
        let passwrodIsValid: AnyPublisher<Bool, Never>
        let buttonIsValid: AnyPublisher<Bool, Never>
        let networkState: CurrentValueSubject<Bool, Never>
    }
    
    var networkState = CurrentValueSubject<Bool, Never>(false)
    
    func transform(input: Input) -> Output {
        let emailStatePublisher = input.email
            .map { [weak self] in
                guard let self else { return false }
                return self.checkEmail($0) }
            .eraseToAnyPublisher()
        
        let passwordStatePublisher = input.password.combineLatest(input.password2)
            .map { [weak self] in
                guard let self else { return false }
                return self.checkPassword($0, $1) }
            .eraseToAnyPublisher()
        
        let idNicknameEmail = input.id.combineLatest(input.nickName, input.email)
        let passwordCheck = input.password.combineLatest(input.password2)
        
        let buttonStatePublisher = idNicknameEmail.combineLatest(passwordCheck)
            .map { [weak self] idNicknameEmail, password in
                guard let self else { return false }
                return idNicknameEmail.0.count > 0 && idNicknameEmail.1.count > 0 && self.checkEmail(idNicknameEmail.2) && self.checkPassword(password.0, password.1)
            }
            .eraseToAnyPublisher()
        
        return Output(emailIsValid: emailStatePublisher, passwrodIsValid: passwordStatePublisher, buttonIsValid: buttonStatePublisher, networkState: networkState)
    }
    
    func checkEmail(_ str: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return str.count > 0 && NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: str)
    }
    
    func checkPassword(_ str1: String, _ str2: String) -> Bool {
        str1.count > 0 && str1 == str2
    }
    
    func joinAction(id: String?, pw: String?, email: String?, nickname: String?) {
        guard let id, let pw, let email, let nickname else { return }
        UserDefault.shared.setLogin(id: id, nickname: nickname)
        
        let parameter: [String : Any] = [
            "user_ID" : id,
            "user_PW" : pw,
            "user_Email" : email,
            "user_Name" : nickname
        ]
        
        NetworkManager.shared.push(with: APIConstants.joinURL, parameter: parameter) { result in
            if result != .success {
                UserDefault.shared.setLogout()
                self.networkState.send(false)
                print("회원가입 오류")
                return
            }
            self.networkState.send(true)
        }
        
    }
}
