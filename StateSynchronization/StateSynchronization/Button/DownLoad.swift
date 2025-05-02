//
//  DownLoad.swift
//  StateSynchronization
//
//  Created by Lee Wonsun on 5/2/25.
//

import Foundation

enum DownLoad: String, Codable {
    case 받기
    case 열기
    case 재개
    case 다운로드_중
    case 다시받기
    
    var text: String {
        return self.rawValue
    }
}
