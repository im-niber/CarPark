import Foundation

final class UserDefault {
    static let shared = UserDefault()
    private init() {}
    
    struct Parks: Codable {
        var data: [Item]?
        
        init(data: [Item]? = nil) {
            self.data = data
        }
    }

    var recentParks: Parks? {
        if let data = UserDefaults.standard.object(forKey: "RecentParks") as? Data {
            if let item = try? JSONDecoder().decode(Parks.self, from: data) {
                return item
            }
        }
        return nil
    }
    
    var favoriteParks: Parks? {
        if let data = UserDefaults.standard.object(forKey: "FavoriteParks") as? Data {
            if let item = try? JSONDecoder().decode(Parks.self, from: data) {
                return item
            }
        }
        return nil
    }
    
    func setRecentParks(item: Item) {
        if let recentParks, var recentData = recentParks.data {
            if recentData.contains(item) { return }
            recentData.insert(item, at: 0)
            
            if recentData.count == Constant.maxSearchHistory {
                recentData.removeLast()
            }
            
            if let encoded = try? JSONEncoder().encode(Parks(data: recentData)) {
                UserDefaults.standard.set(encoded, forKey: "RecentParks")
            }
        } else {
            if let encoded = try? JSONEncoder().encode(Parks(data: [item])) {
                UserDefaults.standard.set(encoded, forKey: "RecentParks")
            }
        }
    }
    
    func allDeleteRecentParks() {
        UserDefaults.standard.removeObject(forKey: "RecentParks")
    }
    
    func setFavoriteParks(item: Item) {
        if let favoriteParks, var favoriteData = favoriteParks.data {
            if favoriteData.contains(item) {
                favoriteData.remove(at: favoriteData.firstIndex(of: item)!)
            }
            else { favoriteData.insert(item, at: 0) }

            if let encoded = try? JSONEncoder().encode(Parks(data: favoriteData)) {
                UserDefaults.standard.set(encoded, forKey: "FavoriteParks")
            }
        } else {
            if let encoded = try? JSONEncoder().encode(Parks(data: [item])) {
                UserDefaults.standard.set(encoded, forKey: "FavoriteParks")
            }
        }
        
    }
    
    func checkFavorite(with item: Item) -> Bool {
        guard let favoriteParks, let favoriteData = favoriteParks.data else { return false }
        return favoriteData.contains(item)
    }
    
    func allDeleteFavoriteParks() {
        UserDefaults.standard.removeObject(forKey: "FavoriteParks")
    }
    
    func setLogin(id: String, nickname: String? = nil) {
        UserDefaults.standard.set(id, forKey: "id")
        UserDefaults.standard.set(nickname, forKey: "nickname")
        UserDefaults.standard.set(true, forKey: "LoggedIn")
    }
    
    func setLogout() {
        UserDefaults.standard.set(false, forKey: "LoggedIn")
    }
    
    func checkLoggedIn() -> Bool {
        guard UserDefaults.standard.bool(forKey: "LoggedIn") else {
            return false
        }
        return true
    }
    
    func getUserID() -> String {
        return UserDefaults.standard.string(forKey: "id") ?? ""
    }
    
    func getNickname() -> String {
        return UserDefaults.standard.string(forKey: "nickname") ?? ""
    }
}

