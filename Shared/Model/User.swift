//
//  User.swift
//  OrbitMalaysia
//
//  Created by Martin Parker on 17/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct User{
    var id : String
    var email: String
    var stripeId: String
    
    init(id: String = "",
         email: String = "",
         stripeId: String = "") {
        
        self.id = id
        self.email = email
        self.stripeId = stripeId
        
    }
    
    init(data: [String : Any]) {
        self.id = data ["id"] as? String ?? ""
        self.email = data ["email"] as? String ?? ""
        self.stripeId = data ["stripeId"] as? String ?? ""
        
    }
    
    static func modelToData(user: User) -> [String: Any]{
        
        let data : [String: Any] = [
            "id" : user.id,
            "email" : user.email,
            "stripeId" : user.stripeId
        ]
        return data
    }
    
}

