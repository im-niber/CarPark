import Foundation

// MARK: - ParkAPI
struct ParkModel: Codable {
    let getPblcPrkngInfo: GetPblcPrkngInfo
}

// MARK: - GetPblcPrkngInfo
struct GetPblcPrkngInfo: Codable {
    let header: Header
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let items: Parks
    let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct Parks: Codable {
    let parks: [Park]
}

// MARK: - Item
struct Park: Codable, Equatable {
    var id: Int?
    var emptySpace: String?
    var handicapSpace: String?
    
    let guNm, pkNam, mgntNum, doroAddr: String
    let jibunAddr, tponNum, pkFm, pkCnt: String
    let svcSrtTe, svcEndTe, satSrtTe, satEndTe: String
    let hldSrtTe, hldEndTe, ldRtg, tenMin: String
    let ftDay, ftMon, xCdnt, yCdnt: String
    let fnlDt, pkGubun, bujeGubun, oprDay: String
    let feeInfo, pkBascTime, pkAddTime, feeAdd: String
    let ftDayApplytime, payMtd, spclNote, currava: String
    let oprtFm: String

    enum CodingKeys: String, CodingKey {
        case guNm, pkNam, mgntNum, doroAddr, jibunAddr, tponNum, pkFm, pkCnt, svcSrtTe, svcEndTe, satSrtTe, satEndTe, hldSrtTe, hldEndTe, ldRtg, tenMin, ftDay, ftMon, xCdnt, yCdnt, fnlDt, pkGubun, bujeGubun, oprDay, feeInfo, pkBascTime, pkAddTime, feeAdd, ftDayApplytime, payMtd, spclNote, currava
        case oprtFm = "oprt_fm"
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        guard lhs.xCdnt == rhs.xCdnt && lhs.yCdnt == rhs.yCdnt else { return false }
        return true
    }
    
    static func empty() -> Self {
        Park(guNm: "", pkNam: "", mgntNum: "", doroAddr: "", jibunAddr: "", tponNum: "", pkFm: "", pkCnt: "", svcSrtTe: "", svcEndTe: "", satSrtTe: "", satEndTe: "", hldSrtTe: "", hldEndTe: "", ldRtg: "", tenMin: "", ftDay: "", ftMon: "", xCdnt: "", yCdnt: "", fnlDt: "", pkGubun: "", bujeGubun: "", oprDay: "", feeInfo: "", pkBascTime: "", pkAddTime: "", feeAdd: "", ftDayApplytime: "", payMtd: "", spclNote: "", currava: "", oprtFm: "")
    }
}

// MARK: - 유저가 등록한 주차장 데이터 모델
struct UserPark: Codable, Equatable {
    let userNickname: String
    let description: String
    let lat: Double
    let lng: Double
    let startTime: String
    let endTime: String
    
    static func empty() -> Self {
        UserPark(userNickname: "", description: "", lat: 0.0, lng: 0.0, startTime: "", endTime: "")
    }
}

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMsg: String
}

