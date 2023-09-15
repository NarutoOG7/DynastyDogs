//
//  LeagueSyncView.swift
//  DD
//
//  Created by Spencer Belton on 5/26/23.
//

import SwiftUI

struct LeagueSyncView: View {
        
    @ObservedObject var leagueSyncVM = LeagueSyncViewModel.instance
        
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 50) {
                    leagueInfoField(.username, $leagueSyncVM.usernameInput)
                    or
                    leagueInfoField(.leagueID, $leagueSyncVM.leagueIDInput)
                    Spacer(minLength: 35)
                    submitButton
                }
                .padding()
                ////
                ////            if leagueSyncVM.moveToChooseLeague {
                ////                LeagueSyncPopUp()
                ////            }
                //            .popover(isPresented: $leagueSyncVM.moveToChooseLeague) {
                //                LeagueSyncPopUp()
                //                    .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.3)
                //            }
                //
                //            .popover(isPresented: $leagueSyncVM.moveToChooseTeam) {
                //                LeagueTeamSyncPopUp()
                //                    .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.3)
                //            }
                
            
                        }
        }
    }
        
    private func leagueInfoField(_ type: SleeperField, _ input: Binding<String>) -> some View {
        let leagueIDMessage = leagueSyncVM.leagueIDErrorMessage
        let usernameMessage = leagueSyncVM.usernameErrorMessage
        let typeIsLeagueID = type == .leagueID
        let errorMessage = typeIsLeagueID ? leagueIDMessage : usernameMessage
        let shouldShowLeagueIDError = typeIsLeagueID && leagueIDMessage != ""
        let shouldShowUsernameError = !typeIsLeagueID && usernameMessage != ""
        return VStack(alignment: .leading) {
            Text(type.headline)
            TextField(type.rawValue.capitalized, text: input)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20).foregroundColor(.yellow))
            Text(errorMessage)
                .opacity(shouldShowUsernameError || shouldShowLeagueIDError ? 1 : 0)
                .foregroundColor(.red)
        }
    }
    
    private var or: some View {
        HStack(spacing: 15) {
            
            Rectangle()
                .fill(.yellow)
                .frame(height: 1)
            
            Text("OR")
                .foregroundColor(.yellow)
                .font(.avenirNext(size: 20))
            
            Rectangle()
                .fill(.yellow)
                .frame(height: 1)
            
        }
        .padding(.horizontal, 30)
        .padding(.top, 25)
    }
    
    private var submitButton: some View {
        let disabled = !leagueSyncVM.aFieldIsFilled
        
        return Button {
            leagueSyncVM.submitTapped { success in
                if success {
                    leagueSyncVM.moveToChooseLeague = true
                }
            }
        } label: { }
            .buttonStyle(FullRectangleButtonStyle(text: "Submit", image: nil, color: .blue, textColor: disabled ? .white.opacity(0.7) : .white))
    }
    
    
//    private var submitButton: some View {
//        let disabled = !leagueSyncVM.aFieldIsFilled
//       return NavigationLink {
//            LeagueSyncPopUp()
//        } label: { }
//            .disabled(disabled)
//            .buttonStyle(FullRectangleButtonStyle(text: "Submit", image: nil, color: .blue, textColor: disabled ? .white.opacity(0.7) : .white))
//    }
    
//    private var submiButton: some View {
//        if leagueSyncVM.leagueIDInput != "" {
//            NavigationLink {
//                LeagueSyncPopUp()
//            } label: { }
//                .buttonStyle(FullRectangleButtonStyle(text: "Submit", image: nil, color: .blue))
//                .onTapGesture {
//                    leagueSyncVM.getSleeperLeagueFromID()
//                }
//        } else if leagueSyncVM.usernameInput != "" {
//            NavigationLink {
//                LeagueTeamSyncPopUp()
//            } label: { }
//                .buttonStyle(FullRectangleButtonStyle(text: "Submit", image: nil, color: .blue))
//                .onTapGesture {
//                    leagueSyncVM.getSleeperLeagueFromUsername()
//                }
//        } else {
//            NavigationLink {
//                LeagueSyncPopUp()
//            } label: { }
//                .buttonStyle(FullRectangleButtonStyle(text: "Submit", image: nil, color: .blue))
//                .disabled(true)
//
//        }
//    }
    
//        Button(action: leagueSyncVM.submitTapped) {
//            Text("Submit")
//                .foregroundColor(.yellow)
//                .background(
//                    RoundedRectangle(cornerRadius: 20)
//                        .foregroundColor(.blue))
//        }
   
}

struct LeagueSyncView_Previews: PreviewProvider {
    static var previews: some View {
        LeagueSyncView()
    }
}


enum SleeperField: String {
    case username, leagueID = "league ID"
    
    var headline: String {
        switch self {
        case .username:
            return "Enter Sleeper Username"
        case .leagueID:
            return "Enter Your Sleeper League ID"
        }
    }
}
