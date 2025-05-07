//
//  GoogleSignInPaintView.swift
//  GoogleSignInTest
//
//  Created by user on 06.05.2025.
//

import SwiftUI
import PencilKit
import Combine


/// Главная вьюшка для рисования.
/// Даёт возможность импортировать изображение
/// или вызвать окно для применения фильтров.
struct GoogleSignInPaintView: View {
    @Environment(\.displayScale) var displayScale: CGFloat
    
    @State private var canvasView = PKCanvasView()
    @State private var toolPicker = PKToolPicker()
    @State private var updatedImage: UIImage?
    
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
                    if let updatedImage = self.updatedImage {
                        ShareLink(item: GoogleSignInShareImage(image: updatedImage),
                                  preview: SharePreview(GoogleSignInShareImage.fileName, image: Image(uiImage: updatedImage)), label: {
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
                    if self.updatedImage != nil {
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
                if let updatedImage = self.updatedImage {
                    NavigationStack(root: {
                        let filtersView = GoogleSignInFiltersView(image: updatedImage)
                        filtersView
                            .onReceive(filtersView.publisher, perform: { _ in
                                self.showingFiltersView = false
                            })
                    })
                }
            })
    }
    
    private func onSaved(canvasView: PKCanvasView) {
        let updatedImage = canvasView.drawing.image(from: canvasView.bounds, scale: self.displayScale)
        self.updatedImage = updatedImage
    }
}

