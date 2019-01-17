//
//  LessonService.swift
//  keystone
//
//  Created by Sarika on 17/01/19.
//  Copyright © 2019 Sarika All rights reserved.
//

import Foundation
import CoreData

enum LessonType : String{
    case ski,snowboard
}

typealias StudentHandler = (Bool,[Student])->() //we are passing Student array so that tableview will be refreshed with new passed Student array
class LessonService {
    private let context : NSManagedObjectContext
    private var students = [Student]()
    
    init(context : NSManagedObjectContext) {
        self.context = context
    }
    
    //MARK : Read
    func getAllStudent() -> [Student]?{ //optional because if there is no students we return nil value
        let sortByLesson = NSSortDescriptor(key: "studenttolesson.type", ascending: true)
        let sortByName = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptor = [sortByLesson,sortByName]
        let request : NSFetchRequest<Student> = Student.fetchRequest()
        request.sortDescriptors  = sortDescriptor
        
        do {
             students = try context.fetch(request)
             return students
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    //MARK : Add
    func addStudent(name : String, for type: LessonType, completion : StudentHandler){ //handler because after we press add button in alert we need to notify out table that student has beed added and tableview needs to be refreshed
        let student = Student(context: context)
        student.name = name
        
        if let lesson = lessonExist(type){
            register(student, for: lesson)
            students.append(student)
            completion(true,students)
        }
        save()
    }
    
    //MARK : Delete
    func deleteStudent(student: Student)  {
        let lesson = student.studenttolesson
        students = students.filter{($0 != student)}
        lesson?.removeFromLessontostudents(student)
        context.delete(student)
        save()
    }
    
    //MARK : Private
    private func lessonExist(_ type:LessonType) -> Lesson?{
        let request : NSFetchRequest<Lesson> = Lesson.fetchRequest()
        request.predicate = NSPredicate(format: "type = %@", type.rawValue)
        var lesson : Lesson?
        
        do {
            let result = try context.fetch(request) // result will be array of fetch request
            lesson = result.isEmpty ? addNewLesson(lesson: type) : result.first
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return lesson
    }
    
    private func addNewLesson(lesson type : LessonType) -> Lesson{
        let lesson = Lesson(context: context)
        lesson.type = type.rawValue
        return lesson
    }
    
    private func register(_ student : Student, for lesson : Lesson){
       student.studenttolesson = lesson
    }
    
    private func save()
    {
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
