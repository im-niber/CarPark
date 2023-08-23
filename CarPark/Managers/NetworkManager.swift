import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func request<T: Codable>(
        with url: String, method: HTTPMethod, type: T.Type = HTTPStatusCode.self, parameter: [String: Any]? = nil, completion: @escaping (Result<T, NetworkError>) -> Void) {
            switch method {
            case .get:
                fetch(with: url, type: T.self) { result in
                    switch result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .post:
                push(with: url, parameter: parameter!) { result in
                    switch result {
                    case .success(let code):
                        guard let code = code as? T else { return }
                        completion(.success(code))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            default: break
            }
        }
    
    /// 서버에서 데이터를 들고오는 함수, 데이터 타입을 파라미터에 넘겨야 합니다
    func fetch<T: Codable>(session: URLSession = URLSession(configuration: .default), with url: String, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let url = URL(string: url)!
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                print("\(String(describing: response))")
                return
            }
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(T.self, from: data)
                completion(.success(data))
                
            } catch let error as NSError{
                print("error: \(error)")
            }
        }
        
        task.resume()
    }
    
    /// 서버에 데이터를 보내는 함수,
    /// 완료 핸들러에 넘겨지는 NetworkResult로 성공여부를 판단해야합니다
    func push(with url: String, parameter data: [String:Any], completion: @escaping (Result<HTTPStatusCode, NetworkError>) -> Void) {
        let url = URL(string: url)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: [])
        } catch {
            print("json error")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let _ = response as? HTTPURLResponse else {
                print("\(String(describing: response))")
                completion(.failure(.networkFail))
                return
            }
            do {
                let data = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                guard let status = data?["code"] as? Int, status == 200 else {
                    completion(.failure(.serverErr))
                    return
                }
                completion(.success(.ok))
            }
            catch {
                print("data error")
                completion(.failure(.requestErr))
            }
        }
        task.resume()
    }
}

