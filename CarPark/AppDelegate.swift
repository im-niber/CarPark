import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        fetchParks()
        fetchPartnerParks()
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
    
    func fetchPartnerParks() {
        NetworkManager.shared.fetch(with: APIConstants.partnerParkURL, type: Array<PartnerPark>.self) { data in
            data.forEach { park in
                let item = park.toParkItem()
                ParkDB.shared.partnerParks.append(item)
                ParkDB.shared.partnerMarkers.append(ParkMarker(data: item))
            }
            
            DispatchQueue.main.async {
                ParkDB.shared.allMarkers += ParkDB.shared.partnerMarkers
            }
        }
    }
    
    func fetchParks() {
        if ParkDB.shared.data.count > 0 {
            ParkDB.shared.data.forEach { item in
                ParkDB.shared.markers.append(ParkMarker(data: item))
            }
            return
        }
        
        NetworkManager.shared.fetch(with: APIConstants.pubilcParkURL, type: Park.self) { data in
            let parkData = data.getPblcPrkngInfo.body.items.item
            ParkDB.shared.createTable()

            parkData.forEach { item in
                ParkDB.shared.markers.append(ParkMarker(data: item))
                ParkDB.shared.insertData(item: item)
            }
            DispatchQueue.main.async {
                ParkDB.shared.allMarkers += ParkDB.shared.markers
            }
        }
    }
}

