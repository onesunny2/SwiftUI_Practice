//
//  NetworkMonitor.swift
//  NetworkObserver
//
//  Created by Lee Wonsun on 5/7/25.
//

import SwiftUI
import Network

extension EnvironmentValues {
    @Entry var isNetworkConnected: Bool?
    @Entry var connetionType: NWInterface.InterfaceType?
}


final class NetworkMonitor: ObservableObject {
    
    @Published private(set) var isConnected: Bool?
    @Published private(set) var connectionType: NWInterface.InterfaceType?
    
    // monitor properties
    private var queue = DispatchQueue(label: "Monitor")
    private var monitor = NWPathMonitor()
    
    init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        
        monitor.pathUpdateHandler = { path in
            Task {
                await MainActor.run {
                    self.isConnected = path.status == .satisfied
                    
                    let types: [NWInterface.InterfaceType] = [.wifi, .cellular, .wiredEthernet, .loopback]
                    if let type = types.first(where: path.usesInterfaceType) {
                        self.connectionType = type
                    } else {
                        self.connectionType = nil
                    }
                }
            }
        }
        
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    func restartMonitoring() {
        stopMonitoring()
        monitor = NWPathMonitor()
        startMonitoring()
    }
}
