//
//  FormViewModel.swift
//  FormSubmission
//
//  Created by Gursimran Kaur on 04/06/25.
//

import Foundation

class FormViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var contactNumber: String = ""
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    var isFormValid: Bool {
        !name.isEmpty &&
        email.isValidEmail &&
        !contactNumber.isEmpty &&
        contactNumber.count >= 10
    }
    
    func submitForm() {
        guard isFormValid else { return }
        
        isLoading = true
        
        let formData = FormData(
            name: name,
            email: email,
            contactNumber: contactNumber
        )
        
        NetworkManager.shared.submitForm(formData: formData) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                    case .success(let response):
                        self?.alertTitle = "Success"
                        self?.alertMessage = response.message
                        self?.resetForm()
                        
                    case .failure(let error):
                        self?.alertTitle = "Error"
                        self?.alertMessage = error.localizedDescription
                }
                
                self?.showAlert = true
            }
        }
    }
    
    private func resetForm() {
        name = ""
        email = ""
        contactNumber = ""
    }
}

extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}
