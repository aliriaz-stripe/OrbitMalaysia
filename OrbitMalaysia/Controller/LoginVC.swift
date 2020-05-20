//
//  LoginVC.swift
//  OrbitMalaysia
//
//  Created by Martin Parker on 17/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore

class LoginVC: UIViewController, GIDSignInDelegate {
    
    //Outlet
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //Variable
    var users = [User]()
    var db : Firestore!
    var listener : ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        GIDSignIn.sharedInstance()?.delegate = self
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        listener?.remove()
    }
    
    
    @IBAction func googleclicked(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func guestClicked(_ sender: Any) {
        activityIndicator.startAnimating()
        Auth.auth().signInAnonymously { (result, error) in
            if let error  = error{
                debugPrint(error)
            }
            
            self.dismiss(animated: true, completion: nil)
            self.activityIndicator.stopAnimating()
            
            
            
        }
    }
    
    //Google Sign in Function
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        activityIndicator.startAnimating()
        
        guard let authentication  = user?.authentication else {
            self.activityIndicator.stopAnimating()
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        if error == nil {
            //Do what ever you want to do this
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil){
                    self.activityIndicator.stopAnimating()
                    return
                }else{
                    //Dismiss and go to HomeVC
                    
                    guard let userRef = Auth.auth().currentUser?.uid else {return}
                    self.checkIfUserSignUpBefore(idRef: userRef)
                    print("LogIn!")
                }
            }
        }else{
            self.activityIndicator.stopAnimating()
            return
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //Perform operation when user got disconnected
        
    }
    
    func checkIfUserSignUpBefore(idRef: String){
        listener = db.collection("users").document(idRef).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
           guard let data = document.data() else {
         
                //here is the user is invalid
                // User havent sign-up before
                print("This user Havent sign-up before")
            
                guard let userEmail = Auth.auth().currentUser?.email else {return}
                guard let userId = Auth.auth().currentUser?.uid else {return}
                
                let artUser = User.init(id: userId, email: userEmail, stripeId: "")
                self.createFirestoreUser(user: artUser)
                
                return
            }
            
            //here the user is sign-up before
            print("This user had sign-up before ")
            print("Current data: \(data)")
            
            DispatchQueue.main.async {
                
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
                
                
            }
            
        }
    }
    
    func tryCreateUser(){
        
    }
    
    func createFirestoreUser(user: User) {
        
        // Step 1: Create document reference
        let newUserRef = Firestore.firestore().collection("users").document(user.id)
        
        // Step 2: Create model data
        let data = User.modelToData(user: user)
        
        // Step 3: Upload to Firestore.
        newUserRef.setData(data) { (error) in
            if let error = error {
                //Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint("Error signing in: \(error.localizedDescription)")
                self.activityIndicator.stopAnimating()
            } else {
                print("success create user")
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
}
