//
//  UnderlinedSegmentedControl.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/13.
//

import UIKit

class UnderlinedSegmentedControl: UIControl {
    // MARK: - Properties

    var selectedSegmentIndex = 0 {
        didSet {
            didSelect(segmentIndex: selectedSegmentIndex)
        }
    }
    var segments: [UIButton]

    var segmentSpacing: CGFloat = 0 {
        didSet {
            stack.spacing = segmentSpacing
            setNeedsLayout()
        }
    }

    var textSize: CGFloat = 16 {
        didSet {
            for button in segments {
                button.setNeedsUpdateConfiguration()
            }
        }
    }
    var textColor: UIColor = .label {
        didSet {
            for button in segments {
                button.setNeedsUpdateConfiguration()
            }
        }
    }

    lazy var selectorLine: UIView = {
        let line = UIView(frame: .zero)
        line.backgroundColor = selectorColor
        return line
    }()

    var selectorLineWidth: CGFloat = 1 {
        didSet {
            selectorLineHeightConstraint = selectorLine.heightAnchor.constraint(equalToConstant: selectorLineWidth)
            setNeedsLayout()
        }
    }

    private var selectorLineHeightConstraint: NSLayoutConstraint?
    private var selectorLineLeadingConstraint: NSLayoutConstraint?

    var selectorColor: UIColor = .systemGray {
        didSet {
            selectorLine.backgroundColor = selectorColor
            setNeedsLayout()
        }
    }
    var selectorTextColor: UIColor = .label

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        for segment in segments {
            stack.addArrangedSubview(segment)
        }
        stack.axis = .horizontal
        stack.spacing = segmentSpacing
        return stack
    }()

    // MARK: - LifeCycle

    init(titles: [String]) {
        self.segments = []
        super.init(frame: .zero)

        for title in titles {
            let button = UIButton(configuration: .plain())
            button.configurationUpdateHandler = {[unowned self] button in
                guard var config = button.configuration else { return }
                var attributedTitle = AttributedString(title)
                attributedTitle.font = .systemFont(ofSize: textSize)
                attributedTitle.foregroundColor = textColor
                config.attributedTitle = attributedTitle
                button.configuration = config
            }

            button.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
            segments.append(button)
        }

        configureHierarchy()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        [stack, selectorLine].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),

            selectorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        selectorLineLeadingConstraint = selectorLine.leadingAnchor.constraint(equalTo: leadingAnchor)
        selectorLineLeadingConstraint?.isActive = true

        selectorLineHeightConstraint = selectorLine.heightAnchor.constraint(equalToConstant: selectorLineWidth)
        selectorLineHeightConstraint?.isActive = true

        if let segmentWidthAnchor = stack.arrangedSubviews.first?.widthAnchor {
            selectorLine.widthAnchor.constraint(equalTo: segmentWidthAnchor).isActive = true
        }
    }

    // MARK: - Private Methods

    @objc private func tapped(sender: UIButton) {
        guard let selectedIndex = segments.firstIndex(of: sender) else { return }
        selectedSegmentIndex = selectedIndex
    }

    private func didSelect(segmentIndex: Int) {
        let selectedSegment = segments[segmentIndex]
        selectorLineLeadingConstraint?.constant = selectedSegment.frame.origin.x
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        sendActions(for: .valueChanged)
    }
}
