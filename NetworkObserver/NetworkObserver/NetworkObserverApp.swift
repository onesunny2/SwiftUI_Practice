//
//  NetworkObserverApp.swift
//  NetworkObserver
//
//  Created by Lee Wonsun on 5/4/25.
//

import SwiftUI

@main
struct NetworkObserverApp: App {
    
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.isNetworkConnected, networkMonitor.isConnected)
                .environment(\.connetionType, networkMonitor.connectionType)
        }
    }
}
