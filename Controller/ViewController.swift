

import UIKit
import AVFoundation
import Combine
import ARKit
import RealityKit

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, ARSessionDelegate {

    @IBOutlet var arView: ARView!

    // The 3D character to display.
    var character: BodyTrackedEntity?
    let characterOffset: SIMD3<Float> = [0, 0, 0] // Offset the character by one meter to the left
    let characterAnchor = AnchorEntity()
    
    // A tracked raycast which is used to place the character accurately
    // in the scene wherever the user taps.
    var placementRaycast: ARTrackedRaycast?
    var tapPlacementAnchor: AnchorEntity?
    
    var showRobot = true
    var startTracking = false
//    var bodyPosition1 : PositionCa
    
    var model = Model.shared
    var timer = Timer()
    let poseKit = PoseKit()
    
    // Total time for a phase
    let totalTime = TimeInterval(10.0)
    // Points needed for winning
    let finishLine = 10
    // Points got when a team win a phase
    let pointsForPhase = 3
    // Precision for judging the pose [0.0 ~ 1.0]
    let precision : Double = 0.85
    // Seconds needed to stay in the pose
    let secondsToPose = TimeInterval(0.75)
    
    let timeFrame = 0.05
    
    @IBOutlet weak var getReadyTeamImgView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var redScoreLabel: UILabel!
    @IBOutlet weak var blueScoreLabel: UILabel!
    @IBOutlet weak var TimerLabel: UILabel!
    
    @IBOutlet weak var form: UIImageView!
    var formNow : Int!
    
    @IBOutlet weak var peopleCelebratingImgView: UIImageView!
    
    @IBOutlet weak var prepareToPlayView: UIView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var scoredView: UIView!
    @IBOutlet weak var scoredLabel: UILabel!
    @IBOutlet weak var scoredUIImageView: UIImageView!
    
    @IBOutlet weak var teamGetReadyView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var imagePicker: UIImagePickerController!
    
    @IBOutlet var allScreenTapGesture: UITapGestureRecognizer!
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allScreenTapGesture.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        arView.session.delegate = self
        
        // If the iOS device doesn't support body tracking, raise a developer error for
        // this unhandled case.
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }

        // Run a body tracking configration.
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)
        
        arView.scene.addAnchor(characterAnchor)
        
        // Asynchronously load the 3D character.
        var cancellable: AnyCancellable? = nil
        cancellable = Entity.loadBodyTrackedAsync(named: "character/robot").sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: Unable to load model: \(error.localizedDescription)")
                }
                cancellable?.cancel()
        }, receiveValue: { (character: Entity) in
            if let character = character as? BodyTrackedEntity {
                // Scale the character to human size
                character.scale = [1.0, 1.0, 1.0]
                self.character = character
                cancellable?.cancel()
            } else {
                print("Error: Unable to load model as BodyTrackedEntity")
            }
        })
        initScreen()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        showGetReady()
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func allScreenTapGestureAction(_ sender: UITapGestureRecognizer) {
        if !timer.isValid {
            hideScoredView()
        }
    }
    
    func initScreen(){
        
        redScoreLabel.text = String(model.teams[0].points)
        blueScoreLabel.text = String(model.teams[1].points)
        
        prepareToPlayView.layer.masksToBounds = true
        prepareToPlayView.layer.cornerRadius = 50
        scoredView.layer.masksToBounds = true
        scoredView.layer.cornerRadius = 50
        teamGetReadyView.layer.masksToBounds = true
        teamGetReadyView.layer.cornerRadius = 50
        
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
        timer = Timer.scheduledTimer(withTimeInterval: timeFrame, repeats: true, block: { _ in
            self.passoTimer()
        })
    }
    
    @IBAction func playButton(_ sender: Any) {
        hideGetReady()
        startPhase()
    }
    
    @IBAction func getReadyTeamPlayButton(_ sender: Any) {
        hideGetReadyTeam()
        startPhase()
    }
    
    func hideGetReady(){
        prepareToPlayView.isHidden = true
        prepareToPlayView.alpha = 0.0
    }
    
    func showGetReady(){
        prepareToPlayView.isHidden = false
        prepareToPlayView.alpha = 1.0
        form.alpha = 0.0

    }
    
    func hideGetReadyTeam(){
        teamGetReadyView.isHidden = true
        teamGetReadyView.alpha = 0.0
        
    }
    
    func showGetReadyTeam(){
        changeTeam()
        welcomeLabel.text = "\(ACTUALTEAM()) TEAM, GET READY!"
        getReadyTeamImgView.image = UIImage(named: "\(actualTeam())")
        changeTeam()
        teamGetReadyView.isHidden = false
        teamGetReadyView.alpha = 1.0
    }
    
    func hideScoredView(){
        scoredView.isHidden = true
        scoredView.alpha = 0.0
    }
    
    func showScoredView(){
        scoredView.isHidden = false
        scoredView.alpha = 1.0
    }
    
    // Set the team infos and show the view
    // when the current team scored
    func showScored(){
        
        scoredLabel.text = "THE \(ACTUALTEAM()) TEAM SCORED!"
        scoredUIImageView.image = UIImage(named: "\(actualTeam())score")
        peopleCelebratingImgView.alpha = 1
        peopleCelebratingImgView.image = UIImage(named: "team \(actualTeam())")
        
        showScoredView()
    }
    
    func showTie(){
        
        scoredLabel.text = "IT'S A TIE! PLAY AGAIN TO SOLVE THIS."
        scoredUIImageView.image = UIImage(named: "Empate fundo")
        peopleCelebratingImgView.alpha = 1
        
        showScoredView()
    }
    
    // Set the team infos and show the view
    // when the current team losed
    func showLosed(){
        
        scoredLabel.text = "THE \(ACTUALTEAM()) TEAM LOSE!"
        scoredUIImageView.image = UIImage(named: "\(actualTeam())lose")
        peopleCelebratingImgView.alpha = 1
        
        showScoredView()
        
    }
    
    func startPhase() {
        formNow = Int.random(in: 0 ..< 6)
        let poseImg : UIImage? = UIImage(named: Forms.shared.Poses[formNow].image)
//        let poseImg : UIImage = UIImage(named: "pose \(formNow)")!
        form.image = poseImg
        model.winner = -1
        model.secondsInPose = TimeInterval(0)
        form.alpha = 1.0
        // Team that starts
        if model.actualTeam == -1 {
            model.actualTeam = 0
        }
        // Change the team
        else {
            changeTeam()
        }
        
        if !timer.isValid {
            startTimer(segundos: totalTime)
        }
    }
    
    func changeTeam(){
        if model.actualTeam == 0 {
            model.actualTeam = 1
        } else if model.actualTeam == 1 {
            model.actualTeam = 0
        } else {
            print("Team not changed!")
        }
    }
    
    // For each timeFrame executes:
    func passoTimer(){
        
        // Shows the error message
        if character?.isActive ?? false {
            self.errorLabel.alpha = 0
            if model.time > 0 {
                model.time -= timeFrame
                refreshTimer()
                if model.time <= 0 {
                    timeIsUp()
                }
            }
            if judgePose() >= precision {
                model.secondsInPose += timeFrame
                if model.secondsInPose >= secondsToPose {
                    timeIsUp()
                }
            }
        } else {
            self.errorLabel.alpha = 1.0
        }
        
        
    }
    
    func resetTimer(){
        timer.invalidate()
        model.time = totalTime
    }
    
    func timeIsUp(){
        
        // Stop and reset the timer
        resetTimer()
        
        if judgePose() >= precision  || model.secondsInPose >= secondsToPose {
            prize()
        }
        
        // Both of the teams played and some team won and it isn't a tie!
        if model.actualTeam == 1, (model.teams[0].points > finishLine || model.teams[1].points > finishLine) && model.teams[0].points != model.teams[1].points {
            callVictory()
        }
        else {
            // If the team haven't made any points
            if model.actualPoints == 0 {
                showLosed()
            }
            // If somebody has scored but haven't won.
            else if model.teams[0].points != model.teams[1].points {
                showScored()
            }
            else {
                showTie()
            }
            showGetReadyTeam()
        }
        
    }
    
    func judgePose() -> Double {
        var score : Double
        let forms = Forms.shared
//        score = Double.random(in: 0.5 ..< 1.0)
//        print(model.secondsInPose)
//        return score
//        if startTracking {
//
//            if forms.Poses[0].leftArmCase == bodyPosition1.leftArmCase &&
//                forms.Poses[0].leftHandCase == bodyPosition1.leftHandCase &&
//                forms.Poses[0].leftKneeCase == bodyPosition1.leftKneeCase &&
//                forms.Poses[0].leftLegCase == bodyPosition1.leftLegCase &&
//                forms.Poses[0].rightArmCase == bodyPosition1.rightArmCase &&
//                forms.Poses[0].rightHandCase == bodyPosition1.rightHandCase &&
//                forms.Poses[0].rightKneeCase == bodyPosition1.rightKneeCase &&
//                forms.Poses[0].rightLegCase == bodyPosition1.rightLegCase {
//
////                print("certo")
//                return 1
//
//            } else { return 0 } //print("ta errado"); return 0}

        // print(bodyPosition1)

       // }
        return 0
    }
    
    func prize(){
        attachPoints()
        refreshScoreLabels()
    }
    
    func attachPoints(){
        model.actualPoints = pointsForPhase
        model.teams[model.actualTeam].points += pointsForPhase
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
            startPhase()
            return
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
        if model.time >= 10.0 {
            TimerLabel.text = String(Int(model.time))
        } else {
            TimerLabel.text = NSString(format: "%.1f", abs(Double(model.time))) as String
        }
    }
    
    func refreshScoreLabels() {
        redScoreLabel.text = String(model.teams[0].points)
        blueScoreLabel.text = String(model.teams[1].points)
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
    
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {

        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }


            
            //pra baixo é o sample code + código da andy

            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            let bodyOrientation = Transform(matrix: bodyAnchor.transform).rotation
            characterAnchor.position = bodyPosition + characterOffset
            // Also copy over the rotation of the body anchor, because the skeleton's pose
            // in the world is relative to the body anchor's rotation.
            characterAnchor.orientation = bodyOrientation

            if let character = character, character.parent == nil {
                // Attach the character to its anchor as soon as
                // 1. the body anchor was detected and
                // 2. the character was loaded.
                
                if showRobot {
                    characterAnchor.addChild(character)
                }
                
            }
            
            if let character = character{
                startTracking = true
//                bodyPosition1 = faustoKit.BodyTrackingPosition(character: character, bodyAnchor: bodyAnchor)
//                print(bodyPosition1.rightArmCase, ", ", bodyPosition1.rightHandCase)
                print(poseKit.BodyTrackingPosition(character: character, bodyAnchor: bodyAnchor))
            }
        }
    }
}
