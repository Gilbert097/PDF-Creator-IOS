//
//  FormTableViewController.swift
//  PDF Creator
//
//  Created by Gilberto Silva on 13/04/22.
//

import UIKit

class FormTableViewController: UITableViewController {
    
    var formCell = FormTableViewCell()
    private var imagePickerViewController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 800
        imagePickerViewController.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? FormTableViewCell {
            self.formCell = cell
            self.formCell.selectImageButton.addTarget(self, action: #selector(onSelectImageButtonClick), for: .touchUpInside)
            return cell
        }
        return formCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func showMessage(
        title: String,
        message: String,
        handler: ((UIAlertAction) -> Void)? = nil
    ){
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
}

extension FormTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "formToPreview" {
            guard
                let vc = segue.destination as? PreviewViewController,
                let title = self.formCell.titleTextField.text,
                let body = self.formCell.bodyTextView.text,
                let contact = self.formCell.contactInfoTextView.text,
                let image = self.formCell.selectedImageView.image
            else { return }
            let pdfCreator = PDFCreator(
                title: title,
                body: body,
                image: image,
                contact: contact
            )
            //vc.documentData = pdfCreator.createFlyer()
            vc.url = pdfCreator.createURLFlyer()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String,
                                     sender: Any?) -> Bool {
        if
            let title = self.formCell.titleTextField.text, !title.isEmpty,
            let body = self.formCell.bodyTextView.text, !body.isEmpty,
            let contact = self.formCell.contactInfoTextView.text, !contact.isEmpty,
            let _ = self.formCell.selectedImageView.image {
            return true
        }
        
        showMessage(
            title: "All Information Not Provided",
            message: "You must supply all information to create a flyer."
        )
        
        return false
    }
    
}

extension FormTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.formCell.selectedImageView.image = originalImage
        imagePickerViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func onSelectImageButtonClick() {
        imagePickerViewController.sourceType = .savedPhotosAlbum
        present(imagePickerViewController, animated: true, completion: nil)
    }
}

