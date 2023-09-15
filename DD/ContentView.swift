//
//  ContentView.swift
//  DD
//
//  Created by Spencer Belton on 5/26/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var leagueSyncVM = LeagueSyncViewModel.instance
    @ObservedObject var userStore = UserStore.instance
    
    var body: some View {
        NavigationStack {
            if userStore.isSignedIn {
                if userStore.leagues.isEmpty {
                    LetsGetStartedHomePage()
                } else {
                    TeamHomeView()
                }
            } else {
                WelcomeAuthPage()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
