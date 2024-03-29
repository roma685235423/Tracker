import UIKit

final class OnboardingPageController: UIPageViewController {
    
    // MARK: Private properties
    
    private let goToTrackerScreenButton = UIButton(
        label: NSLocalizedString("onboarding.button", comment: "")
    )
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlackDay
        pageControl.pageIndicatorTintColor = .ypBlackDayTint
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    @UserDefaultsBacked(key: "isOnboardingShown", defaultValue: false)
    private var isOnboardingShown: Bool
    private var currentIndex: Int = 0
    private lazy var pages: [UIViewController] = [
        OnboardingViewController(page: .first),
        OnboardingViewController(page: .second)
    ]
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
        if let first = pages.first {
            self.setViewControllers([first], direction: .forward, animated: false, completion: nil)
        }
        goToTrackerScreenButton.addToSuperview(view)
        view.addSubviews([goToTrackerScreenButton, pageControl])
        goToTrackerScreenButton.addTarget(self, action: #selector(didTapGoToTrackerScreenButton), for: .touchUpInside)
        layoutConfigure()
        goToTrackerScreenButton.setStaticColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentIndex = 0
        pageControl.currentPage = 0
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingPageController: UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return pages[pages.count - 1]
        }
        return pages[previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return pages[0]
        }
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingPageController: UIPageViewControllerDelegate {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
            self.currentIndex = currentIndex
        }
    }
}

// MARK: - Private methods

private extension OnboardingPageController {
    
    func layoutConfigure() {
        goToTrackerScreenButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            goToTrackerScreenButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            goToTrackerScreenButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            goToTrackerScreenButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            goToTrackerScreenButton.heightAnchor.constraint(equalToConstant: 60),
            
            pageControl.bottomAnchor.constraint(equalTo: goToTrackerScreenButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func showTabBar() {
        let tabBarViewController = TabBarViewController()
        tabBarViewController.awakeFromNib()
        let window = UIApplication.shared.windows.first
        window?.rootViewController = tabBarViewController
    }
    
    // MARK: Action
    
    @objc
    func didTapGoToTrackerScreenButton() {
        showTabBar()
        isOnboardingShown = true
    }
    
    @objc
    func pageControlValueChanged() {
        guard let currentViewController = viewControllers?.first,
              let currentIndex = pages.firstIndex(of: currentViewController),
              currentIndex != pageControl.currentPage else {
            return
        }
        let selectedViewController = pages[pageControl.currentPage]
        let direction: UIPageViewController.NavigationDirection = currentIndex < pageControl.currentPage ? .forward : .reverse
        setViewControllers([selectedViewController], direction: direction, animated: true, completion: nil)
        
        self.currentIndex = pageControl.currentPage
    }
}
