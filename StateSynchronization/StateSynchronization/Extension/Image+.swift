//
//  Image+.swift
//  StateSynchronization
//
//  Created by Lee Wonsun on 5/2/25.
//

import SwiftUI

extension Image {
    
    func setBasic(ratio: CGFloat = 1.0, content mode: ContentMode = .fit) -> some View {
        self
            .resizable()
            .aspectRatio(ratio, contentMode: mode)
    }
    
    func setSystemImage(size: CGFloat, weight: Font.Weight, color: Color = .pink) -> some View {
        self
            .font(.system(size: size, weight: weight))
            .foregroundStyle(color)
    }
}
