import Foundation

extension Date {
    
    public enum Format: String {
        case yearToDay = "yyyy.MM.dd"
        case yearToSecond = "yyyy-MM-dd HH:mm:ss"
        case timeStamp = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case hourAndMinute = "HH:mm"
        case monthAndDate = "M월 d일"
        case monthAndDate2 = "MM.dd."
        case yearAndMonthAndDate = "YYYY년 M월 d일"
        case yearAndMonth = "YYYY년 M월"
        case yearAndMonthandDate2 = "YYYY.MM.dd."
        case yearAndMonthandDate3 = "YYYYMMdd"
    }
    
    // MARK: Methods
    public func toString(type: Format) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = type.rawValue
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    public func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    public func stringToDate(dateString: String, type: Format) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = type.rawValue
        return formatter.date(from: dateString)
    }
    
    public func stringToDate(dateString: String, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: dateString)
    }
}

extension Date {
    
    public static func fromStringOrNow(_ string: String, ofFormat format: Format = .timeStamp) -> Date {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "ko_KR")
        
        if formatter.date(from: string) == nil {
            print("string -> date failed.")
        }
        
        return formatter.date(from: string) ?? Date()
    }
}

extension String {
    
    public enum Format: String {
        case yearToDay = "yyyy.MM.dd"
        case yearToSecond = "yyyy-MM-dd HH:mm:ss"
        case timeStamp = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case hourAndMinute = "HH:mm"
        case monthAndDate = "M월 d일"
        case monthAndDate2 = "MM.dd."
        case yearAndMonthAndDate = "YYYY년 M월 d일"
        case yearAndMonth = "YYYY년 M월"
        case yearAndMonthandDate2 = "YYYY.MM.dd."
        case yearAndMonthandDate3 = "YYYYMMdd"
    }
    
    public func toDate(type: Format) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: self)
    }
}
