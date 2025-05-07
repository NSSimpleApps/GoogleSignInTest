//
//  GoogleSignInShareImage.swift
//  GoogleSignInTest
//
//  Created by user on 07.05.2025.
//

import SwiftUI

/// Структура для импорта изображения.
/// Реализует протокол `Transferable`.
struct GoogleSignInShareImage: Transferable {
    let image: UIImage
    static var fileName: String { "image.jpg" }
    
    static var transferRepresentation: some TransferRepresentation {
        return DataRepresentation<Self>(exportedContentType: .image,
                                        exporting: { sSelf in
            return sSelf.image.jpegData(compressionQuality: 1) ?? Data()
            
        }).suggestedFileName(Self.fileName)
    }
}
