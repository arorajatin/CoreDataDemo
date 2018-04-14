//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Jatin on 13/04/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import UIKit
import CoreData

enum Section: Int {
    
    case injectObjects
    case fetchRequest
    case faults
    case performance
    
    case _count
    
}

final class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let moc: NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        moc = PersistenceController.shared.persistentContainer.viewContext
        super.init(coder: aDecoder)
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = Section(rawValue: indexPath.row) else {
            fatalError()
        }
        
        switch section {
        case .injectObjects:
            self.injectObjects()
        case .fetchRequest:
            self.fetchRequestTest()
        case .faults:
            self.faultsTest()
        case .performance:
            self.performanceTest()
        default:
            print("")
        }
        
    }
    
    func injectObjects() {
        
        for i in 0..<100 {

            if let department = NSEntityDescription.insertNewObject(forEntityName: "Department", into: moc) as?
                Department {
                department.name = "D" + "\(i)"
                
                for j in 0..<100 {
                    
                    if let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: moc) as?
                        Employee {
                        
                        employee.name = "Emp" + "\(i)" + "\(j)"
                        department.addToEmployees(employee)
                    }
                    
                }
                
            }
        }
        
        try? moc.save()
    }
    
    func fetchRequestTest() {
        
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        fetchRequest.predicate = NSPredicate(format: "department.name = %@", "D1")
        fetchRequest.returnsObjectsAsFaults = true
        
        if let employees = try? self.moc.fetch(fetchRequest) {
            print("Employees = \(String(describing: employees))")
            
            for employee in employees {
                print("")
                print("\(employee.name)")
            }
        }
        
    }
    
    func faultsTest() {
        
    }
    
    func performanceTest() {
        
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


