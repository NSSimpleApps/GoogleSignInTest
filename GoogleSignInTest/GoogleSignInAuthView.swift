//
//  GoogleSignInAuthView.swift
//  GoogleSignInTest
//
//  Created by user on 06.05.2025.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

/// Вьюшка для входа в гугл-аккаунт.
struct GoogleSignInAuthView: View {
    var body: some View {
        GoogleSignInButton {
            if let rootViewController = UIApplication.shared.appercodeKeyWindow?.rootViewController {
                GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController, completion: { signInResult, error in
                    print(signInResult, error)
                })
            }
        }
    }
}

/// Расширение над `UIApplication` для получения главного окна приложения.
extension UIApplication {
    var appercodeKeyWindow: UIWindow? {
        if let sceneDelegate = self.connectedScenes.first?.delegate as? UIWindowSceneDelegate {
            if let window = sceneDelegate.window {
                return window
            }
        }
        return nil
    }
}
