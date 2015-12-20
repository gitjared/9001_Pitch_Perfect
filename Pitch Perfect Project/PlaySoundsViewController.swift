//
//  PlaySoundsViewController.swift
//  Pitch Perfect Project
//
//  Created by Jared Wong on 12/16/15.
//  Copyright © 2015 Apparatus Unlimited. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL:receivedAudio.filePathURL)
            audioFile = try AVAudioFile(forReading: receivedAudio.filePathURL)
            audioPlayer.enableRate = true
            
            audioEngine = AVAudioEngine()
            
        } catch let error as NSError {
            print("Error loading audio: \(error)")
        }
}
    
    @IBAction func snailButton(sender: AnyObject) {
        playAudioWithSnailSpeed(0.5)
    }
    
    func playAudioWithSnailSpeed(pitch: Float){
        audioPlayer.stop()
        audioPlayer.rate = 0.49
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
        func playAudioWithVariableSpeed(speed: Float){
            audioPlayer.stop()
            audioPlayer.rate = speed
            audioPlayer.currentTime = 0.0
            audioPlayer.play()
        }
    }
    
    @IBAction func rabbitButton(sender: AnyObject) {
        playAudioWithRabbitPitch(5.5)
    }
    
    func playAudioWithRabbitPitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.stop()
        audioPlayer.rate = 2.50
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }
    func playAudioWithVariableSpeed(speed: Float){
        audioPlayer.stop()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func chipmunkButton(sender: AnyObject) {
        playAudioWithVariablePitch(750)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format:nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch _ {
        }
        
        audioPlayerNode.play()
    }
    
    @IBAction func darthvaderButton(sender: AnyObject) {
        playAudioWithDarthPitch(-380)
    }
    
    func playAudioWithDarthPitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format:nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch _ {
        }
        audioPlayerNode.play()
    }
    
    @IBAction func stopButton(sender: AnyObject) {
        audioPlayer.stop()
        audioEngine.stop()
        audioPlayer.currentTime = 0.0
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
