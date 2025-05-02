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
    @State private var status: DownLoad = .받기
    @State private var count: CGFloat = 0.0
    @State private var timerCancellable: AnyCancellable?
    private var progressRate: CGFloat {
        get {
            return CGFloat(count / 30.0)
        }
    }
    
    var body: some View {
        appButton()
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
                    status = .다운로드_중
                    startTimer()
                case .열기:
                    break
                case .재개:
                    status = .다운로드_중
                case .다운로드_중:
                    if progressRate != 1.0 {
                        status = .재개
                    }
                case .다시받기:
                    status = .다운로드_중
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
                guard count < 30.0 else {
                    status = .열기
                    timerCancellable?.cancel()
                    timerCancellable = nil
                    count = 0.0
                    return
                }
                
                count += 0.1
            }
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

#Preview {
    AppDownloadButtonCell()
}
