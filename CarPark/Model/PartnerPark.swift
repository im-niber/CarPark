//   let partnerPark = try? JSONDecoder().decode(PartnerPark.self, from: jsonData)

import Foundation

struct PartnerPark: Codable, Equatable {
    let parkName: String
    let parkX, parkY: Double
    let parkEmpty, parkSpace, handicapSpace: Int
    let parkType: String
    let parkBaseRate: String
    let parkPerDayRate, parkMonthlyRate: String?
    let parkOperatingTime: String
    let parkAddress, parkPhone: String

    enum CodingKeys: String, CodingKey {
        case parkName = "park_Name"
        case parkX = "park_X"
        case parkY = "park_Y"
        case parkEmpty = "park_Empty"
        case parkSpace = "park_Space"
        case handicapSpace = "handicap_Space"
        case parkType = "park_type"
        case parkBaseRate = "park_base_rate"
        case parkPerDayRate = "park_per_day_rate"
        case parkMonthlyRate = "park_monthly_rate"
        case parkOperatingTime = "park_operating_time"
        case parkAddress = "park_address"
        case parkPhone = "park_phone"
    }
    
    func toParkItem() -> Park {
        return Park(id: nil, emptySpace: String(parkEmpty), handicapSpace: String(handicapSpace), guNm: "", pkNam: parkName, mgntNum: "", doroAddr: parkAddress, jibunAddr: "", tponNum: parkPhone, pkFm: "", pkCnt: String(parkSpace), svcSrtTe: parkOperatingTime, svcEndTe: "", satSrtTe: "", satEndTe: "", hldSrtTe: "", hldEndTe: "", ldRtg: "", tenMin: parkBaseRate, ftDay: parkPerDayRate ?? "", ftMon: parkMonthlyRate ?? "", xCdnt: String(parkX), yCdnt: String(parkY), fnlDt: "", pkGubun: parkType, bujeGubun: "", oprDay: "", feeInfo: "", pkBascTime: "", pkAddTime: "", feeAdd: "", ftDayApplytime: "", payMtd: "", spclNote: "", currava: "", oprtFm: "")
    }
}

