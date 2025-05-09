//
//  StateSynchronizationApp.swift
//  StateSynchronization
//
//  Created by Lee Wonsun on 5/1/25.
//

import SwiftUI

@main
struct StateSynchronizationApp: App {
    
    @StateObject private var saveDownloadManager = SaveDownloadManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(saveDownloadManager)
        }
    }
}
