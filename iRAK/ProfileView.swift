//
//  ProfileView.swift
//  iRAK
//
//  Created by 90310013 on 4/6/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
  @Environment(\.dismiss) var dismiss
  @State private var isEditing = false
  @State private var name = "name1"
  @FocusState private var nameIsFocused: Bool
  
  @State var selectedPhoto: PhotosPickerItem?
  @State var selectedPhotoData: Data?
  @State var isDialogPresented = false
  @State var buttonDisabledPhoto = false
  
  var body: some View {
    NavigationView {
      GeometryReader { _ in
        ZStack {
          Color("BackgroundColor")
            .ignoresSafeArea()
          VStack {
            ZStack {
              HStack {
                Text("Profile")
                  .font(.system(size: 25, weight: .bold))
                  .padding(.horizontal, 25)
                Spacer()
              }
              HStack {
                Spacer()
                Button {
                  dismiss()
                } label: {
                  Image("x-symbol")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .padding()
                }
              }
            }
            // Profile Stack
            VStack {
              PhotosPicker(selection: $selectedPhoto, matching: .images) {
                ZStack {
                  if let selectedPhotoData, let uiImage = UIImage(data: selectedPhotoData) {
                    Image(uiImage: uiImage)
                      .profileImage()
                  } else {
                    Image(systemName: "person.circle.fill")
                      .profileImage()
                  }
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
              .disabled(buttonDisabledPhoto)
              .simultaneousGesture(LongPressGesture(minimumDuration: 0.5).onEnded({ (b) in
                if isEditing && selectedPhotoData != nil {
                  showDialog(true)
                }
              }))
              
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
        .onAppear {
          selectedPhotoData = UserDefaults.standard.data(forKey: "selectedPhotoData")
        }
        .task(id: selectedPhoto) {
          if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
            withAnimation {
              selectedPhotoData = data
              UserDefaults.standard.set(data, forKey: "selectedPhotoData")
            }
          }
        }
        .confirmationDialog("Remove Profile Image", isPresented: $isDialogPresented, actions: {
          Button("Remove") {
            withAnimation {
              selectedPhoto = nil
              selectedPhotoData = nil
              UserDefaults.standard.removeObject(forKey: "selectedPhotoData")
            }
            showDialog(false)
          }
          Button("Cancle", role: .cancel) {
            showDialog(false)
          }
        }, message: {Text("Do you want to remove your profile Image?")})
      }
    }
  }
  func showDialog(_ state: Bool) {
    isDialogPresented = state
    buttonDisabledPhoto = state
  }
}

extension Image {
  func profileImage() -> some View {
    self
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: 100, height: 100)
      .clipShape(Circle())
      .overlay(
        Circle().stroke(Color.primary, lineWidth: 2)
      )
      .shadow(radius: 3)
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
