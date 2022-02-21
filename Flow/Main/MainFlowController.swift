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
    let mainTabController = UITabBarController()

    func start() {
        let homeFlowController = flowController(
            HomeFlowController(barButtonDelegate: self),
            withIconName: "house",
            selectedIconName: "house.fill"
        )
        let searchFlowController = flowController(
            SearchFlowController(barButtonDelegate: self),
            withIconName: "magnifyingglass",
            selectedIconName: "magnifyingglass"
        )
        let newPostFlowController = flowController(
            NewPostFlowController(),
            withIconName: "plus.app",
            selectedIconName: "plus.app.fill",
            pointSize: 20
        )
        newPostFlowController.delegate = self
        let chatFlowController = flowController(
            ChatFlowController(),
            withIconName: "ellipsis.bubble",
            selectedIconName: "ellipsis.bubble.fill"
        )
        let profileFlowController = flowController(
            ProfileFlowController(barButtonDelegate: self),
            withIconName: "person.crop.circle",
            selectedIconName: "person.crop.circle.fill"
        )

        mainTabController.delegate = self
        mainTabController.viewControllers = [
            homeFlowController,
            searchFlowController,
            newPostFlowController,
            chatFlowController,
            profileFlowController,
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
    }
}

// MARK: - NewPostFlowControllerDelegate

extension MainFlowController: NewPostFlowControllerDelegate {
    func newPostFlowControllerDidFinish(_ flowController: UIViewController) {
        mainTabController.selectedIndex = 0
    }
}

// MARK: - UITabBarControllerDelegate

extension MainFlowController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let newPostFlow = viewController as? NewPostFlowController else { return }
        if newPostFlow.didFinish {
            newPostFlow.showNewPost()
        }
    }
}
