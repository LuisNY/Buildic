//
//  TranslationsViewControler.swift
//  Buildic
//
//  Created by Luigi Pepe on 2/16/17.
//  Copyright © 2017 Luigi Pepe. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import AVFoundation

class TranslationsViewControler: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate  {

    
    var keyboardHeight: CGFloat = 0.0
    
    var newTranslationView: NewTranslationView!
    var translationsView: TranslationsView!
    var notesView: NotesView!
    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
    var translationsModel = TranslationsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var i:Int = 0
        
        
        if self.translationsModel.languages!.count > 1 {
            while self.translationsModel.languages?[i] == self.translationsModel.currentLanguage {
                i += 1
            }
            self.translationsModel.newTranslationLang = self.translationsModel.languages![i]
            self.translationsModel.visibleLang = self.translationsModel.newTranslationLang
        }
        
        else {
            self.translationsModel.newTranslationLang = ""
            self.translationsModel.visibleLang = ""
        }
        
        
        self.translationsView = TranslationsView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), allLang: self.translationsModel.languages!, currentLang: self.translationsModel.currentLanguage!, visibleLang: self.translationsModel.visibleLang!)
        self.view = self.translationsView
        
        self.translationsView.selectLangButton.addTarget(self, action: #selector(showSelectLangView), for: .touchUpInside)
        if self.translationsModel.visibleLang == "" {
            self.translationsView.selectLangButton.isEnabled = false
        }
        
        self.translationsView.translationsTableView.delegate = self
        self.translationsView.translationsTableView.dataSource = self
        
        self.notesView = NotesView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        self.notesView.notesTextView.delegate = self
        
        self.newTranslationView = NewTranslationView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), allLang: self.translationsModel.languages!, currLang: self.translationsModel.currentLanguage!)
        
        self.newTranslationView.translationTextField.delegate = self
        
        let barButtonItem1 =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewTranslationView))
        let barButtonItem2 =  UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showNotesView))
        if self.translationsModel.languages!.count > 1 {
            barButtonItem1.isEnabled = true
        }
        else {
            barButtonItem1.isEnabled = false
        }
        barButtonItem2.isEnabled = true
        self.navigationController?.visibleViewController?.navigationItem.rightBarButtonItems = [barButtonItem1, barButtonItem2]
        
        var kind : String?
        if self.translationsModel.myKind! == "Other" {
            kind = self.translationsModel.myKind!
        }
        else {
            kind = self.translationsModel.myKind!.substring(to: self.translationsModel.myKind!.index(before: self.translationsModel.myKind!.endIndex))
        }
        
        navigationController?.visibleViewController?.navigationItem.title = self.translationsModel.myWord! + " (" + kind! + ")"

        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        self.newTranslationView.cancelButton.addTarget(self, action: #selector(dismissNewTranslationView), for: .touchUpInside)
        self.newTranslationView.doneButton.addTarget(self, action: #selector(doneAddingTranslation), for: .touchUpInside)
        
        
        self.setupButtonTargets()
        self.setupSelectLanguageTargets()
        self.fetchTranslations(self.translationsModel.visibleLang!, type: self.translationsModel.myKind!)
        
        do {
            try self.translationsModel.recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try self.translationsModel.recordingSession.setActive(true)
            try self.translationsModel.recordingSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            self.translationsModel.recordingSession.requestRecordPermission() { (granted: Bool)-> Void in
                if !granted {
                    return
                }
            }
        } catch {
            return
        }
        
        self.translationsView.playButton.addTarget(self, action: #selector(self.playButtonPressed), for: .touchUpInside)
        self.translationsView.recordButton.addTarget(self, action: #selector(self.recordButtonPressed), for: .touchUpInside)
        self.translationsView.deleteButton.addTarget(self, action: #selector(self.deleteButtonPressed), for: .touchUpInside)
        
        
        self.translationsView.recordingLabel.textColor = UIColor.blue
        self.translationsView.recordingLabel.textAlignment = NSTextAlignment(rawValue: 1)!
        self.translationsModel.audioFileURL = self.getDocumentsDirectory().appendingPathComponent("\(self.translationsModel.myWord!).m4a")
        
        self.translationsView.recordingLabel.text = "Pronunciation of: \(self.translationsModel.myWord!)"
        
        do {
            self.translationsModel.audioPlayer = try AVAudioPlayer(contentsOf: self.translationsModel.audioFileURL)
            self.translationsView.playButton.isEnabled = true
            self.translationsView.recordButton.isEnabled = false
            self.translationsView.deleteButton.isEnabled = true
            
        } catch {
            self.translationsView.playButton.isEnabled = false
            self.translationsView.recordButton.isEnabled = true
            self.translationsView.deleteButton.isEnabled = false
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.translationsModel.myTranslationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "translationCell", for: indexPath) as! TranslationCell
        cell.cellLabel.textAlignment = .center
        cell.cellLabel.textColor = UIColor.blue
        cell.cellLabel.text = self.translationsModel.myTranslationList[indexPath.row].word
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.translationsView.translationsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete ) {
            
            let word = self.translationsModel.myTranslationList[(indexPath as NSIndexPath).row].word
            let kind = self.translationsModel.myTranslationList[(indexPath as NSIndexPath).row].kind
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
            
            self.fetchTranslations(self.translationsModel.visibleLang!, type: self.translationsModel.myKind!)
            
            do {
                try self.managedObjectContext!.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            DispatchQueue.main.async {
                self.translationsView.translationsTableView.reloadData()
            }
        }
    }

    
    
    func repristinateNavBar(){
        
        let barButtonItem1 =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewTranslationView))
        barButtonItem1.isEnabled = true
        let barButtonItem2 =  UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showNotesView))
        barButtonItem2.isEnabled = true
        self.navigationController?.visibleViewController?.navigationItem.rightBarButtonItems = [barButtonItem1, barButtonItem2]
        navigationController?.visibleViewController?.navigationItem.title = self.translationsModel.myWord! + " (" + self.translationsModel.myKind! + ")"
        
        navigationController?.visibleViewController?.navigationItem.hidesBackButton = false
    }
    
    
    
    func showNotesView() {
        navigationController?.visibleViewController?.navigationItem.hidesBackButton = true
        navigationController?.visibleViewController?.navigationItem.title = "Notes"
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems = []
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissNotesView))
        
        self.notesView.notesTextView.text = self.translationsModel.word!.notes
        
        DispatchQueue.main.async {
            self.view.addSubview(self.notesView)
        }
    }
    
    func dismissNotesView() {
        
        
        self.saveNotes()
        
        self.repristinateNavBar()
        
        DispatchQueue.main.async {
            self.notesView.removeFromSuperview()
        }
    }
    
    
    
    
    
    func saveNotes() {
        
        let request: NSFetchRequest<Word> = Word.fetchRequest() as! NSFetchRequest<Word>
        var result : [Word]!
        
        var predicates = [NSPredicate]()
        let predicate1 = NSPredicate(format: "language == %@", self.translationsModel.currentLanguage!)
        let predicate2 = NSPredicate(format: "word == %@", self.translationsModel.myWord!)
        let predicate3 = NSPredicate(format: "kind == %@", self.translationsModel.myKind!)
        predicates.append(predicate1)
        predicates.append(predicate2)
        predicates.append(predicate3)
        
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.predicate = compound
        
        do {
            result = try self.managedObjectContext?.fetch(request)
            
            result[0].notes = self.notesView.notesTextView.text
            print("Results  ", result)
        } catch { print("ERROREEEEE")
        }

        if self.managedObjectContext!.hasChanges {
            
            do {
                try self.managedObjectContext!.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    
    
    func showNewTranslationView() {
        
        navigationController?.visibleViewController?.navigationItem.hidesBackButton = true
        navigationController?.visibleViewController?.navigationItem.title = "New translation"
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems = []

        DispatchQueue.main.async {
            self.view.addSubview(self.newTranslationView)
        }
    }
    
    func dismissNewTranslationView() {
        
        self.repristinateNavBar()
        
        DispatchQueue.main.async {
            self.newTranslationView.removeFromSuperview()
        }
    }
    
    func doneAddingTranslation() {
        
        let trimmedString = self.newTranslationView.translationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if trimmedString! != "" {
            
            for i in 0..<self.translationsModel.allDictionaries!.count {
             
                if self.translationsModel.newTranslationLang == self.translationsModel.allDictionaries![i].name {
                    
                    self.translationsModel.newTranslationDictionary = self.translationsModel.allDictionaries![i]
                }
            }
            
            self.addNewWord(trimmedString!, language: self.translationsModel.newTranslationLang!, kind: self.translationsModel.myKind!, dictionary: self.translationsModel.newTranslationDictionary!)
            
            self.newTranslationView.translationTextField.resignFirstResponder()
            
            self.newTranslationView.translationTextField.text = ""
            
            self.view.endEditing(true)
            
            self.dismissNewTranslationView()
        }
            
        else {
            
            let alert = UIAlertController(title: "New word", message: "Please add new translation", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in }
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func addNewWord(_ word: String, language: String, kind: String, dictionary: Dictionary) {
        
        let request: NSFetchRequest<Word> = Word.fetchRequest() as! NSFetchRequest<Word>
        var result : [Word]!
        
        var predicates = [NSPredicate]()
        let predicate1 = NSPredicate(format: "language == %@", self.translationsModel.newTranslationLang!)
        let predicate2 = NSPredicate(format: "word == %@", word)
        let predicate3 = NSPredicate(format: "kind == %@", kind)
        predicates.append(predicate1)
        predicates.append(predicate2)
        predicates.append(predicate3)
        
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.predicate = compound
        
        do {
            result = try self.managedObjectContext!.fetch(request)
        } catch { print("ERROREEEEE")
        }
        
        if result.isEmpty == false {
            
            result[0].addConnectionTo(self.translationsModel.word!)
            result[0].addConnectionFrom(self.translationsModel.word!)
            self.translationsModel.word!.addConnectionTo(result[0])
            self.translationsModel.word!.addConnectionFrom(result[0])
            
            if self.managedObjectContext!.hasChanges {
                
                do {
                    try self.managedObjectContext!.save()
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }
        
        else {
            
            let newItem = Word.createInManagedObjectContext(self.managedObjectContext!, word: word, language: language, kind: kind, dictionary: dictionary)
            newItem.addConnectionTo(self.translationsModel.word!)
            newItem.addConnectionFrom(self.translationsModel.word!)
            
            self.fetchTranslations(self.translationsModel.currentLanguage!, type: self.translationsModel.myKind!)
            
            if let newItemIndex = self.translationsModel.myTranslationList.index(of: newItem) {
                
                let newItemIndexPath = IndexPath(row: newItemIndex, section: 0)
                self.translationsView.translationsTableView.insertRows(at: [newItemIndexPath], with: .automatic)
            }
            
            if self.managedObjectContext!.hasChanges {
                
                do {
                    try self.managedObjectContext!.save()
                    self.translationsModel.word!.addConnectionTo(newItem)
                    self.translationsModel.word!.addConnectionFrom(newItem)
                    
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        }

        self.fetchTranslations(self.translationsModel.visibleLang!, type: self.translationsModel.myKind!)
    }

    
    func fetchTranslations(_ visibleLang: String, type: String) {
        
        let moc = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        var results : [Word]!
        let request: NSFetchRequest<Word> = Word.fetchRequest() as! NSFetchRequest<Word>
        
        var predicates = [NSPredicate]()
        let predicate1 = NSPredicate(format: "ANY toOtherWord == %@", self.translationsModel.word!)
        let predicate2 = NSPredicate(format: "language == %@", visibleLang)
        let predicate3 = NSPredicate(format: "kind == %@", type)
        predicates.append(predicate1)
        predicates.append(predicate2)
        predicates.append(predicate3)
        
        
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.predicate = compound
        
        
        let sortDescriptor = NSSortDescriptor(key: "word", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            results = try moc?.fetch(request)
            self.translationsModel.myTranslationList = results
            DispatchQueue.main.async {
                self.translationsView.translationsTableView.reloadData()
            }
        } catch { // error stuff}
        }
    }

    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
        
      
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        self.notesView.notesTextView.becomeFirstResponder()

        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        self.keyboardHeight = keyboardRectangle.height
        self.notesView.notesTextView.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 64 - self.keyboardHeight)
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        self.notesView.notesTextView.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 64)
        
        
        self.notesView.notesTextView.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    
    
    

    
    
    func setupButtonTargets() {
        
        for i in 0..<self.newTranslationView.langButtonSet.count {
            
            self.translationsModel.langButtonIndex = i
            self.newTranslationView.langButtonSet[i].addTarget(self, action: #selector(setupSingleButton), for: .touchUpInside)
        }
    }
    
    
    func setupSingleButton(_ sender: CustomisedButton) {
        
        self.translationsModel.newTranslationLang = self.newTranslationView.langLabelSet[sender.index!].text!
        self.setImageFunction(index: sender.index!)
    }
    
    
    func setImageFunction(index: Int) {
        
        for i in 0..<self.newTranslationView.langButtonSet.count {
            
            self.newTranslationView.langButtonSet[i].setImage(UIImage(named: "unchecked"), for: UIControlState())
            if i == index {
                self.newTranslationView.langButtonSet[i].setImage(UIImage(named: "checked"), for: UIControlState())
            }
        }
    }
    
    func showSelectLangView() {
        self.translationsView.selectLangButton.addTarget(self, action: #selector(dismissSelectLangView), for: .touchUpInside)
        DispatchQueue.main.async {
            self.translationsView.addSubview(self.translationsView.langStackView)
            
            self.translationsView.rightRectangleView.image = UIImage(named: "arrowdown")
            self.translationsView.rightRectangleView.image = self.translationsView.rightRectangleView.image!.withRenderingMode(.alwaysTemplate)
            self.translationsView.rightRectangleView.tintColor = UIColor.blue
            
            self.translationsView.leftRectangleView.image = UIImage(named: "arrowdown")
            self.translationsView.leftRectangleView.image = self.translationsView.leftRectangleView.image!.withRenderingMode(.alwaysTemplate)
            self.translationsView.leftRectangleView.tintColor = UIColor.blue
            
            
            
        }
    }
    
    func dismissSelectLangView() {
        self.translationsView.selectLangButton.addTarget(self, action: #selector(showSelectLangView), for: .touchUpInside)
        DispatchQueue.main.async {
            self.translationsView.langStackView.removeFromSuperview()
            
            self.translationsView.leftRectangleView.image = UIImage(named: "arrowleft")
            self.translationsView.leftRectangleView.image = self.translationsView.leftRectangleView.image!.withRenderingMode(.alwaysTemplate)
            self.translationsView.leftRectangleView.tintColor = UIColor.blue
            
            self.translationsView.rightRectangleView.image = UIImage(named: "arrowright")
            self.translationsView.rightRectangleView.image = self.translationsView.rightRectangleView.image!.withRenderingMode(.alwaysTemplate)
            self.translationsView.rightRectangleView.tintColor = UIColor.blue
        }
    }
    
    func setupSelectLanguageTargets() {
        
        for i in 0..<self.translationsView.langButtonSet.count {
            
            self.translationsView.langButtonSet[i].addTarget(self, action: #selector(setupSelectLangButton), for: .touchUpInside)
        }
    }
 
    func setupSelectLangButton(_ sender: CustomisedButton) {
        
        self.translationsModel.visibleLang = self.translationsView.langButtonSet[sender.index!].title(for: .normal)!
        self.dismissSelectLangView()
        self.self.translationsView.selectLangButton.setTitle(self.translationsModel.visibleLang, for: .normal)
        self.fetchTranslations(self.translationsModel.visibleLang!, type: self.translationsModel.myKind!)
    }
    
    
   
  
    
    func recordButtonPressed() {
        print("record")
        
        DispatchQueue.main.async {
            self.translationsView.countLabel.textColor = UIColor.blue
            self.translationsView.countLabel.text = "\(self.translationsModel.count)"
            self.translationsView.addSubview(self.translationsView.countLabel)
        }
        
        self.startCountdown()
        let mySettings = [ AVFormatIDKey: Int(kAudioFormatAppleLossless),
                        AVSampleRateKey: 8000,
                        AVNumberOfChannelsKey: 1,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue ] as [String: Any]
        
        do {
            self.translationsModel.audioRecorder = try AVAudioRecorder(url: self.translationsModel.audioFileURL, settings: mySettings)
            self.translationsModel.audioRecorder.delegate = self
            self.translationsModel.audioRecorder.record()
            
        } catch {
            self.translationsModel.audioRecorder.stop()
            self.translationsModel.audioRecorder = nil
            self.translationsModel.myTimer.invalidate()
            self.translationsModel.count = 3
            DispatchQueue.main.async {
                self.translationsView.countLabel.removeFromSuperview()
                self.translationsView.countLabel.text = "\(self.translationsModel.count)"
            }
            
        }

        
        
    }
    
    func deleteButtonPressed() {

        let str = "Do you really want to delete this pronunciation?"
        let alert = UIAlertController(title: "Delete pronunciation", message: str, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) -> Void in
            
            let myPath = self.getDocumentsDirectory().appendingPathComponent("\(self.translationsModel.myWord!).m4a")
            print(myPath)
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            let filePath = url.appendingPathComponent("\(self.translationsModel.myWord!).m4a")?.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath!) {
                print("FILE AVAILABLE")
                do {
                    try fileManager.removeItem(atPath: filePath!)
                    self.translationsView.recordButton.isEnabled = true
                    self.translationsView.playButton.isEnabled = false
                    self.translationsView.deleteButton.isEnabled = false
                } catch {
                    let alert = UIAlertController(title: "An error occurred", message: str, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "File not found", message: str, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    
    
    
    func playButtonPressed() {
        print("play")
        print(self.translationsModel.audioFileURL)
        self.translationsView.playButton.isEnabled = false
        self.translationsView.deleteButton.isEnabled = false
        self.translationsModel.audioPlayer = try! AVAudioPlayer(contentsOf: self.translationsModel.audioFileURL)
        self.translationsModel.audioPlayer.delegate = self
        self.translationsModel.audioPlayer.prepareToPlay()
        self.translationsModel.audioPlayer.play()
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {

        self.translationsModel.audioPlayer.stop()
        self.translationsView.playButton.isEnabled = true
        self.translationsView.deleteButton.isEnabled = true
    }
    
    
  
    
    
    
    
    func startCountdown() {
        self.translationsModel.myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCount), userInfo: nil, repeats: true)
        
    }
    
    func updateCount() {
        
        
        if self.translationsModel.count > 0 {
            self.translationsModel.count = self.translationsModel.count - 1
            DispatchQueue.main.async {
                self.translationsView.countLabel.text = "\(self.translationsModel.count)"
            }
        } else if self.translationsModel.count == 0 {
            self.translationsModel.audioRecorder.stop()
            self.translationsModel.audioRecorder = nil
            self.translationsModel.myTimer.invalidate()
            self.translationsModel.count = 3
            DispatchQueue.main.async {
                self.translationsView.countLabel.removeFromSuperview()
                self.translationsView.countLabel.text = "\(self.translationsModel.count)"
            }
            self.translationsView.recordButton.isEnabled = false
            self.translationsView.playButton.isEnabled = true
            self.translationsView.deleteButton.isEnabled = true
        }
    }
}




