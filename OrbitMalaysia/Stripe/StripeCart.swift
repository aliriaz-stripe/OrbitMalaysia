//
//  StripeCart.swift
//  OrbitMalaysia
//
//  Created by Martin Parker on 18/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import Foundation

let StripeCart = _StripeCart()

//Singleton
final class _StripeCart {
    
    //variable to hold all the product in the cart
    var cartItems = [Product]() //Initial an empty Product Array
    var shippingFees = 0
    
    //Variable for subtotal, processing fees, total
    var subtotal: Int {
        var amount = 0
        for item in cartItems {
            let pricePennies = Int(round(item.price * 100))
            amount += pricePennies
        }
        return amount
    }
    var total: Int{
        return subtotal + shippingFees
    }
    
    func addItemToCart(item: Product){
        cartItems.append(item)
    }
    
    func removeItemFromCart(item: Product){
        if let index = cartItems.firstIndex(of: item){
            cartItems.remove(at: index)
        }
    }
    
    func clearCart(){
        cartItems.removeAll()
    }
    
}
