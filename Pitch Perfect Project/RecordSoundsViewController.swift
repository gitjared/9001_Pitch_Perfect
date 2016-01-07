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
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordingInProgress.hidden = true
        
    }
    
        
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
        tapToRecord.hidden = false
}

    @IBAction func recordAudio(sender: AnyObject) {
        //Show text "recording in progress"
        tapToRecord.hidden = true
        stopButton.hidden = false
        recordingInProgress.hidden = false
        recordButton.enabled = false
        
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
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
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

