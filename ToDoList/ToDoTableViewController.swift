//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Itzcoatl Torres on 12/05/24.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
    
    var toDos = [ToDo]() {
        didSet {
            ToDo.saveToDos(toDos)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        toDos = ToDo.loadToDos() ?? ToDo.loadSampleToDo()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier", for: indexPath) as? ToDoCell else {
            fatalError("Could not dequeue a cell")
        }
        configureCell(cell, at: indexPath)
        return cell
    }

    private func configureCell(_ cell: ToDoCell, at indexPath: IndexPath) {
        let todo = toDos[indexPath.row]
        cell.delegate = self
        cell.titleLabel?.text = todo.title
        cell.isCompleteButton.isSelected = todo.isComplete
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            guard let todoViewController = segue.destination as? AddToDoViewController,
                  let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            todoViewController.todo = toDos[indexPath.row]
        }
    }

    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = toDos[indexPath.row]
            todo.isComplete = !todo.isComplete
            toDos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind", let sourceViewController = segue.source as? AddToDoViewController, let todo = sourceViewController.todo else { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            toDos[selectedIndexPath.row] = todo
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let newIndexPath = IndexPath(row: toDos.count, section: 0)
            toDos.append(todo)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}
