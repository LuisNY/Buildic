//
//  TranslationsView.swift
//  Buildic
//
//  Created by Luigi Pepe on 2/16/17.
//  Copyright © 2017 Luigi Pepe. All rights reserved.
//

import UIKit

class TranslationsView: UIView {

    var translationsTableView: UITableView!
    var selectLangButton: UIButton!
    var langStackView: UIStackView!
    var langButtonSet: [CustomisedButton]!
    var topView: UIView!
    var rightRectangleView: UIImageView!
    var leftRectangleView: UIImageView!
    var recordingView: UIView!
    var recordingLabel: UILabel!
    var recordButton: UIButton!
    var playButton: UIButton!
    var deleteButton: UIButton!
    var bottomButtonsStackView: UIStackView!
    
    var countLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, allLang: [String], currentLang: String, visibleLang: String) {
        self.init()
        
        self.backgroundColor = UIColor.red
        self.setupTopView(visibleLang: visibleLang)
        self.langButtonSet = [CustomisedButton]()
        self.setupTableView()
        self.setupStackView(allLang: allLang, currLang: currentLang)
        self.setupRecordingView()
        self.setupCountLabel()
        
    }
    
    func setupTopView(visibleLang: String) {
        
        self.topView = UIView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 40))
        self.topView.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        self.addSubview(self.topView)
        
        self.selectLangButton = UIButton()
        self.selectLangButton.frame = CGRect(x: 30, y: 0, width: self.topView.bounds.size.width - 60, height: 40)
        
        self.selectLangButton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        if visibleLang != "" {
            self.selectLangButton.setTitle(visibleLang, for: .normal)
        } else {
            self.selectLangButton.setTitle("No other dictionaries found", for: .normal)
        }
        
        self.selectLangButton.setTitleColor(UIColor.blue, for: .normal)
        self.selectLangButton.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        self.topView.addSubview(self.selectLangButton)
        
        self.rightRectangleView = UIImageView(frame: CGRect(x: 0, y: 8, width: 30, height: 24))
        self.rightRectangleView.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        self.rightRectangleView.image = UIImage(named: "arrowright")
        
        self.rightRectangleView.image = self.rightRectangleView.image!.withRenderingMode(.alwaysTemplate)
        self.rightRectangleView.tintColor = UIColor.blue
        self.topView.addSubview(self.rightRectangleView)
        
        self.leftRectangleView = UIImageView(frame: CGRect(x: self.topView.bounds.size.width - 30, y: 8, width: 30, height: 24))
        self.leftRectangleView.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        self.leftRectangleView.image = UIImage(named: "arrowleft")
        
        self.leftRectangleView.image = self.leftRectangleView.image!.withRenderingMode(.alwaysTemplate)
        self.leftRectangleView.tintColor = UIColor.blue
        self.topView.addSubview(self.leftRectangleView)
    }
    
    func setupTableView() {
        self.translationsTableView = UITableView()
        self.translationsTableView.separatorInset = UIEdgeInsets.zero
        self.translationsTableView.frame = CGRect(x: 0, y: 104, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 164)
        self.translationsTableView.backgroundColor = UIColor.white
        
        self.translationsTableView.register(TranslationCell.self, forCellReuseIdentifier: "translationCell")
        self.addSubview(self.translationsTableView)
    }
    
    
    func setupStackView(allLang: [String], currLang: String) {
        
        var heightButton = 50
        while (heightButton * (allLang.count - 1) > Int(UIScreen.main.bounds.size.height) - 104) {
            heightButton -= 5
        }
        
        self.langStackView = UIStackView(frame: CGRect(x: 0, y: 104, width: Int(UIScreen.main.bounds.size.width), height: heightButton * (allLang.count - 1)))
        self.langStackView.backgroundColor = UIColor.red
        self.langStackView.axis = UILayoutConstraintAxis(rawValue: 1)!
        self.langStackView.distribution = UIStackViewDistribution(rawValue: 1)!
        
        for i in 0..<allLang.count {
            
            if allLang[i] != currLang {

                let languageButton = CustomisedButton()
                languageButton.setTitle(allLang[i], for: .normal)
                languageButton.titleLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
                languageButton.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
                languageButton.setTitleColor(UIColor.blue, for: .normal)
                self.langButtonSet.append(languageButton)
                self.langStackView.addArrangedSubview(languageButton)
            }
        }
        
        for i in 0..<allLang.count - 1 {
            self.langButtonSet[i].index = i
        }
    }
    
    
    func setupRecordingView() {
        
        self.recordingView = UIView(frame: CGRect(x: 0, y: Int(UIScreen.main.bounds.size.height) - 90, width: Int(UIScreen.main.bounds.size.width), height: 90))
        self.recordingView.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        self.addSubview(self.recordingView)
        
        self.recordingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width), height: 30))
        self.recordingLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 18)
        self.recordingLabel.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        self.recordingView.addSubview(self.recordingLabel)
        
        self.bottomButtonsStackView = UIStackView(frame: CGRect(x: 0, y: 30, width: Int(UIScreen.main.bounds.size.width), height: 60))
        self.bottomButtonsStackView.backgroundColor = UIColor.blue
        self.recordingView.addSubview(self.bottomButtonsStackView)
        
        self.bottomButtonsStackView.axis = UILayoutConstraintAxis(rawValue: 0)!
        self.bottomButtonsStackView.distribution = UIStackViewDistribution(rawValue: 1)!
        
        let playImageView = UIImageView()
        playImageView.image = UIImage(named: "play")
        playImageView.image = playImageView.image!.withRenderingMode(.alwaysTemplate)
        playImageView.tintColor = UIColor.blue
        
        self.playButton = UIButton()
        self.playButton.setImage(playImageView.image, for: .normal)
        self.playButton.tintColor = .blue
        self.bottomButtonsStackView.addArrangedSubview(self.playButton)
        
        playImageView.image = UIImage(named: "record")
        playImageView.image = playImageView.image!.withRenderingMode(.alwaysTemplate)
        playImageView.tintColor = UIColor.blue
        
        self.recordButton = UIButton()
        self.recordButton.setImage(playImageView.image, for: .normal)
        self.recordButton.tintColor = .blue
        self.bottomButtonsStackView.addArrangedSubview(self.recordButton)
        
        playImageView.image = UIImage(named: "delete")
        playImageView.image = playImageView.image!.withRenderingMode(.alwaysTemplate)
        playImageView.tintColor = UIColor.blue
        
        self.deleteButton = UIButton()
        self.deleteButton.setImage(playImageView.image, for: .normal)
        self.deleteButton.tintColor = .blue
        self.bottomButtonsStackView.addArrangedSubview(self.deleteButton)
    }
    
    func setupCountLabel() {
        
        self.countLabel = UILabel(frame: CGRect(x: 150, y: 300, width: Int(UIScreen.main.bounds.size.width) - 300, height: 60))
        self.countLabel.textColor = UIColor.blue
        self.countLabel.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        self.countLabel.textAlignment = NSTextAlignment(rawValue: 1)!
        self.countLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 50)

    }
}



class NotesView: UIView {
    
    var notesTextView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.setupTextView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTextView() {
        
        self.notesTextView = UITextView(frame: CGRect(x: 0, y: 64, width: self.bounds.size.width, height: self.bounds.size.height - 64))
        self.notesTextView.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        self.notesTextView.textColor = UIColor.blue
        self.notesTextView.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.notesTextView.allowsEditingTextAttributes = true
        self.notesTextView.isEditable = true
        self.notesTextView.returnKeyType = .default
        self.notesTextView.isScrollEnabled = true
        self.addSubview(self.notesTextView)        
    }
    
    func dismissKeyboard() {
        self.endEditing(true)
    }

}






class NewTranslationView: UIView {
    
    
    
    var doneButton: UIButton!
    var cancelButton: UIButton!
    
    var upperStack: UIStackView!
    var dictionaryStack: UIStackView!
    var bottomStack: UIStackView!
    
    var translationLabel: UILabel!
    var translationTextField: UITextField!
    
    
    var langButtonSet: [CustomisedButton]!
    var langLabelSet: [UILabel]!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init (frame: CGRect, allLang: [String], currLang: String) {
        self.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        
        self.langButtonSet = [CustomisedButton]()
        self.langLabelSet = [UILabel]()
        
        self.setupBottomStack()
        self.setupUpperStack()
        self.setupDictStack(allLang: allLang, currLang: currLang)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupBottomStack() {
    
        self.bottomStack = UIStackView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 60, width: UIScreen.main.bounds.size.width, height: 60))
        self.addSubview(self.bottomStack)
        self.bottomStack.axis = UILayoutConstraintAxis(rawValue: 0)!
        self.bottomStack.distribution = UIStackViewDistribution(rawValue: 1)!
        
        self.doneButton = UIButton()
        self.doneButton.setTitle("Done", for: .normal)
        self.doneButton.backgroundColor = UIColor.blue
        self.doneButton.setTitleColor(UIColor.white, for: .normal)
        self.bottomStack.addArrangedSubview(self.doneButton)
        
        self.cancelButton = UIButton()
        self.cancelButton.setTitle("Cancel", for: .normal)
        self.cancelButton.setTitleColor(UIColor.white, for: .normal)
        self.cancelButton.backgroundColor = UIColor.blue
        self.bottomStack.addArrangedSubview(self.cancelButton)
    
    }
    
    
    func setupUpperStack() {
        
        self.upperStack = UIStackView(frame: CGRect(x: 20, y: 80, width: UIScreen.main.bounds.size.width - 40, height: 40))
        self.addSubview(self.upperStack)
        self.upperStack.axis = UILayoutConstraintAxis(rawValue: 0)!
        self.upperStack.distribution = UIStackViewDistribution(rawValue: 1)!
        
        self.translationLabel = UILabel()
        self.translationLabel.text = "Translation:"
        self.translationLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.translationLabel.textColor = UIColor.blue
        
        self.translationTextField = UITextField()
        self.translationTextField.text = ""
        self.translationTextField.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.translationTextField.returnKeyType = .done
        self.translationTextField.enablesReturnKeyAutomatically = true
        self.translationTextField.textColor = UIColor.blue
        self.translationTextField.backgroundColor = UIColor.white
        
        
        self.upperStack.addArrangedSubview(self.translationLabel)
        self.upperStack.addArrangedSubview(self.translationTextField)
        
        
    }
    
    
    
    
    func setupDictStack(allLang: [String], currLang: String) {
        
        self.dictionaryStack = UIStackView(frame: CGRect(x: 0, y: 120, width: UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height - 120 - 60))
        self.dictionaryStack.backgroundColor = UIColor.red
        self.addSubview(self.dictionaryStack)
        self.dictionaryStack.axis = UILayoutConstraintAxis(rawValue: 1)!
        self.dictionaryStack.distribution = UIStackViewDistribution(rawValue: 1)!
        
        var first: Bool = false
        
        for i in 0..<allLang.count {
            
            if allLang[i] != currLang {
                
                let newLangStack = UIStackView()
                newLangStack.axis = UILayoutConstraintAxis(rawValue: 0)!
                newLangStack.distribution = UIStackViewDistribution(rawValue: 1)!
                
                
                let languageLabel = UILabel()
                languageLabel.text = allLang[i]
                languageLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
                languageLabel.textColor = UIColor.blue
                languageLabel.textAlignment = NSTextAlignment(rawValue: 1)!
                newLangStack.addArrangedSubview(languageLabel)
                
                let languageView = UIView()
                newLangStack.addArrangedSubview(languageView)
                
                let languageButton = CustomisedButton()
                languageView.addSubview(languageButton)
                languageButton.frame = CGRect(x: self.dictionaryStack.bounds.size.width / 4 - 15, y:
                self.dictionaryStack.bounds.size.height / ((CGFloat(allLang.count) - 1) * 2) - 15, width: 30, height: 30)
                
                if first == false {
                    languageButton.setImage(UIImage(named: "checked"), for: .normal)
                    first = true
                }
                else {
                    languageButton.setImage(UIImage(named: "unchecked"), for: .normal)
                }
                
                self.langButtonSet.append(languageButton)
                self.langLabelSet.append(languageLabel)
                self.dictionaryStack.addArrangedSubview(newLangStack)
            }
        }
        
        for i in 0..<allLang.count - 1 {
            self.langButtonSet[i].index = i
        }
    }
    
    func dismissKeyboard() {
        self.endEditing(true)
    }
}




class CustomisedButton: UIButton {
    
    var index: Int?
    
    required init(value: Int = 0) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(index: Int) {
        self.init()
        
        self.index = index
    }
    
    
}



class TranslationCell: UITableViewCell {
    
    
    var cellLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "translationCell")
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
