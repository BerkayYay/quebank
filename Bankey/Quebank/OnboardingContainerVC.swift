//
//  OnboardingContainerVC.swift
//  Bankey
//
//  Created by Berkay YAY on 13.02.2023.
//

import UIKit

protocol OnboardingContainerVCDelegate: AnyObject {
    func didFinishOnboarding()
}

class OnboardingContainerVC: UIViewController{
    
    let pageVC : UIPageViewController
    var pages = [UIViewController]()
    var currentVC: UIViewController {
        didSet{
            guard let index = pages.firstIndex(of: currentVC) else {return}
            nextButton.isHidden = index == pages.count - 1 // hide if on last page
            backButton.isHidden = index == 0
            doneButton.isHidden = !(index == pages.count - 1) // show if on last page
        }
    }
    let nextButton = UIButton(type: .system)
    let backButton = UIButton(type: .system)
    let doneButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    
    weak var delegate: OnboardingContainerVCDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        let page1 = OnboardingVC(heroImageName: "delorean", titleText: "Quebank is faster, easier to use and has a brand new look and fell that will make you feel like you are back in 1989.")
        let page2 = OnboardingVC(heroImageName: "world", titleText: "Move your money around the world quickly and securely")
        let page3 = OnboardingVC(heroImageName: "thumbs", titleText: "Learn more at www.bankey.com")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        currentVC = pages.first!
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        style()
        layout()
        
        
    }
    
    // MARK: - Functions
    private func setup(){
        view.backgroundColor = .systemPurple
        
        addChild(pageVC)
        view.addSubview(pageVC.view)
        pageVC.didMove(toParent: self)
        
        pageVC.dataSource = self
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: pageVC.view.topAnchor),
            view.leadingAnchor.constraint(equalTo: pageVC.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: pageVC.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: pageVC.view.bottomAnchor)
        ])
        
        pageVC.setViewControllers([pages.first!], direction: .forward, animated: false)
        currentVC = pages.first!
    }
    
    private func style(){
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: [])
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .primaryActionTriggered)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("Back", for: [])
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .primaryActionTriggered)
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Done", for: [])
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .primaryActionTriggered)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Close", for: [])
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .primaryActionTriggered)
    }
    
    private func layout(){
        view.addSubview(nextButton)
        view.addSubview(backButton)
        view.addSubview(closeButton)
        view.addSubview(doneButton)
        
        // Close Button
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            closeButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
        ])
        
        // Back Button
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: backButton.bottomAnchor, multiplier: 8)
            
        ])
        
        // Next Button
        NSLayoutConstraint.activate([
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: nextButton.trailingAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: nextButton.bottomAnchor, multiplier: 8)
        ])
        
        //Done Button
        NSLayoutConstraint.activate([
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: doneButton.trailingAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: doneButton.bottomAnchor, multiplier: 8)
        ])
    }
    
}

// MARK: - UIPageVCDataSource
extension OnboardingContainerVC : UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getPreviousVC(from: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getNextVC(from: viewController)
    }
    
    private func getPreviousVC(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index - 1 >= 0 else {return nil}
        currentVC = pages[index - 1]
        return pages[index - 1]
    }
    
    private func getNextVC(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index + 1 < pages.count else {return nil}
        currentVC = pages[index + 1]
        return pages[index + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.firstIndex(of: self.currentVC) ?? 0
    }
}

// MARK: - Actions
extension OnboardingContainerVC {
    
    @objc func closeButtonTapped(_ sender: UIButton){
        delegate?.didFinishOnboarding()
    }
    
    @objc func nextButtonTapped(_ sender: UIButton){
        guard let nextVC = getNextVC(from: currentVC) else {return}
        pageVC.setViewControllers([nextVC], direction: .forward, animated: true)
    }
    
    @objc func backButtonTapped(_ sender: UIButton){
        guard let previousVC = getPreviousVC(from: currentVC) else {return}
        pageVC.setViewControllers([previousVC], direction: .reverse, animated: true)
    }
    
    @objc func doneButtonTapped(_ sender: UIButton){
        delegate?.didFinishOnboarding()
    }

}



