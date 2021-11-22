//
//  ViewController.swift
//  EntityViewTest
//
//  Created by Jiri Urbasek on 19.11.2021.
//

import UIKit
import SwiftUI

class EntityViewController: UIViewController {

    @IBOutlet weak var tabContainerView: UIView!
    @IBOutlet weak var contentContainerView: UIView!
    
    private lazy var tabbedMenuViewModel: TabbedMenuViewModel = {
        .init(
            itemViewModels: [
                .init(title: "Work Template", isSelected: true, selection: { self.show(content: self.contentControllers[0]) }),
                .init(title: "Fields", selection: { self.show(content: self.contentControllers[1]) }),
                .init(title: "Attachments", selection: { self.show(content: self.contentControllers[2]) }),
                .init(title: "Subtasks", selection: { self.show(content: self.contentControllers[3]) })
            ]
        )
    }()
    
    private lazy var tabController: UIViewController = {
        UIHostingController(
            rootView: ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .edgesIgnoringSafeArea(.all)
                
                TabbedMenuView(viewModel: tabbedMenuViewModel)
            }
        )
    }()
    
    private lazy var contentControllers: [UIViewController] = [
        ContentViewController(title: "My Work Template", color: .gray),
        ContentViewController(title: "Fields", color: .blue),
        ContentViewController(title: "Attachments", color: .purple),
        ContentViewController(title: "Subtasks", color: .magenta)
    ]
    
    private lazy var pageController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        add(tabController, into: tabContainerView)
        
        pageController.setViewControllers([contentControllers[0]], direction: .forward, animated: false, completion: nil)
        pageController.dataSource = self
        pageController.delegate = self
        
        //show(content: pageController)
        add(pageController, into: contentContainerView)
    }
    
    private var currentContentController: UIViewController?
    private func show(content contentController: UIViewController) {
        if pageController.viewControllers != [contentController] {
            pageController.setViewControllers([contentController], direction: .forward, animated: false, completion: nil)
        }
    }
}

extension EntityViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let idx = contentControllers.firstIndex(of: viewController) {
            let newIdx = idx - 1
            if newIdx >= 0 {
                return contentControllers[newIdx]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let idx = contentControllers.firstIndex(of: viewController) {
            let newIdx = idx + 1
            if newIdx < contentControllers.count {
                return contentControllers[newIdx]
            }
        }
        return nil
    }
}

extension EntityViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentPage = pageViewController.viewControllers?.first, let idx = contentControllers.firstIndex(of: currentPage) {
            let item = tabbedMenuViewModel.items[idx]
            
            tabbedMenuViewModel.select(item)
        }
    }
}

@nonobjc extension UIViewController {
    func add(_ child: UIViewController, into view: UIView) {
        addChild(child)
        view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            child.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            child.view.topAnchor.constraint(equalTo: view.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        child.didMove(toParent: self)
    }

    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

