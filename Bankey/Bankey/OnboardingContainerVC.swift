//
//  OnboardingContainerVC.swift
//  Bankey
//
//  Created by Berkay YAY on 13.02.2023.
//

import UIKit

class OnboardingContainerVC: UIViewController{
    
    let pageVC : UIPageViewController
    var pages = [UIViewController]()
    var currentVC: UIViewController{
        didSet{
            
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        let page1 = ViewController1()
        let page2 = ViewController2()
        let page3 = ViewController3()
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


// MARK: - ViewControllers
class ViewController1 : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }
}

class ViewController2 : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
    }
}

class ViewController3 : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
    }
}

