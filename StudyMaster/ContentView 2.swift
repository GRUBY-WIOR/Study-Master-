//
//  ContentView 2.swift
//  StudyMaster
//
//  Created by Igor Janik on 19/12/2024.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Wyśrodkowanie
                Text("StudyMaster")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)

                Spacer() //przyciski w dół

                // planowanie zajęć
                NavigationLink(destination: LessonView()) {
                    Text("Plan Zajęć")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                //lista zadań
                NavigationLink(destination: TaskListView()) {
                    Text("Lista zadań")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal)


                //tryb  nauki
                NavigationLink(destination: StudySessionView()) {
                    Text("Tryb Nauki")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                //śledzenie postępów
                NavigationLink("Śledzenie Postępów", destination: ProgressTrackingView())
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
                    .padding(.horizontal)

                Spacer() // dół ekranu
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
