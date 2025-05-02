//
//  SearchView.swift
//  StateSynchronization
//
//  Created by Lee Wonsun on 5/2/25.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject private var manager: SaveDownloadManager
    let appIds = [1,2,3,4,5]
    
    var body: some View {
        ForEach(appIds, id: \.self) { id in
            listCell(id: id, manager: manager)
        }
    }
}

struct listCell: View {
    
    let id: Int
    @ObservedObject var manager: SaveDownloadManager
    
    var body: some View {
        HStack {
            Text("\(id)")
            AppDownloadButtonCell(id: id, manager: manager)
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(SaveDownloadManager())
}
