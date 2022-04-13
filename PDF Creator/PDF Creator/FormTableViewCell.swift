//
//  FormTableViewCell.swift
//  PDF Creator
//
//  Created by Gilberto Silva on 13/04/22.
//

import UIKit

class FormTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var contactInfoTextView: UITextView!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyBorder(textView: bodyTextView)
        applyBorder(textView: contactInfoTextView)
        
        selectedImageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        selectedImageView.layer.masksToBounds = true
        selectedImageView.contentMode = .scaleToFill
        selectedImageView.layer.borderWidth = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onSelectImageButtonClick(_ sender: UIButton) {
    }
    
    private func applyBorder(textView: UITextView) {
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
