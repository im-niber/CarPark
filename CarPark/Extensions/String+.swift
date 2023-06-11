import Foundation

extension String
{
    func encodeUrl() -> String? {
        return self.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
    }
    
    func decodeUrl() -> String? {
        return self.removingPercentEncoding
    }
}
