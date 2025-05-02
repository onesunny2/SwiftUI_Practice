//
//  AppDownloadButtonCell.swift
//  StateSynchronization
//
//  Created by Lee Wonsun on 5/2/25.
//

import SwiftUI
import Combine

struct AppDownloadButtonCell: View {
//    @Environment(\.scenePhase) private var scenePhase
    
    @ObservedObject var manager: SaveDownloadManager
    let id: Int
    
    private var progressRate: CGFloat {
        guard let info = manager.statusById[id] else { return 0}
        return CGFloat(info.count / 10.0)
    }
    
    private var count: CGFloat {
        return manager.statusById[id]?.count ?? 0.0
    }
    
    private var status: DownLoad {
        return manager.statusById[id]?.status ?? .받기
    }
    
    var body: some View {
        appButton()
            .onAppear {
                if status == .다운로드_중 {
                    manager.startTimer(for: id)
                }
            }
//        if #available(iOS 17, *) {
//            appButton()
//                .onChange(of: scenePhase) { oldValue, newValue in
//                    viewModel.action(.scenePhaseChanged(phase: newValue))
//                }
//        } else {
//            appButton()
//                .onChange(of: scenePhase) { newValue in
//                    viewModel.action(.scenePhaseChanged(phase: newValue))
//                }
//        }
    }
    
    private func appButton() -> some View {
        Button {
            withAnimation(.interactiveSpring(duration: 0.3)) {
                switch status {
                case .받기:
                    updateStatus(new: .다운로드_중)
                    manager.startTimer(for: id)
                case .열기:
                    break
                case .재개:
                    updateStatus(new: .다운로드_중)
                    manager.startTimer(for: id)
                case .다운로드_중:
                    if progressRate != 1.0 {
                        manager.pauseTimer(for: id)
                    }
                case .다시받기:
                    updateStatus(new: .다운로드_중)
                    manager.startTimer(for: id)
                }
            }
        } label: {
            switch status {
            case .받기:
                onlyText
            case .열기:
                onlyText
            case .재개:
                redownloading
            case .다운로드_중:
                downloading
            case .다시받기:
                resume
            }
        }
        .buttonStyle(.plain)
    }
    
    private var onlyText: some View {
        Text(status.text)
            .setBasic(size: 16, weight: .semibold, color: .pink)
            .frame(width: 80)
            .padding(.vertical, 8)
            .background(.gray.opacity(0.2))
            .clipShape(.rect(cornerRadius: 40))
    }
    
    private var downloading: some View {
        HStack {
            Spacer()
            Circle()
                .strokeBorder(Color(.systemGray5), lineWidth: 2)
                .frame(width: 30, height: 30)
                .overlay(alignment: .center) {
                    Circle()
                        .trim(from: 0, to: progressRate)
                        .stroke(Color.pink, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 30, height: 30)
                }
                .overlay(alignment: .center) {
                    Image(systemName: ImageLiteral.pause.text)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.pink)
                }
        }
        .frame(width: 80)
    }
    
    private var resume: some View {
        HStack {
            Spacer()
            Image(systemName: ImageLiteral.cloudDown.text)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.pink)
        }
        .frame(width: 80)
    }
    
    private var redownloading: some View {
        HStack(alignment: .center, spacing: 4) {
            Image(systemName: ImageLiteral.cloudDown.text)
                .setSystemImage(size: 13, weight: .semibold, color: .pink)
            Text(status.text)
                .setBasic(size: 13, weight: .semibold, color: .pink)
        }
        .frame(width: 80)
        .padding(.vertical, 8)
        .background(.gray.opacity(0.2))
        .clipShape(.rect(cornerRadius: 40))
    }
    
    private func updateStatus(new status: DownLoad) {
        manager.saveInfo(
            id: id,
            status: status,
            count: count,
            date: Date()
        )
    }
    
    private func updateCount(new count: CGFloat) {
        manager.saveInfo(
            id: id,
            status: status,
            count: count,
            date: Date()
        )
    }
}

extension AppDownloadButtonCell {
    enum ImageLiteral {
        case pause
        case cloudDown
        
        var text: String {
            switch self {
            case .pause: return "pause.fill"
            case .cloudDown: return "icloud.and.arrow.down"
            }
        }
    }
}

//#Preview {
//    AppDownloadButtonCell(status: .받기)
//}
