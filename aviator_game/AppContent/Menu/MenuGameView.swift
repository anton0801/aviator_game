//
//  MenuGameView.swift
//  aviator_game
//
//  Created by Anton on 20/4/24.
//

import SwiftUI

struct MenuGameView: View {
    
    @StateObject var playerData = PlayerData()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    
                    Text("\(playerData.coins)")
                        .font(.custom("jsMath-cmbx10", size: 32))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 1)
                    
                    Image("ic_coin")
                        .resizable()
                        .frame(width: 72, height: 78)
                }
                
                NavigationLink(destination: PlaneRescueLevelsView()
                    .environmentObject(playerData)
                    .navigationBarBackButtonHidden(true)) {
                        Image("game_btn")
                            .resizable()
                            .frame(width: 300, height: 150)
                    }
                
                NavigationLink(destination: ShopView()
                    .environmentObject(playerData)
                    .navigationBarBackButtonHidden(true)) {
                        Image("shop_btn")
                            .resizable()
                            .frame(width: 300, height: 150)
                    }
                
                NavigationLink(destination: RecordsView()
                    .environmentObject(playerData)
                    .navigationBarBackButtonHidden(true)) {
                        Image("records_btn")
                            .resizable()
                            .frame(width: 300, height: 150)
                    }
                
                NavigationLink(destination: SettingsView()
                    .navigationBarBackButtonHidden(true)) {
                        Image("settings_btn")
                            .resizable()
                            .frame(width: 300, height: 150)
                    }
                
                Spacer()
            }
            .background(
                Image("app_back")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .opacity(0.7)
                    .ignoresSafeArea()
            )
            .preferredColorScheme(.dark)
            .onAppear {
                AppDelegate.orientationLock = .portrait
                if !UserDefaults.standard.bool(forKey: "is_not_first_launch") {
                    playerData.firstLaunchAndSetData()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MenuGameView()
}
