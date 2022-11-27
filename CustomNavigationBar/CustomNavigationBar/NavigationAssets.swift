//
//  NavigationAssets.swift
//  CustomNavigationBar
//
//  Created by J_Min on 2022/11/26.
//

import UIKit
import SnapKit
import Combine

final class JMNavigationBar: UIView {
    
    enum TitleAlignment {
        case left, right, center
    }
    
    enum LeftItemStyle {
        case back, dismiss, custom, none
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        
        return label
    }()
    
    private let leftBarButtonItems: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let rightBarButtonItems: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        return blurEffectView
    }()
    
    private let backButton: NavigationButton = {
        let button = NavigationButton(image: UIImage(systemName: "arrow.left"))
        
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = NavigationButton(image: UIImage(systemName: "xmark"))
        
        return button
    }()
    
    var titleAlignment: TitleAlignment = .center {
        didSet {
            updateTitleConstraints(titleAlignment)
        }
    }
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var titleFont: UIFont = UIFont() {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    var titleTextColor: UIColor = .label {
        didSet {
            titleLabel.textColor = titleTextColor
        }
    }
    
    var leftItemStyle: LeftItemStyle = .none {
        didSet {
            setLeftItemStyle(leftItemStyle)
        }
    }
    
    let backButtonPublisher = PassthroughSubject<Void, Never>()
    let dismissButtonPublisher = PassthroughSubject<Void, Never>()
    
    var statusBarBlurView: UIView?
    var statusBarView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        connectTarget()
        blurView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Target
    private func connectTarget() {
        backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissButtonAction(_:)), for: .touchUpInside)
    }
    
    @objc private func backButtonAction(_ sender: UIButton) {
        backButtonPublisher.send()
    }
    
    @objc private func dismissButtonAction(_ sender: UIButton) {
        dismissButtonPublisher.send()
    }
    
    // MARK: - Method
    func blur(_ isShow: Bool, statusBar: Bool) {
        blurView.isHidden = isShow ? false : true
        if isShow {
            if statusBar {
                addStatusBarBlur()
            }
        } else {
            removeStatusBarBlur()
        }
    }
    
    private func addStatusBarBlur() {
        var statusBarManager: UIStatusBarManager?
        
        if #available(iOS 15.0, *) {
            let window = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.windows.first
            statusBarManager = window?.windowScene?.statusBarManager
        } else {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            statusBarManager = window?.windowScene?.statusBarManager
        }
        
        let statusBarHeight = statusBarManager?.statusBarFrame.height
        let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? CGRect.zero)
        print(statusBarView.frame)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.statusBarView = statusBarView
        self.statusBarBlurView = blurEffectView
        addSubview(statusBarView)
        statusBarView.addSubview(blurEffectView)
        
        statusBarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(-(statusBarHeight ?? .zero))
            $0.height.equalTo(statusBarHeight ?? .zero)
        }
        
        blurEffectView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func removeStatusBarBlur() {
        guard let statusBarView = statusBarView,
              let statusBarBlurView = statusBarBlurView else {
            return
        }
        
        [statusBarBlurView, statusBarView].forEach {
            $0.removeFromSuperview()
        }
    }
    
    private func updateTitleConstraints(_ alignment: TitleAlignment) {
        titleLabel.snp.remakeConstraints {
            $0.centerY.equalToSuperview()
            switch alignment {
            case .center:
                $0.centerX.equalToSuperview()
            case .left:
                $0.leading.equalTo(leftBarButtonItems.snp.trailing).offset(10)
            case .right:
                $0.trailing.equalTo(rightBarButtonItems.snp.leading).offset(-10)
            }
        }
    }
    
    private func setLeftItemStyle(_ style: LeftItemStyle) {
        removeLeftBarButtonItems()
        switch style {
        case .back:
            leftBarButtonItems.addArrangedSubview(backButton)
        case .dismiss:
            leftBarButtonItems.addArrangedSubview(dismissButton)
        default:
            break
        }
    }
    
    func setLeftBarButtonItem(_ item: NavigationButton) {
        removeLeftBarButtonItems()
        leftItemStyle = .custom
        item.snp.makeConstraints {
            $0.size.equalTo(44)
        }
        leftBarButtonItems.addArrangedSubview(item)
    }
    
    func setLeftBarButtonItems(_ items: [NavigationButton]) {
        removeLeftBarButtonItems()
        leftItemStyle = .custom
        for item in items {
            item.snp.makeConstraints {
                $0.size.equalTo(44)
            }
            leftBarButtonItems.addArrangedSubview(item)
        }
    }
    
    func setRightBarButtonItem(_ item: NavigationButton) {
        removeRightBarButtonItems()
        item.snp.makeConstraints {
            $0.size.equalTo(44)
        }
        rightBarButtonItems.addArrangedSubview(item)
    }
    
    func setRightBarButtonItems(_ items: [NavigationButton]) {
        removeRightBarButtonItems()
        for item in items {
            item.snp.makeConstraints {
                $0.size.equalTo(44)
            }
            rightBarButtonItems.addArrangedSubview(item)
        }
    }
    
    private func removeLeftBarButtonItems() {
        leftBarButtonItems.arrangedSubviews.forEach {
            $0.removeFromSuperview()
            leftBarButtonItems.removeArrangedSubview($0)
        }
    }
    
    private func removeRightBarButtonItems() {
        rightBarButtonItems.arrangedSubviews.forEach {
            $0.removeFromSuperview()
            rightBarButtonItems.removeArrangedSubview($0)
        }
    }
    
    // MARK: - UI
    private func setSubViews() {
        [blurView, leftBarButtonItems, titleLabel, rightBarButtonItems].forEach {
            addSubview($0)
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        leftBarButtonItems.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        rightBarButtonItems.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(44)
        }
        
        dismissButton.snp.makeConstraints {
            $0.size.equalTo(44)
        }
    }
}

class JMViewController: UIViewController {
    
    let navigationBar: JMNavigationBar = {
        let navigationBar = JMNavigationBar()
        
        return navigationBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if navigationController != nil {
            view.addSubview(navigationBar)
        }
        binding()
        setNavigation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if navigationController != nil {
            navigationBar.frame = navigationController?.navigationBar.frame ?? .zero
            navigationController?.navigationBar.removeFromSuperview()
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    private func binding() {
        navigationBar.backButtonPublisher
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &subscriptions)
        
        navigationBar.dismissButtonPublisher
            .sink { [weak self] in
                self?.dismiss(animated: true)
            }.store(in: &subscriptions)
    }
    
    func setNavigation() { }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
