//
//  CheckoutVC.swift
//  OrbitMalaysia
//
//  Created by Martin Parker on 18/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFunctions
class CheckoutVC: UIViewController, CartItemDelegate {
  
    
    //Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentMethodBtn: UIButton!
    @IBOutlet weak var shippingMethodBtn: UIButton!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var shippingCostLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
   
    //Variable
    var paymentContext : STPPaymentContext! //Because we need to access our payment context from multiple location in our checkoutVC, so we create a class variable for that to access all around this VC.
    

     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupStripeConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(StripeCart.cartItems)
        setupPaymentInfo()
        // print(paymentContext.selectedPaymentOption ?? "No Payment selected yet")
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.CartItemCell, bundle: nil), forCellReuseIdentifier: Identifiers.CartItemCell)
    }
    func setupPaymentInfo(){
        subtotalLbl.text = StripeCart.subtotal.penniesToFormattedCurrency()
        shippingCostLbl.text = StripeCart.shippingFees.penniesToFormattedCurrency()
        totalLbl.text = StripeCart.total.penniesToFormattedCurrency()
        
    }
    
    func setupStripeConfig(){
        //add a couple of additional configuration to the payment context using the stripe payment context configuration.
        //Initial a variable call config with "STPPaymentConfiguration" which mean all the options you can set or change around a payment.
        let config = STPPaymentConfiguration.shared()
        config.requiredBillingAddressFields = .none
        config.requiredShippingAddressFields = [.postalAddress ]
        config.additionalPaymentOptions = .FPX
        config.shippingType = .delivery
        
        
        
        // -create our customer context and when we create this customer context its going to invoke the cloud function generate an Emphemeral key pass it back and then
        //  this customer context class will go ahead and pre fetch the stripe customer's information from its stripe object
        //  getting its saved credit card information if there are any, shipping informatio that saved all of that information.
        let customerContext = STPCustomerContext(keyProvider: StripeApi)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        
        //set the paymentContext's payment Amount$
        paymentContext.paymentAmount = StripeCart.total
        paymentContext.delegate = self
        paymentContext.hostViewController = self
        
        
    }
    
    @IBAction func placeOrderClicked(_ sender: Any) {
        paymentContext.requestPayment()
        activityIndicator.startAnimating()
    }
    
    @IBAction func paymentMethodClicked(_ sender: Any) {
        self.paymentContext.pushPaymentOptionsViewController()
    }
    
    @IBAction func shippingMethodClicked(_ sender: Any) {
        
        self.paymentContext.pushShippingViewController()
    }
    
    func removeItem(item: Product) {
        StripeCart.removeItemFromCart(item: item)
        tableView.reloadData()
        setupPaymentInfo()
        //when we remove an item, stripeCart update it amount but we also need to update the paymentContext's payment Amount$
        paymentContext.paymentAmount = StripeCart.total
    }
    
    
}
//class AuthContext: NSObject, STPAuthenticationContext {
//
//    var viewController: UIViewController
//
//    init(viewController: UIViewController) {
//        self.viewController = viewController
//    }
//
//    func authenticationPresentingViewController() -> UIViewController {
//        return self.viewController
//    }
//    func authenticationContextWillDismiss(_ viewController: UIViewController) {
//        debugPrint("authenticationContextWillDismiss")
//
//    }
//    func prepare(forPresentation completion: @escaping STPVoidBlock) {
//
//      completion()
//    }
//
//
//}


extension CheckoutVC: STPPaymentContextDelegate{
   
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        //Updating the selected payment method
        if let paymentMethod = paymentContext.selectedPaymentOption{
            paymentMethodBtn.setTitle(paymentMethod.label, for: .normal)
        }else{
            paymentMethodBtn.setTitle("Select Method", for: .normal)
        }
        
        //Updating the selected shipping method
        if  paymentContext.shippingAddress != nil {
            shippingMethodBtn.setTitle("Selected", for: .normal)
            StripeCart.shippingFees = Int(0.01 * 100)
            setupPaymentInfo()
        }else{
            shippingMethodBtn.setTitle("Select", for: .normal)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        activityIndicator.stopAnimating()
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.paymentContext.retryLoading()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(retry)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Step 1: Function for Begin a Stripe Charge
    //Here is where we are going to call our Cloud Function that actually sends the information to stripe
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        //Step 1: call charge cloud function here
        //
          //      let idempotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        //
        //        //create our dictionary data here
        //        let data : [String: Any] = [
        //            "total" : StripeCart.total,
        //            "customerId" : UserService.user.stripeId,
        //            "payment_method_id" : paymentResult.paymentMethod?.stripeId ?? "",
        //            //"payment_method" : paymentResult.paymentMethod ?? "",
        //            "idempotency" : idempotency
        //        ]
        //
        //        //create function call the "makeCharge" cloud function by passing by the data and wait for the response
        //        Functions.functions().httpsCallable("createCharge").call(data) { (result, error) in
        //
        //            //If error happen
        //            if let error = error {
        //                debugPrint(error.localizedDescription)
        //                self.simpleAlert(title: "Error", msg: "\(error.localizedDescription)")
        //                completion(STPPaymentStatus.error, error)
        //                return
        //            }
        //
        //            //If Payment success
        //            StripeCart.clearCart()
        //            self.tableView.reloadData()
        //            self.setupPaymentInfo()
        //            completion(.success,nil)
        //        }
        
        //For FPX
        let data : [String: Any] = [
            "total" : StripeCart.total,
            "customerId" : UserService.user.stripeId,
           // "idempotency" : idempotency
            
        ]
        
        Functions.functions().httpsCallable("createFpxCharge").call(data) { (result, error) in
            //If error happen
            if let error = error {
                debugPrint(error.localizedDescription)
                self.simpleAlert(title: "Error", msg: "\(error.localizedDescription)")
                print("Cannot create Payment Intent")
                completion(STPPaymentStatus.error, error)
                return
            }
            
            guard let clientSecretKey = result?.data as? String else{
                completion(.error,nil)
                return
            }
            //let authContext = AuthContext(viewController: self)
            let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecretKey)
            paymentIntentParams.configure(with: paymentResult)
            paymentIntentParams.returnURL = "payments-example://stripe-redirect"
 
            
            
            STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: paymentContext) { status, paymentIntent, error in
                
                print("Haha it here")
               
                
                switch status {
                case .succeeded:
                    
                    // Our example backend asynchronously fulfills the customer's order via webhook
                    // See https://stripe.com/docs/payments/payment-intents/ios#fulfillment
                   
                   // print(successPaymentIntent)
                    completion(.success, nil)
                    print("It success")
                case .failed:
                    completion(.error, error)
                    print("It fail")
                case .canceled:
                    completion(.userCancellation, nil)
                    print("It canceled")
                    
                @unknown default:
                    completion(.error, nil)
                    print("It unknown error")
                    
                }
            }
            
            
        }
        
        
        
    }
    //MARK: Step 2: Which is the cloud function sending the information to stripe, write in javascript with VsCode
    
    //MARK: Step 3:Function for when the payment is complete, stripe server will send the payment status here whether successful or not
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
        let title: String
        let message: String
        
        activityIndicator.stopAnimating()
        
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            title = "Payment Success"
            message = "Thank you for your purchase."
        case .userCancellation:
            return
        @unknown default:
            title = "Error"
            message = error?.localizedDescription ?? ""
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //Function to include the delivery courier
    //    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
    //
    //        let selfPickup = PKShippingMethod()
    //        selfPickup.amount = 0
    //        selfPickup.label = "Self Pick-up"
    //        selfPickup.detail = "Pickup hour:\nMon-Fri : 8:00AM - 6:00PM\nSat-Sun : 10:00AM - 4:00PM"
    //        selfPickup.identifier = "self_pickup"
    //
    //        let lalamove = PKShippingMethod()
    //        lalamove.amount = 8.90
    //        lalamove.label = "Lalamove"
    //        lalamove.detail = "Arrive in 1-2 days"
    //        lalamove.identifier = "lalamove"
    //
    //        if address.country == "MY" {
    //            completion(.valid, nil, [selfPickup, lalamove], lalamove)
    //        }
    //        else {
    //            completion(.invalid, nil, nil, nil)
    //        }
    //
    //    }
    
    
}

extension CheckoutVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.CartItemCell, for: indexPath) as? CartItemCell {
            
            let item = StripeCart.cartItems[indexPath.row]
            cell.configureCell(item: item, delegate: self)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
