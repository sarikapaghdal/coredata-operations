//
//  LessonTableViewController.swift
//  keystone
//
//  Created by Sarika on 17/01/19.
//  Copyright © 2019 Sarika All rights reserved.
//

import UIKit
import CoreData

class LessonTableViewController: UITableViewController {
    var context: NSManagedObjectContext? {
        didSet{
            if let context = context{
                lessonService = LessonService(context: context)
            }
        }
    }
    
    private var lessonService: LessonService?
    private var studentList = [Student]()
    private var studentToUpdate : Student?
    
    @IBAction func studentpressed(_ sender: UIBarButtonItem) {
        present(alertController(actionType: "Add"), animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudents()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        cell.textLabel?.text = studentList[indexPath.row].name
        cell.detailTextLabel?.text = studentList[indexPath.row].studenttolesson?.type
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            lessonService?.deleteStudent(student: studentList[indexPath.row])
            studentList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        loadStudents()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        studentToUpdate = studentList[indexPath.row]
        present(alertController(actionType: "update"), animated: true, completion: nil)
    }
    
    //MARK : Private
    private func alertController(actionType: String) -> UIAlertController{
        let ac = UIAlertController(title: "Perk Lesson", message: "Student Info", preferredStyle: .alert)
        ac.addTextField { (testField: UITextField) in
            testField.placeholder = "Name"
        }
        ac.addTextField { (testField: UITextField) in
            testField.placeholder = "Lesson type : Ski,snow board"
        }
        let defaultAction = UIAlertAction(title: actionType.uppercased(), style: .default) { [weak self](alertAction) in
            guard let studentName = ac.textFields?[0].text , let lesson = ac.textFields?[1].text else{return}
            if actionType.caseInsensitiveCompare("add") == .orderedSame{
                if let lessonType = LessonType(rawValue: lesson.lowercased()){
                    self?.lessonService?.addStudent(name: studentName, for: lessonType, completion: { (success, students) in
                        if success{
                            self?.studentList = students
                        }
                    })
                }
            }
            else{
                
                guard let name = ac.textFields?.first?.text, !name.isEmpty,
                let studenttoupdate = self?.studentToUpdate,
                let lessonType = ac.textFields?[1].text else{
                    return
                }
                
            }
            DispatchQueue.main.async {
                self?.loadStudents()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in}
        ac.addAction(defaultAction)
        ac.addAction(cancelAction)
        return ac
    }
    
    private func loadStudents(){
        if let student = lessonService?.getAllStudent(){
            studentList = student
            tableView.reloadData()
        }
    }
}
