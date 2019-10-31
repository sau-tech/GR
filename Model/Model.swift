//
//  Model.swift
//  GetReady
//
//  Created by Saulo de Freitas Martins da Silva on 30/10/19.
//  Copyright © 2019 leonardo palinkas. All rights reserved.
//

import Foundation

class Model {
    static var shared = Model()
    
    var time = TimeInterval(10.0)
    var vencedor = -1
    // The Team[0] is the red team and the Team [1] is the blue one.
    var teams : [Team] = [Team(pts: 50), Team(pts: 20)]
}
