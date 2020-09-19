//
//  LoginViewModel.swift
//  SocmedApp
//
//  Created by Najibullah Ulul Albab on 18/09/20.
//

import SwiftUI
import Firebase

class LoginViewModel: ObservableObject{
    
    @Published var code = ""
    @Published var number = ""
    
    //Jika ada Errors
    @Published var errorMsg = ""
    @Published var error = false
    
    @Published var registerUser = false
    @AppStorage("current_status") var status = false
    
    // Loading when Searches for user...
    @Published var isLoading = false
    
    func verifyUser(){
        isLoading = true
        
        //Remove when testing in live
        
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        let phoneNumber = "+" + code + number
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (ID, err) in
            if err != nil{
                self.errorMsg = err!.localizedDescription
                self.error.toggle()
                return
            }
            
            // Code sent sucessfully
            
            self.alertView { (Code) in
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: ID!, verificationCode: Code)
                
                Auth.auth().signIn(with: credential) { (ID, err) in
                    if err != nil {
                        self.errorMsg = err!.localizedDescription
                        self.error.toggle()
                        return
                    }
                    
                    self.checkUser()
                }
            }
        }
    }
    
    func alertView(completion: @escaping (String) -> ()){
        
        
        let alert = UIAlertController(title: "Verification", message: "Enter Code", preferredStyle: .alert)
        
        alert.addTextField { (txt) in
            txt.placeholder = "123456"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        alert.addAction(UIAlertAction(title: "Verify", style: .default, handler: { (_) in
            completion(alert.textFields![0].text ?? "")
            
            let code = alert.textFields![0].text ?? ""
            
            if code == ""{
                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
                return
            }
            completion(code)
        }))
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    func checkUser(){
        
        let ref = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        
        ref.collection("Users").whereField("uid", isEqualTo: uid).getDocuments { (snap, err) in
            
            if err != nil{
                // No Documents..
                // No User Found...
                self.registerUser.toggle()
                print("toggle eror")
                self.isLoading = false
                return
            }
            
            if snap!.documents.isEmpty{
                self.registerUser = true;
                print("toggle document is empty")
                self.isLoading = false
                return
            }
            self.status = true
        }
    }
}
