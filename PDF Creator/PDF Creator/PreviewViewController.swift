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
    public var documentData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pdfView)
        
        //        guard
        //            let url = Bundle.main.url(forResource: "PDF_2022_03_28_23_24_02", withExtension: "pdf"),
        //            let document = PDFDocument(url: url)
        //        else {
        //            return
        //        }
        
        if let data = documentData {
            pdfView.document = PDFDocument(data: data)
            pdfView.autoScales = true
            pdfView.delegate = self
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = view.bounds
    }
    
    @IBAction func onSharedButtonClick(_ sender: UIBarButtonItem) {
        if let data = documentData {
            let vc = UIActivityViewController(
                activityItems: [data],
                applicationActivities: []
            )
            present(vc, animated: true, completion: nil)
        }
    }
}
