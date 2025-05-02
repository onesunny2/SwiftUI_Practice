//
//  SearchDetailView.swift
//  StateSynchronization
//
//  Created by Lee Wonsun on 5/2/25.
//

import SwiftUI

struct SearchDetailView: View {
    
    @EnvironmentObject var manager: SaveDownloadManager
    let id: Int
    
    var body: some View {
        listCell(id: id)
    }
}
//
//#Preview {
//    SearchDetailView()
//}
