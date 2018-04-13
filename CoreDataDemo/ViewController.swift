//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Jatin on 13/04/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import UIKit

enum Section: Int {
    
    case injectObjects
    case fetchRequest
    case faults
    case performance
    
    case _count
    
}

final class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let section = Section(rawValue: indexPath.row) else {
            fatalError()
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        switch section {
        case .injectObjects:
            cell.textLabel?.text = "Insert Objects"
        case .fetchRequest:
            cell.textLabel?.text = "Fetch Request"
        case .faults:
            cell.textLabel?.text = "Faults"
        case .performance:
            cell.textLabel?.text = "Performance"
        default:
            fatalError()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section._count.rawValue
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}


