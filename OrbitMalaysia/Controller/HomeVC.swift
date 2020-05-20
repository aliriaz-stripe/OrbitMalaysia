//
//  HomeVC.swift
//  OrbitMalaysia
//
//  Created by Martin Parker on 17/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class HomeVC: UIViewController {
    //Outlet
    @IBOutlet weak var productNameLbl: UILabel!
    
    
    //Variable
    var product : Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CheckIfUserExist()
        
        let product1 = Product(name: "Apple", id: "dfdfd", category: "cid", price: 2.00, productDescription: "No Desc", imageUrl: "imgUrl.com")
        product = product1
        
    }
    func CheckIfUserExist(){
        if Auth.auth().currentUser == nil{
            self.presentLoginController()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if product != nil {
            productNameLbl.text = "\(product?.name ?? "nil")\n\(product?.price ?? 0.0) "
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        UserService.getCurrentUser()
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        if let _ = Auth.auth().currentUser {
            // We are logged in
            do{
                try Auth.auth().signOut()
                presentLoginController()
                print("Logout success")
            }catch{
                print(error.localizedDescription)
                //Give user UIAlert to show them error
                //  Auth.auth().handleFireAuthError(error: error, vc: self)
            }
            
        }
    }
    // function to load the LoginStorboard
    func presentLoginController(){
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard , bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.LoginVC)
        present(controller, animated: false, completion: nil)
        
    }
    
    @IBAction func addClicked(_ sender: Any) {
        //print(product ?? "nil")
        let alertController = UIAlertController(title: "Added Success!", message: "", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            StripeCart.addItemToCart(item: self.product!)
        }
        
        alertController.addAction(confirm)
        self.present(alertController, animated: true, completion: nil)
    }
}
