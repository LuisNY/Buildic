//
//  AddNewDictionaryView.swift
//  Buildic
//
//  Created by Luigi Pepe on 2/14/17.
//  Copyright © 2017 Luigi Pepe. All rights reserved.
//

import UIKit



class DictionariesView: UIView {
    
    var dictionaryTableView: UITableView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.dictionaryTableView = UITableView()
        self.dictionaryTableView.separatorInset = UIEdgeInsets.zero
        self.dictionaryTableView.frame = CGRect(x: 0, y: 64, width: self.bounds.size.width, height: UIScreen.main.bounds.size.height - 64)
        self.dictionaryTableView.backgroundColor = UIColor.white
        self.dictionaryTableView.register(DictionaryCell.self, forCellReuseIdentifier: "dictionaryCell")
        self.addSubview(self.dictionaryTableView)
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}










class NewDictionaryView: UIView {
    
    var doneButton: UIButton!
    var cancelButton: UIButton!
    var bottomStack: UIStackView!
    
    var langStack: UIStackView!
    
    var langLabel: UILabel!
    
    var langTextField: UITextField!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1)
        self.setupBottomStackView()
        self.setupLangStack()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.addGestureRecognizer(tap)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupBottomStackView() {
        
        self.bottomStack = UIStackView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 50, width: UIScreen.main.bounds.size.width, height: 50))
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
    
    
  
    
    func setupLangStack() {
        
        self.langStack = UIStackView(frame: CGRect(x: 20, y: 80, width: UIScreen.main.bounds.size.width - 40, height: 40))
        self.addSubview(self.langStack)
        
        self.langLabel = UILabel()
        self.langLabel.text = "New language:"
        self.langLabel.textColor = UIColor.blue
        self.langLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 20)

        
        self.langTextField = UITextField()
        self.langTextField.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        self.langTextField.text = ""
        self.langTextField.textColor = UIColor.blue
        self.langTextField.backgroundColor = UIColor.white
        
        self.langStack.axis = UILayoutConstraintAxis(rawValue: 0)!
        self.langStack.addArrangedSubview(self.langLabel)
        self.langStack.addArrangedSubview(self.langTextField)
        self.langStack.distribution = UIStackViewDistribution(rawValue: 1)!
    }
    
    
    func dismissKeyboard() {
        self.endEditing(true)
    }
}

class DictionaryCell: UITableViewCell {
    
    
    var cellLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "dictionaryCel")
        
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

