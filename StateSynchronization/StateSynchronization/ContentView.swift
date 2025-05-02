//
//  ContentView.swift
//  StateSynchronization
//
//  Created by Lee Wonsun on 5/1/25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            TodayView()
                .largeNaviTitle(
                    NaviTitle.투데이.text,
                    StringLiteral.투데이.text,
                    ImageLiteral.today
                )
            
            GameView()
                .largeNaviTitle(
                    NaviTitle.게임.text,
                    StringLiteral.게임.text,
                    ImageLiteral.game
                )
            
            InstalledView()
                .largeNaviTitle(
                    NaviTitle.앱.text,
                    StringLiteral.앱.text,
                    ImageLiteral.app
                )
            
            ArcadeView()
                .largeNaviTitle(
                    NaviTitle.아케이드.text,
                    StringLiteral.아케이드.text,
                    ImageLiteral.arcade
                )
            
            SearchView()
                .largeNaviTitle(
                    NaviTitle.검색.text,
                    StringLiteral.검색.text,
                    ImageLiteral.search
                )
        }
        .tint(.pink)
    }
}

extension ContentView {
    enum StringLiteral: String {
        case 투데이
        case 게임
        case 앱
        case 아케이드 = "Arcade"
        case 검색
        
        var text: String {
            return self.rawValue
        }
    }
    
    enum ImageLiteral {
        static let today: Image = Image(systemName: "text.rectangle.page")
        static let game: Image = Image(systemName: "gamecontroller.fill")
        static let app: Image = Image(systemName: "square.stack.3d.up.fill")
        static let arcade: Image = Image(systemName: "arcade.stick")
        static let search: Image = Image(systemName: "magnifyingglass")
    }
    
    enum NaviTitle: String {
        case 투데이
        case 게임
        case 앱
        case 아케이드
        case 검색
        
        var text: String {
            return self.rawValue
        }
    }
}

#Preview {
    ContentView()
}
