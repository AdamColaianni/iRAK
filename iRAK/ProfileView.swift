//
//  ProfileView.swift
//  iRAK
//
//  Created by 90310013 on 4/6/24.
//

import SwiftUI

struct ProfileView: View {
  @Environment(\.dismiss) var dismiss
  @State private var isEditing = false
  @State private var name = "name1"
  @FocusState private var nameIsFocused: Bool
  
  var body: some View {
    NavigationView {
      ZStack {
        Color("BackgroundColor")
          .ignoresSafeArea()
        VStack {
          VStack {
            Image(systemName: "questionmark.square.fill")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 100, height: 100)
              .clipShape(Circle())
              .overlay(
                Circle().stroke(Color.blue, lineWidth: 2)
              )
              .shadow(radius: 5)
            if isEditing {
              TextField("Enter name", text: $name, onCommit: {
                // Save the entered name and toggle back to text display
                isEditing = false
              })
              .focused($nameIsFocused)
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .font(.system(size: 30, weight: .bold, design: .rounded))
              .multilineTextAlignment(.center)
              .padding()
            } else {
              Text(name)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .padding()
            }
            
            Button(isEditing ? "Done" : "Edit Profile") {
              isEditing.toggle()
              nameIsFocused = true
            }
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .frame(width: 250, height: 50)
            .background(Color("Foreground2Color"))
            .clipShape(Capsule())
            .shadow(radius: 1)
          }
          .frame(maxWidth: 350, maxHeight: 300)
          .background(Color("ForegroundColor"))
          .foregroundColor(.primary)
          .clipShape(Rectangle())
          .cornerRadius(10)
          .shadow(radius: 3)
          .padding()
          List {
            NavigationLink(destination: Text("Updates")) {
              HStack {
                Text("")
                Image(systemName: "bell")
                Text("Updates")
              }
              .font(.system(size: 20))
            }
            NavigationLink(destination: Text("About")) {
              HStack {
                Text("")
                Image(systemName: "book")
                Text("About")
              }
              .font(.system(size: 20))
            }
            NavigationLink(destination: Text("Credit")) {
              HStack {
                Text("")
                Image(systemName: "info.circle")
                Text("Credits")
              }
              .font(.system(size: 20))
            }
          }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              dismiss()
            } label: {
              Text("X")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            }
          }
        }
      }
    }
  }
}

#Preview {
  ProfileView()
}
