//
//  ViewController.swift
//  ZhiBook
//
//  Created by 林兴栋 on 2018/7/18.
//  Copyright © 2018年 林兴栋. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    var webView:WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url = NSURL(string: "http://test-h5.lanxinka.com/")
        
        let configuration = WKWebViewConfiguration()
        configuration.suppressesIncrementalRendering = false
        configuration.allowsInlineMediaPlayback = true//网页播放
        if #available(iOS 9.0, *) {
            configuration.allowsAirPlayForMediaPlayback = true
        } else {
            // Fallback on earlier versions
        }//airplay上播放
        if #available(iOS 9.0, *) {
            configuration.allowsPictureInPictureMediaPlayback = true
        } else {
            // Fallback on earlier versions
        }//画中画
        
        let pool = WKProcessPool()
        configuration.processPool = pool
        
        let preference = WKPreferences()
        preference.minimumFontSize = 0
        preference.javaScriptEnabled = true//允许js
        preference.javaScriptCanOpenWindowsAutomatically = true//台许自动打开窗口
        configuration.preferences = preference
        
        
        let userContentController = WKUserContentController()
        //设一个OC能识别的方法
        userContentController.add(self, name: "namell")
        //给网页注入一段js代码
        let jsSource = "function userFuncll(){window.webkit.messageHandlers.name.postMessage( {\"namell\":\"haha\"})}"
        let userScript = WKUserScript(source: jsSource, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userContentController.addUserScript(userScript)
        
        
        
//        configuration.userContentController = userContentController
        
        webView = WKWebView(frame: UIScreen.main.bounds, configuration: configuration)
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                print(cookie)
            }
        }
        
        let cookie = HTTPCookie(properties: [
            HTTPCookiePropertyKey.path : "/",
            HTTPCookiePropertyKey.name : "ga",
            HTTPCookiePropertyKey.value: "1",
            HTTPCookiePropertyKey.domain:"lanxinka.com"]
        )
        cookieStorage.setCookie(cookie!)
        
        self.view.addSubview(webView!);
        webView!.load(URLRequest(url: url! as URL))
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView?.configuration.userContentController.removeAllUserScripts()
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "namell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController:WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler{
    
    //MARK: - WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name,"=====",message.body)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //页面开始加载时调用
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //页面开始返回时调用
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //页面加载完成之后调用
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //页面加载完成有错之后调用
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        //页面加载错误之后调用

    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        //接收到服务器跳转请求之后调用
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        //在收到响应后，决定是否跳转
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //在发送请求前，决定是否跳转
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                print(cookie)
            }
        }
        
        
        
        decisionHandler(.allow)
    }
    
    //MARK: - WKUIDelegate
    //创建一个新的webView
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        return WKWebView()
    }
    
    //输入框
    //JS端调用prompt函数时，会触发此方法
    //要求输入一段文字
    //在原生输入得到文本内容后，通过completionHandler回调给js
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
    }
    
    //确认框
    //js端调用confirm函数时，会触发此方法
    //通过message可以拿到js端所传的数据
    //在iOS端显示原生alert得到YES/NO后
    //通过completionHandler回调给JS端
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
    }
    
    //警告框
    //在JS端调用alert函数时，会触发此代理方法。
    //JS端调用alert时所传的数据可以通过message拿到
    //在原生得到结果后，需要回调JS，是通过completionHandler回调
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
    
    
}

