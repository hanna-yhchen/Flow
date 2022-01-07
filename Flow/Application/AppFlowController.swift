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
    }

    private func startLogin() {
        let loginFlowController = AuthFlowController()
        loginFlowController.delegate = self
        add(child: loginFlowController)
        loginFlowController.start()
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
    func authFlowControllerDidFinish(_ flowController: UIViewController) {
        remove(child: flowController)
        startMain()
    }
}

extension AppFlowController: MainFlowControllerDelegate {
}
