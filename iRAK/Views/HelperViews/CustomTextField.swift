import SwiftUI
import UIKit

struct CustomTextField: UIViewRepresentable {
  var placeholder: String
  @Binding var text: String
  @Binding var isYourTurn: Bool
  var word: String
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
    
    // Setting the left view with the ">" symbol
    let leftLabel = UILabel()
    leftLabel.text = ">"
    leftLabel.sizeToFit()
    
    textField.leftView = leftLabel
    textField.leftViewMode = .always
    
    textField.placeholder = placeholder
    textField.delegate = context.coordinator
    textField.addTarget(context.coordinator, action: #selector(Coordinator.textChanged(_:)), for: .editingChanged)
    textField.autocorrectionType = .no
    textField.borderStyle = .none
    
    // Adding an underline to simulate the "_" characters
    let underline = UIView()
    underline.translatesAutoresizingMaskIntoConstraints = false
    underline.backgroundColor = UIColor(Color.primary)
    textField.addSubview(underline)
    
    NSLayoutConstraint.activate([
      underline.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: leftLabel.frame.width + 5),
      underline.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
      underline.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
      underline.heightAnchor.constraint(equalToConstant: 1)
    ])
    
    return textField
  }
  
  func updateUIView(_ uiView: UITextField, context: Context) {
    if isYourTurn {
      uiView.isEnabled = true
      uiView.text = text
      uiView.placeholder = placeholder
    } else {
      uiView.isEnabled = false
      uiView.text = word
    }
  }
}
