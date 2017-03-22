//
//  WordsViewController.swift
//  Buildic
//
//  Created by Luigi Pepe on 2/15/17.
//  Copyright © 2017 Luigi Pepe. All rights reserved.
//

import UIKit
import CoreData



class WordsViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    var wordsView: WordsView!
    var newWordView: NewWordView!
    var wordsModel = WordsModel()
    
    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wordsView = WordsView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        self.view = self.wordsView
        
        
        self.wordsView.wordsTableView.delegate      =   self
        self.wordsView.wordsTableView.dataSource    =   self
        
        
        
        self.wordsView.allButton.setTitleColor(UIColor.red, for: .normal)
        self.wordsView.allButton.addTarget(self, action: #selector(self.allTabAction), for: .touchUpInside)
        self.wordsView.nounsButton.addTarget(self, action: #selector(self.nounsTabAction), for: .touchUpInside)
        self.wordsView.verbsButton.addTarget(self, action: #selector(self.verbsTabAction), for: .touchUpInside)
        self.wordsView.adverbsButton.addTarget(self, action: #selector(self.adverbsTabAction), for: .touchUpInside)
        self.wordsView.adjectivesButton.addTarget(self, action: #selector(self.adjectivesTabAction), for: .touchUpInside)
        self.wordsView.restButton.addTarget(self, action: #selector(self.restTabAction), for: .touchUpInside)
        
        self.wordsView.searchBar.delegate = self
        
        self.setKindValue("Nouns")
        
        
        self.newWordView = NewWordView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        self.newWordView.whatLanguageLabel.text = self.wordsModel.currentLanguage
        self.newWordView.cancelButton.addTarget(self, action: #selector(hideInputWordView), for: .touchUpInside)
        self.newWordView.doneButton.addTarget(self, action: #selector(doneAddingWord), for: .touchUpInside)
        
        self.newWordView.nounsButton.addTarget(self, action: #selector(nounSelectButton), for: .touchUpInside)
        self.newWordView.adjectivesButton.addTarget(self, action: #selector(adjectiveSelectButton), for: .touchUpInside)
        self.newWordView.verbsButton.addTarget(self, action: #selector(verbSelectButton), for: .touchUpInside)
        self.newWordView.adverbsButton.addTarget(self, action: #selector(adverbSelectButton), for: .touchUpInside)
        self.newWordView.restButton.addTarget(self, action: #selector(restSelectButton), for: .touchUpInside)
        
        let barButtonItem1 =  UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(confirmDeleteDictionary))
        barButtonItem1.isEnabled = true
        let barButtonItem2 =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showInputWordView))
        barButtonItem2.isEnabled = true
        self.navigationController?.visibleViewController?.navigationItem.rightBarButtonItems = [barButtonItem1, barButtonItem2]
        
        navigationController?.visibleViewController?.navigationItem.title = self.wordsModel.currentLanguage
       
        
        
        self.newWordView.wordTextField.delegate = self
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.fetchTypeWord(self.wordsModel.currentLanguage!, type: self.wordsModel.tabActive!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wordsModel.myWordsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell") as! WordsCell
        cell.cellLabel.text = self.wordsModel.myWordsList[indexPath.row].word
        cell.cellLabel.textColor = UIColor.blue
        cell.cellLabel.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        let destinationVC = TranslationsViewControler(nibName: nil, bundle: nil)
        
        let indexPath = tableView.indexPathForSelectedRow!
        
        destinationVC.translationsModel.myWord = self.wordsModel.myWordsList[(indexPath as NSIndexPath).row].word
        destinationVC.translationsModel.currentLanguage = self.wordsModel.currentLanguage
        destinationVC.translationsModel.languages = self.wordsModel.languages
        destinationVC.translationsModel.myKind = self.wordsModel.myWordsList[(indexPath as NSIndexPath).row].kind
        destinationVC.translationsModel.word = self.wordsModel.myWordsList[(indexPath as NSIndexPath).row]
        destinationVC.translationsModel.textFieldContentsKey = self.wordsModel.myWordsList[(indexPath as NSIndexPath).row].word
        destinationVC.translationsModel.allDictionaries = self.wordsModel.allDictionaries
        destinationVC.translationsModel.tabActive = self.wordsModel.tabActive
        self.wordsView.searchBar.endEditing(true)
        self.wordsView.searchBar.text = ""
        self.wordsView.searchBar.showsCancelButton = false
        
        navigationController?.pushViewController(destinationVC, animated: true)
        self.wordsView.wordsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete ) {
            
            let word = self.wordsModel.myWordsList[(indexPath as NSIndexPath).row].word
            let kind = self.wordsModel.myWordsList[(indexPath as NSIndexPath).row].kind
            let request: NSFetchRequest<Word> = Word.fetchRequest() as! NSFetchRequest<Word>
            
            var predicates = [NSPredicate]()
            let predicate1 = NSPredicate(format: "word == %@", word!)
            let predicate2 = NSPredicate(format: "kind == %@", kind!)
            
            predicates.append(predicate1)
            predicates.append(predicate2)
            
            let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            request.predicate = compound
            
            let deleteRequest =  NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
            
            do {
                // Execute Batch Request
                try self.managedObjectContext!.execute(deleteRequest)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            self.fetchTypeWord(self.wordsModel.currentLanguage!, type: self.wordsModel.tabActive!)
            
            do {
                try self.managedObjectContext!.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            DispatchQueue.main.async {
                self.wordsView.wordsTableView.reloadData()
            }
        }
    }
    
    
    func confirmDeleteDictionary() {
        let alert = UIAlertController(title: "Dedete Dictionary", message: "Do you really want to delete this dictionary?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction) in self.deleteDictionary()}
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    
    func deleteDictionary() {
        
        for i in 0..<self.wordsModel.myWordsList.count {
            let request: NSFetchRequest<Word> = Word.fetchRequest() as! NSFetchRequest<Word>
            var predicates = [NSPredicate]()
            let predicate1 = NSPredicate(format: "word == %@", self.wordsModel.myWordsList[i].word!)

            predicates.append(predicate1)
            let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            request.predicate = compound
            
            let deleteRequest =  NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
            
            do {
                // Execute Batch Request
                try self.managedObjectContext!.execute(deleteRequest)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        
        let request: NSFetchRequest<Dictionary> = Dictionary.fetchRequest() as! NSFetchRequest<Dictionary>
        
        var predicates = [NSPredicate]()
        let predicate1 = NSPredicate(format: "name == %@", self.wordsModel.selectedDictionary!.name!)
        predicates.append(predicate1)
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.predicate = compound
        
        let deleteRequest =  NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        
        do {

            try self.managedObjectContext!.execute(deleteRequest)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        navigationController!.popViewController(animated: true)
        
    }
    
    
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        
        
        self.wordsView.allButton.isEnabled = false
        self.wordsView.nounsButton.isEnabled = false
        self.wordsView.adjectivesButton.isEnabled = false
        self.wordsView.verbsButton.isEnabled = false
        self.wordsView.adverbsButton.isEnabled = false
        self.wordsView.restButton.isEnabled = false
        
        navigationController?.navigationBar.isUserInteractionEnabled = false
        
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        self.fetchTypeWord(self.wordsModel.currentLanguage!, type: self.wordsModel.tabActive!)
        
        self.wordsView.allButton.isEnabled = true
        self.wordsView.nounsButton.isEnabled = true
        self.wordsView.adjectivesButton.isEnabled = true
        self.wordsView.verbsButton.isEnabled = true
        self.wordsView.adverbsButton.isEnabled = true
        self.wordsView.restButton.isEnabled = true

        navigationController?.navigationBar.isUserInteractionEnabled = true
        
        
        self.wordsModel.searchActive = false
        DispatchQueue.main.async {
            self.wordsView.wordsTableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.wordsModel.myFileteredWordsList = self.wordsModel.myWordsList.filter({ Word -> Bool in
            let tmp: NSString = Word.word! as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        if self.wordsModel.myFileteredWordsList!.count > 0 {
            
            self.wordsModel.searchActive = true
            self.fetchTypeWord(self.wordsModel.currentLanguage!, type: self.wordsModel.tabActive!, searchActive: true, str: searchText)
            DispatchQueue.main.async {
                self.wordsView.wordsTableView.reloadData()
            }
        }
        else {
            if searchText != "" {
                self.wordsModel.searchActive = true
                self.fetchTypeWord(self.wordsModel.currentLanguage!, type: self.wordsModel.tabActive!, searchActive: true, str: searchText)
                DispatchQueue.main.async {
                    self.wordsView.wordsTableView.reloadData()
                }
            }
            else {
                self.wordsModel.searchActive = true
                self.fetchTypeWord(self.wordsModel.currentLanguage!, type: self.wordsModel.tabActive!, searchActive: false)
                DispatchQueue.main.async {
                    self.wordsView.wordsTableView.reloadData()
                }
            }
        }
    }
    
    
    func fetchTypeWord(_ currentLang: String, type: String = "All", searchActive: Bool = false, str: String = "") {
        
        let moc = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        var results : [Word]!
        let request: NSFetchRequest<Word> = Word.fetchRequest() as! NSFetchRequest<Word>
        
        var predicates = [NSPredicate]()
        let predicate1 = NSPredicate(format: "toDictionary == %@", self.wordsModel.selectedDictionary!)
        let predicate2 = NSPredicate(format: "language == %@", currentLang)
        predicates.append(predicate1)
        predicates.append(predicate2)
        
        if type != "All" {
            let predicate3 = NSPredicate(format: "kind == %@", type)
            predicates.append(predicate3)
        }
        
        if searchActive == true {
            
            let predicate4 = NSPredicate(format:  "word contains[c] %@", str)
            predicates.append(predicate4)
        }
        
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.predicate = compound
        
        let sortDescriptor = NSSortDescriptor(key: "word", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            results = try moc?.fetch(request)
            self.wordsModel.myWordsList = results
        } catch { // error stuff}
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.showsCancelButton = false
        self.wordsView.searchBar.endEditing(true)
    }
    
    func showInputWordView() {
        
        navigationController?.visibleViewController?.navigationItem.hidesBackButton = true
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[0].isEnabled = false
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[1].isEnabled = false
        DispatchQueue.main.async {
            self.view.addSubview(self.newWordView)
        }
    }
    
    func hideInputWordView(){
        navigationController?.visibleViewController?.navigationItem.hidesBackButton = false
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[0].isEnabled = true
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[1].isEnabled = true
        DispatchQueue.main.async {
            self.newWordView.removeFromSuperview()
        }
    }

    
    
    func doneAddingWord() {
        
        let trimmedString = self.newWordView.wordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedString! != "" && self.wordsModel.kind != "" {
            
            self.addNewWord(trimmedString!, language: self.wordsModel.currentLanguage!, kind: self.wordsModel.kind!, dictionary: self.wordsModel.selectedDictionary!)
            
            self.newWordView.wordTextField.resignFirstResponder()
            
            self.newWordView.wordTextField.text = ""
            
            self.view.endEditing(true)
            
            self.hideInputWordView()
        }
            
        else {
            
            let alert = UIAlertController(title: "New Word", message: "Please fill up all fields", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in }
            
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func addNewWord(_ word: String, language: String, kind: String, dictionary: Dictionary) {
        
        let moc = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        let request: NSFetchRequest<Word> = Word.fetchRequest() as! NSFetchRequest<Word>
        var result : [Word]!
        
        var predicates = [NSPredicate]()
        let predicate1 = NSPredicate(format: "toDictionary == %@", self.wordsModel.selectedDictionary!)
        let predicate2 = NSPredicate(format: "word == %@", word)
        let predicate3 = NSPredicate(format: "kind == %@", kind)
        predicates.append(predicate1)
        predicates.append(predicate2)
        predicates.append(predicate3)
        
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.predicate = compound
        
        do {
            result = try moc?.fetch(request)
            print(result)
        } catch { // error stuff}
        }
        
        if result.isEmpty == false {
            
            navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[0].isEnabled = true
            navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[1].isEnabled = true
            let alert = UIAlertController(title: "Word already exists", message: "Please enter a new word", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in }
            
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
        else {
            
            let newItem = Word.createInManagedObjectContext(self.managedObjectContext!, word: word, language: language, kind: kind, dictionary: dictionary)
            
            self.fetchTypeWord(self.wordsModel.currentLanguage!)
            
            if let newItemIndex = self.wordsModel.myWordsList.index(of: newItem) {
                
                let newItemIndexPath = IndexPath(row: newItemIndex, section: 0)
                self.wordsView.wordsTableView.insertRows(at: [newItemIndexPath], with: .automatic)
            }
            
            do {
                try self.managedObjectContext!.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            DispatchQueue.main.async {
               self.wordsView.wordsTableView.reloadData()
            }
        }
    }
    
    
        
    
    
    
    
    func allTabAction(_ sender: UIButton) {
        self.wordsModel.tabActive = "All"
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[0].isEnabled = true
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[1].isEnabled = true
        self.fetchTypeWord(self.wordsModel.currentLanguage!)
        DispatchQueue.main.async {
            self.wordsView.wordsTableView.reloadData()
            self.setColorTypeButtons(0)
        }
    }
    
    
    func nounsTabAction(_ sender: UIButton) {
        self.wordsModel.tabActive = "Nouns"
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[0].isEnabled = false
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[1].isEnabled = false
        self.fetchTypeWord(self.wordsModel.currentLanguage!, type: self.wordsModel.tabActive!)
        DispatchQueue.main.async {
            self.wordsView.wordsTableView.reloadData()
            self.setColorTypeButtons(1)
        }
    }
    
    
    
    
    func verbsTabAction(_ sender: UIButton) {
        self.wordsModel.tabActive = "Verbs"
        //print("tab active ", self.tabActive, " c l ", self.currentLanguage)
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[0].isEnabled = false
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[1].isEnabled = false
        self.fetchTypeWord(self.wordsModel.currentLanguage!, type: self.wordsModel.tabActive!)
        
        DispatchQueue.main.async {
            self.wordsView.wordsTableView.reloadData()
            self.setColorTypeButtons(2)
        }
    }
    
    
    func adjectivesTabAction(_ sender: UIButton) {
        self.wordsModel.tabActive = "Adjectives"
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[0].isEnabled = false
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[1].isEnabled = false
        self.fetchTypeWord(self.wordsModel.currentLanguage!, type: self.wordsModel.tabActive!)
        DispatchQueue.main.async {
            self.wordsView.wordsTableView.reloadData()
            self.setColorTypeButtons(3)
        }
    }
    
    func adverbsTabAction(_ sender: UIButton) {
        self.wordsModel.tabActive = "Adverbs"
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[0].isEnabled = false
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[1].isEnabled = false
        self.fetchTypeWord(self.wordsModel.currentLanguage!, type: self.wordsModel.tabActive!)
        DispatchQueue.main.async {
            self.wordsView.wordsTableView.reloadData()
            self.setColorTypeButtons(4)
        }
    }
    
    
    func restTabAction(_ sender: UIButton) {
        self.wordsModel.tabActive = "Other"
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[0].isEnabled = false
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems?[1].isEnabled = false
        self.fetchTypeWord(self.wordsModel.currentLanguage!, type: self.wordsModel.tabActive!)
        DispatchQueue.main.async {
            self.wordsView.wordsTableView.reloadData()
            self.setColorTypeButtons(5)
        }
    }
    
    
    
    func setColorTypeButtons(_ type: Int) {
        
        self.wordsView.allButton.setTitleColor(UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1), for: UIControlState())
        self.wordsView.nounsButton.setTitleColor(UIColor.blue, for: UIControlState())
        self.wordsView.verbsButton.setTitleColor(UIColor.blue, for: UIControlState())
        self.wordsView.adjectivesButton.setTitleColor(UIColor.blue, for: UIControlState())
        self.wordsView.adverbsButton.setTitleColor(UIColor.blue, for: UIControlState())
        self.wordsView.restButton.setTitleColor(UIColor.blue, for: UIControlState())
        
        switch type {
        case 0:
            self.wordsView.allButton.setTitleColor(UIColor.red, for: UIControlState())
        case 1:
            self.wordsView.nounsButton.setTitleColor(UIColor.red, for: UIControlState())
        case 2:
            self.wordsView.verbsButton.setTitleColor(UIColor.red, for: UIControlState())
        case 3:
            self.wordsView.adjectivesButton.setTitleColor(UIColor.red, for: UIControlState())
        case 4:
            self.wordsView.adverbsButton.setTitleColor(UIColor.red, for: UIControlState())
        case 5:
            self.wordsView.restButton.setTitleColor(UIColor.red, for: UIControlState())
        default:
            self.wordsView.allButton.setTitleColor(UIColor.red, for: UIControlState())
        }
    }
    
    
    func nounSelectButton(_ sender: UIButton) {
        setKindValue("Nouns")
        selectKindWordImageButton(1)
    }
    
    func verbSelectButton(_ sender: AnyObject) {
        setKindValue("Verbs")
        selectKindWordImageButton(2)
    }
    
    func adjectiveSelectButton(_ sender: UIButton) {
        setKindValue("Adjectives")
        selectKindWordImageButton(3)
    }
    
    func adverbSelectButton(_ sender: UIButton) {
        setKindValue("Adverbs")
        selectKindWordImageButton(4)
    }
    
    func restSelectButton(_ sender: UIButton) {
        setKindValue("Other")
        selectKindWordImageButton(5)
    }
    
    
    func setKindValue(_ kind: String) {
        self.wordsModel.kind = kind
    }
    
    
    func selectKindWordImageButton(_ kind: Int) {
        
        self.newWordView.nounsButton.setImage(UIImage(named: "unchecked"), for: UIControlState())
        self.newWordView.verbsButton.setImage(UIImage(named: "unchecked"), for: UIControlState())
        self.newWordView.adjectivesButton.setImage(UIImage(named: "unchecked"), for: UIControlState())
        self.newWordView.adverbsButton.setImage(UIImage(named: "unchecked"), for: UIControlState())
        self.newWordView.restButton.setImage(UIImage(named: "unchecked"), for: UIControlState())
        
        switch kind {
        case 1:
            self.newWordView.nounsButton.setImage(UIImage(named: "checked"), for: UIControlState());
        case 2:
            self.newWordView.verbsButton.setImage(UIImage(named: "checked"), for: UIControlState());
        case 3:
            self.newWordView.adjectivesButton.setImage(UIImage(named: "checked"), for: UIControlState());
        case 4:
            self.newWordView.adverbsButton.setImage(UIImage(named: "checked"), for: UIControlState());
        case 5:
            self.newWordView.restButton.setImage(UIImage(named: "checked"), for: UIControlState());
        default:
            self.newWordView.nounsButton.setImage(UIImage(named: "checked"), for: UIControlState());
        }
    }

    
    
}
