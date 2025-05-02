//
//  LargeNavigationTitleModifier.swift
//  StateSynchronization
//
//  Created by Lee Wonsun on 5/2/25.
//

import SwiftUI

struct LargeNavigationTitleModifier: ViewModifier {
    
    let title: String
    let tabTitle: String
    let tabImage: Image
    
    func body(content: Content) -> some View {
        NavigationStack {
            content
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.large)
        }
        .tabItem(tabTitle, tabImage)
    }
}

struct LargeNavigationTitleModifierWithRouter: ViewModifier {
    
    let title: String
    let tabTitle: String
    let tabImage: Image
    
    @Binding var path: NavigationPath
    
    func body(content: Content) -> some View {
        NavigationStack(path: $path) {
            content
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.large)
        }
        .tabItem(tabTitle, tabImage)
    }
}

extension View {
    func largeNaviTitle(_ title: String, _ tabTitle: String, _ tabImage: Image) -> some View {
        modifier(LargeNavigationTitleModifier(title: title, tabTitle: tabTitle, tabImage: tabImage))
    }
    
    func largeNaviTitle(_ title: String, _ tabTitle: String, _ tabImage: Image, path: Binding<NavigationPath>) -> some View {
        modifier(LargeNavigationTitleModifierWithRouter(title: title, tabTitle: tabTitle, tabImage: tabImage, path: path))
    }
}

struct TabItemModifier: ViewModifier {
    
    let title: String
    let image: Image
    
    func body(content: Content) -> some View {
        content
            .tabItem {
                image
                Text(title)
            }
    }
}

extension View {
    func tabItem(_ title: String, _ image: Image) -> some View {
        modifier(TabItemModifier(title: title, image: image))
    }
}
