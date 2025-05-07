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
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.isNetworkConnected, networkMonitor.isConnected)
                .environment(\.connetionType, networkMonitor.connectionType)
        }
//        .onChange(of: scenePhase) { newValue in
//            switch newValue {
//            case .background, .inactive:
//                networkMonitor.stopMonitoring()
//            case .active:
//                networkMonitor.restartMonitoring()
//            @unknown default:
//                break
//            }
//        }
    }
}


/*
 scenePhase로 @main 단계에서 작업하면 UI 작업에 과부하가 걸려서 AppDelegate로 처리하려고 했지만!
 NWMonitor가 백그라운드 상태에서는 어차피 감지가 안된다고 한다. 그래서 작업하지 않기로 함 => 백그라운드 처리는 나중에 타이머만 별개로 ㅇㅇ
 */
final class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationDidEnterBackground(_ application: UIApplication) {
        // background 상태로 전환 시 처리
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // foreground 복귀 시 처리
    }
}
