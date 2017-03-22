//
//  WordsModel.swift
//  Buildic
//
//  Created by Luigi Pepe on 2/15/17.
//  Copyright © 2017 Luigi Pepe. All rights reserved.
//

import Foundation


class WordsModel: NSObject {
    
    var currentLanguage: String?
    var tabActive: String?
    var selectedDictionary: Dictionary?
    var allDictionaries: [Dictionary]?
    var kind: String?
    var myWordsList = [Word]()
    var myFileteredWordsList: [Word]?
    var searchActive: Bool = false
    var languages: [String]?
    let switchButtonTitle = "Switch to: "
    
}
