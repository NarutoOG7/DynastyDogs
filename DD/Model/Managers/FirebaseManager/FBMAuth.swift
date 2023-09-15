//
//  FBMAuth.swift
//  DD
//
//  Created by Spencer Belton on 6/11/23.
//

import SwiftUI
import FirebaseAuth


class FBMAuth {
    
    static let instance = FBMAuth()
    
    let auth = Auth.auth()
        
    @ObservedObject var userStore = UserStore.instance
    
    var isSignedIn: Bool {
        auth.currentUser != nil
    }
    
    func isUserAlready(id: String) -> Bool {
        id == auth.currentUser?.uid
    }
    
    func signIn(email: String, password: String, success onSuccess: @escaping(Bool) -> Void, error onError: @escaping(K.ErrorHelper.Errors) -> Void) {
        
        auth.signIn(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                                
                switch error.localizedDescription {
                    
                case let str where str.contains("no user record corresponding to this identifier"):
                    onError(.unrecognizedEmail)
                    
                case let str where str.contains("email address"):
                    onError(.incorrectEmail)
                    
                case let str where str.contains("password must be 6 characters"):
                    onError(.insufficientPassword)
                    
                case let str where str.contains("email in use"):
                    onError(.emailInUse)
                    
                case let str where str.contains("password is invalid"):
                    onError(.incorrectPassword)
                    
                case let str where str.contains("network error has occurred"):
                    onError(.troubleConnectingToFirebase)
                    
                default:
                    onError(.firebaseTrouble)
                }
            }
            
            if let result = authResult {
                
                let user = User(id: result.user.uid,
                                name: result.user.displayName ?? "",
                                email: result.user.email ?? "")
                                
                DispatchQueue.main.async {
                    
                    self.userStore.isSignedIn = true
                    self.userStore.user = user
                    
                    UserDefaults.standard.set(true, forKey: "signedIn")
                    
                    self.saveUserToUserDefaults(user: user) { error in
                        if let _ = error {
                            onError(.failedToSaveUser)
                        }
                    }
                    
                    onSuccess(true)
                }
            }
        }
    }
    
    func signUp(userName: String, email: String, password: String, confirmPassword: String, withCompletion completion: @escaping(Bool, K.ErrorHelper.Errors?) -> Void) {
        
        if confirmPassword == password {
            
            auth.createUser(withEmail: email, password: password) { (result, error) in
                
                if let error = error {
                                        
                    switch error.localizedDescription {
                        
                    case let str where str.contains("network error has occurred"):
                        completion(false, .troubleConnectingToFirebase)
                        
                    case let str where str.contains("email address is already in use"):
                        completion(false, .emailInUse)
                        
                    case let str where str.contains("email address is badly formatted"):
                        completion(false, .emailIsBadlyFormatted)
                        
                    case let str where str.contains("password must be 6 characters"):
                        completion(false, .insufficientPassword)
                        
                    case let str where str.contains("passwords do not match"):
                        completion(false, .passwordsDontMatch)
                        
                    default:
                        completion(false, .firebaseTrouble)
                    }
                    
                } else {
                    guard let result = result else {
                        completion(false, .firebaseTrouble)
                        return
                    }
                    
                    let user = User(id: result.user.uid, name: userName, email: result.user.email ?? "")
                    
                    
                    DispatchQueue.main.async {
                        
                        self.userStore.isSignedIn = true
                        self.userStore.user = user
                        
                        UserDefaults.standard.set(true, forKey: "signedIn")
                        
                        self.saveUserToUserDefaults(user: user) { error in
                            if let _ = error {
                                completion(false, .failedToSaveUser)
                            }
                        }
                        completion(true, nil)
                    }
                }
            }
        } else {
          completion(false, .passwordsDontMatch)
        }
    }
    
    
    //MARK: - SignOut
    func signOut(error onError: @escaping(K.ErrorHelper.Messages.Auth) -> Void) {
        
        do {
            
            try auth.signOut()
            
            self.userStore.isSignedIn = false
            self.userStore.user = User()
            
            UserDefaults.standard.set(false, forKey: "signedIn")
            
            self.saveUserToUserDefaults(user: User()) { error in
                
                if let _ = error {
                    
                    onError(.failedToSaveUser)
                }
            }
            
        } catch {
            print("Trouble siging out. \(error)")
            onError(.failToSignOut)
        }
    }
    
    //MARK: - PasswordReset
    func passwordReset(email: String, withCompletion completion: @escaping(Bool) -> Void, error onError: @escaping(K.ErrorHelper.Errors) -> Void) {
        
        auth.sendPasswordReset(withEmail: email) { error in
            
            if let error = error {
                print(error.localizedDescription)
                onError(.firebaseTrouble)
            } else {
                completion(true)
            }
        }
    }
    
    //MARK: - DeleteAccount
    func deleteUserAccount(error onError: @escaping(String) -> Void, success onSuccess: @escaping(Bool) -> Void) {
        
        if let user = auth.currentUser {
            
            user.delete { error in
                if let error = error {
                    print(error.localizedDescription)
                    onError(error.localizedDescription)
                } else {
                    // Account deleted.
                    DispatchQueue.main.async {
                        
                        self.userStore.isSignedIn = false
                        
                        UserDefaults.standard.set(false, forKey: "signedIn")
                        
                        self.saveUserToUserDefaults(user: User()) { error in
                            
                            if let error = error {
                                onError(error)
                            }
                        }
                    }
                    
                    onSuccess(true)
                }
            }
            
        }
    }
    
    
    //MARK: - Save User To UserDefaults
    
    func saveUserToUserDefaults(user: User, error onError: @escaping(String?) -> Void) {
        
        do {
            
            let encoder = JSONEncoder()
            
            let data = try encoder.encode(user)
            
            UserDefaults.standard.set(data, forKey: "user")
            
        } catch {
            
            onError(K.ErrorHelper.Messages.Auth.failedToSaveUser.rawValue)
        }
    }
    

}
