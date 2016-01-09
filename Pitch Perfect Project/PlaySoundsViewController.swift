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
        playAudioWithVariableSpeed(0.5)
    }
    
    func stopReset(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0.0
    }
    
    func playAudioWithVariableSpeed(rate: Float){
        stopReset()
      
        let changeRateEffect = audioPlayer
        changeRateEffect.rate = rate
 
        audioPlayer.play()
    }
    
    @IBAction func rabbitButton(sender: AnyObject) {
        playAudioWithVariableSpeed(2.1)
    }
    
    @IBAction func chipmunkButton(sender: AnyObject) {
        playAudioWithVariablePitch(750)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        stopReset()
        
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
        playAudioWithVariablePitch(-387)
    }
    
    @IBAction func stopButton(sender: AnyObject) {
        stopReset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

/*
How to create the reverb effect:

Stop all audio
Create an instance of AVAudioPlayerNode
Attach this variable to the audioEngine previously created
Create an instance of AVAudioUnitReverb
Use loadFactoryPreset to configure the Reverb Audio Unit
Apply the wetDryMix (normally 50 is enough)
Attach the instance of AVAudioUnitReverb you created to the audioEngine previously created
Connect your instance of AVAudioPlayerNode to the AVAudioUnitReverb using .connect
Connect your instance of AVAudioUnitReverb to your outputNode's audioEngine
Use the startAndReturnError(nil) property in your audioEngine instance
Play the instance of AVAudioPlayerNode

*/


