//
//  FaqsViewController.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit
import Firebase 

class FaqsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var Faqs: [FAQ] = []
    var selectedFaq = FAQ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        loadFaqs()
    }
    
    func loadFaqs() {
        self.Faqs = []
        FAQ.getAll() { (faqs) in
            self.Faqs = faqs
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFaq" {
            let destination = segue.destination as! FaqViewController
            destination.Faq = self.selectedFaq
        }
    }
}


extension FaqsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Faqs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "faqCell", for: indexPath)
        cell.textLabel?.text = Faqs[indexPath.row].question
        cell.detailTextLabel?.text = Faqs[indexPath.row].topic
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFaq = Faqs[indexPath.row]
        performSegue(withIdentifier: "showFaq", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
