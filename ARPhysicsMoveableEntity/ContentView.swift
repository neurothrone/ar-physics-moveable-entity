//
//  ContentView.swift
//  ARPhysicsMoveableEntity
//
//  Created by Zaid Neurothrone on 2022-10-15.
//

import RealityKit
import SwiftUI

struct ContentView : View {
  var body: some View {
    ARViewContainer().edgesIgnoringSafeArea(.all)
  }
}

struct ARViewContainer: UIViewRepresentable {
  
  func makeUIView(context: Context) -> ARView {
    let arView = ARView(frame: .zero)
    context.coordinator.view = arView
    context.coordinator.buildEnvironment()
    return arView
  }
  
  func makeCoordinator() -> Coordinator {
    .init()
  }
  
  func updateUIView(_ uiView: ARView, context: Context) {}
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
