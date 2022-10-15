//
//  Coordinator.swift
//  ARGravity
//
//  Created by Zaid Neurothrone on 2022-10-15.
//

import ARKit
import Combine
import Foundation
import RealityKit

final class Coordinator: NSObject, ARSessionDelegate {
  weak var view: ARView?

  var movableEntities: [MoveableEntity] = []

  func buildEnvironment() {
    guard let view = view else { return }
    
    let anchor = AnchorEntity(plane: .horizontal)
    
    // Create a floor
    let floor = ModelEntity(mesh: .generatePlane(width: 1, depth: 1), materials: [SimpleMaterial(color: .green, isMetallic: true)])
    floor.generateCollisionShapes(recursive: true)
    floor.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .static)
    
    let box1 = MoveableEntity(size: 0.3, color: .purple, shape: .box)
    let box2 = MoveableEntity(size: 0.3, color: .blue, shape: .box)
    let sphere1 = MoveableEntity(size: 0.3, color: .systemPink, shape: .sphere)
    let sphere2 = MoveableEntity(size: 0.3, color: .orange, shape: .sphere)    
    
    for entity in [box1, box2, sphere1, sphere2] {
      anchor.addChild(entity)
      movableEntities.append(entity)
    }
    
    anchor.addChild(floor)
    view.scene.addAnchor(anchor)
    
    movableEntities.forEach { entity in
      view.installGestures(.all, for: entity).forEach { entityGestureDelegate in
        entityGestureDelegate.delegate = self
      }
    }
    
    setUpGestures()
  }
  
  fileprivate func setUpGestures() {
    guard let view = view else { return }
    
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panned))
    panGesture.delegate = self
    view.addGestureRecognizer(panGesture)
  }
  
  @objc func panned(_ sender: UIPanGestureRecognizer) {
    switch sender.state {
    case .ended, .cancelled, .failed:
      // Change the physics mode to dynamic
      // First get all non-null entities
      movableEntities.compactMap { $0 }.forEach { entity in
        entity.physicsBody?.mode = .dynamic
      }
    default:
      return
    }
  }
}

extension Coordinator: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard let translationGesture = gestureRecognizer as? EntityTranslationGestureRecognizer,
          let entity = translationGesture.entity as? MoveableEntity else {
      return true
    }
    
    entity.physicsBody?.mode = .kinematic
    return true
  }
}
