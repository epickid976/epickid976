//
//  ViewController.swift
//  Project 27
//
//  Created by Jose Blanco on 7/15/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drawRectangle()
    }
    
    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerBoard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawEmoji()
        case 7:
            drawTwin()
        default:
            break
        }
    }
 
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            //awesome drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        
        imageView.image = image
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            //awesome drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        
        imageView.image = image
    }
    
    func drawCheckerBoard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            //awesome drawing code
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = image
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
        
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
            
        }
        
        imageView.image = image
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        imageView.image = image
    }
    
    func drawEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            let eyesRectangle1 = CGRect(x: 150, y: 170, width: 50, height: 50)
            
            ctx.cgContext.setFillColor(UIColor.orange.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            
            ctx.cgContext.addEllipse(in: eyesRectangle1)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            let eyesRectangle2 = CGRect(x: 340, y: 170, width: 50, height: 50)
            
            ctx.cgContext.setFillColor(UIColor.orange.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            
            ctx.cgContext.addEllipse(in: eyesRectangle2)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            let mouthRectangle = CGRect(x: 170, y: 300, width: 200, height: 20)
            
            ctx.cgContext.setFillColor(UIColor.orange.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.addRect(mouthRectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        
        imageView.image = image
    }
    
    func drawTwin() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.rotate(by: 0)
            
            ctx.cgContext.move(to: CGPoint(x: 20, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 100, y: 100))
            
            ctx.cgContext.move(to: CGPoint(x: 60, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 60, y: 400))
            
            ctx.cgContext.move(to: CGPoint(x: 120, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 160, y: 400))
            
            ctx.cgContext.move(to: CGPoint(x: 160, y: 400))
            ctx.cgContext.addLine(to: CGPoint(x: 200, y: 100))
            
            ctx.cgContext.move(to: CGPoint(x: 200, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 240, y: 400))
            
            ctx.cgContext.move(to: CGPoint(x: 240, y: 400))
            ctx.cgContext.addLine(to: CGPoint(x: 280, y: 100))
            
            ctx.cgContext.move(to: CGPoint(x: 340, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 340, y: 400))
            
            ctx.cgContext.move(to: CGPoint(x: 400, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 400, y: 400))
            
            ctx.cgContext.move(to: CGPoint(x: 400, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 440, y: 400))
            
            ctx.cgContext.move(to: CGPoint(x: 440, y: 100))
            ctx.cgContext.addLine(to: CGPoint(x: 440, y: 400))
            
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
}

