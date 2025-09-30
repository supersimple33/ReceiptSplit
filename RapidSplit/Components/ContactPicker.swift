//
//  ContactPicker.swift
//  RapidSplit
//
//  Created by Addison Hanrattie on 9/24/25.
//

import SwiftUI
import ContactsUI

public struct ContactPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var onSelect: (CNContact, CNContactProperty?) -> Void

    public func makeUIViewController(context: Context) -> some UIViewController {
        let navController = UINavigationController()
        let pickerVC = CNContactPickerViewController()

        pickerVC.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        pickerVC.predicateForSelectionOfContact = NSPredicate(format: "\(CNContactPhoneNumbersKey).@count <= 1")
        pickerVC.predicateForSelectionOfProperty = NSPredicate(format: "key == '\(CNContactPhoneNumbersKey)'")
        pickerVC.delegate = context.coordinator

        navController.pushViewController(pickerVC, animated: false)
        navController.isNavigationBarHidden = true
        return navController
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    @MainActor
    public class Coordinator: NSObject, @MainActor CNContactPickerDelegate {
        var parent: ContactPicker

        init(parent: ContactPicker) {
            self.parent = parent
        }

        public func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        }

        public func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            parent.onSelect(contact, nil)
        }

        public func contactPicker(
            _ picker: CNContactPickerViewController,
            didSelect contactProperty: CNContactProperty
        ) {
            parent.onSelect(contactProperty.contact, contactProperty)
        }
    }
}

struct ContactPickerViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    var onDismiss: (() -> Void)?
    var onSelect: ((CNContact, CNContactProperty?) -> Void)

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented, onDismiss: onDismiss) {
                ContactPicker(isPresented: $isPresented, onSelect: onSelect)
            }
    }
}

public extension View {
    func contactPicker(isPresented: Binding<Bool>, onDismiss: (() -> Void)?, onSelect: @escaping ((CNContact, CNContactProperty?) -> Void)) -> some View {
        modifier(ContactPickerViewModifier(isPresented: isPresented, onDismiss: onDismiss, onSelect: onSelect))
    }
}

