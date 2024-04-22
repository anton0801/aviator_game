//
//  RecordsView.swift
//  aviator_game
//
//  Created by Anton on 20/4/24.
//

import SwiftUI

struct RecordsView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @EnvironmentObject var playerData: PlayerData
    
    @StateObject private var recordsData = RecordsData()
    
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
                ForEach(recordsData.recordsList, id: \.self) { recordLevelName in
                    VStack {
                        HStack {
                            Spacer()
                            
                            let levelNum = recordLevelName.components(separatedBy: "_")[1]
                            Text("lv\(levelNum)")
                                .font(.custom("jsMath-cmbx10", size: 24))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            let recordTime = self.secondsToMinutesAndSeconds(seconds: recordsData.records[recordLevelName]!)
                            if recordTime == "00:00" {
                                Text("N/S")
                                    .font(.custom("jsMath-cmbx10", size: 24))
                                    .foregroundColor(.white)
                            } else {
                                Text("\(recordTime)")
                                    .font(.custom("jsMath-cmbx10", size: 24))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            
                            Text("-")
                                .font(.custom("jsMath-cmbx10", size: 24))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            if recordTime == "00:00" {
                                Text("N/S")
                                    .font(.custom("jsMath-cmbx10", size: 24))
                                    .foregroundColor(.white)
                            } else {
                                Text("\(recordsData.recordsDates[recordLevelName]!.convertToDate().formattToPretty())")
                                    .font(.custom("jsMath-cmbx10", size: 24))
                                    .foregroundColor(.white)
                            }

                            Spacer()
                            
                        }
                        .padding()
                    }
                    .background(
                        Image("record_btn")
                            .resizable()
                            .frame(width: 410, height: 90)
                    )
                    .padding()
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
    }
    
    private func backAction() {
        presMode.wrappedValue.dismiss()
    }
    
    private func secondsToMinutesAndSeconds(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}

#Preview {
    RecordsView()
        .environmentObject(PlayerData())
}
