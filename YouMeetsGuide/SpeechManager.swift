//
//  SpeechManager.swift
//  NoticeConcierge
//
//  Created by Ryou on 2015/08/11.
//  Copyright (c) 2015年 Oak Leaf Project. All rights reserved.
//

import Foundation
import AVFoundation
final class SpeechManager: NSObject, AVSpeechSynthesizerDelegate, AVAudioPlayerDelegate {
    let synthesiser:AVSpeechSynthesizer = AVSpeechSynthesizer();
    var audioPlayer:AVAudioPlayer!;
    var speechTextSwap:String?;
    var speechTextLangSwap:String?;
    var soundStac:NSMutableArray = NSMutableArray();
    private override init() {
    }
    class var sharedManager : SpeechManager {
        struct SharedManager {
            static let sharedManager = SpeechManager();
        }
        return SharedManager.sharedManager;
    }
    
    func playSpeech(speechText:String!, language:String!){
        if (self.synthesiser.delegate == nil){
            self.synthesiser.delegate = self;
        }
        var speechData:AVSpeechUtterance! = AVSpeechUtterance(string: speechText);
        speechData.voice = AVSpeechSynthesisVoice(language: language);
        speechData.pitchMultiplier = 1.0;
        speechData.preUtteranceDelay = 0.0;
        speechData.volume = 1.0;
        speechData.rate = AVSpeechUtteranceMaximumSpeechRate * 0.5;

        self.synthesiser.speak(speechData);
    }
    
}
