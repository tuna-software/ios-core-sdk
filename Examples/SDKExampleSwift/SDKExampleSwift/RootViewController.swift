//
//  RootViewController.swift
//  SDKExampleSwift
//
//  Created by Guilherme Rambo on 24/03/21.
//

import UIKit
import Tuna

final class RootViewController: UIViewController {

    @IBOutlet weak var customerIDField: UITextField!
    @IBOutlet weak var customerEmailField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerIDField.text = previousCustomerID
        customerEmailField.text = previousCustomerEmail
    }
    
    private var previousCustomerID: String? {
        // Note: do not use UserDefaults to store sensitive data in production apps,
        // this is being done here only for convenience when using the sample app.
        get { UserDefaults.standard.string(forKey: #function) }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
            UserDefaults.standard.synchronize()
        }
    }
    
    private var previousCustomerEmail: String? {
        // Note: do not use UserDefaults to store sensitive data in production apps,
        // this is being done here only for convenience when using the sample app.
        get { UserDefaults.standard.string(forKey: #function) }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
            UserDefaults.standard.synchronize()
        }
    }

    @IBAction func startCheckout(_ sender: Any) {
        spinner.startAnimating()
        
        guard let customerID = customerIDField.text,
              !customerID.isEmpty,
              let customerEmail = customerEmailField.text,
              !customerEmail.isEmpty
        else {
            let alert = UIAlertController(title: "Missing Information", message: "Please enter the customer's ID and e-mail address.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        previousCustomerID = customerID
        previousCustomerEmail = customerEmail
        
        (sender as? UIButton)?.isHidden = true
        
        /*
         Start a new Tuna session. Keep in mind that the startSession method should only be used in the sandbox environment for
         testing. When running in the production environment, a session ID must be generated in your backend and sent back
         to the app. Please refer to the SDK documentation for more details.
         */
        
        TunaSDK.startSession(customerId: customerID, customerEmail: customerEmail) { [weak self] error in
            // `error` will be `nil` if the session has been started successfully
            guard let self = self else { return }
            
            self.spinner.stopAnimating()
            (sender as? UIButton)?.isHidden = false
            
            self.performSegue(withIdentifier: "checkout", sender: sender)
        }
    }
    

}

