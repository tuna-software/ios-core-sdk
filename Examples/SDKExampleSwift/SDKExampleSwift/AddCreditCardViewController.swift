//
//  AddCreditCardViewController.swift
//  SDKExampleSwift
//
//  Created by Guilherme Rambo on 08/04/21.
//

import UIKit
import Tuna

final class AddCreditCardViewController: UITableViewController, UIAdaptivePresentationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var expirationField: UITextField!
    @IBOutlet weak var saveSwitch: UISwitch!
    
    @IBOutlet weak var cancelButtonItem: UIBarButtonItem!
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.presentationController?.delegate = self
    }
    
    @IBAction func cancel(_ sender: Any?) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func setFormEnabled(_ enabled: Bool) {
        nameField.isEnabled = enabled
        numberField.isEnabled = enabled
        expirationField.isEnabled = enabled
        doneButtonItem.isEnabled = enabled
        cancelButtonItem.isEnabled = enabled
    }
    
    @IBAction func done(_ sender: Any?) {
        guard let name = nameField.text, let number = numberField.text, let expiration = expirationField.text else { return }
        guard !name.isEmpty, !number.isEmpty, !expiration.isEmpty else {
            UIAlertController.show(message: "Please fill in all the fields.", from: self)
            return
        }
        
        let expirationComponents = expiration.components(separatedBy: "/")
        
        guard expirationComponents.count == 2,
              expirationComponents[0].count == 2,
              expirationComponents[1].count == 4,
              let expirationMonth = Int(expirationComponents[0]),
              let expirationYear = Int(expirationComponents[1])
        else {
            UIAlertController.show(message: "Please enter an expiration date in the format MM/YYYY.", from: self)
            return
        }
        
        setFormEnabled(false)

        TunaSDK.addNewCard(
            number: number,
            cardHolderName: name,
            expirationMonth: expirationMonth,
            expirationYear: expirationYear,
            save: saveSwitch.isOn
        ) { [weak self] result in
            guard let self = self else { return }
            defer { self.setFormEnabled(true) }
            
            switch result {
            
            case .success(let newCard):
                NotificationCenter.default.post(name: .reloadCards, object: nil)
                print(newCard)
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            case .failure(let error):
                UIAlertController.show(message: "Failed to add card: \(String(describing: error))", from: self)
            }
        }
    }
    
    var hasEnteredAnyData: Bool { !nameField.text.isNilOrEmpty || !numberField.text.isNilOrEmpty || !expirationField.text.isNilOrEmpty }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool { !hasEnteredAnyData }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "Close Form", message: "Are you sure you want to cancel adding this new card?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Close", style: .destructive, handler: { [weak self] _ in
            self?.cancel(nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
}


extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        guard let unwrapped = self else { return true }
        return unwrapped.isEmpty
    }
}
