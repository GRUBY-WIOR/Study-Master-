//
//  TaskListView.swift
//  StudyMaster
//
//  Created by Igor Janik on 16/01/2025.
//

import SwiftUI

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
}

struct TaskListView: View {
    @State private var tasks: [Task] = []
    @State private var newTaskTitle: String = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Dodaj nowe zadanie", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: addTask) {
                        Text("Dodaj")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }

                List {
                    ForEach(tasks) { task in
                        HStack {
                            Text(task.title)
                                .strikethrough(task.isCompleted)
                            Spacer()
                            Button(action: { toggleCompletion(for: task) }) {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(task.isCompleted ? .green : .gray)
                            }
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
            }
            .navigationTitle("Lista Zadań")
            .onAppear(perform: loadTasks)
        }
    }

    private func addTask() {
        guard !newTaskTitle.isEmpty else { return }
        let newTask = Task(id: UUID(), title: newTaskTitle, isCompleted: false)
        tasks.append(newTask)
        saveTasks()
        newTaskTitle = ""
    }

    private func toggleCompletion(for task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
        }
    }

    private func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveTasks()
    }

    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }

    private func loadTasks() {
        if let savedTasks = UserDefaults.standard.data(forKey: "tasks"),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: savedTasks) {
            tasks = decodedTasks
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
