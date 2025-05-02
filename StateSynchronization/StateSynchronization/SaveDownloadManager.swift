//
//  SaveDownloadManager.swift
//  StateSynchronization
//
//  Created by Lee Wonsun on 5/2/25.
//

import Foundation

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
        return String(self)
    }
}

final class SaveDownloadManager: ObservableObject {
    
    @Published var statusById: [Int: DownLoad] = [:]
    
    func saveInfo(id: Int, status: DownLoad, count: CGFloat, date: Date) {
        let data: AppInfo = AppInfo(
            id: id,
            status: status,
            count: count,
            lastTime: date
        )
        
        do {
            let saveData = try Coders.encoder.encode(data)
            UserDefaults.standard.set(saveData, forKey: id.forKey())
        } catch {
            print("userdefault 저장 실패: \(error)")
        }
        
    }
    
    func loadInfo(for id: Int) -> AppInfo? {
        
        guard let data = UserDefaults.standard.data(forKey: id.forKey()) else { return nil }
        
        do {
            let info = try Coders.decoder.decode(AppInfo.self, from: data)
            return info
        } catch {
            print("userdefault 불러오기 실패: \(error)")
            return nil
        }
    }
}
