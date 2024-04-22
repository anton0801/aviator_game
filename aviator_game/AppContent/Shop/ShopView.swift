//
//  ShopView.swift
//  aviator_game
//
//  Created by Anton on 20/4/24.
//

import SwiftUI

struct ShopView: View {
    
    @EnvironmentObject var playerData: PlayerData
    
    @Environment(\.presentationMode) var presMode
    
    @State var alertErrorBuyShown = false
    
    var body: some View {
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
                
                Text("\(playerData.coins)")
                    .font(.custom("jsMath-cmbx10", size: 32))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 1)
                
                Image("ic_coin")
                    .resizable()
                    .frame(width: 72, height: 78)
            }
            .padding([.leading, .trailing])
            
            ScrollView {
                ForEach(playerData.allItems, id: \.self) { item in
                    VStack {
                        HStack {
                            Spacer()
                            
                            if !playerData.buyiedItems.filter { $0.name == item }.isEmpty {
                                if item == playerData.selectedPlane || item == playerData.selectedGameBack {
                                    Text("selected")
                                        .font(.custom("jsMath-cmbx10", size: 32))
                                        .foregroundColor(.white)
                                        .shadow(color: .black, radius: 1)
                                } else {
                                    Button {
                                        playerData.selectItem(item: item)
                                    } label: {
                                        Text("Select")
                                            .font(.custom("jsMath-cmbx10", size: 32))
                                            .foregroundColor(.white)
                                            .shadow(color: .black, radius: 1)
                                    }
                                }
                            } else {
                                Button {
                                    alertErrorBuyShown = playerData.buyItem(item: item)
                                } label: {
                                    Text("\(playerData.itemPrices[item]!)")
                                        .font(.custom("jsMath-cmbx10", size: 32))
                                        .foregroundColor(.white)
                                        .shadow(color: .black, radius: 1)
                                    
                                    Image("ic_coin")
                                        .resizable()
                                        .frame(width: 72, height: 78)
                                }
                            }
                            
                            Spacer()
                            
                            Text("=")
                                .font(.custom("jsMath-cmbx10", size: 32))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 1)
                            
                            Spacer()
                            
                            Image(item)
                                .resizable()
                                .frame(width: 100, height: 70)
                                .cornerRadius(12)
                            
                            Spacer()
                        }
                        .padding()
                        .background(
                            Image("record_btn")
                                .resizable()
                                .frame(width: 410, height: 130)
                        )
                    }
                    .padding([.top, .bottom])
                }
            }
        }
        .background(
            Image("app_back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .opacity(0.7)
                .ignoresSafeArea()
        )
        .preferredColorScheme(.dark)
        .alert(isPresented: $alertErrorBuyShown) {
            Alert(title: Text("Shop Error"),
                  message: Text("You don't have enough coins! Play the game, catch the coins and come back soon!"),
                  dismissButton: .cancel(Text("Ok")))
        }
    }

    private func backAction() {
        presMode.wrappedValue.dismiss()
    }
    
}

#Preview {
    ShopView()
        .environmentObject(PlayerData())
}
