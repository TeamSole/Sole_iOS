//
//  AppDelegate.swift
//  SoleApp
//
//  Created by SUN on 2023/02/06.
//

import UIKit
import KakaoSDKCommon
import NMapsMap

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let shared = UIApplication.shared.delegate as! AppDelegate
    
    var mainViewModel = MainViewModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KakaoSDK.initSDK(appKey: Constant.kakaoAppKey)
        NMFAuthManager.shared().clientId = Constant.nmfClientId
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }


}

