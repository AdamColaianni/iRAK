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
          ZStack {
            HStack {
              Spacer()
              Text("Profile")
                .font(.system(size: 18))
              Spacer()
            }
            HStack {
              Spacer()
              Button {
                dismiss()
              } label: {
                Image("x-symbol")
                  .resizable()
                  .frame(width: 15, height: 15)
                  .font(.system(size: 20, weight: .bold, design: .rounded))
                  .padding()
              }
            }
          }
          // Profile Stack
          VStack {
            Button {
              // Code to upload and save image
              print("Replace image")
            } label: {
              ZStack {
                Image(systemName: "questionmark.square.fill")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 100, height: 100)
                  .clipShape(Circle())
                  .overlay(
                    Circle().stroke(Color.primary, lineWidth: 2)
                  )
                .shadow(radius: 3)
                if isEditing {
                    Image(systemName: "camera.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.primary)
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(Color("Foreground2Color"))
                        .clipShape(Circle())
                        .offset(x: 35, y: 35)
                        .shadow(radius: 3)
                }
              }
            }
            .disabled(!isEditing)

            if isEditing {
              TextField("Enter name", text: $name, onCommit: {
                // Save the entered name and toggle back to text display
                isEditing = false
              })
              .focused($nameIsFocused)
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .font(.system(size: 30, weight: .bold, design: .rounded))
              .multilineTextAlignment(.center)
              .padding(2)
            } else {
              Text(name)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            }
            
            Button {
              isEditing.toggle()
              nameIsFocused = true
            } label: {
              Text(isEditing ? "Done" : "Edit Profile")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color("Foreground2Color"))
                .clipShape(Capsule())
                .shadow(radius: 1)
            }
          }
          .padding(30)
          .foregroundColor(.primary)
          .frame(maxWidth: .infinity)
          .background(Color("ForegroundColor"))
          .cornerRadius(15)
          .shadow(radius: 3)
          .padding()
          
          Spacer()
          
          // Button Stack
          VStack {
            NavigationLink(destination: Text("Updates")) {
              ProfileButtonStyle(imageName: "bell", text: "Updates")
            }
            NavigationLink(destination: Text("About")) {
              ProfileButtonStyle(imageName: "book", text: "About")
            }
            NavigationLink(destination: Text("Info")) {
              ProfileButtonStyle(imageName: "info.circle", text: "Info")
            }
          }
        }
      }
    }
  }
}

struct ProfileButtonStyle: View {
  @State var imageName: String
  @State var text: String
  
  var body: some View {
    HStack {
      Image(systemName: imageName)
      Text(text)
      Spacer()
      Image(systemName: "chevron.right")
    }
    .padding()
    .background(Color("ForegroundColor"))
    .foregroundColor(.primary)
    .cornerRadius(15)
    .shadow(radius: 3)
    .padding(.horizontal)
    .font(.system(size: 20))
  }
}

#Preview {
  ProfileView()
}
