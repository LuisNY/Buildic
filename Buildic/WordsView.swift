//
//  WordsView.swift
//  Buildic
//
//  Created by Luigi Pepe on 2/15/17.
//  Copyright © 2017 Luigi Pepe. All rights reserved.
//
import UIKit

class WordsView: UIView {
    
    var lateralStack: UIStackView!
    var searchBar: UISearchBar!
    var wordsTableView: UITableView!
    
    var allButton: UIButton!
    var nounsButton: UIButton!
    var verbsButton: UIButton!
    var adjectivesButton: UIButton!
    var adverbsButton: UIButton!
    var restButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        
        self.setupSearchBar()
        self.setupLateralStack()
        self.setupTableView()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    func setupSearchBar() {
        
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 65, width: UIScreen.main.bounds.size.width, height:40))
        
        self.addSubview(self.searchBar)
        
    }
    func setupLateralStack() {
        
        self.lateralStack = UIStackView(frame: CGRect(x: 0, y: 105, width: UIScreen.main.bounds.size.width / 4, height: UIScreen.main.bounds.size.height - 105))
        self.lateralStack.axis = UILayoutConstraintAxis(rawValue: 1)!
        self.lateralStack.distribution = UIStackViewDistribution(rawValue: 1)!
        self.addSubview(self.lateralStack)
        
        self.setupLateralButtons()
    }
    
    func setupLateralButtons() {
        
        self.allButton = UIButton()
        self.allButton.setTitle("All", for: .normal)
        self.allButton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.allButton.setTitleColor(UIColor.white, for: .normal)
        self.allButton.backgroundColor = UIColor.blue
        self.lateralStack.addArrangedSubview(self.allButton)
        
        self.nounsButton = UIButton()
        self.nounsButton.setTitle("Nouns", for: .normal)
        self.nounsButton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.nounsButton.setTitleColor(UIColor.blue, for: .normal)
        self.nounsButton.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        self.lateralStack.addArrangedSubview(self.nounsButton)
        
        self.verbsButton = UIButton()
        self.verbsButton.setTitle("Verbs", for: .normal)
        self.verbsButton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.verbsButton.setTitleColor(UIColor.blue, for: .normal)
        self.verbsButton.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        self.lateralStack.addArrangedSubview(self.verbsButton)
        
        self.adjectivesButton = UIButton()
        self.adjectivesButton.setTitle("Adjectives", for: .normal)
        self.adjectivesButton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.adjectivesButton.setTitleColor(UIColor.blue, for: .normal)
        self.adjectivesButton.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        self.lateralStack.addArrangedSubview(self.adjectivesButton)
        
        self.adverbsButton = UIButton()
        self.adverbsButton.setTitle("Adverbs", for: .normal)
        self.adverbsButton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.adverbsButton.setTitleColor(UIColor.blue, for: .normal)
        self.adverbsButton.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        self.lateralStack.addArrangedSubview(self.adverbsButton)
        
        self.restButton = UIButton()
        self.restButton.setTitle("Other", for: .normal)
        self.restButton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.restButton.setTitleColor(UIColor.blue, for: .normal)
        self.restButton.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        self.lateralStack.addArrangedSubview(self.restButton)
    }
    
    func setupTableView() {
        
        self.wordsTableView = UITableView()
        self.wordsTableView.separatorInset = UIEdgeInsets.zero
        self.wordsTableView.frame = CGRect(x: UIScreen.main.bounds.size.width / 4, y: 105, width: UIScreen.main.bounds.size.width * 3 / 4, height: UIScreen.main.bounds.size.height - 105)
        self.wordsTableView.backgroundColor = UIColor.white
        self.wordsTableView.register(WordsCell.self, forCellReuseIdentifier: "wordCell")
        self.addSubview(self.wordsTableView)
    }
    
}


class NewWordView: UIView {
    
    
    var bottomStack: UIStackView!
    var doneButton: UIButton!
    var cancelButton: UIButton!
    
    
    var upperStack: UIStackView!
    
    var wordStack: UIStackView!
    var wordLabel: UILabel!
    var wordView: UIView!
    var wordTextField: UITextField!
    
    var languageStack: UIStackView!
    var languageLabel: UILabel!
    var whatLanguageLabel: UILabel!
    
    var nounsStack: UIStackView!
    var nounsLabel: UILabel!
    var nounsView: UIView!
    var nounsButton: UIButton!
    
    var verbsStack: UIStackView!
    var verbsLabel: UILabel!
    var verbsView: UIView!
    var verbsButton: UIButton!
    
    
    var adjectivesStack: UIStackView!
    var adjectivesLabel: UILabel!
    var adjectivesView: UIView!
    var adjectivesButton: UIButton!
    
    
    var adverbsStack: UIStackView!
    var adverbsLabel: UILabel!
    var adverbsView: UIView!
    var adverbsButton: UIButton!
    
    var restStack: UIStackView!
    var restLabel: UILabel!
    var restView: UIView!
    var restButton: UIButton!
    
    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.addGestureRecognizer(tap)
        self.setupBottomStack()
        
        self.setupUpperStack()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissKeyboard() {
        self.endEditing(true)
    }

    func setupBottomStack() {
        
        self.bottomStack = UIStackView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 60, width: UIScreen.main.bounds.size.width, height: 60))
        self.addSubview(self.bottomStack)
        
        self.doneButton = UIButton()
        self.doneButton.setTitle("Done", for: .normal)
        self.doneButton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.doneButton.tintColor = UIColor.yellow
        self.doneButton.backgroundColor = UIColor.blue
        
        self.cancelButton = UIButton()
        self.cancelButton.setTitle("Cancel", for: .normal)
        self.cancelButton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.cancelButton.tintColor = UIColor.yellow
        self.cancelButton.backgroundColor = UIColor.blue
        
        self.bottomStack.axis = UILayoutConstraintAxis(rawValue: 0)!
        self.bottomStack.addArrangedSubview(self.doneButton)
        self.bottomStack.addArrangedSubview(self.cancelButton)
        self.bottomStack.distribution = UIStackViewDistribution(rawValue: 1)!
        
    }

    
    func setupUpperStack() {
        
        
        self.upperStack = UIStackView(frame: CGRect(x: 0, y: 65, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 125))
        self.addSubview(self.upperStack)
        
        self.setupWordStack()
        self.setupLanguageStack()
        self.setupNounsStack()
        self.setupVerbsStack()
        self.setupAdverbsStack()
        self.setupAdjectivesStack()
        self.setupRestStack()
        
        
        self.upperStack.axis = UILayoutConstraintAxis(rawValue: 1)!
        self.upperStack.addArrangedSubview(self.wordStack)
        self.upperStack.addArrangedSubview(self.languageStack)
        self.upperStack.addArrangedSubview(self.nounsStack)
        self.upperStack.addArrangedSubview(self.verbsStack)
        self.upperStack.addArrangedSubview(self.adjectivesStack)
        self.upperStack.addArrangedSubview(self.adverbsStack)
        self.upperStack.addArrangedSubview(self.restStack)
        self.upperStack.distribution = UIStackViewDistribution(rawValue: 1)!
        
        
    }
    
    
    
    func setupWordStack() {
        
        self.wordStack = UIStackView()
        self.addSubview(self.wordStack)
        self.wordStack.axis = UILayoutConstraintAxis(rawValue: 0)!
        self.wordStack.distribution = UIStackViewDistribution(rawValue: 1)!

        
        self.wordLabel = UILabel()
        self.wordLabel.text = "New Word:"
        self.wordLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.wordLabel.textColor = UIColor.blue
        self.wordLabel.textAlignment = NSTextAlignment(rawValue: 1)!
        self.wordStack.addArrangedSubview(self.wordLabel)
        
        
        self.wordView = UIView()
        self.wordStack.addArrangedSubview(self.wordView)
        
        
        self.wordTextField = UITextField()
        self.wordTextField.text = ""
        self.wordTextField.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.wordTextField.textColor = UIColor.blue
        self.wordTextField.backgroundColor = UIColor.white
        self.wordTextField.returnKeyType = .done
        self.wordTextField.enablesReturnKeyAutomatically = true
        self.wordView.addSubview(self.wordTextField)
        
        self.wordTextField.frame = CGRect(x: 0, y: 20, width: self.upperStack.bounds.size.width, height: self.upperStack.bounds.size.height / 7 - 40)
    }
    
    func setupLanguageStack() {
        
        self.languageStack = UIStackView()
        self.addSubview(self.languageStack)
        
        self.languageLabel = UILabel()
        self.languageLabel.text = "Language:"
        self.languageLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.languageLabel.textColor = UIColor.blue
        self.languageLabel.textAlignment = NSTextAlignment(rawValue: 1)!
        
        self.whatLanguageLabel = UILabel()
        self.whatLanguageLabel.text = ""
        self.whatLanguageLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.whatLanguageLabel.textColor = UIColor.blue
        self.whatLanguageLabel.textAlignment = NSTextAlignment(rawValue: 1)!

        
        self.languageStack.axis = UILayoutConstraintAxis(rawValue: 0)!
        self.languageStack.addArrangedSubview(self.languageLabel)
        self.languageStack.addArrangedSubview(self.whatLanguageLabel)
        self.languageStack.distribution = UIStackViewDistribution(rawValue: 1)!
    }
    

    func setupNounsStack() {
        
        self.nounsStack = UIStackView()
        self.addSubview(self.nounsStack)
        self.nounsStack.axis = UILayoutConstraintAxis(rawValue: 0)!
        self.nounsStack.distribution = UIStackViewDistribution(rawValue: 1)!
        
        self.nounsLabel = UILabel()
        self.nounsLabel.text = "Noun"
        self.nounsLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.nounsLabel.textColor = UIColor.blue
        self.nounsLabel.textAlignment = NSTextAlignment(rawValue: 1)!
        self.nounsStack.addArrangedSubview(self.nounsLabel)
        
        self.nounsView = UIView()
        self.nounsStack.addArrangedSubview(self.nounsView)
        
        self.nounsButton = UIButton()
        self.nounsButton.setImage(UIImage(named: "checked"), for: .normal)
        self.nounsView.addSubview(self.nounsButton)
        
        self.nounsButton.frame = CGRect(x: self.upperStack.bounds.size.width / 4 - 15, y: self.upperStack.bounds.size.height / 14 - 15, width: 30, height: 30)
    }
    
    func setupVerbsStack() {
        
        self.verbsStack = UIStackView()
        self.addSubview(self.verbsStack)
        self.verbsStack.axis = UILayoutConstraintAxis(rawValue: 0)!
        self.verbsStack.distribution = UIStackViewDistribution(rawValue: 1)!
        
        self.verbsLabel = UILabel()
        self.verbsLabel.text = "Verb"
        self.verbsLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.verbsLabel.textColor = UIColor.blue
        self.verbsLabel.textAlignment = NSTextAlignment(rawValue: 1)!
        self.verbsStack.addArrangedSubview(self.verbsLabel)
        
        self.verbsView = UIView()
        self.verbsStack.addArrangedSubview(self.verbsView)
        
        self.verbsButton = UIButton()
        self.verbsButton.setImage(UIImage(named: "unchecked"), for: .normal)
        self.verbsView.addSubview(self.verbsButton)
        
        self.verbsButton.frame = CGRect(x: self.upperStack.bounds.size.width / 4 - 15, y: self.upperStack.bounds.size.height / 14 - 15, width: 30, height: 30)
    }
    
    func setupAdjectivesStack() {
     
        self.adjectivesStack = UIStackView()
        self.addSubview(self.adjectivesStack)
        self.adjectivesStack.axis = UILayoutConstraintAxis(rawValue: 0)!
        self.adjectivesStack.distribution = UIStackViewDistribution(rawValue: 1)!
        
        self.adjectivesLabel = UILabel()
        self.adjectivesLabel.text = "Adjective"
        self.adjectivesLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.adjectivesLabel.textColor = UIColor.blue
        self.adjectivesLabel.textAlignment = NSTextAlignment(rawValue: 1)!
        self.adjectivesStack.addArrangedSubview(self.adjectivesLabel)
        
        self.adjectivesView = UIView()
        self.adjectivesStack.addArrangedSubview(self.adjectivesView)
        
        self.adjectivesButton = UIButton()
        self.adjectivesButton.setImage(UIImage(named: "unchecked"), for: .normal)
        self.adjectivesView.addSubview(self.adjectivesButton)
        
        self.adjectivesButton.frame = CGRect(x: self.upperStack.bounds.size.width / 4 - 15, y: self.upperStack.bounds.size.height / 14 - 15, width: 30, height: 30)
    }
    
    func setupAdverbsStack() {
        
        self.adverbsStack = UIStackView()
        self.addSubview(self.adverbsStack)
        self.adverbsStack.axis = UILayoutConstraintAxis(rawValue: 0)!
        self.adverbsStack.distribution = UIStackViewDistribution(rawValue: 1)!
        
        self.adverbsLabel = UILabel()
        self.adverbsLabel.text = "Adverb"
        self.adverbsLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.adverbsLabel.textColor = UIColor.blue
        self.adverbsLabel.textAlignment = NSTextAlignment(rawValue: 1)!
        self.adverbsStack.addArrangedSubview(self.adverbsLabel)
        
        self.adverbsView = UIView()
        self.adverbsStack.addArrangedSubview(self.adverbsView)
        
        self.adverbsButton = UIButton()
        self.adverbsButton.setImage(UIImage(named: "unchecked"), for: .normal)
        self.adverbsView.addSubview(self.adverbsButton)
        
        self.adverbsButton.frame = CGRect(x: self.upperStack.bounds.size.width / 4 - 15, y: self.upperStack.bounds.size.height / 14 - 15, width: 30, height: 30)
    }
    
    func setupRestStack() {
        
        self.restStack = UIStackView()
        self.addSubview(self.restStack)
        self.restStack.axis = UILayoutConstraintAxis(rawValue: 0)!
        self.restStack.distribution = UIStackViewDistribution(rawValue: 1)!
        
        self.restLabel = UILabel()
        self.restLabel.text = "Other"
        self.restLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.restLabel.textColor = UIColor.blue
        self.restLabel.textAlignment = NSTextAlignment(rawValue: 1)!
        self.restStack.addArrangedSubview(self.restLabel)
        
        self.restView = UIView()
        self.restStack.addArrangedSubview(self.restView)
        
        self.restButton = UIButton()
        self.restButton.setImage(UIImage(named: "unchecked"), for: .normal)
        self.restView.addSubview(self.restButton)
        
        self.restButton.frame = CGRect(x: self.upperStack.bounds.size.width / 4 - 15, y: self.upperStack.bounds.size.height / 14 - 15, width: 30, height: 30)
        
    }

}













class WordsCell: UITableViewCell {
    
    
    var cellLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "wordCell")
        
        self.contentView.addSubview(cellLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        cellLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
    }
    
}



