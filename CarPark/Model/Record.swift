import Foundation

struct Record: Identifiable, Hashable {
    var id = UUID()
    
    var category: String!
    var title: String!
    var time: String!
    var charge: String!
    var date: String!
    
    static let mockData: [Record] = [Record(category: "주차장", title: "괴정천복개로(하단동)", time: "18:23 ~ 20:20", charge: "2000", date: "2023-10-10"), Record(category: "주차장", title: "하단5일상설시장 노상공영주차장", time: "11:25 ~ 14:10", charge: "4000", date: "2023-10-9"), Record(category: "주차장", title: "다이소 옆 주차장", time: "12:40 ~ 16:32", charge: "5000", date: "2023-10-04"), Record(category: "주차장", title: "엄궁 한신아파트 앞", time: "15:55 ~ 19:50", charge: "5000", date: "2023-10-5"), Record(category: "주차장", title: "엄궁 한신아파트 앞", time: "15:55 ~ 19:50", charge: "5000", date: "2023-10-5"), Record(category: "주차장", title: "엄궁 한신아파트 앞", time: "15:55 ~ 19:50", charge: "5000", date: "2023-10-5"), Record(category: "주차장", title: "엄궁 한신아파트 앞", time: "15:55 ~ 19:50", charge: "5000", date: "2023-10-5"), Record(category: "주차장", title: "엄궁 한신아파트 앞", time: "15:55 ~ 19:50", charge: "5000", date: "2023-10-5"), Record(category: "주차장", title: "엄궁 한신아파트 앞", time: "15:55 ~ 19:50", charge: "5000", date: "2023-10-5"), Record(category: "주차장", title: "엄궁 한신아파트 앞", time: "15:55 ~ 19:50", charge: "5000", date: "2023-10-5"), Record(category: "주차장", title: "엄궁 한신아파트 앞", time: "15:55 ~ 19:50", charge: "5000", date: "2023-10-5"), Record(category: "주차장", title: "엄궁 한신아파트 앞", time: "15:55 ~ 19:50", charge: "5000", date: "2023-10-5"), Record(category: "주차장", title: "엄궁 한신아파트 앞", time: "15:55 ~ 19:50", charge: "5000", date: "2023-10-5"), Record(category: "주차장", title: "엄궁 한신아파트 앞", time: "15:55 ~ 19:50", charge: "5000", date: "2023-10-5")]
}

