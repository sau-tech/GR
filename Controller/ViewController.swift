

import UIKit
import SpriteKit
import ARKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var model = Model.shared
    var timer = Timer()
    
    @IBOutlet weak var txtWelcome: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var txtRedScore: UILabel!
    @IBOutlet weak var txtBlueScore: UILabel!
    @IBOutlet weak var txtTimer: UILabel!
    @IBOutlet weak var form: UIImageView!

    @IBOutlet weak var prepareToPlayView: UIView!
    @IBOutlet weak var previewView: UIView!
    
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
        
        iniciarTimer(segundos: 10)
        
        txtRedScore.text = String(model.teams[0].points)
        txtBlueScore.text = String(model.teams[1].points)
        
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
    
    func iniciarTimer(segundos: TimeInterval) {
        model.time = segundos
        refreshTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.passoTimer()
        })
    }
    
    // A cada iteração (1 segundo), executa:
    func passoTimer(){
        
        if model.time > 0 {
            model.time -= 1
            refreshTimer()
        } else {
            print("cabou o tempo!")
        }
    }
    
    func refreshTimer() {
        refreshTimerLabels()
    }
    
    func refreshTimerLabels() {
        txtTimer.text = String(Int(model.time))
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
}
