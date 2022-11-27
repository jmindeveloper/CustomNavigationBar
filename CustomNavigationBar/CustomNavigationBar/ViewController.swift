//
//  ViewController.swift
//  CustomNavigationBar
//
//  Created by J_Min on 2022/11/26.
//

import UIKit
import Combine

final class Cell: UITableViewCell {
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        label.snp.makeConstraints { $0.center.equalToSuperview() }
        label.text = "klasdfj;lasdkfj;lsakdfjls;akjfl;ksajdf;laksjdfl;ksajl;"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ViewController: JMViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(Cell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }        
    }
    
    override func setNavigation() {
        super.setNavigation()
        navigationBar.title = "배가고프다"
        navigationBar.titleFont = .systemFont(ofSize: 24, weight: .black)
        navigationBar.titleTextColor = .label
    }
    
    @objc private func pushAction() {
        let vc = SecondVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! Cell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        pushAction()
    }
}

final class SecondVC: JMViewController {
    
    let present: UIButton = {
        let button = UIButton()
        button.setTitle("push", for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        view.addSubview(present)
        
        present.snp.makeConstraints { $0.center.equalToSuperview() }
        present.addTarget(self, action: #selector(presentAction), for: .touchUpInside)
    }
    
    override func setNavigation() {
        super.setNavigation()
        navigationBar.title = "SecondVC"
        navigationBar.titleAlignment = .left
        navigationBar.leftItemStyle = .back
    }
    
    @objc private func presentAction() {
        let vc = ThirdVC()
        let naviVC = UINavigationController(rootViewController: vc)
        self.present(naviVC, animated: true)
    }
}

final class ThirdVC: JMViewController {
    
    let push: UIButton = {
        let button = UIButton()
        button.setTitle("push", for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(push)
        
        push.snp.makeConstraints { $0.center.equalToSuperview() }
        push.addTarget(self, action: #selector(pushAction), for: .touchUpInside)
    }
    
    override func setNavigation() {
        super.setNavigation()
        navigationBar.title = "ThirdVC"
        navigationBar.leftItemStyle = .dismiss
    }
    
    @objc private func pushAction() {
        let vc = FourthVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

final class FourthVC: JMViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }
    
    override func setNavigation() {
        super.setNavigation()
        navigationBar.title = "FourthVC"
        navigationBar.titleAlignment = .center
        navigationBar.leftItemStyle = .back
        
        let leftItem = NavigationButton(image: UIImage(systemName: "pencil"))
        leftItem.tintColor = .blue
        leftItem.addTarget(self, action: #selector(leftItemAction), for: .touchUpInside)
        let rightItem = NavigationButton(title: "버튼")
        rightItem.setTitleColor(.blue, for: .normal)
        rightItem.addTarget(self, action: #selector(rightItemAction), for: .touchUpInside)
        
        navigationBar.setLeftBarButtonItem(leftItem)
        navigationBar.setRightBarButtonItem(rightItem)
    }
    
    @objc private func leftItemAction() {
        print("leftItem Tapped!!")
    }
    
    @objc private func rightItemAction() {
        print("rightItem Tapped!!")
    }
}
