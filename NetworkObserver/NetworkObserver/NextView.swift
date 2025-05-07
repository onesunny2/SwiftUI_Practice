//
//  NextView.swift
//  NetworkObserver
//
//  Created by Lee Wonsun on 5/7/25.
//

import SwiftUI

struct NextView: View {
    
    @Environment(\.isNetworkConnected) private var isConnected
    @Environment(\.connetionType) private var connectionType
    
    var body: some View {
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
        .sheet(isPresented: .constant(!(isConnected ?? true))) {
            NoInternetView()
                .presentationDetents([.height(310)])
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    NextView()
}
