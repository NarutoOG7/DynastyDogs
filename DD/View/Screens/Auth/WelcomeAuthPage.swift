//
//  WelcomeAuthPage.swift
//  DD
//
//  Created by Spencer Belton on 6/8/23.
//

import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth

class AuthManager: ObservableObject {
    static let instance = AuthManager()
    
    @Published var shouldShowLogIn = false
    @Published var shouldShowSignUp = false
        
    @AppStorage("rememberMe") var rememberMe = false
    
    var signUpMessageAndButton: some View {
        HStack {
            Text("Don't have an account?")
                .font(.avenirNext(size: 17))
                .foregroundColor(.white)
            Button(action: signUpInsteadTapped) {
                Text("Sign Up")
                    .font(.avenirNext(size: 17))
                    .foregroundColor( Color("Gold"))
            }
        }
    }
    
    var signUpNavLink: some View {
        HStack {
            Text("Don't have an account?")
                .font(.avenirNext(size: 17))
                .foregroundColor(.white)
            
            NavigationLink {
                SignUp()
            } label: {
                Text("Sign Up")
                    .font(.avenirNext(size: 17))
                    .foregroundColor( Color("Gold"))
            }
        }
    }
    
    func agreeToTermsView(page: AuthPage) -> some View {
        let termsLink = "[Terms & Conditions](https://doc-hosting.flycricket.io/dynasty-dogs-terms-of-use/b15a2410-a112-4796-9c9c-7f45640e6e65/terms)"
        let privacyPolicyLink = "[Privacy Policy](https://doc-hosting.flycricket.io/dynasty-dogs-privacy-policy/460ee657-4ac9-462a-99ce-f39e6c12f853/privacy)"
        let termsMessage = "By clicking \(page.termsMessage) above, you agree to Dynasty Dogs' \(termsLink) and \(privacyPolicyLink)."
        return Text(.init(termsMessage))
            .font(.avenirNext(size: 15))
            .foregroundColor(.gray)
            .padding()
            .accentColor( Color("Gold"))
    }
    
    private func signUpInsteadTapped() {
        if self.shouldShowLogIn {
            
        }
        self.shouldShowSignUp = true
    }
    
    var logoImage: Image {
        Image("DDNEWLOGO")
    }
    
    func backButton(_ presentationMode: Binding<PresentationMode>) -> some View {
        VStack {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    ZStack {
                        Circle()
                            .shadow(color: .black, radius: 2)
                            .foregroundColor(.gray.opacity(0.6))
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color("Gold"))
                    }
                }
                .frame(width: 50, height: 50)
                Spacer()
            }
            .padding()
            Spacer()
        }
    }
}

struct WelcomeAuthPage: View {
    
    @ObservedObject var authManager = AuthManager.instance
        
    var body: some View {
        VStack {
            authManager.logoImage
                .padding(.bottom, 30)
            continueWithEmailView
            newAppleButton
                authManager.signUpNavLink
            
                .padding(.top)
            Spacer()
            authManager.agreeToTermsView(page: .welcome)
        }
        .padding()
        .background(Color("Black"))
        
    }
    
    
    
    private var continueWithEmailView: some View {
        NavigationLink {
            LogIn()
        } label: { }
            .buttonStyle(FullRectangleButtonStyle(text: "Continue with Email", image: nil, color: Color("Gold"), textColor: .black))
    }
    
    private var newAppleButton: some View {
        Button {
            AppleSignInManager.instance.startSignInWithAppleFlow()
        } label: { }
            .buttonStyle(FullRectangleButtonStyle(text: "Continue With Apple", image: Image("AppleLogo"), color: .white, textColor: .black))

    }
    
    
    private var appleButton: some View {
        SignInWithAppleButton { request in
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case .success(let authResult):
                // Handle successful sign-in
                handleSuccessfulSignIn(authResult: authResult)
            case .failure(let error):
                // Handle sign-in failure
                handleSignInFailure(error: error)
            }
        }
        .frame(height: 65)
    }
    
    func handleSuccessfulSignIn(authResult: ASAuthorization) {
        // Handle successful sign-in
        // You can access user information from authResult.credential
        // For example, to get the user's full name:
        if let appleIDCredential = authResult.credential as? ASAuthorizationAppleIDCredential {
            let fullName = appleIDCredential.fullName
            // Process the full name
        }
        
        // Perform any additional actions after successful sign-in
    }
    func handleSignInFailure(error: Error) {
        // Handle sign-in failure
        // Display an error message or take appropriate action
    }
    
    func continueWithEmailTapped() {
        authManager.shouldShowLogIn = true
    }
}

struct WelcomeAuthPage_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeAuthPage()
    }
}


class AppleSignInManager: NSObject, ASAuthorizationControllerDelegate {
    
    static let instance = AppleSignInManager()
    
    let auth = FBMAuth.instance
    @ObservedObject var errorManager = ErrorManager.instance
    @ObservedObject var userStore = UserStore.instance
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
       if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
         guard let nonce = currentNonce else {
           fatalError("Invalid state: A login callback was received, but no login request was sent.")
         }
         guard let appleIDToken = appleIDCredential.identityToken else {
           print("Unable to fetch identity token")
           return
         }
         guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
           print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
           return
         }
         // Initialize a Firebase credential, including the user's full name.
         let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
         // Sign in with Firebase.
           
           auth.auth.signIn(with: credential) { (authResult, error) in
           if let error = error {
             // Error. If error.code == .MissingOrInvalidNonce, make sure
             // you're sending the SHA256-hashed nonce as a hex string with
             // your request to Apple.
             print(error.localizedDescription)
             return
           }
             if let authResult = authResult {
                 let id = authResult.user.uid
                 let name = authResult.user.displayName ?? ""
                 let email = authResult.user.email ?? ""
                 let user = User(id: id, name: name, email: email)
                 
                 DispatchQueue.main.async {
                     
                     self.userStore.isSignedIn = true
                     self.userStore.user = user
                     
                     UserDefaults.standard.set(true, forKey: "signedIn")
                     
                     self.auth.saveUserToUserDefaults(user: user) { error in
                         if let error = error {
                             self.errorManager.handleError(error)
                         }
                     }
                }
             }
         }
       }
     }

     func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
       // Handle error.
       print("Sign in with Apple errored: \(error)")
     }

    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
            // TODO: HANDLE ERROR
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }

    private func sha256(_ input: String) -> String {
           let inputData = Data(input.utf8)
           let hashedData = SHA256.hash(data: inputData)
           let hashString = hashedData.compactMap {
               String(format: "%02x", $0)
           }.joined()

           return hashString
       }
    
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.performRequests()
    }
}


enum AuthPage {
    case welcome, login, signup
    
    var termsMessage: String {
        switch self {
        case .welcome:
            return "\"Continue with Email/Apple\""
        case .login:
            return "\"Sign In\""
        case .signup:
            return "\"Sign Up\""
        }
    }
}


