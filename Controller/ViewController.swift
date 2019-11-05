

import UIKit
import SpriteKit
import ARKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var model = Model.shared
    var timer = Timer()
    
    // Points needed for winning
    let finishLine = 10
    // Points got when a team win a phase
    let pointsForPhase = 3
    // Precision for judging the pose [0.0 ~ 1.0]
    let precision : Double = 0.85
    // Total time for a phase
    let totalTime: TimeInterval = 3.0
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var redScoreLabel: UILabel!
    @IBOutlet weak var blueScoreLabel: UILabel!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var form: UIImageView!

    @IBOutlet weak var prepareToPlayView: UIView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var scoredView: UIView!
    @IBOutlet weak var scoredLabel: UILabel!
    @IBOutlet weak var scoredUIImageView: UIImageView!
    

    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var imagePicker: UIImagePickerController!
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initScreen()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        prepareToPlayView.isHidden = false
        prepareToPlayView.alpha = 1
        btnPlay.isEnabled = true
        
        super.viewWillAppear(animated)
        
    }
    
    func initScreen(){
        
        redScoreLabel.text = String(model.teams[0].points)
        blueScoreLabel.text = String(model.teams[1].points)
        
        initCamera()
        
    }
    
    func initCamera() {
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            stillImageOutput = AVCapturePhotoOutput()

            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    func startTimer(segundos: TimeInterval) {
        model.time = segundos
        refreshTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.passoTimer()
        })
    }
    
    @IBAction func playButton(_ sender: Any) {
        startPhase()
    }
    
    func startPhase() {
        
        model.winner = -1
        model.secondsInPose = TimeInterval(0)
        
        // Team that starts
        if model.actualTeam == -1 {
            model.actualTeam = 0
        } else if model.actualTeam == 0 {
            model.actualTeam = 1
        } else {
            model.actualTeam = 0
        }
        
        startTimer(segundos: totalTime)
    }
    
    // A cada 1 segundo, executa:
    func passoTimer(){
        
        if model.time > 0 {
            model.time -= 1
            refreshTimer()
        } else {
            timeIsUp()
        }
    }
    
    func timeIsUp(){
        
        // Stop the timer
        timer.invalidate()
        
        attachPoints()
        refreshScoreLabels()
        
        // If the team haven't made any points
        if model.actualPoints == 0 {
            showLosed()
        }
        // The current team won!
        else if model.teams[model.actualTeam].points > finishLine {
            callVictory()
        }
        // If somebody has scored but haven't won.
        else {
            showScored()
        }
        
    }
    
    func judgePose() -> Double {
        var score : Double
        score = 1.0
        return score
    }
    
    func attachPoints(){
        if judgePose() > precision {
            model.actualPoints = pointsForPhase
            model.teams[model.actualTeam].points += pointsForPhase
        }
    }
    
    // Set the team infos and show the view
    // when the current team scored
    func showScored(){
        
        scoredLabel.text = "THE \(ACTUALTEAM()) TEAM SCORED!"
        scoredUIImageView.image = UIImage(named: "\(actualTeam())score")

        scoredView.alpha = 1.0
    }
    
    // Set the team infos and show the view
    // when the current team losed
    func showLosed(){
        
        scoredLabel.text = "THE \(ACTUALTEAM()) TEAM LOSE!"
        scoredUIImageView.image = UIImage(named: "\(actualTeam())lose")

        scoredView.alpha = 1.0
        
    }
    
    func actualTeam() -> String {
        if model.actualTeam == 0 {
            return "red"
        }
        return "blue"
    }
    
    func ACTUALTEAM() -> String {
        if model.actualTeam == 0 {
            return "RED"
        }
        return "BLUE"
    }
    
    func callVictory(){
        
        if model.teams[0].points == model.teams[1].points {
            // TODO: EMPATE! O QUE FAZER?
        }
        // RED won
        else if model.teams[0].points >= finishLine {
            model.winner = 0
        }
        // BLUE won
        else {
            model.winner = 1
        }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Win") as? WinViewController {
            // Call the ViewController
            self.present(vc, animated:true, completion:nil)
        }
    }
    
    func refreshTimer() {
        refreshTimerLabels()
    }
    
    func refreshTimerLabels() {
        TimerLabel.text = String(Int(model.time))
    }
    
    func refreshScoreLabels() {
        redScoreLabel.text = String(model.teams[0].points)
        blueScoreLabel.text = String(model.teams[1].points)
    }
    
    @IBAction func welcome(_ sender: Any) {
        prepareToPlayView.isHidden = true
        prepareToPlayView.alpha = 1
        btnPlay.isEnabled = false
        form.isHidden = false
        form.alpha = 1
    }
    
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    @IBAction func goToTutorial(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "tutorial") as? TutorialViewController {
                   self.present(vc, animated:false, completion:nil)
               }
    }
    
}
