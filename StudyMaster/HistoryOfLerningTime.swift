//
//  HistoryOfLerningTime.swift
//  StudyMaster
//
//  Created by Igor Janik on 26/01/2025.
//

import SwiftUI

struct HistoryOfLearningTimeView: View {
    @State private var learningSessions: [LearningSession] = []
    
    var body: some View {
        List(learningSessions) { session in
            HStack {
                Text(session.title)
                Spacer()
                Text("\(session.timeElapsed, specifier: "%.1f") min")
            }
        }
        .onAppear {
            loadLearningSessions()
        }
        .navigationBarTitle("Historia Czasu Nauki")
    }
    
    private func loadLearningSessions() {
        if let savedSessions = UserDefaults.standard.data(forKey: "learningSessions"),
           let decodedSessions = try? JSONDecoder().decode([LearningSession].self, from: savedSessions) {
            learningSessions = decodedSessions
        }
    }
}

struct LearningSession: Identifiable, Codable {
    let id: UUID
    var title: String
    var timeElapsed: Double // czas
}

struct HistoryOfLearningTimeView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryOfLearningTimeView()
    }
}
