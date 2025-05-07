//
//  GoogleSignInCanvasView.swift
//  GoogleSignInTest
//
//  Created by user on 07.05.2025.
//

import SwiftUI
import PencilKit

struct GoogleSignInCanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var toolPicker: PKToolPicker
    let onSaved: (PKCanvasView) -> Void
    
    func makeUIView(context: Context) -> PKCanvasView {
        self.canvasView.tool = PKInkingTool(.pen, color: .gray, width: 10)
        
//#if targetEnvironment(simulator)
//        self.canvasView.drawingPolicy = .pencilOnly
//#endif
        self.canvasView.delegate = context.coordinator
        self.showToolPicker()
        
        return self.canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) { }
    
    func makeCoordinator() -> GoogleSignInCoordinator {
        return .init(onSaved: self.onSaved)
    }
    
    func showToolPicker() {
        self.toolPicker.setVisible(true, forFirstResponder: self.canvasView)
        self.toolPicker.addObserver(self.canvasView)
        
        self.canvasView.becomeFirstResponder()
    }
}

final class GoogleSignInCoordinator: NSObject, PKCanvasViewDelegate {
    //let canvasView: Binding<PKCanvasView>
    let onSaved: (PKCanvasView) -> Void
    
    init(onSaved: @escaping (PKCanvasView) -> Void) {
        self.onSaved = onSaved
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        if canvasView.drawing.bounds.isEmpty == false {
            self.onSaved(canvasView)
        }
    }
}
