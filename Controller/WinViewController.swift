//
//  WinViewController.swift
//  GetReady
//
//  Created by leonardo palinkas on 25/10/19.
//  Copyright © 2019 leonardo palinkas. All rights reserved.
//

import UIKit

class WinViewController: UIViewController {

    @IBOutlet weak var backGround: UIImageView!
    @IBOutlet weak var reload: UIButton!
    
    var model = Model.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshWinner()
        
    }
    func refreshWinner() {
        // If RED won
        if model.winner == 0 {
            self.backGround.image = UIImage(named: "redwin")
        }
        // If BLUE won
        else if model.winner == 1 {
            self.backGround.image = UIImage(named: "bluewin")
        }
        // Mensagem de Erro
        else {
            print("vencedor não atualizado na model!")
        }
    }
}
