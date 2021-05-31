//
//  CreditCardsViewController.swift
//  SDKExampleSwift
//
//  Created by Guilherme Rambo on 08/04/21.
//

import UIKit
import Tuna

extension Notification.Name {
    static let reloadCards = Notification.Name("ReloadCards")
}

final class CreditCardsViewController: UITableViewController {
    
    private var isLoading = false {
        didSet {
            guard isLoading != oldValue else { return }
            tableView.reloadData()
        }
    }
    
    private var cards: [TunaCard] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: .reloadCards, object: nil, queue: .main) { [weak self] _ in
            self?.loadCards()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Select Card"
        
        loadCards()
    }
    
    func loadCards() {
        isLoading = true
        
        TunaSDK.shared.sessionManager.fetchCards { [weak self] result in
            guard let self = self else { return }
            defer { self.isLoading = false }
            
            switch result {
            case .failure(let error):
                UIAlertController.show(message: "Failed to fetch cards: \(String(describing: error))", from: self)
            case .success(let cards):
                self.cards = cards
            }
        }
    }
    
    @IBAction func addCreditCard(_ sender: UIBarButtonItem) {
        guard let nav = storyboard?.instantiateViewController(identifier: "AddCreditCard") as? UINavigationController else { return }
        present(nav, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isLoading ? 1 : cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if isLoading {
            cell.textLabel?.text = "Loading..."
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = cards[indexPath.row].maskedNumber
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    private var selectedCard: TunaCard? {
        guard let index = tableView.indexPathForSelectedRow?.row else { return nil }
        return cards[index]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let bindController = segue.destination as? BindCardViewController else { return }
        guard let card = selectedCard else { fatalError() }
        
        bindController.card = card
    }
    
}

extension UIAlertController {
    static func show(title: String = "Error", message: String, from presenter: UIViewController, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        presenter.present(alert, animated: true, completion: completion)
    }
}
