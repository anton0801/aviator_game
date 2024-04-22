//
//  PlaneRescueLevelsView.swift
//  aviator_game
//
//  Created by Anton on 20/4/24.
//

import SwiftUI

struct PlaneRescueLevelsView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.presentationMode) var presMode
    
    @EnvironmentObject var playerData: PlayerData
    
    @StateObject var levelsData = LevelsData()
    @State var selectedLevel = "level_1"
    @State var goToGame = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        backAction()
                    } label: {
                        Image("back_btn")
                            .resizable()
                            .frame(width: 70, height: 45)
                    }
                    
                    Spacer()
                }
                .padding([.leading, .trailing])
                
                Text("LEVELS")
                    .font(.custom("jsMath-cmbx10", size: 32))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 1)
                    .padding(.top, 42)
                
                LazyVGrid(columns: [
                    GridItem(.fixed(120)),
                    GridItem(.fixed(120)),
                    GridItem(.fixed(120))
                ]) {
                    ForEach(levelsData.allLevels, id: \.self) { level in
                        ZStack {
                            let levelNum = level.components(separatedBy: "_")[1]
                            if levelsData.unlockedLevels.contains(level) {
                                Button {
                                    AppDelegate.orientationLock = .landscape
                                    selectedLevel = level
                                    goToGame = true
                                } label: {
                                    ZStack {
                                        Image("level_item_bg")
                                            .resizable()
                                            .frame(width: 120, height: 90)
                                        Text(levelNum)
                                            .font(.custom("jsMath-cmbx10", size: 32))
                                            .foregroundColor(.white)
                                            .shadow(color: .black, radius: 1)
                                    }
                                }
                            } else {
                                ZStack {
                                    Image("level_item_bg_disabled")
                                        .resizable()
                                        .frame(width: 120, height: 90)
                                    Text(levelNum)
                                        .font(.custom("jsMath-cmbx10", size: 32))
                                        .foregroundColor(.white)
                                        .shadow(color: .black, radius: 1)
                                }
                            }
                        }
                    }
                }
                .padding([.leading, .trailing, .top])
                
                Spacer()
                
                NavigationLink(destination: PlaneRescueGameView(level: selectedLevel)
                    .environmentObject(playerData)
                    .environmentObject(levelsData)
                    .navigationBarBackButtonHidden(true), isActive: $goToGame) {
                        EmptyView()
                    }
            }
            .onAppear {
                AppDelegate.orientationLock = .portrait
            }
            .background(
                Image("app_back")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .opacity(0.7)
                    .rotationEffect(Angle(degrees: shouldRotate() ? 0 : 90))
                    .ignoresSafeArea()
            )
            .preferredColorScheme(.dark)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func shouldRotate() -> Bool {
        return horizontalSizeClass == .compact
    }
    
    private func backAction() {
        presMode.wrappedValue.dismiss()
    }
    
}

#Preview {
    PlaneRescueLevelsView()
        .environmentObject(PlayerData())
}
