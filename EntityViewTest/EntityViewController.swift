//
//  ViewController.swift
//  EntityViewTest
//
//  Created by Jiri Urbasek on 19.11.2021.
//

import UIKit
import SwiftUI
import Combine

class EntityViewController: UIViewController {

    @IBOutlet weak var tabContainerView: UIView!
    @IBOutlet weak var contentContainerView: UIView!
    
    var viewModel: EntityViewModel!
    
    private lazy var tabbedMenuViewModel: TabbedMenuViewModel = {
        .init(
            itemViewModels: viewModel.contentItems.map { contentItem in
                    .init(
                        title: contentItem.title,
                        isSelected: contentItem.id == viewModel.selectedItem?.id,
                        selection: { self.viewModel.show(content: contentItem) }
                    )
            }
        )
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    
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
    
    private var contentControllers: [UIViewController] = []
    
    private lazy var pageController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        controller.dataSource = self
        controller.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        if let initialySelectedController = viewModel.selectedItem?.viewController {
            pageController.setViewControllers([initialySelectedController()], direction: .forward, animated: false, completion: nil)
        }

        add(tabController, into: tabContainerView)
        add(pageController, into: contentContainerView)
        
        viewModel.$selectedItem
            .sink { [weak self] in
                guard let item = $0 else { return }
                
                self?.show(content: item.viewController())
            }
            .store(in: &cancellables)
        
        viewModel.$contentItems
            .sink { [weak self] in
                self?.contentControllers = $0.map { $0.viewController() }
            }
            .store(in: &cancellables)
    }
    
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

