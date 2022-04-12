//
//  PDFCreator.swift
//  PDF Creator
//
//  Created by Gilberto Silva on 12/04/22.
//

import Foundation
import PDFKit

class PDFCreator {
    
    func createFlyer() -> Data {
     
        let pdfMetaData = [
            kCGPDFContextCreator: "Flyer Builder",
            kCGPDFContextAuthor: "raywenderlich.com"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
     
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
   
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
 
        let data = renderer.pdfData { (context) in
   
            context.beginPage()

            let attributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 72)
            ]
            let text = "I'm a PDF!"
            text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        }
        
        return data
    }
}
