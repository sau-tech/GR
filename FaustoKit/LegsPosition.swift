//
//  LegsPosition.swift
//  BodyDetection
//
//  Created by Vinicius Dilay on 31/10/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import ARKit
import RealityKit

struct legCases {
    let legCase : LegToKneeCase
    let kneeCase: KneeToFootCase
}


public enum LegToKneeCase {
    case straight //perna reta
    case halfOpen //perna meio-aberta
    case Open     //perna totalmente aberta
}
//depende doq?
public enum LegToKneeSubcase {
    case straightReto   //perna reta e reta pra baixo
    case straightBack   //perna reta más pra trás
    case halfOpenMiddleFront //perna meio aberta e meio pra frente
    case halfOpenReto       //perna meio aberta e reta
    case halfOpenFront      //perna meio aberta e para frente
    case openReto           //perna aberta e reta
    case openMiddleFront    //perna aberta e meio pra frente
    case openFront          //perna aberta pra frente
}

//depende do angulo
public enum KneeToFootCase {
    case straight       //esticada
    case bentOut        //um pouco dobrada
    case bent           //dobrada
    case bentIn         //muito dobrada
}

//ver casos com as duas pernas (de pé, agachado, sentado, etc)

class LegsPosition  {
    let bodyPart = BodyPart()
    
    func LegToKneePos( kneeTransform: simd_float4, legTransform: simd_float4) -> LegToKneeCase {
        let vectorLegToKnee = bodyPart.vector(joint1: kneeTransform, joint2: legTransform)
        let legToKneeCase: LegToKneeCase
        
        //         print(vectorLegToKnee.y)//, "eixo z: ", vectorLegToKnee.z)
        if vectorLegToKnee.y < 0.15 { legToKneeCase = .Open }
        else if vectorLegToKnee.y < 0.35 { legToKneeCase = .halfOpen }
        else { legToKneeCase = .straight }
        
        return LegToKneePosZ(kneeTransform: kneeTransform, legTransform: legTransform, legToKneeCase: legToKneeCase )
    }
    
    func LegToKneePosZ(kneeTransform: simd_float4, legTransform: simd_float4, legToKneeCase : LegToKneeCase) -> LegToKneeCase {
        let vectorLegToKnee = bodyPart.vector(joint1: kneeTransform, joint2: legTransform)

        if legToKneeCase == .straight {
//            if vectorLegToKnee.z < -0.05 { return .straightBack }
//            else {return .straightReto }
//            return .straightReto
            return .straight
        } else if legToKneeCase == .halfOpen{
//            if vectorLegToKnee.z < 0.05 { return .halfOpenReto}
//            else if vectorLegToKnee.z < 0.15 { return .halfOpenMiddleFront}
//            else {return .halfOpenFront}
            return .halfOpen
        } else {
//            if vectorLegToKnee.z < 0.05 { return .openReto}
//            else if vectorLegToKnee.z < 0.15 { return .openMiddleFront}
//            else { return .openFront}
            return .Open
        }
    }
    
    func KneeToFootPos(kneeTransform: simd_float4, legTransform: simd_float4, footTransform: simd_float4, legToKneeSubcase: LegToKneeCase ) -> KneeToFootCase {

        let vectorLegToKnee = bodyPart.vector(joint1: kneeTransform, joint2: legTransform)
        let vectorKneeToFoot = bodyPart.vector(joint1: legTransform, joint2: footTransform)
        
        let kneeBentAngle = bodyPart.angle(vector1: vectorLegToKnee, vector2: vectorKneeToFoot)
        
        if kneeBentAngle > 80 {return .straight}
        else if kneeBentAngle > 65 {return .bentOut}
        else if kneeBentAngle > 45 {return .bent}
        else {return .bentIn}
    }
}
