//
//  MainFlowController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/3.
//

import UIKit

protocol MainFlowControllerDelegate: AnyObject {
    func mainFlowControllerDidFinish(_ flowController: UIViewController)
}

protocol BarButtonDelegate: AnyObject {
    func configureBarButtons(in controller: UIViewController)
}

class MainFlowController: UIViewController {
    weak var delegate: MainFlowControllerDelegate?
    private let mainTabController = UITabBarController()

    // swiftlint:disable implicitly_unwrapped_optional
    private var homeFlow: UIViewController! = nil
    private var searchFlow: UIViewController! = nil
    private var newPostFlow: UIViewController! = nil
    private var chatFlow: UIViewController! = nil
    private var profileFlow: UIViewController! = nil
    // swiftlint:enable implicitly_unwrapped_optional

    func start() {
        homeFlow = flowController(
            HomeFlowController(barButtonDelegate: self),
            withIconName: "house",
            selectedIconName: "house.fill"
        )
        searchFlow = flowController(
            SearchFlowController(barButtonDelegate: self),
            withIconName: "magnifyingglass",
            selectedIconName: "magnifyingglass"
        )
        newPostFlow = flowController(
            NewPostFlowController(delegate: self),
            withIconName: "plus.app",
            selectedIconName: "plus.app.fill",
            pointSize: 20
        )
        chatFlow = flowController(
            ChatFlowController(),
            withIconName: "ellipsis.bubble",
            selectedIconName: "ellipsis.bubble.fill"
        )
        profileFlow = flowController(
            ProfileFlowController(barButtonDelegate: self),
            withIconName: "person.crop.circle",
            selectedIconName: "person.crop.circle.fill"
        )

        mainTabController.delegate = self
        mainTabController.viewControllers = [
            homeFlow,
            searchFlow,
            newPostFlow,
            chatFlow,
            profileFlow,
        ]
        mainTabController.view.backgroundColor = .systemBackground

        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        mainTabController.tabBar.standardAppearance = appearance
        mainTabController.tabBar.scrollEdgeAppearance = appearance

        add(child: mainTabController)
    }

    private func flowController<T: UIViewController>(_ controller: T, withIconName iconName: String, selectedIconName: String, pointSize: CGFloat = 16) -> T {
        let icon = UIImage(
            systemName: iconName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: pointSize)
        )
        let selectedIcon = UIImage(
            systemName: selectedIconName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: pointSize + 1)
        )
        controller.tabBarItem.image = icon
        controller.tabBarItem.selectedImage = selectedIcon
        return controller
    }
}

// MARK: - BarButtonDelegate

extension MainFlowController: BarButtonDelegate {
    func configureBarButtons(in controller: UIViewController) {
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.crop.circle"),
            style: .plain,
            target: self,
            action: #selector(sideInfoButtonTapped))
        controller.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "bell"),
            style: .plain,
            target: self,
            action: #selector(notificationButtonTapped))
    }

    @objc func notificationButtonTapped() {
        print("notificationButtonTapped")
    }

    @objc func sideInfoButtonTapped() {
        print("sideInfoButtonTapped")
        // TODO: side menu
        // temporarily used for logging out
        delegate?.mainFlowControllerDidFinish(self)
    }
}

// MARK: - NewPostFlowControllerDelegate

extension MainFlowController: NewPostFlowControllerDelegate {
    func newPostFlowControllerDidFinish(_ flowController: NewPostFlowController) {
        if flowController.didFinish {
            (homeFlow as? HomeFlowController)?.reload()
            (searchFlow as? SearchFlowController)?.reload()
            (profileFlow as? ProfileFlowController)?.reload()
        }
        mainTabController.selectedIndex = 0
    }
}

// MARK: - UITabBarControllerDelegate

extension MainFlowController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let newPostFlow = viewController as? NewPostFlowController {
            if newPostFlow.didFinish {
                newPostFlow.showNewPost()
            }
        }
    }
}
