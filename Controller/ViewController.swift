

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var BtnCapture: UIButton!
    @IBOutlet weak var BtnPause: UIButton!
    @IBOutlet weak var txtWelcome: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var txtRedScore: UILabel!
    @IBOutlet weak var txtBlueScore: UILabel!
    @IBOutlet weak var txtTimer: UILabel!
    @IBOutlet weak var form: UIImageView!
    @IBOutlet weak var contador: UILabel!

    @IBOutlet weak var prepareToPlayView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        
        prepareToPlayView.isHidden = false
        prepareToPlayView.alpha = 1
        btnPlay.isEnabled = true
        
        super.viewWillAppear(animated)
        
    }
    
    
    @IBAction func welcome(_ sender: Any) {
        prepareToPlayView.isHidden = true
        prepareToPlayView.alpha = 1
        btnPlay.isEnabled = false
        form.isHidden = false
        form.alpha = 1
    }
    
}
    
  
    


