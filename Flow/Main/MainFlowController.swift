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
    }
}
