//   let parkAPI = try? JSONDecoder().decode(ParkAPI.self, from: jsonData)
import Foundation

// MARK: - ParkAPI
struct Park: Codable {
    let getPblcPrkngInfo: GetPblcPrkngInfo
}

// MARK: - GetPblcPrkngInfo
struct GetPblcPrkngInfo: Codable {
    let header: Header
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let items: Items
    let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct Items: Codable {
    let item: [Item]
}

// MARK: - Item
struct Item: Codable, Equatable {
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
}

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMsg: String
}

