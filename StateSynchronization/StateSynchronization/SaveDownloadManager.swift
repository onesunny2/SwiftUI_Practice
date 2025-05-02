//
//  SaveDownloadManager.swift
//  StateSynchronization
//
//  Created by Lee Wonsun on 5/2/25.
//

import Foundation
import Combine

struct AppInfo: Codable {
    let id: Int
    let status: DownLoad
    let count: CGFloat
    let lastTime: Date
}

enum Coders {
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
}

extension Int {
    func forKey() -> String {
        return "AppInfo_\(self)"
    }
}

final class SaveDownloadManager: ObservableObject {
    
    @Published var statusById: [Int: AppInfo] = [:]
    var timers: [Int: AnyCancellable] = [:]
    
    init() {
        loadAllInfo()
    }
    
    func loadAllInfo() {
        
        let allKeys = UserDefaults.standard.dictionaryRepresentation().keys
        let appKeys = allKeys.filter { $0.hasPrefix("AppInfo_") }
        
        for key in appKeys {
            
            guard let idString = key.split(separator: "_").last,
                  let id = Int(idString),
                  let data = UserDefaults.standard.data(forKey: key) else { return }
            
            do {
                let info = try Coders.decoder.decode(AppInfo.self, from: data)
                statusById[id] = info
                
                if info.status == .다운로드_중 {
                    
                }
                
            } catch {
                print("\(id) 정보 불러오기 실패: \(error)")
            }
        }
        
        print("총 \(statusById.count)개의 앱 정보 로드 완료")
    }
    
    func saveInfo(id: Int, status: DownLoad, count: CGFloat, date: Date) {
        let data: AppInfo = AppInfo(
            id: id,
            status: status,
            count: count,
            lastTime: date
        )
        
        statusById[id] = data
        
        do {
            let saveData = try Coders.encoder.encode(data)
            UserDefaults.standard.set(saveData, forKey: id.forKey())
            
            objectWillChange.send()
        } catch {
            print("userdefault 저장 실패: \(error)")
        }
    }
    
    func startTimer(for id: Int) {
        // 기존 타이머 취소
        timers[id]?.cancel()
        
        // 타이머 생성
        timers[id] = Timer.publish(every: 0.1, on: .current, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self,
                      let info = self.statusById[id] else { return }
                
                if info.count >= 10.0 {
                    // 다운로드 완료
                    self.saveInfo(
                        id: id,
                        status: .열기,
                        count: 0.0,
                        date: Date()
                    )
                    self.pauseTimer(for: id, saveStatus: false)
                } else {
                    // 진행 중
                    self.saveInfo(
                        id: id,
                        status: .다운로드_중,
                        count: info.count + 0.1,
                        date: Date()
                    )
                }
            }
    }
    
    func pauseTimer(for id: Int, saveStatus: Bool = true) {
        if saveStatus {
            // 상태를 재개(또는 다시받기)로 변경
            if let info = statusById[id] {
                saveInfo(
                    id: id,
                    status: .재개,
                    count: info.count,
                    date: Date()
                )
            }
        }
        
        // 타이머 취소
        timers[id]?.cancel()
        timers[id] = nil
    }
    
    //    func loadInfo(for id: Int) -> AppInfo? {
    //
    //        guard let data = UserDefaults.standard.data(forKey: id.forKey()) else { return nil }
    //
    //        do {
    //            let info = try Coders.decoder.decode(AppInfo.self, from: data)
    //            return info
    //        } catch {
    //            print("userdefault 불러오기 실패: \(error)")
    //            return nil
    //        }
    //    }
}
