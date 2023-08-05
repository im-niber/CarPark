import Foundation
import Combine

final class JoinViewModel {
    
    typealias VerifyTuple = (id: Bool, nickName: Bool, email: Bool, password: Bool)
    
    @Published var verifys: VerifyTuple = (false, false, false, false)
    
    func checkid(_ bool: Bool) {
        verifys.id = bool
    }
    
    func checkNickname(_ bool: Bool) {
        verifys.nickName = bool
    }
    
    func checkPassword(_ bool: Bool) -> Bool {
        verifys.password = bool
        
        return bool
    }
    
    func checkEmail(_ bool: Bool) -> Bool {
        verifys.email = bool
        
        return bool
    }
    
    func checkJoinBtn(with verifys: VerifyTuple) -> Bool {
        verifys.id && verifys.email && verifys.password && verifys.nickName
    }
    
    func joinAction(id: String?, pw: String?, email: String?, nickname: String?) {
        guard let id = id, let pw = pw, let email = email, let nickname = nickname else { return }
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
                print("회원가입 오류")
            }
        }
        
    }
}
