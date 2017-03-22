//
//  TranslationsModel.swift
//  Buildic
//
//  Created by Luigi Pepe on 2/16/17.
//  Copyright © 2017 Luigi Pepe. All rights reserved.
//

import UIKit
import AVFoundation

class TranslationsModel: NSObject {

    var word: Word?
    var myTranslationList = [Word]()
    
    var newTranslationDictionary: Dictionary?
    var allDictionaries: [Dictionary]?
    
    var tabActive: String?
    var myWord: String?
    var currentLanguage: String?
    var languages: [String]?
    var myKind: String?
    var translation: String?
    var textFieldContentsKey: String? = nil
    
    var langButtonIndex : Int = 0
    var visibleLang: String?
    var newTranslationLang : String?
    
    var audioFileURL: URL!
    var audioPlayer = AVAudioPlayer()
    var recordingSession = AVAudioSession.sharedInstance()
    var audioRecorder: AVAudioRecorder!
    
    var count = 3
    var myTimer: Timer = Timer()
}
