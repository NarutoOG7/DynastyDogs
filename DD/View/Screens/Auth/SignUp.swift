//
//  SignUp.swift
//  DD
//
//  Created by Spencer Belton on 6/11/23.
//

import SwiftUI

struct SignUp: View {
    
    @State var emailInput = ""
    @State var passwordInput = ""
    @State var confirmPasswordInput = ""
    
    @State var shouldShowEmailError = false
    @State var shouldShowPasswordError = false
    @State var shouldShowConfirmPasswordError = false
    
    @State var passwordIsSecured = false
    @State var confirmPasswordIsSecured = false
            
    @ObservedObject var authManager = AuthManager.instance
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            authManager.backButton(presentationMode)
            VStack {
                authManager.logoImage
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 170)
                    .padding(.vertical, 20)
                emailField
                passwordField
                confirmPasswordField
                HStack {
                    rememberMeView
                    Spacer()
                }
                .padding()
                signUpButton
                Spacer()
                authManager.agreeToTermsView(page: .signup)
            }
        }
        .navigationBarBackButtonHidden()
        .background(Color("Black"))
    }
    
    
    private var emailField: some View {
        UserInputCellWithIcon(input: $emailInput,
                              shouldShowErrorMessage: $shouldShowEmailError,
                              isSecured: .constant(false),
                              primaryColor: Color("Gold"),
                              accentColor: .white.opacity(0.8),
                              icon: nil,
                              placeholderText: "Enter your Email",
                              errorMessage: "Email isn't recognized")
    }
    
    private var passwordField: some View {
        UserInputCellWithIcon(input: $passwordInput,
                              shouldShowErrorMessage: $shouldShowPasswordError,
                              isSecured: $passwordIsSecured,
                              primaryColor: Color("Gold"),
                              accentColor: .white.opacity(0.8),
                              icon: nil,
                              placeholderText: "Password",
                              errorMessage: "Password is too weak.")
    }
    
    private var confirmPasswordField: some View {
        UserInputCellWithIcon(input: $confirmPasswordInput,
                              shouldShowErrorMessage: $shouldShowConfirmPasswordError,
                              isSecured: $confirmPasswordIsSecured,
                              primaryColor: Color("Gold"),
                              accentColor: .white.opacity(0.8),
                              icon: nil,
                              placeholderText: "Confirm Password",
                              errorMessage: "Passwords don't match.")
    }
    
    private var rememberMeView: some View {
        Toggle(isOn: $authManager.rememberMe) {
            Text("Remember Me")
                .foregroundColor(.white)
                .font(.avenirNext(size: 17))
        }
        .toggleStyle(CheckBoxStyle(color: Color("Gold")))
    }
    
    private var signUpButton: some View {
        Button(action: logInTapped) {}
            .buttonStyle(FullRectangleButtonStyle(
                text: "Sign Up",
                image: nil,
                color: Color("Gold"),
                textColor: .black))
        .padding()
    }
    
    private func logInTapped() {
        
    }
    
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
