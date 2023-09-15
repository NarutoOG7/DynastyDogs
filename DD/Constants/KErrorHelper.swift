//
//  KErrorHelper.swift
//  DD
//
//  Created by Spencer Belton on 6/11/23.
//

import Foundation

extension K {
    
    enum ErrorHelper {
        
        enum ErrorType {
            case email, password, confirmPassword, firebase
        }
        
        enum Errors {
            case unrecognizedEmail
            case incorrectEmail
            case insufficientPassword
            case emailInUse
            case emailIsBadlyFormatted
            case incorrectPassword
            case passwordsDontMatch
            case troubleConnectingToFirebase
            case firebaseTrouble
            case failedToSaveUser
            
            func message() -> String {
                let authMessages = K.ErrorHelper.Messages.Auth.self
                let networkMessages = K.ErrorHelper.Messages.Network.self
                switch self {
                    
                case .unrecognizedEmail:
                    return authMessages.unrecognizedEmail.rawValue
                    
                case .incorrectEmail:
                    return authMessages.incorrectEmail.rawValue
                    
                case .insufficientPassword:
                    return authMessages.insufficientPassword.rawValue
                    
                case .emailInUse:
                    return authMessages.emailInUse.rawValue
                    
                case .emailIsBadlyFormatted:
                    return authMessages.emailIsBadlyFormatted.rawValue
                    
                case .incorrectPassword:
                    return authMessages.incorrectPassword.rawValue
                    
                case .passwordsDontMatch:
                    return authMessages.passwordsDontMatch.rawValue
                    
                case .troubleConnectingToFirebase:
                    return networkMessages.troubleConnectingToFirebase.rawValue
                    
                case .firebaseTrouble:
                    return networkMessages.firebaseTrouble.rawValue
                    
                case .failedToSaveUser:
                    return authMessages.failedToSaveUser.rawValue
                    
                }
            }
        }
        struct Messages {
            
            enum Auth: String {
                case failToSignOut = "There was an error signing out of your account. Check your connection and try again."
                case failedToSaveUser = "There was a problem saving the user"
                
                case emailBlank = "Please provide an email address."
                case unrecognizedEmail = "This email isn't recognized."
                case incorrectEmail = "Email is invalid."
                case emailIsBadlyFormatted = "This is not recognized as an email."
                case emailInUse = "This email is already in use."
                
                case passwordBlank = "Please provide a password."
                case incorrectPassword = "Password is incorrect."
                case insufficientPassword = "Password must be at least 6 characters long."
                case passwordsDontMatch = "Passwords DO NOT match"
                
            }
            enum Network: String {
                case troubleConnectingToFirebase = "There seems to be an issue with the connection to firebase."
                case firebaseTrouble = "There was an issue creating your account."
                case firebaseConnection = "There was an error with firebase. Check your connection and try again."
            }
            
            enum Sleeper: String {
                case leagueIdNotRecognized = "Sleeper League ID isn't recognized."
                case usernameNotRecognized = "Sleeper Username not recognized."
            }
        }
    }
}
