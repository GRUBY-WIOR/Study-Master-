//
//  ProgressTrackingView.swift
//  StudyMaster
//
//  Created by Igor Janik on 25/01/2025.
//

import SwiftUI

struct ProgressTrackingView: View {
    @State private var showHistory = false
    @State private var showCompletedTasks = false
    @State private var sessionHistory: [StudySession] = []
    @State private var completedTasks: [Task] = []

    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    showHistory.toggle()
                }) {
                    Text("Historia Czasu Nauki")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()

                Button(action: {
                    showCompletedTasks.toggle()
                    loadCompletedTasks()
                }) {
                    Text("Wykonane Zadania")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding()

                // historia sesji
                if showHistory {
                    List {
                        ForEach(sessionHistory) { session in
                            VStack(alignment: .leading) {
                                Text("Data: \(session.startTime, formatter: dateFormatter)")
                                    .font(.headline)
                                Text("Czas nauki: \(formatTime(seconds: session.duration))")
                                    .font(.subheadline)
                            }
                            .padding(.vertical)
                            .contextMenu {
                                Button(action: {
                                    deleteSession(session: session)
                                }) {
                                    Text("Usuń sesję")
                                    Image(systemName: "trash")
                                }
                            }
                        }
                        .onDelete(perform: deleteSessions)
                    }
                    .onAppear {
                        loadSessionHistory()
                    }
                }

                // wykonane zadania
                if showCompletedTasks {
                    List(completedTasks) { task in
                        Text(task.title)
                            .strikethrough(task.isCompleted)
                            .font(.headline)
                    }
                }

                Spacer()
            }
            .padding()
            .navigationBarTitle("Śledzenie Postępów", displayMode: .inline)
        }
    }

    private func loadSessionHistory() {
        if let savedData = UserDefaults.standard.data(forKey: "sessionHistory"),
           let decodedSessions = try? JSONDecoder().decode([StudySession].self, from: savedData) {
            sessionHistory = decodedSessions
        }
    }

    private func loadCompletedTasks() {
        if let savedData = UserDefaults.standard.data(forKey: "tasks"),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: savedData) {
            completedTasks = decodedTasks.filter { $0.isCompleted }
        }
    }

    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

   
    private func deleteSessions(at offsets: IndexSet) {
        sessionHistory.remove(atOffsets: offsets)
        saveSessionHistory()
    }

    
    private func saveSessionHistory() {
        if let encoded = try? JSONEncoder().encode(sessionHistory) {
            UserDefaults.standard.set(encoded, forKey: "sessionHistory")
        }
    }

    // Funkcja do usuwania sesji z context menu 
    private func deleteSession(session: StudySession) {
        if let index = sessionHistory.firstIndex(where: { $0.id == session.id }) {
            sessionHistory.remove(at: index)
            saveSessionHistory()
        }
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
