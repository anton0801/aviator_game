//
//  SettingsView.swift
//  aviator_game
//
//  Created by Anton on 20/4/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var toggleOnPush = false
    @State var toggleOnSounds = false
    
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
            }
            .padding([.leading, .trailing])
            
            Spacer()
            
            VStack {
                Text("Notifications")
                    .font(.custom("jsMath-cmbx10", size: 20))
                    .foregroundColor(.white)
                
                Toggle(isOn: $toggleOnPush) {
                }
                .onChange(of: toggleOnPush) { _ in
                    UserDefaults.standard.set(toggleOnPush, forKey: "push_enabled")
                }
                .offset(x: -120)
            }
            .background(
                Image("settings_item_bg")
                    .resizable()
                    .frame(width: 300, height: 250)
            )
            .frame(width: 300, height: 200)
            
            VStack {
                Text("Sounds")
                    .font(.custom("jsMath-cmbx10", size: 20))
                    .foregroundColor(.white)
                
                Toggle(isOn: $toggleOnSounds) {
                }
                .onChange(of: toggleOnSounds) { _ in
                    UserDefaults.standard.set(toggleOnSounds, forKey: "sounds_enabled")
                }
                .offset(x: -120)
            }
            .background(
                Image("settings_item_bg")
                    .resizable()
                    .frame(width: 300, height: 250)
            )
            .frame(width: 300, height: 200)
            
            Spacer()
        }
        .onAppear {
            toggleOnPush = UserDefaults.standard.bool(forKey: "push_enabled")
            toggleOnSounds = UserDefaults.standard.bool(forKey: "sounds_enabled")
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
    
}

#Preview {
    SettingsView()
}
