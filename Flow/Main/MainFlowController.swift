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
        let postFlowController = flowController(
            PostFlowController(),
            withIconName: "plus.app",
            selectedIconName: "plus.app.fill",
            pointSize: 20
        )
        let chatFlowController = flowController(
            ChatFlowController(),
            withIconName: "ellipsis.bubble",
            selectedIconName: "ellipsis.bubble.fill"
        )
        let profileFlowController = flowController(
            ProfileFlowController(),
            withIconName: "person.crop.circle",
            selectedIconName: "person.crop.circle.fill"
        )

        let mainTabController = UITabBarController()
        mainTabController.viewControllers = [
            homeFlowController,
            searchFlowController,
            postFlowController,
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

extension MainFlowController: BarButtonDelegate {
    func configureBarButtons(in controller: UIViewController) {
        print("configureBarButtons called")

        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.crop.circle"),
            style: .plain,
            target: self,
            action: #selector(notificationButtonTapped))
        controller.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "bell"),
            style: .plain,
            target: self,
            action: #selector(sideInfoButtonTapped))
    }

    @objc func notificationButtonTapped() {
        print("notificationButtonTapped")
    }

    @objc func sideInfoButtonTapped() {
        print("sideInfoButtonTapped")
    }
}
