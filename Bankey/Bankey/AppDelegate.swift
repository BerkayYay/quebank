//
//  AppDelegate.swift
//  Bankey
//
//  Created by Berkay YAY on 11.02.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let loginViewController = LoginViewController()
    let onboardingContainerVC = OnboardingContainerVC()
    let dummyVC = DummyVC()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        loginViewController.delegate = self
        onboardingContainerVC.delegate = self
        dummyVC.logoutDelegate = self
        window?.rootViewController = loginViewController
        return true
    }
}

extension AppDelegate: LoginViewControllerDelegate, OnboardingContainerVCDelegate, LogoutDelegate{
    func didLogout() {
        setRootViewController(loginViewController)
    }
    
    func didFinishOnboarding() {
        LocalState.hasOnboarded = true
        setRootViewController(dummyVC)
    }
    
    func didLogin() {
        if LocalState.hasOnboarded {
            setRootViewController(dummyVC)
        } else{
            setRootViewController(onboardingContainerVC)
        }
        
    }
}

extension AppDelegate {
    func setRootViewController(_ vc: UIViewController, animated: Bool = true){
        guard animated, let window = self.window else{
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil)
    }
}
