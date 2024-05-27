//
//  CustomTextField.swift
//  iRAK
//
//  Created by 90310013 on 5/26/24.
//

import SwiftUI

struct CustomTextField: UIViewRepresentable {
  var placeholder: String
  @Binding var text: String
  var onCommit: () -> Void
  
  class Coordinator: NSObject, UITextFieldDelegate {
    var parent: CustomTextField
    
    init(parent: CustomTextField) {
      self.parent = parent
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      self.parent.onCommit()
      return false // Return false to keep the keyboard active
    }
    
    @objc func textChanged(_ textField: UITextField) {
      self.parent.text = textField.text ?? ""
    }
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
  
  func makeUIView(context: Context) -> UITextField {
    let textField = UITextField(frame: .zero)
    textField.placeholder = placeholder
    textField.delegate = context.coordinator
    textField.addTarget(context.coordinator, action: #selector(Coordinator.textChanged(_:)), for: .editingChanged)
    textField.autocorrectionType = .no
    textField.borderStyle = .roundedRect
    return textField
  }
  
  func updateUIView(_ uiView: UITextField, context: Context) {
    uiView.text = text
  }
}
