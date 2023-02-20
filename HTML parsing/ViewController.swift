//
//  ViewController.swift
//  HTML parsing
//
//  Created by Andrei Sushkou on 20.02.23.
//

import WebKit
import UIKit

final class ViewController: UIViewController {
    
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero,
                                configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    private let parser = HTMLParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        guard let url = URL(string: "https://techcrunch.com") else { return }
        view.addSubview(webView)
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
        }
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
}


extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.innerHTML") { [weak self] result, error in
            guard let html = result as? String, error == nil else {
                print ("Fail to get html")
                return
            }
            self?.parser.parse(html: html)
        }
    }
}

