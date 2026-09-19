//
//  MarketGraphCollectionViewCell.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/9/21.
//

import UIKit
import WebKit

class MarketGraphCollectionViewCell: UICollectionViewCell {
    
    var marketGraph: MarketGraph? {
        didSet {
            updateUI()
        }
    }
    
    var url: URL?
    var webView: WKWebView?
    
    //MARK: - DEFAULT INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        addingMainWebView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CREATE UI
    private func addingMainWebView() {
        self.webView = WKWebView()
        guard let webView = self.webView else { return }
        self.webView?.scrollView.bounces = false
        self.webView?.backgroundColor = .cardsColor
        self.webView?.navigationDelegate = self
        contentView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: contentView.topAnchor),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    //MARK: - UPDATE UI
    private func updateUI() {
        guard let graph = marketGraph else { return }
        guard let url = URL(string: graph.url) else { return }
        self.url = url
        let request = URLRequest(url: url)
        webView?.load(request)
        
    }
}

extension MarketGraphCollectionViewCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if let url = self.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let javascriptString = "var meta = document.createElement('meta'); meta.setAttribute( 'name', 'viewport' ); meta.setAttribute( 'content', 'width = device-width, initial-scale = 1.0, shrink-to-fit=no' ); document.getElementsByTagName('head')[0].appendChild(meta)"
        webView.evaluateJavaScript(javascriptString, completionHandler: nil)
        let changeBackground = "document.body.style.backgroundColor = '#141721'"
        webView.evaluateJavaScript(changeBackground, completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let changeBackground = "document.body.style.backgroundColor = '#141721'"
        webView.evaluateJavaScript(changeBackground, completionHandler: nil)
    }
}
