//
//  PDFSinglePageViewer.swift
//  Pods
//
//  Created by Chris Anderson on 3/6/16.
//
//

import UIKit

public protocol PDFSinglePageViewerDelegate {
    
    func singlePageViewer(collectionView: PDFSinglePageViewer, didDisplayPage page:Int)
    func singlePageViewer(collectionView: PDFSinglePageViewer, loadedContent content:PDFPageContentView)
    func singlePageViewer(collectionView: PDFSinglePageViewer, selectedAction action:PDFAction)
}

public class PDFSinglePageViewer: UICollectionView {
    
    public var singlePageDelegate:PDFSinglePageViewerDelegate?
    
    public var document:PDFDocument?
    private var bookmarkedPages:[String]?
    
    public init(frame: CGRect, document: PDFDocument) {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        self.document = document
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        setupCollectionView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        super.init(coder: aDecoder)
        self.collectionViewLayout = layout
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        
        self.pagingEnabled = true
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.showsHorizontalScrollIndicator = false
        self.registerClass(PDFSinglePageCell.self, forCellWithReuseIdentifier: "ContentCell")
        
        self.delegate = self
        self.dataSource = self
        
        guard let document = self.document else { return }
        
        self.displayPage(document.currentPage, animated: false)
        
        if let pageContentView = self.getPageContent(document.currentPage) {
            self.singlePageDelegate?.singlePageViewer(self, loadedContent: pageContentView)
        }
    }
    
    public func indexForPage(page: Int) -> Int {
        
        var currentPage = page - 1
        if currentPage <= 0 {
            currentPage = 0
        }
        if let document = self.document where currentPage > document.pageCount {
            currentPage = document.pageCount - 1
        }
        return currentPage
    }
    
    public func displayPage(page: Int, animated: Bool) {
        
        let currentPage = self.indexForPage(page)
        let indexPath = NSIndexPath(forItem: currentPage, inSection: 0)
        self.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: animated)
    }
    
    public func getPageContent(page: Int) -> PDFPageContentView? {
        if self.document == nil { return nil }
        let currentPage = self.indexForPage(page)
        if let cell = self.collectionView(self, cellForItemAtIndexPath: NSIndexPath(forItem: currentPage, inSection: 0)) as? PDFSinglePageCell,
            let pageContentView = cell.pageContentView {
            return pageContentView
        }
        return nil
    }
}

extension PDFSinglePageViewer: UICollectionViewDataSource {
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let document = self.document else {
            return 0
        }
        return document.pageCount
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:PDFSinglePageCell = self.dequeueReusableCellWithReuseIdentifier("ContentCell", forIndexPath: indexPath) as! PDFSinglePageCell
        
        var contentSize:CGRect = CGRectZero
        contentSize.size = self.collectionView(collectionView, layout: self.collectionViewLayout, sizeForItemAtIndexPath: indexPath)
        
        let page = indexPath.row + 1
        
        cell.contentView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        cell.pageContentView = PDFPageContentView(frame: contentSize, document: self.document!, page: page)
        cell.pageContentView?.contentDelegate = self
        
        return cell
    }
}

extension PDFSinglePageViewer: UICollectionViewDelegate {
    
    public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let pdfCell = cell as! PDFSinglePageCell
        if let pageContentView = pdfCell.pageContentView {
            self.singlePageDelegate?.singlePageViewer(self, loadedContent: pageContentView)
        }
    }
}

extension PDFSinglePageViewer: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var size = self.bounds.size
        size.height -= self.contentInset.bottom + self.contentInset.top + 1
        
        return size
    }
}

extension PDFSinglePageViewer: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.didDisplayPage(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.didDisplayPage(scrollView)
    }
    
    func didDisplayPage(scrollView: UIScrollView) {
        let page:Int = Int((scrollView.contentOffset.x + scrollView.frame.size.width) / scrollView.frame.size.width)
        self.singlePageDelegate?.singlePageViewer(self, didDisplayPage: page)
    }
}

extension PDFSinglePageViewer: PDFPageContentViewDelegate {
    
    public func contentView(contentView: PDFPageContentView, didSelectAction action: PDFAction) {
        
        if let singlePageDelegate = singlePageDelegate {
            singlePageDelegate.singlePageViewer(self, selectedAction: action)
        }
        else if let action = action as? PDFActionGoTo {
            self.displayPage(action.pageIndex, animated: true)
        }
    }
}




public class PDFSinglePageCell:UICollectionViewCell {
    
    private var _pageContentView:PDFPageContentView?
    public var pageContentView:PDFPageContentView? {
        get {
            return self._pageContentView
        }
        set {
            if let pageContentView = self._pageContentView {
                self.removeConstraints(self.constraints)
                pageContentView.removeFromSuperview()
            }
            if let pageContentView = newValue {
                self._pageContentView = pageContentView
                self.contentView.addSubview(pageContentView)
            }
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override public func prepareForReuse() {
        
        self.pageContentView = nil
    }
    
}