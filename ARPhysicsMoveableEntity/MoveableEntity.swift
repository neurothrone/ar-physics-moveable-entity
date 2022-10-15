//
//  MoveableEntity.swift
//  ARPhysicsCollisionDetection2
//
//  Created by Zaid Neurothrone on 2022-10-15.
//

import RealityKit
import UIKit

enum Shape {
  case box
  case sphere
}

final class MoveableEntity: Entity, HasModel, HasPhysics, HasCollision {
  var size: Float!
  var color: UIColor!
  var shape: Shape = .box
  
  init(size: Float, color: UIColor, shape: Shape) {
    super.init()
    self.size = size
    self.color = color
    self.shape = shape
    
    let mesh = generateMeshResource()
    let materials = [generateMaterial()]
    model = ModelComponent(mesh: mesh, materials: materials)
    
    physicsBody = PhysicsBodyComponent(massProperties: .default, material: .default, mode: .dynamic)
    collision = CollisionComponent(shapes: [generateShapeResource()], mode: .trigger, filter: .sensor)
    generateCollisionShapes(recursive: true)
  }
  
  required init() {
    fatalError("init() has not been implemented")
  }
  
  private func generateMeshResource() -> MeshResource {
    switch shape {
    case .box:
      return MeshResource.generateBox(size: size)
    case .sphere:
      return MeshResource.generateSphere(radius: size)
    }
  }
  
  private func generateMaterial() -> Material {
    SimpleMaterial(color: color, isMetallic: true)
  }
  
  private func generateShapeResource() -> ShapeResource {
    switch shape {
    case .box:
      return ShapeResource.generateBox(size: [size, size, size])
    case .sphere:
      return ShapeResource.generateSphere(radius: size)
    }
  }
}
