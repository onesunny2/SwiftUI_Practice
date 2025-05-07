//
//  ContentView.swift
//  NetworkObserver
//
//  Created by Lee Wonsun on 5/4/25.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.isNetworkConnected) private var isConnected
    @Environment(\.connetionType) private var connectionType
    
    var body: some View {
        NavigationStack {
            List {
                Section("Status") {
                    Text((isConnected ?? false) ? "Connected" : "No Internet")
                }
                
                if let connectionType {
                    Section("Type") {
                        Text(String(describing: connectionType).capitalized)
                    }
                }
            }
            .navigationTitle("Network Monitor")
        }
        .sheet(isPresented: .constant(!(isConnected ?? true))) {
            NoInternetView()
                .presentationDetents([.height(310)])
//                .presentationCornerRadius(0)
//                .presentationBackgroundInteraction(.disabled)
//                .presentationBackground(.clear)
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    ContentView()
}
