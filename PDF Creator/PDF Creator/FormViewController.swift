//
//  ViewController.swift
//  PDF Creator
//
//  Created by Gilberto Silva on 11/04/22.
//

import UIKit

class FormViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var contactInfoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyBorder(textView: bodyTextView)
        applyBorder(textView: contactInfoTextView)
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
    
    @IBAction func onPreviewButtonClick(_ sender: UIButton) {
    }
    
    @IBAction func onSelectImageButtonClick(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "formToPreview" {
            guard
                let vc = segue.destination as? PreviewViewController,
                let title = titleTextField.text,
                let body = bodyTextView.text
            else { return }
            let pdfCreator = PDFCreator(
                title: title,
                body: body,
                image: UIImage(),
                contact: ""
            )
            vc.documentData = pdfCreator.createFlyer()
        }
    }
}
