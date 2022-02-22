//
//  AppFlowController.swift
//  Flow
//
//  Created by Hanna Chen on 2022/1/3.
//

import UIKit

class AppFlowController: UIViewController {
    func start() {
        // TODO: Check Authentication State
        startLogin()
        // startMain()
    }

    private func startLogin() {
        let authFlowController = AuthFlowController()
        authFlowController.delegate = self
        add(child: authFlowController)
    }

    private func startMain() {
        let mainFlowController = MainFlowController()
        mainFlowController.delegate = self
        add(child: mainFlowController)
        mainFlowController.start()
    }
}

// MARK: - Child Flow Controller Delegate

extension AppFlowController: AuthFlowControllerDelegate {
    /// Call the app flow controller to show main screen when the user logs in
    func authFlowControllerDidFinish(_ flowController: UIViewController) {
        // Logged In
        remove(child: flowController)
        startMain()
    }
}

extension AppFlowController: MainFlowControllerDelegate {
    /// Get called when the user logs out
    func mainFlowControllerDidFinish(_ flowController: UIViewController) {
        // Logged Out
    }
}
