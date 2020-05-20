//
//  UserService.swift
//  OrbitMalaysia
//
//  Created by Martin Parker on 17/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

//User servie Singleton - fetch and hold information about the looged in User
//                      - fetch and listen for changes to our user document
//                      - fetch and listen to changed to user favorites collection
//                      - handle logic when a product is favorited
//                      - handle the logout for the user

let UserService = _UserService()

final class _UserService {
    
    //Variable
    var user = User() //-Iniatial user object with it default empty values
    
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var userListener : ListenerRegistration? = nil
    
    var isGuest : Bool  {

        guard let authUser = auth.currentUser else{
            return true
        }
        if authUser.isAnonymous {
            return true
        }else{
            return false
        }
    }
    
    func getCurrentUser(){
        guard let authUser = auth.currentUser else { return }
        
        let userRef = db.collection("users").document(authUser.uid)
        userListener = userRef.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            guard let data = snap?.data() else{ return }
            self.user = User.init(data: data)
            print(self.user)
        })
    }
    
    
    
    
}
