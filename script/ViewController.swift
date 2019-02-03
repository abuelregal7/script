//
//  ViewController.swift
//  script
//
//  Created by ahmed abu elregal on 1/25/19.
//  Copyright © 2019 ahmed abu elregal. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class ViewController: UIViewController , AVAudioPlayerDelegate {
    
    var recordButton: UIButton!
    var audioPlayer: AVAudioPlayer!

    @IBOutlet weak var transcriptionTextField: UITextView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        activitySpinner.isHidden = true
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        activitySpinner.stopAnimating()
        activitySpinner.isHidden = true
    }
    func requestSpeechAuth()
    {
        SFSpeechRecognizer.requestAuthorization{ authoStatus in
            if authoStatus == SFSpeechRecognizerAuthorizationStatus.authorized{
                if let path = Bundle.main.url(forResource: "audio", withExtension: "m4a"){
                    do{
                        let sound = try AVAudioPlayer(contentsOf: path)
                        self.audioPlayer = sound
                        self.audioPlayer.delegate = self
                        sound.play()
                        
                    }catch{
                        print("Error!")
                        
                    }
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: path)
                    recognizer?.recognitionTask(with: request) { (result,error) in
                        if let error = error {
                            print("There was an error: \(error)")
                        } else {
                            self.transcriptionTextField.text = result?.bestTranscription.formattedString
                        }
                        
                    }
                    
                }
            }
            
    }


}
    @IBAction func playBtnRecord(_ sender: UIButton) {
        
        
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
        requestSpeechAuth()
        
    }
    
}

