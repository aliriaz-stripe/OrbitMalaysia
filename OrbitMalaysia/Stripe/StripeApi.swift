//
//  StripeApi.swift
//  OrbitMalaysia
//
//  Created by Martin Parker on 19/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import Foundation
import Stripe
import FirebaseFunctions

let StripeApi = _StripeApi()

class _StripeApi: NSObject, STPCustomerEphemeralKeyProvider{
    
    //MARK: Step 1:-What we are doing here is we are going to use this method called "createCustomerKey" to create customer key to contact and then invoke our cloud function on the backend.
    //MARK: Step 2:-We pass the stripe_version and customer_id those are the two required fields to create an Ephemeral key for a given stripe customer.
    //MARK: Step 3:-We invoke the function using functions callable and we tell it which cloud function to invoke by giving it the name -> "createEphemeralKey".
    //MARK:        -then we say .call ,we send it the data and we get back the optional result and an optional error.
    //MARK: Step 4:-We do a check to make sure there are no errors and if there are not error then we extract the key which we return in our cloud function
    
    
    //Step 1:
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        //Step 2:
        let data = [
            "stripe_version": apiVersion,
            "customer_id": UserService.user.stripeId
        ]
        
        //Step 3:
        Functions.functions().httpsCallable("createEphemeralKey").call(data) { (result, error) in
            
            //Step 4:
            if let error = error {
                debugPrint(error.localizedDescription)
                completion(nil, error)
                return
            }
            
            guard let key = result?.data as? [String: Any] else{
                completion(nil,nil)
                return
            }
            
            completion(key, nil)// if everything goes according to plan we return the ephemeral key right here.
            
        }
        
    }
    
    
}
