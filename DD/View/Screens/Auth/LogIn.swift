//
//  LogIn.swift
//  DD
//
//  Created by Spencer Belton on 6/8/23.
//

import SwiftUI

struct LogIn: View {
    
    @State var emailInput = ""
    @State var passwordInput = ""
    
    @State var shouldShowEmailError = false
    @State var shouldShowPasswordError = false
    
    @State var emailErrorMessage = ""
    @State var passwordErrorMessge = ""
    
    @State var passwordIsSecured = false
        
    @ObservedObject var authManager = AuthManager.instance
    @ObservedObject var loginVM = LoginViewModel.instance
    
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
                HStack {
                    rememberMeView
                    Spacer()
                    forgetPasswordButton
                }
                .padding()
                logInButton
                authManager.signUpNavLink
                Spacer()
                authManager.agreeToTermsView(page: .login)
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
                              icon: K.Images.Login.email,
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
                              errorMessage: "Password is incorrect")
    }
    
    private var rememberMeView: some View {
        Toggle(isOn: $authManager.rememberMe) {
            Text("Remember Me")
                .foregroundColor(.white)
                .font(.avenirNext(size: 17))
        }
        .toggleStyle(CheckBoxStyle(color: Color("Gold")))
    }
    
    private var forgetPasswordButton: some View {
        Button(action: loginVM.forgotPasswordTapped) {
            Text("Forgot Password")
                .foregroundColor(Color("Gold"))
                .font(.avenirNext(size: 17))
        }
    }
    
    private var logInButton: some View {

        Button {
            loginVM.loginTapped { success in
                if success {
                    loginVM.reset()
                }
            }
        } label: {}
            .buttonStyle(FullRectangleButtonStyle(
                text: "Continue with Email",
                image: nil,
                color: Color("Gold"),
                textColor: .black))
        .padding()
    }
    
    private func forgotPasswordTapped() {
        // TODO: HANDLE PASSWORD FORGOT
    }
    
    private func logInTapped() {
        
    }
}

struct LogIn_Previews: PreviewProvider {
    static var previews: some View {
        LogIn()
    }
}


struct FullRectangleButtonStyle: ButtonStyle {
    let text: String
    let image: Image?
    let color: Color
    var textColor: Color = .white
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(color)
                .frame(height: 65)
            HStack(spacing: 12) {
                image
                Text(text)
                    .foregroundColor(textColor)
                    .font(.avenirNext(size: 20))
                    .fontWeight(.bold)
            }
        }
    }
}
