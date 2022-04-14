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
    
    var basePath = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
    ).first! + "/gil/files"
    
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
    
    func createURLFlyer() -> URL {
        
        let (renderer, pageRect) = createdDocumentInfo()
        
        let url = createURL()
        
        try? renderer.writePDF(to: url) { (context) in
            createTemplate(
                context: context,
                renderer: renderer,
                pageRect: pageRect
            )
        }
        
        return url
    }
    
    func createDataFlyer() -> Data {
        
        let (renderer, pageRect) = createdDocumentInfo()
        
        let data = renderer.pdfData { (context) in
            createTemplate(
                context: context,
                renderer: renderer,
                pageRect: pageRect
            )
        }
        
        return data
    }
    
    private func createURL() -> URL {
        let basePath = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first! + "/gil/files/"
        print("Path: \(basePath)")
        
        let nameFile = Date().getFormattedDate(format: "dd_MM_yyyy_HH_mm_ss")
        
        let url = URL(fileURLWithPath: basePath + "PDF_\(nameFile).pdf")
        
        if !FileManager.default.fileExists(atPath: basePath) {
            do {
                try FileManager.default.createDirectory(atPath: basePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        return url
    }
    
    private func createTemplate(
        context: UIGraphicsPDFRendererContext,
        renderer: UIGraphicsPDFRenderer,
        pageRect: CGRect
    ) {
        context.beginPage()
        
        let titleBottom = addTitle(
            pageRect: pageRect,
            context: context
        )
        
        let imageBottom = addImage(pageRect: pageRect, imageTop: titleBottom + 18.0)
        
        addBodyText(
            pageRect: pageRect,
            textTop: imageBottom + 18.0,
            context: context
        )
        
        let context = context.cgContext
        drawTearOffs(
            drawContext: context,
            pageRect: pageRect,
            tearOffY: pageRect.height * 4.0 / 5.0,
            numberTabs: 8
        )
        
        drawContactLabels(
            drawContext: context,
            pageRect: pageRect,
            numberTabs: 8
        )
    }
    
    private func createdDocumentInfo() -> (UIGraphicsPDFRenderer, CGRect)  {
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
        let renderer =  UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        return (renderer, pageRect)
    }
    
    private func addTitle(
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
        
        /*applyColor(
         context: context,
         color: UIColor.red,
         rect: titleStringRect
         )*/
        
        attributedTitle.draw(in: titleStringRect)
        
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    
    private func addBodyText(
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
        
        /*applyColor(
         context: context,
         color: UIColor.orange,
         rect: textRect
         )*/
        
        attributedText.draw(in: textRect)
    }
    
    private func applyColor(
        context: UIGraphicsPDFRendererContext,
        color: UIColor,
        rect: CGRect
    ) {
        color.setFill()
        context.fill(rect)
    }
    
    private func addImage(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
        
        let maxHeight = pageRect.height * 0.4
        let maxWidth = pageRect.width * 0.8
        
        let aspectWidth = maxWidth / image.size.width
        let aspectHeight = maxHeight / image.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)
        
        let scaledWidth = image.size.width * aspectRatio
        let scaledHeight = image.size.height * aspectRatio
        
        let imageX = (pageRect.width - scaledWidth) / 2.0
        
        let imageRect = CGRect(
            x: imageX,
            y: imageTop,
            width: scaledWidth,
            height: scaledHeight
        )
        
        image.draw(in: imageRect)
        return imageRect.origin.y + imageRect.size.height
    }
    
    private func drawTearOffs(
        drawContext: CGContext,
        pageRect: CGRect,
        tearOffY: CGFloat,
        numberTabs: Int
    ) {
        
        drawContext.saveGState()
        drawContext.setLineWidth(2.0)
        
        drawContext.move(to: CGPoint(x: 0, y: tearOffY))
        drawContext.addLine(to: CGPoint(x: pageRect.width, y: tearOffY))
        drawContext.strokePath()
        drawContext.restoreGState()
        
        drawContext.saveGState()
        let dashLength = CGFloat(72.0 * 0.2)
        drawContext.setLineDash(phase: 0, lengths: [dashLength, dashLength])
        
        let tabWidth = pageRect.width / CGFloat(numberTabs)
        for tearOffIndex in 1..<numberTabs {
            let tabX = CGFloat(tearOffIndex) * tabWidth
            drawContext.move(to: CGPoint(x: tabX, y: tearOffY))
            drawContext.addLine(to: CGPoint(x: tabX, y: pageRect.height))
            drawContext.strokePath()
        }
        drawContext.restoreGState()
    }
    
    private func drawContactLabels(
        drawContext: CGContext,
        pageRect: CGRect,
        numberTabs: Int
    ) {
        
        let contactTextFont = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let contactBlurbAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: contactTextFont
        ]
        let attributedContactText = NSMutableAttributedString(
            string: contactInfo,
            attributes: contactBlurbAttributes
        )
        
        let textHeight = attributedContactText.size().height
        let tabWidth = pageRect.width / CGFloat(numberTabs)
        let horizontalOffset = (tabWidth - textHeight) / 2.0
        drawContext.saveGState()
        
        drawContext.rotate(by: -90.0 * CGFloat.pi / 180.0)
        for tearOffIndex in 0...numberTabs {
            let tabX = CGFloat(tearOffIndex) * tabWidth + horizontalOffset
            
            attributedContactText.draw(at: CGPoint(x: -pageRect.height + 5.0, y: tabX))
        }
        drawContext.restoreGState()
    }
    
}

private extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
