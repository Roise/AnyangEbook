//
//  PDFDocument.swift
//  Pods
//
//  Created by Chris Anderson on 3/5/16.
//
//

import UIKit

public class PDFDocument: NSObject, NSCoding {
    
    lazy public var documentRef:CGPDFDocument? = {
        do {
            return try CGPDFDocument.create(self.fileUrl, password: self.password)
        }
        catch {
            return nil
        }
    }()
    
    /// Document Properties
    public var password: String?
    public var lastOpen: NSDate?
    public var pageCount: Int = 0
    public var currentPage: Int = 1
    public var bookmarks: NSMutableIndexSet = NSMutableIndexSet()
    public var fileUrl: NSURL
    public var fileSize: Int = 0
    public var guid: String
    
    /// File Properties
    public var title: String?
    public var author: String?
    public var subject: String?
    public var keywords: String?
    public var creator: String?
    public var producer: String?
    public var modificationDate: NSDate?
    public var creationDate: NSDate?
    public var version:Float = 0.0
    
    static func documentFromFile(filePath: String, password: String?) throws -> PDFDocument? {
        
        var document:PDFDocument? = PDFDocument.unarchiveDocumentForFile(filePath, password: password)
        
        if document == nil {
            do {
                document = try PDFDocument(filePath: filePath, password: password)
            } catch let err {
                throw err
            }
        }
        
        return document
    }
    
    static func unarchiveDocumentForFile(filePath: String, password: String?) -> PDFDocument? {
        
        return nil
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        self.guid = aDecoder.decodeObjectForKey("fileGUID") as! String
        self.currentPage = aDecoder.decodeObjectForKey("currentPage") as! Int
        self.bookmarks = aDecoder.decodeObjectForKey("bookmarks") as! NSMutableIndexSet
        self.lastOpen = aDecoder.decodeObjectForKey("lastOpen") as? NSDate
        self.fileUrl = NSURL(fileURLWithPath: aDecoder.decodeObjectForKey("fileURL") as! String)
        
        super.init()
        
        try! self.loadDocumentInformation()
    }
    
    public convenience init(filePath: String) throws {
        do {
            try self.init(filePath: filePath, password: nil)
        } catch let err {
            throw err
        }
    }
    
    public init(filePath: String, password: String?) throws {
        
        self.guid = PDFDocument.GUID()
        self.password = password
        self.fileUrl = NSURL(fileURLWithPath: filePath, isDirectory: false)
        self.lastOpen = NSDate()
        
        super.init()
        
        do {
            try self.loadDocumentInformation()
        } catch let err {
            throw err
        }
        
        self.save()
    }
    
    func loadDocumentInformation() throws {
        
        do {
            
            let pdfDocRef:CGPDFDocumentRef = try CGPDFDocument.create(self.fileUrl, password: self.password)
            
            let infoDic:CGPDFDictionaryRef = CGPDFDocumentGetInfo(pdfDocRef)
            var string:CGPDFStringRef = nil
            
            if CGPDFDictionaryGetString(infoDic, "Title", &string) {
                
                if let ref:CFStringRef = CGPDFStringCopyTextString(string) {
                    self.title = ref as String
                }
            }
            
            if CGPDFDictionaryGetString(infoDic, "Author", &string) {
                
                if let ref:CFStringRef = CGPDFStringCopyTextString(string) {
                    self.author = ref as String
                }
            }
            
            if CGPDFDictionaryGetString(infoDic, "Subject", &string) {
                
                if let ref:CFStringRef = CGPDFStringCopyTextString(string) {
                    self.subject = ref as String
                }
            }
            
            if CGPDFDictionaryGetString(infoDic, "Keywords", &string) {
                
                if let ref:CFStringRef = CGPDFStringCopyTextString(string) {
                    self.keywords = ref as String
                }
            }
            
            if CGPDFDictionaryGetString(infoDic, "Creator", &string) {
                
                if let ref:CFStringRef = CGPDFStringCopyTextString(string) {
                    self.creator = ref as String
                }
            }
            
            if CGPDFDictionaryGetString(infoDic, "Producer", &string) {
                
                if let ref:CFStringRef = CGPDFStringCopyTextString(string) {
                    self.producer = ref as String
                }
            }
            
            if CGPDFDictionaryGetString(infoDic, "CreationDate", &string) {
                
                if let ref:CFDateRef = CGPDFStringCopyDate(string) {
                    self.creationDate = ref as NSDate
                }
            }
            
            if CGPDFDictionaryGetString(infoDic, "ModDate", &string) {
                
                if let ref:CFDateRef = CGPDFStringCopyDate(string) {
                    self.modificationDate = ref as NSDate
                }
            }
            
            //            let majorVersion = UnsafeMutablePointer<Int32>()
            //            let minorVersion = UnsafeMutablePointer<Int32>()
            //            CGPDFDocumentGetVersion(pdfDocRef, majorVersion, minorVersion)
            //            self.version = Float("\(majorVersion).\(minorVersion)")!
            
            self.pageCount = CGPDFDocumentGetNumberOfPages(pdfDocRef)
            
        } catch let err {
            
            throw err
        }
    }
    
    
    /////
    /// Helper methods
    /////
    
    static func GUID() -> String {
        
        return NSProcessInfo.processInfo().globallyUniqueString
    }
    
    public static func documentsPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    }
    
    public static func applicationPath() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return (paths.first! as NSString).stringByDeletingLastPathComponent
    }
    
    public static func applicationSupportPath() -> String {
        
        let fileManager = NSFileManager()
        let pathURL = try! fileManager.URLForDirectory(.ApplicationSupportDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        return pathURL.path!
    }
    
    static func archiveFilePathForFileAtPath(path: String) -> String {
        
        let archivePath = PDFDocument.applicationSupportPath()
        let archiveName = "random-name-fix-later.plist"
        return (archivePath as NSString).stringByAppendingPathComponent(archiveName)
    }
    
    static func isPDF(filePath: String) -> Bool {
        
        let state = false
        //        let path = (filePath as NSString).fileSystemRepresentation
        //        var fd = open(path, O_RDONLY)
        //        if fd > 0 {
        //            let sig = UnsafeMutablePointer<Character>.alloc(1024)
        //
        //            var len = read(fd, sig, sizeOfValue(sig))
        //
        //                state = (strnstr(sig, "%PDF", len) != NULL);
        //
        //                close(fd); // Close the file
        //            }
        
        return state;
    }
    
    func archiveWithFileAtPath(filePath: String) -> Bool {
        
        let archiveFilePath = PDFDocument.archiveFilePathForFileAtPath(filePath)
        return NSKeyedArchiver.archiveRootObject(self, toFile: archiveFilePath)
    }
    
    public func save() {
        
        self.archiveWithFileAtPath(self.fileUrl.path!)
    }
    
    public func reloadProperties() {
        try! self.loadDocumentInformation()
    }
    
    public func boundsForPDFPage(page:Int) -> CGRect {
        let pageRef = CGPDFDocumentGetPage(documentRef, page)
        
        let cropBoxRect:CGRect = CGPDFPageGetBoxRect(pageRef, .CropBox)
        let mediaBoxRect:CGRect = CGPDFPageGetBoxRect(pageRef, .MediaBox)
        let effectiveRect:CGRect = CGRectIntersection(cropBoxRect, mediaBoxRect)
        
        let pageAngle = CGPDFPageGetRotationAngle(pageRef)
        
        switch (pageAngle) {
        case 0, 180: // 0 and 180 degrees
            
            return CGRectMake(
                effectiveRect.origin.x,
                effectiveRect.origin.y,
                effectiveRect.size.width,
                effectiveRect.size.height
            )
        case 90, 270: // 90 and 270 degrees
            return CGRectMake(
                effectiveRect.origin.y,
                effectiveRect.origin.x,
                effectiveRect.size.height,
                effectiveRect.size.width
            )
        default:
            return CGRectMake(
                effectiveRect.origin.x,
                effectiveRect.origin.y,
                effectiveRect.size.width,
                effectiveRect.size.height
            )
        }
    }
    
    //    func setCurrentPage(currentPage: Int) {
    //
    //        if currentPage < 1 {
    //            self.currentPage = 1
    //        }
    //        else if currentPage > self.pageCount {
    //            self.currentPage = self.pageCount
    //        }
    //    }
    
    
    /////
    /// Helper methods
    /////
    
    public func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.guid, forKey: "fileGUID")
        aCoder.encodeObject(self.currentPage, forKey: "currentPage")
        aCoder.encodeObject(self.bookmarks, forKey: "bookmarks")
        aCoder.encodeObject(self.lastOpen, forKey: "lastOpen")
        aCoder.encodeObject(self.fileUrl.path!, forKey: "fileURL")
    }
}
