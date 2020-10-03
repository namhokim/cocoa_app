//
//  ADragDropView.swift
//  ADragDropViewExample
//
//  Created by Soulchild on 24/09/2018.
//  Copyright © 2018 fluffy. All rights reserved.
//

import Cocoa

public final class ADragDropView: NSView {
    
    // highlight the drop zone when mouse drag enters the drop view
    fileprivate var highlight : Bool = false
    
    // check if the dropped file type is accepted
    fileprivate var fileTypeIsOk = false
    
    public var allowAllFileExtensions : Bool = false
    /// Allowed file type extensions to drop, eg: ["png", "jpg", "jpeg"]
    public var acceptedFileExtensions : [String] = []
    
    public weak var delegate: ADragDropViewDelegate?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        if #available(OSX 10.13, *) {
            registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL])
        } else {
            // Fallback on earlier versions
            registerForDraggedTypes([NSPasteboard.PasteboardType("NSFilenamesPboardType")])
        }
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
        if(NSAppKitVersion.current.rawValue < NSAppKitVersion.macOS10_10.rawValue) {
            NSColor.windowBackgroundColor.setFill()
        } else {
            NSColor.clear.set()
        }
        
        __NSRectFillUsingOperation(dirtyRect, NSCompositingOperation.sourceOver)
        
        let grayColor = NSColor(deviceWhite: 0, alpha: highlight ? 1.0/4.0 : 1.0/8.0)
        grayColor.set()
        grayColor.setFill()
        
        let bounds = self.bounds
        let size = min(bounds.size.width - 8.0, bounds.size.height - 8.0);
        let width =  max(2.0, size / 32.0)
        let frame = NSMakeRect((bounds.size.width-size)/2.0, (bounds.size.height-size)/2.0, size, size)
        
        NSBezierPath.defaultLineWidth = width
        
        // draw rounded corner square with dotted borders
        let squarePath = NSBezierPath(roundedRect: frame, xRadius: size/14.0, yRadius: size/14.0)
        let dash : [CGFloat] = [size / 10.0, size / 16.0]
        squarePath.setLineDash(dash, count: 2, phase: 2)
        squarePath.stroke()
        
        // draw arrow
        let arrowPath = NSBezierPath()
        let baseWidth = size / 8.0
        let baseHeight = size / 8.0
        let arrowWidth = baseWidth * 2.0
        let pointHeight = baseHeight * 3.0
        let offset = -size / 8.0
        
        arrowPath.move(to: NSMakePoint(bounds.size.width/2.0 - baseWidth, bounds.size.height/2.0 + baseHeight - offset))
        
        arrowPath.line(to: NSMakePoint(bounds.size.width/2.0 + baseWidth, bounds.size.height/2.0 + baseHeight - offset))
        arrowPath.line(to: NSMakePoint(bounds.size.width/2.0 + baseWidth, bounds.size.height/2.0 - baseHeight - offset))
        arrowPath.line(to: NSMakePoint(bounds.size.width/2.0 + arrowWidth, bounds.size.height/2.0 - baseHeight - offset))
        arrowPath.line(to: NSMakePoint(bounds.size.width/2.0, bounds.size.height/2.0 - pointHeight - offset))
        arrowPath.line(to: NSMakePoint(bounds.size.width/2.0 - arrowWidth, bounds.size.height/2.0 - baseHeight - offset))
        arrowPath.line(to: NSMakePoint(bounds.size.width/2.0 - baseWidth, bounds.size.height/2.0 - baseHeight - offset))
        
        arrowPath.fill()
    }
    
    // MARK: - NSDraggingDestination
    public override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        highlight = true
        fileTypeIsOk = isExtensionAcceptable(draggingInfo: sender)
        
        self.setNeedsDisplay(self.bounds)
        return []
    }
    
    public override func draggingExited(_ sender: NSDraggingInfo?) {
        highlight = false
        self.setNeedsDisplay(self.bounds)
    }
    
    public override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return fileTypeIsOk ? .copy : []
    }
    
    public override func mouseEntered(with event: NSEvent) {
        delegate?.mouseEntered(self, with: event)
    }
    
    public override func mouseExited(with event: NSEvent) {
        delegate?.mouseExited(self, with: event)
    }
    
    public override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        for trackingArea in self.trackingAreas {
            self.removeTrackingArea(trackingArea)
        }
        
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
        let trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    
    public override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        // finished with dragging so remove any highlighting
        highlight = false
        self.setNeedsDisplay(self.bounds)
        
        return true
    }
    
    public override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if sender.filePathURLs.count == 0 {
            return false
        }
        
        if(fileTypeIsOk) {
            if sender.filePathURLs.count == 1 {
                delegate?.dragDropView(self, droppedFileWithURL: sender.filePathURLs.first!)
            } else {
                delegate?.dragDropView(self, droppedFilesWithURLs: sender.filePathURLs)
            }
        } else {
            
        }
        
        return true
    }
    
    fileprivate func isExtensionAcceptable(draggingInfo: NSDraggingInfo) -> Bool {
        if draggingInfo.filePathURLs.count == 0 {
            return false
        }
        
        if (allowAllFileExtensions) {
            return true
        }
        
        for filePathURL in draggingInfo.filePathURLs {
            let fileExtension = filePathURL.pathExtension.lowercased()
            
            if !acceptedFileExtensions.contains(fileExtension){
                return false
            }
        }
        
        return true
    }
    
    public override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
}

public protocol ADragDropViewDelegate: class {
    func dragDropView(_ dragDropView: ADragDropView, droppedFileWithURL  URL: URL)
    func dragDropView(_ dragDropView: ADragDropView, droppedFilesWithURLs URLs: [URL])
    func mouseEntered(_ dragDropView: ADragDropView, with event: NSEvent)
    func mouseExited(_ dragDropView: ADragDropView, with event: NSEvent)
}

extension ADragDropViewDelegate {
    func dragDropView(_ dragDropView: ADragDropView, droppedFileWithURL  URL: URL) {
    }
    
    func dragDropView(_ dragDropView: ADragDropView, droppedFilesWithURLs URLs: [URL]) {
    }
    
    func mouseEntered(_ dragDropView: ADragDropView, with event: NSEvent) {
    }
    
    func mouseExited(_ dragDropView: ADragDropView, with event: NSEvent) {
    }
}
