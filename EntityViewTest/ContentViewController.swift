//
//  ContentViewController.swift
//  EntityViewTest
//
//  Created by Jiri Urbasek on 19.11.2021.
//

import UIKit

class ContentViewController: UIViewController {

    private var label = UILabel()
    
    private let color: UIColor
    
    init(title: String, color: UIColor) {
        self.color = color
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        label.text = title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        label.center = view.center
    }
}
