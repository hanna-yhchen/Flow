//
//  MainFlowController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/3.
//

import UIKit

protocol MainFlowControllerDelegate: AnyObject {
}

class MainFlowController: UIViewController {
    weak var delegate: MainFlowControllerDelegate?

    func start() {
        let homeFlowController = flowController(
            HomeFlowController(),
            withIconName: "house",
            selectedIconName: "house.fill"
        )
        let searchFlowController = flowController(
            SearchFlowController(),
            withIconName: "magnifyingglass",
            selectedIconName: "magnifyingglass"
        )
        let postFlowController = flowController(
            PostFlowController(),
            withIconName: "plus.app",
            selectedIconName: "plus.app.fill",
            pointSize: 24
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
        add(child: mainTabController)
    }

    func flowController<T: UIViewController>(_ controller: T, withIconName iconName: String, selectedIconName: String, pointSize: CGFloat = 20) -> T {
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
