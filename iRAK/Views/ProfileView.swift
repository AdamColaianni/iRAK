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
  @AppStorage("userName") private var userName = "name"
  @AppStorage("selectedProfilePhotoData") private var selectedProfilePhotoData: Data?
  @State private var isEditing = false
  @State private var showingEmptyNameAlert = false
  @State var selectedProfilePhoto: PhotosPickerItem?
  @State var isPhotoDeletionConfirmationPresented = false
  @State var profilePhotoButtonEnabled = false
  
  var body: some View {
    NavigationView {
      GeometryReader { _ in
        ZStack {
          Color("BackgroundColor")
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
                  if isEditing && userName.isEmpty {
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
                  if let selectedProfilePhotoData, let uiImage = UIImage(data: selectedProfilePhotoData) {
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
              .disabled(profilePhotoButtonEnabled)
              .simultaneousGesture(LongPressGesture(minimumDuration: 0.5).onEnded({ (b) in
                if isEditing && selectedProfilePhotoData != nil {
                  showDialog(true)
                }
              }))
              
              // Name or text box
              if isEditing {
                TextField("Enter name", text: $userName, onCommit: {
                  if userName.isEmpty {
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
                Text(userName)
                  .font(.system(size: 30, weight: .bold, design: .rounded))
              }
              
              // Edit profile button
              Button {
                if isEditing && userName.isEmpty {
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
                ProfileButton(imageName: "bell", text: "Updates")
              }
              NavigationLink(destination: Text("About")) {
                ProfileButton(imageName: "book", text: "About")
              }
              NavigationLink(destination: Text("Info")) {
                ProfileButton(imageName: "info.circle", text: "Info")
              }
            }
          }
        }
        .alert(isPresented: $showingEmptyNameAlert) {
            Alert(title: Text("Alert"), message: Text("Cannot have an empty user name"), dismissButton: .default(Text("OK")))
        }
        .task(id: selectedProfilePhoto) {
          if let data = try? await selectedProfilePhoto?.loadTransferable(type: Data.self) {
            withAnimation {
              selectedProfilePhotoData = data
            }
          }
        }
        .confirmationDialog("Remove Profile Image", isPresented: $isPhotoDeletionConfirmationPresented, actions: {
          Button("Remove") {
            withAnimation {
              selectedProfilePhoto = nil
              selectedProfilePhotoData = nil
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
