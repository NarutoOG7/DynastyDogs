//
//  NoLeagueHome.swift
//  DD
//
//  Created by Spencer Belton on 6/13/23.
//

import SwiftUI

struct NoLeagueHome: View {
    
    @ObservedObject var teamHomeLogic = TeamHomeLogic.instance
    
    var body: some View {
        list
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
        return List(players.sorted(by: { $0.id < $1.id
        })) { player in
            Text(player.id + " " + player.name)
        }
    }
}

struct NoLeagueHome_Previews: PreviewProvider {
    static var previews: some View {
        NoLeagueHome()
    }
}
