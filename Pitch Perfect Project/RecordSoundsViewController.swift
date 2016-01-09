//
//  RecordSoundsViewController.swift
//  Pitch Perfect Project
//
//  Created by Jared Wong on 12/16/15.
//  Copyright © 2015 Apparatus Unlimited. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    //Declare Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    @IBOutlet weak var tapToRecord: UILabel!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var paused: UILabel!
    @IBOutlet weak var resumedRecording: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordingInProgress.hidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stopButton.hidden = true
        pauseButton.hidden = true
        recordButton.enabled = true
        recordButton.hidden = false
        tapToRecord.hidden = false
        paused.hidden = true
        resumedRecording.hidden = true
    }
    
    @IBAction func recordAudio(sender: AnyObject) {
        //Show text "recording in progress"
        recordButton.enabled = false
        recordButton.hidden = true
        pauseButton.hidden = false
        tapToRecord.hidden = true
        stopButton.hidden = false
        recordingInProgress.hidden = false
        recordButton.enabled = false
        recordButton.hidden = true
        
        //Return users voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)!
        print(filePath)
        
        //Setup audio session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        do {
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        } catch _ {
        }
        do {
            //Initialize and prepare the recorder
            audioRecorder = try AVAudioRecorder(URL : filePath, settings: [String : AnyObject]())
        } catch _ {
        }
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func pauseRecording(sender: AnyObject) {
        let pauseBtn = sender as! UIButton
        if (!audioRecorder.recording) {
            audioRecorder.record()
        } else {
            audioRecorder.pause()
        }
        recordingInProgress.hidden = true
        paused.hidden = false
        stopButton.hidden = true
        resumedRecording.hidden = true
        pauseBtn.setImage(UIImage(named:"microphone.png"),forState:UIControlState.Normal)
        if(!audioRecorder.recording) {
            audioRecorder.pause()
        } else {
            resumedRecording.hidden = false
            paused.hidden = true
            stopButton.hidden = false
        pauseBtn.setImage(UIImage(named:"recording.png"),forState:UIControlState.Normal)
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: AnyObject) {
        recordingInProgress.hidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance();
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
}

