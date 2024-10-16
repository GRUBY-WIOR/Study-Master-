//
//  LessonView.swift
//  StudyMaster
//
//  Created by Igor Janik on 23/01/2025.
//

import SwiftUI

struct Lesson: Identifiable, Codable {
    var id = UUID()
    var title: String
    var instructor: String
    var room: String
    var day: String
    var time: Date
}

struct LessonView: View {
    @State private var lessons: [Lesson] = []
    @State private var showAddLesson = false
    @State private var selectedLesson: Lesson?
    
    @State private var title = ""
    @State private var instructor = ""
    @State private var room = ""
    @State private var selectedDay = "Poniedziałek"
    @State private var time = Date()

    let daysOfWeek = ["Poniedziałek", "Wtorek", "Środa", "Czwartek", "Piątek", "Sobota", "Niedziela"]

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(daysOfWeek, id: \.self) { day in
                        Section(header: Text(day).font(.headline)) {
                            ForEach(lessonsForDay(day)) { lesson in
                                Button(action: {
                                    selectedLesson = lesson
                                    title = lesson.title
                                    instructor = lesson.instructor
                                    room = lesson.room
                                    selectedDay = lesson.day
                                    time = lesson.time
                                }) {
                                    VStack(alignment: .leading) {
                                        Text("\(lesson.time, formatter: timeFormatter) - \(lesson.title)")
                                            .font(.headline)
                                        Text("Prowadzący: \(lesson.instructor) | Sala: \(lesson.room)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        deleteLesson(lesson)
                                    } label: {
                                        Label("Usuń", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
                
                Button("Dodaj Zajęcia") {
                    showAddLesson.toggle()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .sheet(isPresented: $showAddLesson) {
                    lessonForm
                }
                .sheet(item: $selectedLesson) { lesson in
                    lessonForm
                }
            }
            .navigationBarTitle("Plan Zajęć", displayMode: .inline)
            .onAppear {
                loadLessons()
            }
        }
    }
    
    private func lessonsForDay(_ day: String) -> [Lesson] {
        lessons.filter { $0.day == day }.sorted { $0.time < $1.time }
    }

    private func deleteLesson(_ lesson: Lesson) {
        lessons.removeAll { $0.id == lesson.id }
        saveLessons()
    }
    
    private func loadLessons() {
        if let savedData = UserDefaults.standard.data(forKey: "lessons"),
           let decodedLessons = try? JSONDecoder().decode([Lesson].self, from: savedData) {
            lessons = decodedLessons
        }
    }

    private func saveLessons() {
        if let encoded = try? JSONEncoder().encode(lessons) {
            UserDefaults.standard.set(encoded, forKey: "lessons")
        }
    }

    private var lessonForm: some View {
        NavigationView {
            Form {
                Section(header: Text("Szczegóły zajęć")) {
                    TextField("Nazwa zajęć", text: $title)
                    TextField("Prowadzący", text: $instructor)
                    TextField("Numer sali", text: $room)
                    Picker("Dzień tygodnia", selection: $selectedDay) {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day)
                        }
                    }
                    
                    // wybór godziny
                    DatePicker("Godzina zajęć", selection: $time, displayedComponents: [.hourAndMinute])
                        .labelsHidden()  //  tylko ikona godziny
                        .datePickerStyle(WheelDatePickerStyle()) 
                }
            }
            .navigationBarTitle(selectedLesson == nil ? "Dodaj Zajęcia" : "Edytuj Zajęcia", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Anuluj") {
                    clearForm()
                },
                trailing: Button("Zapisz") {
                    saveLesson()
                    clearForm()
                }
            )
        }
    }
    
    private func saveLesson() {
        if let selectedLesson = selectedLesson {
            if let index = lessons.firstIndex(where: { $0.id == selectedLesson.id }) {
                lessons[index] = Lesson(id: selectedLesson.id, title: title, instructor: instructor, room: room, day: selectedDay, time: time)
            }
        } else {
            let newLesson = Lesson(id: UUID(), title: title, instructor: instructor, room: room, day: selectedDay, time: time)
            lessons.append(newLesson)
        }
        saveLessons()
    }

    private func clearForm() {
        title = ""
        instructor = ""
        room = ""
        selectedDay = "Poniedziałek"
        time = Date()
        selectedLesson = nil
    }
}

let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
}()
