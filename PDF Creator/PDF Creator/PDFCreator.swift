//
//  PDFCreator.swift
//  PDF Creator
//
//  Created by Gilberto Silva on 12/04/22.
//

import Foundation
import PDFKit

class PDFCreator {
    
    let title: String
    let body: String
    let image: UIImage
    let contactInfo: String
    
    init(
        title: String,
        body: String,
        image: UIImage,
        contact: String
    ) {
        self.title = title
        self.body = body
        self.image = image
        self.contactInfo = contact
    }
    
    func createFlyer() -> Data {
        
        let pdfMetaData = [
            kCGPDFContextCreator: "Flyer Builder",
            kCGPDFContextAuthor: "raywenderlich.com",
            kCGPDFContextTitle: title
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { (context) in
            
            context.beginPage()
            
            let titleBottom = addTitle(
                pageRect: pageRect,
                context: context
            )
            
            addBodyText(
                pageRect: pageRect,
                textTop: titleBottom + 36.0,
                context: context
            )
        }
        
        return data
    }
    
    func addTitle(
        pageRect: CGRect,
        context: UIGraphicsPDFRendererContext
    ) -> CGFloat {
        
        let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        
        let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: titleFont]
        
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: titleAttributes
        )
        
        let titleStringSize = attributedTitle.size()
        
        let titleStringRect = CGRect(
            x: (pageRect.width - titleStringSize.width) / 2.0,
            y: 36,
            width: titleStringSize.width,
            height: titleStringSize.height
        )
        
        UIColor.red.setFill()
        context.fill(titleStringRect)
        attributedTitle.draw(in: titleStringRect)
        
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    
    func addBodyText(
        pageRect: CGRect,
        textTop: CGFloat,
        context: UIGraphicsPDFRendererContext
    ) {
        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        
        let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]
        let attributedText = NSAttributedString(
            string: body,
            attributes: textAttributes
        )
        
        let textRect = CGRect(
            x: 10,
            y: textTop,
            width: pageRect.width - 20,
            height: pageRect.height - textTop - pageRect.height / 5.0
        )
        UIColor.orange.setFill()
        context.fill(textRect)
        attributedText.draw(in: textRect)
    }
}
