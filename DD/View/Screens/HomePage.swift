//
//  HomePage.swift
//  DD
//
//  Created by Spencer Belton on 6/12/23.
//

import SwiftUI

struct HomePage: View {
    
    @ObservedObject var teamHomeLogic = TeamHomeLogic.instance
    @ObservedObject var userStore = UserStore.instance
    
    var body: some View {
        
        LetsGetStartedHomePage()
        
//        if userStore.leagues.isEmpty {
//
//        }
        
    }

}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}

class HomeVM: ObservableObject {
    static let instance = HomeVM()
    
    @Published var topTenPlayers: [RankedPlayer] = []

}

struct LetsGetStartedHomePage: View {
    
    let firebaseManager = FirebaseManager.instance
        
    @ObservedObject var errorManager = ErrorManager.instance
    @ObservedObject var homeVM = HomeVM.instance
    @ObservedObject var teamHomeLogic = TeamHomeLogic.instance
        
    var body: some View {
//        ScrollView {
            VStack {
                logo
                title
                subText
                syncButton
                list
            }
            .padding()
            .task {
                self.getTopWR()
//                self.supplyTopTenPlayers()
            }
//        }
        .background(.black)
    }
    
    var logo: some View {
        Image("DDNEWLOGO")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 100)
    }
    
    var title: some View {
        Text("SYNC A LEAGUE")
            .font(.title)
            .foregroundColor(.orange)
    }
    
    var subText: some View {
        Text("Get a breakdown of your team and league.")
            .foregroundColor(.orange)

    }
    
    var list: some View {
        let players = [teamHomeLogic.TLAW,
                       teamHomeLogic.ETN,
                       teamHomeLogic.GIBSON,
                       teamHomeLogic.WADDLE,
                       teamHomeLogic.JSN,
                       teamHomeLogic.NJOKU,
                       teamHomeLogic.GAY,
                       teamHomeLogic.DENVER,
                       teamHomeLogic.DRE
        ]
        return  List {
            ForEach(homeVM.topTenPlayers.sorted(by: { $0.id < $1.id })) { player in
                Text("\(player.id). \(player.name)")
                                .foregroundColor(.white)
                    .listRowBackground(Color.clear)
            }
        }
        .modifier(ClearListBackgroundMod())
    }
    
    var syncButton: some View {
        NavigationLink {
            LeagueSyncView()
        } label: { }
            .buttonStyle(FullRectangleButtonStyle(text: "Sync League", image: nil, color: .orange))
    }
    
    private func supplyTopTenPlayers() {
        firebaseManager.getTopTenPlayerRankings { players, error in
            self.handleError(error)
            if let players = players {
                DispatchQueue.main.async {
                    homeVM.topTenPlayers = players
                }
            }
        }
    }
    
    private func getTopWR() {
        firebaseManager.getTopAmountAtPosition(5, .wr) { players, error in
            self.handleError(error)
            if let players = players {
                DispatchQueue.main.async {
                    homeVM.topTenPlayers = players
                }
            }
        }
    }
    
    private func handleError(_ error: Error?) {
        if let error = error {
            self.errorManager.handleError(error)
        }
    }
}
