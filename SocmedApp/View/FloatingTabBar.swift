//
//  FloatingTabBar.swift
//  SocmedApp
//
//  Created by Najibullah Ulul Albab on 19/09/20.
//

import SwiftUI

struct FloatingTabBar: View {
    @Binding var selectedTab : String
    var body: some View {
        
        HStack(spacing: 65){
            
            TabButton(titleText: "Feeds", title: "tray.2", selectedTab: $selectedTab)
            
            TabButton(titleText: "Profile", title: "person", selectedTab: $selectedTab)
        }
        .padding(.horizontal)
        .background(Color.white)
        .clipShape(Capsule())
    }
}

struct TabButton : View {
    var titleText : String
    var title : String
    @Binding var selectedTab : String
    
    var body: some View{
        
        Button(action: {selectedTab = title}) {
            
            VStack(spacing: 5){
                
                Image(systemName: title)
                    .renderingMode(.template)
                
                Text(titleText)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .foregroundColor(selectedTab == title ? Color("blue") : .gray)
            .padding(.horizontal)
            .padding(.vertical,10)
        }
    }
}
