//
//  LeagueSyncPopUp.swift
//  DD
//
//  Created by Spencer Belton on 5/28/23.
//

import SwiftUI

struct LeagueSyncPopUp: View {
    
    @State var errorMessage = ""
    @State var shouldShowErrorMessage = false
                
    @ObservedObject var leagueSyncVM = LeagueSyncViewModel.instance
    @ObservedObject var teamHomeLogic = TeamHomeLogic.instance
    
    var sleeperLogic = SleeperManager.instance
    
    
    
    var body: some View {
        ZStack {
            VStack {
                list
                confirmButton
            }
            
            .task {
//                leagueSyncVM.submitTapped()
            }
            
        }
            
    }
    
    //MARK: - League List
    
    private var list: some View {
        ForEach(leagueSyncVM.leagues ?? []) { league in
            Button {
                self.leagueCellTapped(league)
            } label: {
                leagueCell(league)
            }

        }
    }
    
    //MARK: - League Cell
    
    private func leagueCell(_ league: League) -> some View {
        let isSelected = leagueSyncVM.selectedLeague == league
        return HStack(spacing: 25) {
            leagueImage(league)
            Text(league.name)
//                .foregroundColor(.yellow)
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 7)
            .foregroundColor(isSelected ? .purple.opacity(0.4) : .clear)
        )
        .padding()
    }
    
    private func leagueImage(_ league: League) -> some View {
        Image(systemName: "pencil")
    }
    
    //MARK: - Buttons
    
    private var confirmButton: some View {
        NavigationLink {
            LeagueTeamSyncPopUp()
        } label: { }
            .buttonStyle(FullRectangleButtonStyle(text: "Confirm", image: nil, color: .blue))

    }
    
    //MARK: - Methods
    
    private func leagueCellTapped(_ league: League) {
        leagueSyncVM.selectedLeague = league
    }
    
    private func confirmButtonTapped() {
        if let _ = leagueSyncVM.selectedLeague {
            syncOwners()
        }
    }
    
    private func syncOwners() {
        if let id = leagueSyncVM.selectedLeague?.id {
            sleeperLogic.getOwnersFromLeagueID(id) { owners, error in
                self.handleError(error)
                self.handleOwners(owners)
            }
        }
    }
    
    private func handleOwners(_ owners: [Owner]?) {
        if let owners = owners {
            DispatchQueue.main.async {
                leagueSyncVM.owners = owners
                teamHomeLogic.owners = owners
                if let chosenUser = owners.first(where: { $0.displayName == leagueSyncVM.usernameInput }) {
                    leagueSyncVM.selectedOwner = chosenUser
                    teamHomeLogic.selectedOwner = chosenUser
                    
                    leagueSyncVM.moveToTeamHomeView = true
                }
            }
        }
    }
    
    private func handleError(_ error: Error?) {
        if let error = error {
            self.errorMessage = error.localizedDescription
            self.shouldShowErrorMessage = true
        }
    }
}

struct LeagueSyncPopUp_Previews: PreviewProvider {
    static var previews: some View {
        LeagueSyncPopUp()
    }
}
