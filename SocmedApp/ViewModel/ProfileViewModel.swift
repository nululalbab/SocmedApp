//
//  ProfileViewModel.swift
//  SocmedApp
//
//  Created by Najibullah Ulul Albab on 19/09/20.
//

import SwiftUI
import Firebase

class ProfileViewModel : ObservableObject{
    
    @Published var userInfo = UserModel(username: "", pic: "", bio: "", uid: "")
    @AppStorage("current_status") var status = false
    
    // Image Picker For Updating Image...
    @Published var picker = false
    @Published var img_data = Data(count: 0)
    
    // Loading View..
    @Published var isLoading = false
    
    let ref = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid
    
    init() {
        
        fetchUser(uid: uid) { (user) in
            self.userInfo = user
        }
    }
    
    
    func logOut(){
        
        // logging out..
        
        try! Auth.auth().signOut()
        status = false
    }
    
}
