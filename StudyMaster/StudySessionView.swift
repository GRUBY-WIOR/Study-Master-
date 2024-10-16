//
//  StudySessionView.swift
//  StudyMaster
//
//  Created by Igor Janik on 19/12/2024.
//

import SwiftUI

struct StudySessionView: View {
    @State private var startTime = Date()
    @State private var duration = 0
    @State private var isStudying = false
    @State private var isPaused = false
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack {
            Text(isStudying ? (isPaused ? "Nauka wstrzymana" : "Nauka w toku...") : "Rozpocznij sesję nauki")
                .font(.title)
                .padding()

            Text("Czas nauki: \(formatTime(seconds: duration))")
                .font(.headline)
                .padding()

            HStack {
                Button(action: {
                    if isStudying {
                        if isPaused {
                            resumeSession()
                        } else {
                            pauseSession()
                        }
                    } else {
                        startSession()
                    }
                }) {
                    Text(isStudying ? (isPaused ? "Wznów sesję" : "Pauzuj sesję") : "Rozpocznij sesję")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                if isStudying && !isPaused {
                    Button(action: {
                        endSession()
                    }) {
                        Text("Zakończ sesję")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
        .onDisappear {
            if isStudying {
                endSession()
            }
        }
        .navigationBarTitle("Sesja Nauki", displayMode: .inline)
    }
    
    private func startSession() {
        isStudying = true
        isPaused = false
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateSessionDuration()
        }
    }

    private func pauseSession() {
        isPaused = true
        timer?.invalidate()
    }

    private func resumeSession() {
        isPaused = false
        startTime = Date().addingTimeInterval(-TimeInterval(duration))
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateSessionDuration()
        }
    }

    private func endSession() {
        isStudying = false
        isPaused = false
        timer?.invalidate() 
        let sessionDuration = duration
        saveSession(duration: sessionDuration)
    }
    
    private func saveSession(duration: Int) {
        let session = StudySession(id: UUID(), startTime: startTime, duration: duration)
        
        var sessionHistory = loadSessionHistory()
        sessionHistory.append(session)
        
        if let encoded = try? JSONEncoder().encode(sessionHistory) {
            UserDefaults.standard.set(encoded, forKey: "sessionHistory")
        }
    }

    private func loadSessionHistory() -> [StudySession] {
        if let savedData = UserDefaults.standard.data(forKey: "sessionHistory"),
           let decodedSessions = try? JSONDecoder().decode([StudySession].self, from: savedData) {
            return decodedSessions
        }
        return []
    }

    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func updateSessionDuration() {
        let elapsed = Int(Date().timeIntervalSince(startTime))
        duration = elapsed
    }
}

struct StudySession: Identifiable, Codable {
    let id: UUID
    let startTime: Date
    let duration: Int
}

struct StudySessionView_Previews: PreviewProvider {
    static var previews: some View {
        StudySessionView()
    }
}
