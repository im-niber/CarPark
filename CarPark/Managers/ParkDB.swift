import SQLite3
import Foundation
import CoreLocation

final class ParkDB {
    static let shared = ParkDB()
    private var _data: [Item]?
    
    var markers: [ParkMarker] = []
    
    var partnerParks: [Item] = []
    var partnerMarkers: [ParkMarker] = []
    
    var allMarkers: [ParkMarker] = []
    
    @Published private(set) var isShowParks: [ParkMarker] = []
    
    var data: [Item] {
        get {
            guard let data = self._data, !data.isEmpty else {
                self._data = readData()
                return self._data ?? []
            }
            return data
        }
    }
    
    var db : OpaquePointer?
    let databaseName = "parks.sqlite"
    
    private init() {
        self.db = createDB()
    }
    
    deinit { sqlite3_close(db) }
    
    private func createDB() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        do {
            let dbPath: String = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false).appendingPathComponent(databaseName).path
            
            if sqlite3_open(dbPath, &db) == SQLITE_OK {
                print("Successfully created DB. Path: \(dbPath)")
                return db
            }
        } catch {
            print("Error while creating Database -\(error.localizedDescription)")
        }
        return nil
    }
    
    func createTable(){
        let query = """
           CREATE TABLE IF NOT EXISTS ParkTable(
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           guNm TEXT NOT NULL, pkNam TEXT NOT NULL, mgntNum TEXT NOT NULL,
           doroAddr TEXT NOT NULL,jibunAddr TEXT NOT NULL, tponNum TEXT NOT NULL, pkFm TEXT NOT NULL, pkCnt TEXT NOT NULL,
           svcSrtTe TEXT NOT NULL,svcEndTe TEXT NOT NULL,satSrtTe TEXT NOT NULL,satEndTe TEXT NOT NULL,
           hldSrtTe TEXT NOT NULL, hldEndTe TEXT NOT NULL, ldRtg TEXT NOT NULL,tenMin TEXT NOT NULL,
           ftDay TEXT NOT NULL,ftMon TEXT NOT NULL,xCdnt TEXT NOT NULL,yCdnt TEXT NOT NULL,
           fnlDt TEXT NOT NULL,pkGuBun TEXT NOT NULL,bujeGubun TEXT NOT NULL,oprDay TEXT NOT NULL,
           feeInfo TEXT NOT NULL,pkBascTime TEXT NOT NULL,pkAddTime TEXT NOT NULL,feeAdd TEXT NOT NULL,
           ftDayApplytime TEXT NOT NULL,payMtd TEXT NOT NULL,spclNote TEXT NOT NULL,currava TEXT NOT NULL,
           oprtFm TEXT NOT NULL);
           """
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Creating table has been succesfully done. db: \(String(describing: self.db))")
                
            }
            else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\nsqlte3_step failure while creating table: \(errorMessage)")
            }
        }
        else {
            let errorMessage = String(cString: sqlite3_errmsg(self.db))
            print("\nsqlite3_prepare failure while creating table: \(errorMessage)")
        }
        
        sqlite3_finalize(statement)
    }
    
    func insertData(item: Item) {
        
        let insertQuery = "insert into ParkTable (id, guNm, pkNam, mgntNum, doroAddr, jibunAddr, tponNum, pkFm, pkCnt, svcSrtTe, svcEndTe, satSrtTe, satEndTe, hldSrtTe, hldEndTe, ldRtg, tenMin, ftDay, ftMon, xCdnt, yCdnt, fnlDt, pkGubun, bujeGubun, oprDay, feeInfo, pkBascTime, pkAddTime, feeAdd, ftDayApplytime, payMtd, spclNote, currava, oprtFm) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        var statement: OpaquePointer? = nil
          
        if sqlite3_prepare_v2(self.db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 2, NSString(string: item.guNm).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, NSString(string: item.pkNam).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, NSString(string: item.mgntNum).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, NSString(string: item.doroAddr).utf8String, -1, nil)
            sqlite3_bind_text(statement, 6, NSString(string: item.jibunAddr).utf8String, -1, nil)
            sqlite3_bind_text(statement, 7, NSString(string: item.tponNum).utf8String, -1, nil)
            sqlite3_bind_text(statement, 8, NSString(string: item.pkFm).utf8String, -1, nil)
            sqlite3_bind_text(statement, 9, NSString(string: item.pkCnt).utf8String, -1, nil)
            sqlite3_bind_text(statement, 10, NSString(string: item.svcSrtTe).utf8String, -1, nil)
            sqlite3_bind_text(statement, 11, NSString(string: item.svcEndTe).utf8String, -1, nil)
            sqlite3_bind_text(statement, 12, NSString(string: item.satSrtTe).utf8String, -1, nil)
            sqlite3_bind_text(statement, 13, NSString(string: item.satEndTe).utf8String, -1, nil)
            sqlite3_bind_text(statement, 14, NSString(string: item.hldSrtTe).utf8String, -1, nil)
            sqlite3_bind_text(statement, 15, NSString(string: item.hldEndTe).utf8String, -1, nil)
            sqlite3_bind_text(statement, 16, NSString(string: item.ldRtg).utf8String, -1, nil)
            sqlite3_bind_text(statement, 17, NSString(string: item.tenMin).utf8String, -1, nil)
            sqlite3_bind_text(statement, 18, NSString(string: item.ftDay).utf8String, -1, nil)
            sqlite3_bind_text(statement, 19, NSString(string: item.ftMon).utf8String, -1, nil)
            sqlite3_bind_text(statement, 20, NSString(string: item.xCdnt).utf8String, -1, nil)
            sqlite3_bind_text(statement, 21, NSString(string: item.yCdnt).utf8String, -1, nil)
            sqlite3_bind_text(statement, 22, NSString(string: item.fnlDt).utf8String, -1, nil)
            sqlite3_bind_text(statement, 23, NSString(string: item.pkGubun).utf8String, -1, nil)
            sqlite3_bind_text(statement, 24, NSString(string: item.bujeGubun).utf8String, -1, nil)
            sqlite3_bind_text(statement, 25, NSString(string: item.oprDay).utf8String, -1, nil)
            sqlite3_bind_text(statement, 26, NSString(string: item.feeInfo).utf8String, -1, nil)
            sqlite3_bind_text(statement, 27, NSString(string: item.pkBascTime).utf8String, -1, nil)
            sqlite3_bind_text(statement, 28, NSString(string: item.pkAddTime).utf8String, -1, nil)
            sqlite3_bind_text(statement, 29, NSString(string: item.feeAdd).utf8String, -1, nil)
            sqlite3_bind_text(statement, 30, NSString(string: item.ftDayApplytime).utf8String, -1, nil)
            sqlite3_bind_text(statement, 31, NSString(string: item.payMtd).utf8String, -1, nil)
            sqlite3_bind_text(statement, 32, NSString(string: item.spclNote).utf8String, -1, nil)
            sqlite3_bind_text(statement, 33, NSString(string: item.currava).utf8String, -1, nil)
            sqlite3_bind_text(statement, 34, NSString(string: item.oprtFm).utf8String, -1, nil)
        }
        else {
            print("sqlite binding failure")
        }
          
        if sqlite3_step(statement) != SQLITE_DONE {
            print("sqlite step failure")
        }
    }
    
    func readData() -> [Item] {
        let query: String = "select * from ParkTable;"
        var statement: OpaquePointer? = nil

        var result: [Item] = []

        if sqlite3_prepare(self.db, query, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("error while prepare: \(errorMessage)")
            return result
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            
//            let id = sqlite3_column_int(statement, 0) // 결과의 0번째 테이블 값
            let gnNm = String(cString: sqlite3_column_text(statement, 1))
            let pkNam = String(cString: sqlite3_column_text(statement, 2))
            let mgntNum = String(cString: sqlite3_column_text(statement, 3))
            let doroAddr = String(cString: sqlite3_column_text(statement, 4))
            let jibunAddr = String(cString: sqlite3_column_text(statement, 5))
            let tponNum = String(cString: sqlite3_column_text(statement, 6))
            let pkFm = String(cString: sqlite3_column_text(statement, 7))
            let pkCnt = String(cString: sqlite3_column_text(statement, 8))
            let svcSrtTe = String(cString: sqlite3_column_text(statement, 9))
            let svcEndTe = String(cString: sqlite3_column_text(statement, 10))
            let satSrtTe = String(cString: sqlite3_column_text(statement, 11))
            let satEndTe = String(cString: sqlite3_column_text(statement, 12))
            let hldSrtTe = String(cString: sqlite3_column_text(statement, 13))
            let hldEndTe = String(cString: sqlite3_column_text(statement, 14))
            let ldRtg = String(cString: sqlite3_column_text(statement, 15))
            let tenMin = String(cString: sqlite3_column_text(statement, 16))
            let ftDay = String(cString: sqlite3_column_text(statement, 17))
            let ftMon = String(cString: sqlite3_column_text(statement, 18))
            let xCdnt = String(cString: sqlite3_column_text(statement, 19))
            let yCdnt = String(cString: sqlite3_column_text(statement, 20))
            let fnlDt = String(cString: sqlite3_column_text(statement, 21))
            let pkGubun = String(cString: sqlite3_column_text(statement, 22))
            let bujeGubun = String(cString: sqlite3_column_text(statement, 23))
            let oprDay = String(cString: sqlite3_column_text(statement, 24))
            let feeInfo = String(cString: sqlite3_column_text(statement, 25))
            let pkBascTime = String(cString: sqlite3_column_text(statement, 26))
            let pkAddTime = String(cString: sqlite3_column_text(statement, 27))
            let feeAdd = String(cString: sqlite3_column_text(statement, 28))
            let ftDayApplytime = String(cString: sqlite3_column_text(statement, 29))
            let payMtd = String(cString: sqlite3_column_text(statement, 30))
            let spclNote = String(cString: sqlite3_column_text(statement, 31))
            let currava = String(cString: sqlite3_column_text(statement, 32))
            let oprtFm = String(cString: sqlite3_column_text(statement, 33))
            
            result.append(Item(guNm: String(gnNm), pkNam: String(pkNam), mgntNum: String(mgntNum), doroAddr: doroAddr, jibunAddr: jibunAddr, tponNum: tponNum, pkFm: pkFm, pkCnt: pkCnt, svcSrtTe: svcSrtTe, svcEndTe: svcEndTe, satSrtTe: satSrtTe, satEndTe: satEndTe, hldSrtTe: hldSrtTe, hldEndTe: hldEndTe, ldRtg: ldRtg, tenMin: tenMin, ftDay: ftDay, ftMon: ftMon, xCdnt: xCdnt, yCdnt: yCdnt, fnlDt: fnlDt, pkGubun: pkGubun, bujeGubun: bujeGubun, oprDay: oprDay, feeInfo: feeInfo, pkBascTime: pkBascTime, pkAddTime: pkAddTime, feeAdd: feeAdd, ftDayApplytime: ftDayApplytime, payMtd: payMtd, spclNote: spclNote, currava: currava, oprtFm: oprtFm))
        }
        sqlite3_finalize(statement)
        return result
    }
    
    func deleteTable() {
       let queryString = "DROP TABLE ParkTable"
       var statement: OpaquePointer?
       
       if sqlite3_prepare(db, queryString, -1, &statement, nil) != SQLITE_OK {
           return
       }
       
       // 쿼리 실행.
       if sqlite3_step(statement) != SQLITE_DONE {
           return
       }
       
       print("drop table has been successfully done")
       
   }
    
    func setRecommendParks(lat: Double, lng: Double) -> [Item] {
        var parks: [Item]
        let current = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        parks = data.sorted(by: { first, second in
            current.distance(from: CLLocationCoordinate2D(latitude: Double(first.yCdnt) ?? -1, longitude: Double(first.xCdnt) ?? -1)) < current.distance(from: CLLocationCoordinate2D(latitude: Double(second.yCdnt) ?? -1, longitude: Double(second.xCdnt) ?? -1))
        })
        
        return Array(parks.prefix(5))
    }
    
    /// 관리 기관(guNm)이 같은 주차장들의 랜덤 주차장과, 개수를 반환하는 함수
    func clusterItems() -> [(Item, Int)] {
        var clusterItems: [(Item, Int)] = []
        var isCheckedGuNm: Set<String> = []
        
        for item in data.reversed() {
            if item.xCdnt == "-" { continue }
            let checkGuNm = item.guNm
            if isCheckedGuNm.contains(checkGuNm) { continue }
            isCheckedGuNm.insert(checkGuNm)
            
            var count = 0
            
            for item in data {
                if checkGuNm == item.guNm { count += 1 }
            }
            
            clusterItems.append((item, count))
        }
        return clusterItems
    }
    
    func setMarker(vc: ViewController) {
        allMarkers = markers + partnerMarkers
        allMarkers.forEach { item in
            item.setTouchEvent(vc: vc)
        }
    }
    
    func resetShowingParks() {
        self.isShowParks = []
    }
    
    func setShowingParks(parkMarker: [ParkMarker]) {
        self.isShowParks = parkMarker
    }
}
