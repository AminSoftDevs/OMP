//
//  MarketsBriefPageViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/6/21.
//

import UIKit

class MarketsBriefPageViewController: UIPageViewController {

    //MARK: - INITIALIZER
    let viewModel: MarketsBriefPageViewControllerViewModel
    
    init(viewModel: MarketsBriefPageViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.setViewControllers(viewModel.getInitialViewController(), direction: .forward, animated: true, completion: nil)
        viewModel.getMarketsListAPI()
    }
    
    func shouldShowPageWithIndex(index: Int) {
        if index < viewModel.currentlyShowingPageIndex {
            self.setViewControllers(viewModel.getNextViewController(index: index), direction: .forward, animated: true, completion: nil)
        } else {
            self.setViewControllers(viewModel.getNextViewController(index: index), direction: .reverse, animated: true, completion: nil)
        }
    }
    
}

extension MarketsBriefPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return viewModel.getViewControllerBeforeThisViewController(this: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return viewModel.getViewControllerAfterThisViewController(this: viewController)
    }
}

extension MarketsBriefPageViewController {
    static func makeInstance() -> MarketsBriefPageViewController {
        .init(viewModel: MarketsBriefPageViewControllerViewModel(type: .brief))
    }
}
