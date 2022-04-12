//
//  PreviewViewController.swift
//  PDF Creator
//
//  Created by Gilberto Silva on 12/04/22.
//

import PDFKit
import UIKit

class PreviewViewController: UIViewController, PDFViewDelegate  {

    let pdfView = PDFView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pdfView)
        
        guard
            let url = Bundle.main.url(forResource: "PDF_2022_03_28_23_24_02", withExtension: "pdf"),
            let document = PDFDocument(url: url)
        else {
            return
        }
        
        pdfView.document = document
        pdfView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = view.bounds
    }

}
