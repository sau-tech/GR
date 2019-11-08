//
//  FaustoKit.swift
//  BodyDetection
//
//  Created by Vinicius Dilay on 30/10/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import ARKit
import RealityKit

struct PositionCases {
    let leftArmCase : ShoulderToForearmSubcase
    let leftHandCase: ForearmToHandSubcase
    
    let rightArmCase : ShoulderToForearmSubcase
    let rightHandCase: ForearmToHandSubcase
    
    let leftLegCase : LegToKneeSubcase
    let leftKneeCase: KneeToFootCase
    
    let rightLegCase : LegToKneeSubcase
    let rightKneeCase: KneeToFootCase
}
// interface de comunicação com o resto do programa (facade pattern)
public class FaustoKit {
    
    func BodyTrackingPosition(character: BodyTrackedEntity?, bodyAnchor: ARBodyAnchor) -> PositionCases {
        let leftArm = LeftArmPosition(character: character, bodyAnchor: bodyAnchor)
        let rightArm = RightArmPosition(character: character, bodyAnchor: bodyAnchor)
        
        let leftLeg = LeftLegPosition(character: character, bodyAnchor: bodyAnchor)
        let rightLeg = RightLegPosition(character: character, bodyAnchor: bodyAnchor)

        let leftArmCase = leftArm.lArmPosition(character: character, bodyAnchor: bodyAnchor)
        let rightArmCase = rightArm.rArmPosition(character: character, bodyAnchor: bodyAnchor)
        let leftLegCase = leftLeg.lLegPos(character: character, bodyAnchor: bodyAnchor)
        let rightLegCase = rightLeg.rLegPos(character: character, bodyAnchor: bodyAnchor)

        return PositionCases(leftArmCase: leftArmCase.ArmCase, leftHandCase: leftArmCase.HandCase, rightArmCase: rightArmCase.ArmCase, rightHandCase: rightArmCase.HandCase,
            leftLegCase: leftLegCase.legCase, leftKneeCase: leftLegCase.kneeCase,
            rightLegCase: rightLegCase.legCase, rightKneeCase: rightLegCase.kneeCase)
    }
}
