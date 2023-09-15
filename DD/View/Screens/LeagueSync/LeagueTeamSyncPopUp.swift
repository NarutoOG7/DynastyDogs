//
//  LeagueTeamSyncPopUp.swift
//  DD
//
//  Created by Spencer Belton on 5/28/23.
//

import SwiftUI

struct LeagueTeamSyncPopUp: View {
    
    //    let league: League
    @State var owners: [Owner] = []
    
    @State var errorMessage: String = ""
    @State var shouldShowErrorMessage = false
    
    @ObservedObject var leagueSyncVM  = LeagueSyncViewModel.instance
    @ObservedObject var teamHomeLogic = TeamHomeLogic.instance
    
    let sleeperLogic = SleeperManager.instance
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    list
                    confirmButton
                }
                .task {
                    getOwners()
                }
            }
        }
    }
    
    private var list: some View {
        ForEach(owners) { owner in
            Button {
                ownerCellTapped(owner)
            } label: {
                ownerCell(owner)
            }
        }
    }
    
    private func handleError(_ error: Error?) {
        self.errorMessage = error?.localizedDescription ?? ""
        self.shouldShowErrorMessage = true
    }
    
    private func getOwners() {
        if let id = leagueSyncVM.selectedLeague?.id {
            sleeperLogic.getOwnersFromLeagueID(id) { owners, error in
                self.handleError(error)
                if let owners = owners {
                    self.owners = owners
                }
            }
        }
    }
    

}

struct LeagueTeamSyncPopUp_Previews: PreviewProvider {
    static var previews: some View {
        LeagueTeamSyncPopUp()
    }
}

extension LeagueTeamSyncPopUp {
    
    //MARK: - Owner Cell

    private func ownerCell(_ owner: Owner) -> some View {
        let isSelected = leagueSyncVM.selectedOwner == owner
        return
            Text(owner.displayName)
                .foregroundColor(.yellow)
        .padding()
        .background(RoundedRectangle(cornerRadius: 7)
            .foregroundColor(isSelected ? .purple.opacity(0.4) : .clear)
        )
        .padding()
    }
    
    private func ownerCellTapped(_ owner: Owner) {
        leagueSyncVM.selectedOwner = owner
    }
    
    
    
    //MARK: - Confirm Button
    private var confirmButton: some View {
        NavigationLink {
            TeamHomeView()
        } label: { }
            .buttonStyle(FullRectangleButtonStyle(text: "Confirm", image: nil, color: .blue
                                                 ))

//        Button(action: confirmButtonTapped) {
//            Text("Confirm")
//                .foregroundColor(.yellow)
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 20)
//                        .foregroundColor(.blue))
//        }
    }
    
    private func confirmButtonTapped() {
        if let owner = leagueSyncVM.selectedOwner {
            teamHomeLogic.owners = owners
            teamHomeLogic.selectedOwner = owner
            leagueSyncVM.moveToTeamHomeView = true

        }
    }
}

