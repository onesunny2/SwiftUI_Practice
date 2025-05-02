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
    
    @State private var status: DownLoad
    @State private var count: CGFloat
    @State private var timerCancellable: AnyCancellable?
    private var progressRate: CGFloat {
        get {
            return CGFloat(count / 10.0)
        }
    }
    
    init(id: Int, manager: SaveDownloadManager) {
        self.id = id
        self.manager = manager
        
        guard let info = manager.statusById[id] else {
            _status = State(initialValue: .받기)
            _count = State(initialValue: 0.0)
            return
        }
        
        _status = State(initialValue: info.status)
        _count = State(initialValue: info.count)
    }
    
    var body: some View {
        appButton()
            .onAppear {
                if status == .다운로드_중 {
                    startTimer()
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
                    startTimer()
                case .열기:
                    break
                case .재개:
                    updateStatus(new: .다운로드_중)
                    startTimer()
                case .다운로드_중:
                    if progressRate != 1.0 {
                        pauseTimer()
                    }
                case .다시받기:
                    updateStatus(new: .다운로드_중)
                    startTimer()
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
    
    private func startTimer() {
        timerCancellable?.cancel()
        
        timerCancellable = Timer.publish(every: 0.1, on: .current, in: .common)
            .autoconnect()
            .sink { _ in
                guard count < 10.0 else {
                    updateStatus(new: .열기)
                    timerCancellable?.cancel()
                    timerCancellable = nil
                    updateCount(new: 0.0)
                    return
                }
                
                updateCount(new: count + 0.1)
            }
    }
    
    private func pauseTimer(saveStatus: Bool = true) {
        if saveStatus {
            updateStatus(new: .재개)
        }
        
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    private func updateStatus(new status: DownLoad) {
        self.status = status
        manager.saveInfo(
            id: id,
            status: status,
            count: count,
            date: Date()
        )
    }
    
    private func updateCount(new count: CGFloat) {
        self.count = count
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
