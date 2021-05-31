//
//  BindCardViewController.swift
//  SDKExampleSwift
//
//  Created by Guilherme Rambo on 04/05/21.
//

import UIKit
import Tuna

final class BindCardViewController: UIViewController {
    
    @IBOutlet weak var bindButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var cvvField: UITextField! {
        didSet {
            cvvField?.delegate = self
            cvvField?.addTarget(self, action: #selector(cvvFieldChanged), for: .editingChanged)
        }
    }
    
    var card: TunaCard? {
        didSet {
            guard isViewLoaded else { return }
            
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindButton.isEnabled = false
        updateUI()
    }
    
    private func updateUI() {
        title = card?.maskedNumber ?? "Bind Card"
    }
    
    @IBAction func performBind(_ sender: UIButton) {
        guard let card = card else { return }
        
        spinner.startAnimating()
        sender.isHidden = true
        
        TunaSDK.bindCard(card, cvv: cvvField.text ?? "") { [weak self] result in
            guard let self = self else { return }
            
            defer { self.stopLoading() }
            
            switch result {
            case .success(let bindedCard):
                print(bindedCard)
                self.bindButton.setTitle("Binded Successfully!", for: .disabled)
                self.bindButton.isEnabled = false
            case .failure(let error):
                print(String(describing: error))
                let alert = UIAlertController(title: "Bind Failed", message: String(describing: error), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func stopLoading() {
        spinner.stopAnimating()
        bindButton.isHidden = false
    }
    
}

extension BindCardViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performBind(bindButton)
        return true
    }
    
    @objc private func cvvFieldChanged(_ field: UITextField) {
        bindButton.isEnabled = (field.text ?? "").count >= 3
    }
    
}
