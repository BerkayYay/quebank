//
//  AppDelegate.swift
//  Bankey
//
//  Created by Berkay YAY on 11.02.2023.
//

import UIKit
let appColor: UIColor = .systemTeal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let loginViewController = LoginViewController()
    let onboardingContainerVC = OnboardingContainerVC()
    let mainVC = MainViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        loginViewController.delegate = self
        onboardingContainerVC.delegate = self
        
        registerForNotifications()
        
        displayLogin()
        return true
    }
    
    private func registerForNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout), name: .logout, object: nil)
    }
    
    private func displayLogin(){
        setRootViewController(loginViewController)
//        setRootViewController(mainVC)
    }
    
    private func displayNextScreen(){
        if LocalState.hasOnboarded {
            prepMainView()
            setRootViewController(mainVC)
        } else {
            setRootViewController(onboardingContainerVC)
        }
    }
    
    private func prepMainView(){
        mainVC.setStatusBar()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = appColor
    }
}

extension AppDelegate: LoginViewControllerDelegate, OnboardingContainerVCDelegate, LogoutDelegate{
    @objc func didLogout() {
        setRootViewController(loginViewController)
    }
    
    func didFinishOnboarding() {
        LocalState.hasOnboarded = true
        prepMainView()
        setRootViewController(mainVC)
    }
    
    func didLogin() {
       displayNextScreen()
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
