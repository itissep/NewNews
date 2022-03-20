//
//  FavsVC.swift
//  NewNews
//
//  Created by The GORDEEVS on 19.03.2022.
//

import UIKit

class FavsVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        title = "Bookmarks"
        
        self.hideKeyboardWhenTappedAround()

        layout()
    }
    
    lazy var searchField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "search",
                                                             attributes:[NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 16
        textField.layer.borderWidth = 3
        textField.layer.borderColor = UIColor.systemOrange.cgColor
        textField.textColor = .black
        
        let image = UIImage(named: "magnifyer")?
            .resizeImage(targetSize: CGSize(width: 40, height: 40))
            .withInset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
        
        let leftImageView = UIImageView(image: image)
        leftImageView.clipsToBounds = true
        leftImageView.contentMode = .scaleAspectFill
        textField.leftView = leftImageView
        
        textField.leftViewMode = .always
        
        let clearButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 15, height: 15)))
        let clearImage = UIImage(systemName: "clear")?
            .withInset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))?
            .withTintColor(.systemOrange)
        clearButton.setImage(clearImage, for: .normal)

        textField.rightView = clearButton
        clearButton.addTarget(self, action: #selector(clearSearch), for: .touchUpInside)

        textField.clearButtonMode = .never
        textField.rightViewMode = .whileEditing
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    @objc func clearSearch(){
        searchField.text = ""
    }
    
    private func layout(){
        view.addSubview(searchField)
        
        searchField.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
    }
    
    
    func hideKeyboardWhenTappedAround() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }


}


extension FavsVC: UITextFieldDelegate {

    @objc private func buttonAction(){
        searchField.endEditing(true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let input = searchField.text {
            print(input)
        }
        searchField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchField.text != "" {
            return true
        } else {
            searchField.placeholder = "type something"
            return false
        }
    }

}

