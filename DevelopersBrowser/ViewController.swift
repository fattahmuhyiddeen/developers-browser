//
//  ViewController.swift
//  Project4
//
//  Created by TwoStraws on 13/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
	var webView: WKWebView!
	var progressView: UIProgressView!
    var typedURL: String!
    

	var websites = ["apple.com", "hackingwithswift.com"]
    
    var history = [] as NSMutableArray

	override func loadView() {
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let url = URL(string: "https://" + websites[0])!
//        webView.load(URLRequest(url: url))
        webView.load(URLRequest(url: URL(string: "https://google.com")!))
		webView.allowsBackForwardNavigationGestures = true

		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "History", style: .plain, target: self, action: #selector(editStored))

		progressView = UIProgressView(progressViewStyle: .default)
		progressView.sizeToFit()
		let progressButton = UIBarButtonItem(customView: progressView)

		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))

		toolbarItems = [progressButton, spacer, refresh]
		navigationController?.isToolbarHidden = false

		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
	}
    
    @objc func editStored(){
                let ac = UIAlertController(title: "Only URL typed only will be saved here ...", message: nil, preferredStyle: .actionSheet)
        
                for website in history {
                    ac.addAction(UIAlertAction(title: website as! String, style: .default, handler: openPage))
                }
        
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
                present(ac, animated: true)
    }

	@objc func editTapped() {

        
        let alert = UIAlertController(title: "Enter URL", message: "Please enter exactly including http or https", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Go", style: .cancel) { (alertAction) in
            let tf = alert.textFields![0] as UITextField
//            print(tf.text as! String)
            let txt = tf.text
            if txt != nil {
                if txt! != "" {
                    
                    self.typedURL = txt!
                    
                    self.history.add(self.typedURL)
                    let day_url = URL(string: self.typedURL)
                    let day_url_request = URLRequest(url: day_url!,
                                                     cachePolicy:NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData,
                                                     timeoutInterval: 10.0)
                    
                    self.webView.load(day_url_request)
                    
//                    self.webView.load(URLRequest(url: URL(string: txt!)!))
                }
            }

        }
        alert.addTextField { (tf) in
            tf.placeholder = "Enter your URL"
            tf.text = self.typedURL
            tf.clearButtonMode = UITextFieldViewMode.whileEditing
            
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(action)
        present(alert, animated: true)
        

	}

    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webView.title
	}

	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		let url = navigationAction.request.url
        
//        if let host = url!.host {
//            for website in websites {
//                if host.range(of: website) != nil {
//                    decisionHandler(.allow)
//                    return
//                }
//            }
//        }
        
        decisionHandler(.allow)
        return

//        decisionHandler(.cancel)
	}

	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(webView.estimatedProgress)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

