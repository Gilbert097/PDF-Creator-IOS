//
//  FormTableViewController.swift
//  PDF Creator
//
//  Created by Gilberto Silva on 13/04/22.
//

import UIKit

class FormTableViewController: UITableViewController {

    var formCell = FormTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 800
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? FormTableViewCell {
            self.formCell = cell
            return cell
        }
        return formCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "formToPreview" {
            guard
                let vc = segue.destination as? PreviewViewController,
                let title = self.formCell.titleTextField.text,
                let body = self.formCell.bodyTextView.text
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
