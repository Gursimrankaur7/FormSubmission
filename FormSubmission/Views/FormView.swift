//
//  FormView.swift
//  FormSubmission
//
//  Created by Gursimran Kaur on 04/06/25.
//

import SwiftUI

struct FormView: View {
    @StateObject private var viewModel = FormViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Info")) {
                    TextField("Name", text: $viewModel.name)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                    
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                    
                    TextField("Contact Number", text: $viewModel.contactNumber)
                        .keyboardType(.phonePad)
                }
                
                Section {
                    Button(action: viewModel.submitForm) {
                        HStack {
                            Text("Submit")
                            if viewModel.isLoading {
                                Spacer()
                                ProgressView()
                            }
                        }
                    }
                    .disabled(!viewModel.isFormValid || viewModel.isLoading)
                }
            }
            .navigationTitle("Submit Form")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(viewModel.alertTitle),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
