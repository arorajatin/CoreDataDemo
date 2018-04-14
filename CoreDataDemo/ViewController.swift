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
    case prefetch
    case findOrFetch
    case compoundIndex
    
    case _count
    
}

final class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let moc: NSManagedObjectContext
    var object: NSManagedObject?
    
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
        case .prefetch:
            cell.textLabel?.text = "Prefetch"
        case .findOrFetch:
            cell.textLabel?.text = "Find or Fetch (Performance)"
        case .compoundIndex:
            cell.textLabel?.text = "Compound Indexes"
        case ._count:
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
        case .prefetch:
            self.prefetchTest()
        case .findOrFetch:
            self.findOrFetchTest()
        case .compoundIndex:
            self.compoundIndexTest()
        case ._count:
            fatalError()
        }
        
    }
    
    func injectObjects() {
        
        var amazing = false
        
        for i in 0..<100 {

            if let department = NSEntityDescription.insertNewObject(forEntityName: "Department", into: moc) as?
                Department {
                department.name = "D" + "\(i)"
                
                for j in 0..<100 {
                    
                    if let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: moc) as?
                        Employee {
                        
                        employee.name = "Emp" + "\(i)" + "\(j)"
                        amazing = !amazing
                        employee.amazing = amazing
                        employee.score = Int64(random())
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
        
        let fetchRequest = NSFetchRequest<Department>(entityName: "Department")
        fetchRequest.predicate = NSPredicate(format: "name = %@", "D1")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchLimit = 1
        
        if let departments = try? self.moc.fetch(fetchRequest) {
            let department = departments[0]
            print("\(department.name)")
            print("")
            print("\(department.employees?.count ?? 0)")
            print("")
            
            if let employees = department.employees as? Set<Employee> {
                for employee in employees {
                    print("\(employee.objectID)")
                    print("\(employee.name)")
                }
            }
        }
        
    }
    
    func prefetchTest() {
        //Pre-fetch the object
        
        object = Employee.fetch(in: self.moc) { (request) in
            request.predicate = NSPredicate(format: "name = %@", "Emp990")
            request.returnsObjectsAsFaults = false
        }?.first
        print("")
    }
    
    func findOrFetchTest() {
        //If you know your object graph, then use the findOrFetch method
        let predicate = NSPredicate(format: "name = %@", "Emp990")
        
        _ = Employee.fetch(in: self.moc) { (request) in
            request.predicate = predicate
            request.returnsObjectsAsFaults = false
        }

        print("")
        
//        if let employee = Employee.findOrFetch(in: self.moc, matching: predicate) {
//            print("\(employee.name)")
//        }
    }
    
    func compoundIndexTest() {
        let _ = Employee.fetch(in: self.moc) { request in
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Employee.amazing), ascending: true),
            NSSortDescriptor(key: #keyPath(Employee.score), ascending: true)]
        }
        
        print("")
    }
    
    func random() -> Int {
        let lower : UInt32 = 0
        let upper : UInt32 = 100
        return Int(arc4random_uniform(upper - lower) + lower)
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


