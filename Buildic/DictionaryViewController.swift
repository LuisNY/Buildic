//
//  ViewController.swift
//  Buildic
//
//  Created by Luigi Pepe on 2/14/17.
//  Copyright © 2017 Luigi Pepe. All rights reserved.
//

import UIKit
import CoreData

class DictionaryViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    


    var mainView: DictionariesView!
    
    
    var newDictionaryView: NewDictionaryView!
    
    var dictionaryModel = DictionaryModel()
    
    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView = DictionariesView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        self.view = self.mainView
        
        
        self.mainView.dictionaryTableView.delegate      =   self
        self.mainView.dictionaryTableView.dataSource    =   self
        
        
        
        
        
        
        navigationController?.visibleViewController?.title = "Dictionaries"
        navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.blue,
             NSFontAttributeName: UIFont(name: "TimesNewRomanPSMT", size: 20)! ]
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        
        self.newDictionaryView = NewDictionaryView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        
        self.newDictionaryView.doneButton.addTarget(self, action: #selector(doneNewDictionaryView), for: .touchUpInside)
        self.newDictionaryView.cancelButton.addTarget(self, action: #selector(cancelNewDictionaryView), for: .touchUpInside)
        self.newDictionaryView.langTextField.delegate = self
        
        self.newDictionaryView.langTextField.returnKeyType = .done
        self.newDictionaryView.langTextField.enablesReturnKeyAutomatically = true
        

        navigationController?.visibleViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewDictionaryViewAction))
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.fetchDictionary()
        print(self.dictionaryModel.languages)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dictionaryModel.myDictionaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dictionaryCell") as! DictionaryCell
        cell.cellLabel.text = self.dictionaryModel.myDictionaryList[indexPath.row].name
        cell.cellLabel.textColor = UIColor.blue
        cell.cellLabel.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        let destinationVC = WordsViewController(nibName: nil, bundle: nil)
        destinationVC.wordsModel.languages = self.dictionaryModel.languages
        destinationVC.wordsModel.tabActive = "All"
        destinationVC.wordsModel.allDictionaries = self.dictionaryModel.myDictionaryList
        destinationVC.wordsModel.selectedDictionary = self.dictionaryModel.myDictionaryList[indexPath.row]
        destinationVC.wordsModel.currentLanguage = self.dictionaryModel.languages[indexPath.row]
        navigationController?.pushViewController(destinationVC, animated: true)
        self.mainView.dictionaryTableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    
    
    func addNewDictionaryViewAction() {
        DispatchQueue.main.async {
            self.view.addSubview(self.newDictionaryView)
        }
    }
    
    func cancelNewDictionaryView() {
        DispatchQueue.main.async {
            self.newDictionaryView.removeFromSuperview()
        }
    }
    
    func doneNewDictionaryView() {
        
        
        self.dictionaryModel.newLanguage = self.newDictionaryView.langTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.dictionaryModel.newLanguage != nil && self.dictionaryModel.newLanguage != ""  {
            
            let fullName = self.dictionaryModel.newLanguage!
            
            DispatchQueue.main.async {
                self.newDictionaryView.removeFromSuperview()
            }
            
            self.createNewDictionary(fullName: fullName)
            
            self.newDictionaryView.langTextField.resignFirstResponder()
            
            self.newDictionaryView.langTextField.text = ""
            
            self.view.endEditing(true)
        }
            
        else {
            
            let str = "Please enter a new language"
            let alert = UIAlertController(title: "New Dictionary", message: str, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in }
            
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    
    
    func createNewDictionary(fullName: String) {
        
        
        let moc = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        let request: NSFetchRequest<Dictionary> = Dictionary.fetchRequest() as! NSFetchRequest<Dictionary>
        var result : [Dictionary]!
        
        var predicates = [NSPredicate]()
        let predicate1 = NSPredicate(format: "name == %@", fullName)
        
        predicates.append(predicate1)
        
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.predicate = compound
        
        do {
            result = try moc?.fetch(request)
        } catch { // error stuff}
        }

        if result.isEmpty == false {
            
            navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[0].isEnabled = true
            let alert = UIAlertController(title: "Dictionary already exists", message: "Please enter a new language", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in }
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
        
        
        else {
            let newItem = Dictionary.createInManagedObjectContext(self.managedObjectContext!, name: fullName)
            
            self.fetchDictionary()
            
            if let newItemIndex = self.dictionaryModel.myDictionaryList.index(of: newItem) {
                
                // Create an NSIndexPath from the newItemIndex
                let newItemIndexPath = NSIndexPath(row: newItemIndex, section: 0)
                // Animate in the insertion of this row
                self.mainView.dictionaryTableView.insertRows(at: [newItemIndexPath as IndexPath], with: .automatic)
            }
            
            do {
                try managedObjectContext!.save()
                //self.dictionaryModel.languages.append(fullName)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            DispatchQueue.main.async {
                self.mainView.dictionaryTableView.reloadData()
            }
        }
    }
    
    func fetchDictionary() {
        
        let moc = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext //NSManagedObjectContext!
        let request: NSFetchRequest<Dictionary> = Dictionary.fetchRequest() as! NSFetchRequest<Dictionary>

        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        var results : [Dictionary]!
        
        do {
            results = try moc?.fetch(request)
            self.dictionaryModel.myDictionaryList = results
            
            self.dictionaryModel.languages = []
            
            for i in 0..<self.dictionaryModel.myDictionaryList.count {

                self.dictionaryModel.languages.append(self.dictionaryModel.myDictionaryList[i].name!)
            }
        } catch { // error stuff}
        }
        
        DispatchQueue.main.async {
            self.mainView.dictionaryTableView.reloadData()
        }
    }

}

