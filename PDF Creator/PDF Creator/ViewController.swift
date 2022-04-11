//
//  ViewController.swift
//  PDF Creator
//
//  Created by Gilberto Silva on 11/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var selectImageLabel: UILabel!
    @IBOutlet weak var contactInfoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyBorder(textView: bodyTextView)
        applyBorder(textView: contactInfoTextView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction))
        selectImageLabel.addGestureRecognizer(tap)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func applyBorder(textView: UITextView) {
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func onCreateButtonClick(_ sender: UIButton) {
        
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
    }
}



