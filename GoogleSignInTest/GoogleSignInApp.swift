//
//  GoogleSignInApp.swift
//  GoogleSignInTest
//
//  Created by user on 06.05.2025.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift


@main
struct GoogleSignInApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        let configuration =
        GIDConfiguration(clientID: "953928813196-gjdok659efkalecmdakk26s8oqbngrs1.apps.googleusercontent.com",
                         serverClientID: "com.googleusercontent.apps.953928813196-gjdok659efkalecmdakk26s8oqbngrs1",
                         hostedDomain: nil, openIDRealm: nil)
        GIDSignIn.sharedInstance.configuration = configuration
    }
    
    var body: some Scene {
        WindowGroup {
            GoogleSignInPaintView()
            //GoogleSignInAuthView()
        }
    }
}

final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(#function, url)
        return GIDSignIn.sharedInstance.handle(url)
    }
}
