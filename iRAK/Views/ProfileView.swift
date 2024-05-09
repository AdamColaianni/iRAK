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
  @FocusState private var focusOnTextBox: Bool
  @State private var isEditing = false
  @State private var showingEmptyNameAlert = false
  @State private var selectedProfilePhoto: PhotosPickerItem?
  @State private var isPhotoDeletionConfirmationPresented = false
  @State private var profilePhotoButtonEnabled = false
  @State private var showingDeleteConfirmation = false
  
  var body: some View {
    NavigationView {
      GeometryReader { _ in
        ZStack {
          Color.backgroundColor
            .ignoresSafeArea()
          VStack {
            // Header
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
                  if isEditing && Settings.userName.isEmpty {
                    showingEmptyNameAlert = true
                  } else {
                    isEditing = false
                    dismiss()
                  }
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
              // Profile Photo
              PhotosPicker(selection: $selectedProfilePhoto, matching: .images) {
                ZStack {
                  if let imageData = Settings.selectedProfilePhotoData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                      .profileImageStyle(width: 100, height: 100)
                  } else {
                    Image(systemName: "person.circle.fill")
                      .profileImageStyle(width: 100, height: 100)
                  }
                  if isEditing {
                    Image(systemName: "camera.fill")
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .foregroundColor(.primary)
                      .frame(width: 20, height: 20)
                      .padding(8)
                      .background(Color.foregroundColor)
                      .clipShape(Circle())
                      .offset(x: 35, y: 35)
                      .shadow(radius: 3)
                  }
                }
              }
              .disabled(!isEditing)
              .disabled(profilePhotoButtonEnabled)
              .simultaneousGesture(LongPressGesture(minimumDuration: 0.5).onEnded({ (b) in
                if isEditing && Settings.selectedProfilePhotoData != nil {
                  showDialog(true)
                }
              }))
              
              // Name or text box
              if isEditing {
                TextField("Enter name", text: Settings.$userName, onCommit: {
                  if Settings.userName.isEmpty {
                    showingEmptyNameAlert = true
                    focusOnTextBox = true
                  } else {
                    isEditing = false
                  }
                })
                .focused($focusOnTextBox)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(2)
              } else {
                Text(Settings.userName)
                  .font(.system(size: 30, weight: .bold, design: .rounded))
              }
              
              // Edit profile button
              Button {
                if isEditing && Settings.userName.isEmpty {
                  showingEmptyNameAlert = true
                } else {
                  isEditing.toggle()
                  focusOnTextBox = true
                }
              } label: {
                Text(isEditing ? "Done" : "Edit Profile")
                  .font(.system(size: 20, weight: .bold, design: .rounded))
                  .padding(10)
                  .frame(maxWidth: .infinity)
                  .background(Color.foregroundColor)
                  .clipShape(Capsule())
                  .shadow(radius: 1)
              }
            }
            .padding(30)
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .background(Color.midgroundColor)
            .cornerRadius(15)
            .shadow(radius: 3)
            .padding()
            
            Spacer()
            
            // Button Stack
            VStack {
              NavigationLink(destination: Text("Updates")) {
                ProfileButton(imageName: "bell", text: "Updates")
              }
              NavigationLink(destination: Text("About")) {
                ProfileButton(imageName: "book", text: "About")
              }
              NavigationLink(destination: Text("Info")) {
                ProfileButton(imageName: "info.circle", text: "Info")
              }
              Button(action: {
                showingDeleteConfirmation = true
              }) {
                HStack {
                  Image(systemName: "trash")
                  Text("Reset Account")
                  Spacer()
                  Image(systemName: "chevron.right")
                }
                .padding()
                .background(Color.midgroundColor)
                .foregroundColor(.red)
                .cornerRadius(15)
                .shadow(radius: 3)
                .padding(.horizontal)
                .font(.system(size: 20))
              }
            }
          }
        }
        .confirmationDialog("Confirmation", isPresented: $showingDeleteConfirmation, actions: {
          Button("Delete", role: .destructive) {
            Task {
              do {
                try await AuthenticationManager.shared.delete()
                try await AuthenticationManager.shared.signInAnonymous()
              } catch {
                print(error)
              }
            }
          }
        }, message: {Text("Do you want to reset your account?")})
        .alert(isPresented: $showingEmptyNameAlert) {
            Alert(title: Text("Alert"), message: Text("Cannot have an empty user name"), dismissButton: .default(Text("OK")))
        }
        .task(id: selectedProfilePhoto) {
          if let data = try? await selectedProfilePhoto?.loadTransferable(type: Data.self) {
            withAnimation {
              Settings.selectedProfilePhotoData = data
            }
          }
        }
        .confirmationDialog("Remove Profile Image", isPresented: $isPhotoDeletionConfirmationPresented, actions: {
          Button("Remove") {
            withAnimation {
              selectedProfilePhoto = nil
              Settings.selectedProfilePhotoData = nil
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
    isPhotoDeletionConfirmationPresented = state
    profilePhotoButtonEnabled = state
  }
}

#Preview {
  ProfileView()
}
