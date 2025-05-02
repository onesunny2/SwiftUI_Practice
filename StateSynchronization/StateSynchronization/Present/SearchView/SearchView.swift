//
//  SearchView.swift
//  StateSynchronization
//
//  Created by Lee Wonsun on 5/2/25.
//

import SwiftUI

struct SearchView: View {
    let appIds = [6,7,8,9,10]
    
    var body: some View {
        ForEach(appIds, id: \.self) { id in
            NavigationLink {
                SearchDetailView(id: id)
            } label: {
                listCell(id: id)
                    .padding(.horizontal, 20)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct listCell: View {
    
    let id: Int
    @EnvironmentObject var manager: SaveDownloadManager
    
    var body: some View {
        HStack {
            Text("\(id)")
            Spacer()
            AppDownloadButtonCell(manager: manager, id: id)
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(SaveDownloadManager())
}
