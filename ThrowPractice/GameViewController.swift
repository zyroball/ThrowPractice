//
//  GameViewController.swift
//  ThrowPractice
//
//  Created by yu_ookubo on 2018/03/14.
//  Copyright © 2018年 ThrowPractice. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate
{
    weak var sceneView : SCNView?
    var radialNode = SCNNode()
    var balls: NSMutableArray = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setupScene()
        self.createGround()
        self.createCamera()
        self.createBall()

    }

    func setupScene()
    {
        let sv = SCNView(frame: view.bounds)
        sv.backgroundColor = UIColor(hue: 0.3,
                                     saturation: 0.1,
                                     brightness: 0.1,
                                     alpha: 1)
        sv.scene = SCNScene()
        sv.autoenablesDefaultLighting = true
        sv.allowsCameraControl = true
        sv.delegate = self
        view.addSubview(sv)
        
        self.sceneView = sv
    }
    
    func createGround()
    {
        let ground = SCNBox(width: 15,
                            height: 0.1,
                            length: 15,
                            chamferRadius: 0)
        ground.firstMaterial?.diffuse.contents = UIColor(hue: 0.6,
                                                         saturation: 0.5,
                                                         brightness: 0.7,
                                                         alpha: 1)
        let groundNode = SCNNode(geometry: ground)
        groundNode.position = SCNVector3(x: 0,
                                         y: -1, z: 0)
        
        groundNode.physicsBody = SCNPhysicsBody.static()
        groundNode.physicsBody?.restitution = 0.8
        groundNode.physicsBody?.categoryBitMask = 1 << 2
        groundNode.physicsBody?.collisionBitMask = 1 << 1

        sceneView?.scene?.rootNode.addChildNode(groundNode)
    }
    
    func createBall() -> SCNNode
    {
        let ball = SCNSphere(radius: 0.2)
        ball.firstMaterial?.diffuse.contents = UIColor.white
        let ballNode = SCNNode(geometry: ball)

        return ballNode
    }
    
    func createCamera()
    {
        let camera = SCNNode()
        camera.camera = SCNCamera()
        camera.position = SCNVector3Make(-12.166028, 8.2300024, 20.9988766)
        camera.rotation = SCNVector4Make(-0.560657382, -0.814222217, -0.150681511, 0.637639999)

        sceneView?.scene?.rootNode.addChildNode(camera)
    }
    
    func runRadialAction()
    {
        let dw = Float(Double.pi) / 5.0

        let ball = createBall()
        ball.name = "1"
        ball.rotation = SCNVector4(x: 0,
                                   y: 8,
                                   z: 0,
                                   w: Float(1) * dw)
        ball.physicsBody = SCNPhysicsBody.dynamic()
        ball.physicsBody?.categoryBitMask = 1 << 1
        ball.physicsBody?.collisionBitMask = 1 << 2
        ball.physicsBody?.restitution = 1
        sceneView?.scene?.rootNode.addChildNode(ball)
        
        let dx = 3 * cos(Float(1) * dw)
        let dz = 3 * sin(Float(1) * dw)
        ball.physicsBody?.applyForce(SCNVector3(x: 20, y: 8, z: dz), asImpulse: true)
        ball.physicsBody?.angularDamping = 0.7
        
        self.balls.add(ball)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.sceneView?.scene?.rootNode.addChildNode(radialNode)
        runRadialAction()
    }
    
    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: TimeInterval)
    {
        for i in 0..<self.balls.count
        {
            let tmpBall = self.balls[i] as! SCNNode
            let dot = SCNBox(width: 0.04, height: 0.04, length: 0.04, chamferRadius: 0)
            dot.firstMaterial?.diffuse.contents = UIColor(hue: CGFloat(Int(tmpBall.name!)!) * 0.1,
                                                          saturation: 0.4, brightness: 1, alpha: 1)
            let dotNode = SCNNode(geometry: dot)
            dotNode.position = tmpBall.presentation.position
            self.radialNode.addChildNode(dotNode)
            
            if tmpBall.position.y < 0
            {
                tmpBall.removeFromParentNode()
            }
        }
    }
}
