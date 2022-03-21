//
//  WelcomeVC.swift
//  NewNews
//
//  Created by The GORDEEVS on 18.03.2022.
//

import UIKit
import SnapKit

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
    }
    
    
    lazy var goButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go", for: .normal)
        button.addTarget(self, action: #selector(goBtnPressed), for: .touchUpInside)
        
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 16
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    lazy var navBar: UITabBarController = {
        let nav = UITabBarController()
        
        let vc1 = NewsVC()
        let vc2 = BestSellerVC()
        let vc3 = FavsVC()
        let vc4 = SettingsVC()
        
        vc4.title = "Settings"
        vc3.title = "Bookmarks"
        vc2.title = "Best Sellers"
        vc1.title = "Feed"
        
        nav.tabBar.isTranslucent = false
        nav.view.backgroundColor = .white
        nav.tabBar.tintColor = .systemOrange
        
        nav.setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        
        if let items = nav.tabBar.items {
            let images = ["newspaper", "book", "bookmark", "gearshape"]
            
            for i in 0 ..< items.count {
                items[i].image = UIImage(systemName: images[i])
            }
        }
        nav.modalPresentationStyle = .fullScreen
        return nav
    }()
    
    
    @objc func goBtnPressed(){
        present(navBar, animated: true)
    }
    
    
    lazy var label: UILabel = {
        let l = UILabel()
        l.text = "Wanna find out news?"
        l.textColor = .systemOrange
        l.numberOfLines = 0
        
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    
    func layout(){
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(view.center)
            make.height.equalTo(25)
        }
        
        
        view.addSubview(goButton)
        goButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(label.snp.bottom).offset(10)
            make.width.equalTo(label)
        }
    }
}
