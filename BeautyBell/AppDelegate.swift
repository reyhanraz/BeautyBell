//
//  AppDelegate.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 21/06/21.
//

import UIKit
import FBSDKCoreKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import GRDB
import GoogleMaps
import GooglePlaces

public protocol AppDelegateType {
    var dbQueue: DatabaseQueue! { get }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppDelegateType {
    
    var dbQueue: DatabaseQueue!

    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        try! setupDatabase(application)

        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        GMSServices.provideAPIKey("AIzaSyArS0GikL_aZLZBxX0rnSq3Aqi76P63J28")
        GMSPlacesClient.provideAPIKey("AIzaSyArS0GikL_aZLZBxX0rnSq3Aqi76P63J28")

        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self

        return true
    }
          
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {

        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

    }
    
    private func setupDatabase(_ application: UIApplication) throws {
        let databaseURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("beautybell")
        
        dbQueue = try AppDatabase.openDatabase(atPath: databaseURL.path)
    }

}
    
extension  AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            if let error = error {
                print("Failed to sign in with Google: \(error)")
            }
            return
        }

        guard let user = user else {
            return
        }

        print("Did sign in with Google: \(user)")

        let email = user.profile.email
        let name = user.profile.name
        var imageURL = URL(string: "")
        
        if user.profile.hasImage{
            imageURL = user.profile.imageURL(withDimension: 150)
        }
        let users = Users(name: name ?? "", imageURL: imageURL?.path ?? "", dateOfBirth: "", email: email ?? "")
        UserProfileCache.save(users)
        
        guard let authentication = user.authentication else {
            print("Missing auth object off of google user")
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
            guard authResult != nil, error == nil else {
                print("failed to log in with google credential")
                return
            }

            print("Successfully signed in with Google cred.")
            NotificationCenter.default.post(name: .didLogInNotification, object: nil)
        })
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google user was disconnected")
    }
}
