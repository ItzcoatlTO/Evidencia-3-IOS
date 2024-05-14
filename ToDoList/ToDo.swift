//
//  ToDo.swift
//  ToDoList
//
//  Created by Itzcoatl Torres on 12/05/24.
//
import Foundation

struct ToDo: Equatable, Codable {
    let id: UUID
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    init(id: UUID? = nil, title: String, isComplete: Bool, dueDate: Date, notes: String? = nil) {
        self.id = id ?? UUID()
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
    }

    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
    
    static func loadToDos() -> [ToDo]? {
        guard let codedToDos = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self, from: codedToDos)
    }
    
    static func saveToDos(_ todos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        if let codedToDos = try? propertyListEncoder.encode(todos) {
            try? codedToDos.write(to: archiveURL, options: .noFileProtection)
        }
    }
    
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    static func loadSampleToDo() -> [ToDo] {
        let todo1 = ToDo(id: UUID(), title: "Avance 2 de Evidencia CDV", isComplete: false, dueDate: Date(), notes: "Hay que ir a presentar la evidencia")
        let todo2 = ToDo(id: UUID(), title: "Evidencia 3 IOS", isComplete: false, dueDate: Date(), notes: "Se sube en Github")
        let todo3 = ToDo(id: UUID(), title: "Evidencia 3 Ética", isComplete: false, dueDate: Date(), notes: "Hay que ir a presentar la evidencia")
        return [todo1, todo2, todo3]
    }
}
