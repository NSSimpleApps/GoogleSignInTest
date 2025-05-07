//
//  GoogleSignInPaintView.swift
//  GoogleSignInTest
//
//  Created by user on 06.05.2025.
//

import SwiftUI
import PencilKit
import Combine


struct GoogleSignInImageState {
    let originalImage: UIImage
    let filteredImage: UIImage
}

struct GoogleSignInPaintView: View {
    @Environment(\.displayScale) var displayScale: CGFloat
    
    @State private var canvasView = PKCanvasView()
    @State private var toolPicker = PKToolPicker()
    @State private var imageState: GoogleSignInImageState?
    
    @Environment(\.undoManager) private var undoManager
    
    @State private var showingFiltersView = false
    
    var body: some View {
        GoogleSignInCanvasView(canvasView: self.$canvasView, toolPicker: self.$toolPicker,
                               onSaved: { canvasView in
            self.onSaved(canvasView: canvasView)
        })
            .navigationTitle("Drawing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    if let filteredImage = self.imageState?.filteredImage {
                        ShareLink(item: GoogleSignInShareImage(image: filteredImage),
                                  preview: SharePreview(GoogleSignInShareImage.fileName, image: Image(uiImage: filteredImage)), label: {
                            Image(systemName: "square.and.arrow.up")
                        })
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        self.undoManager?.undo()
                        self.onSaved(canvasView: self.canvasView)
                    }, label: {
                        Image(systemName: "arrow.uturn.left")
                    })
                }
                ToolbarItem(placement: .topBarLeading) {
                    if self.imageState != nil {
                        Button("Filters", action: {
                            self.toolPicker.setVisible(false, forFirstResponder: self.canvasView)
                            self.showingFiltersView = true
                        })
                    }
                }
            })
            .sheet(isPresented: self.$showingFiltersView,
                   onDismiss: {
                self.toolPicker.setVisible(true, forFirstResponder: self.canvasView)
            },
                   content: {
                if let filteredImage = self.imageState?.filteredImage {
                    NavigationStack(root: {
                        let filtersView = GoogleSignInFiltersView(originalImage: filteredImage)
                        filtersView
                            .onReceive(filtersView.publisher, perform: { _ in
                                self.showingFiltersView = false
                            })
                    })
                }
            })
    }
    
    private func onSaved(canvasView: PKCanvasView) {
        let filteredImage = canvasView.drawing.image(from: canvasView.bounds, scale: self.displayScale)
        
        if let imageState = self.imageState {
            let newImageState = GoogleSignInImageState(originalImage: imageState.originalImage, filteredImage: filteredImage)
            self.imageState = newImageState
        } else {
            let imageState = GoogleSignInImageState(originalImage: filteredImage, filteredImage: filteredImage)
            self.imageState = imageState
        }
    }
}

