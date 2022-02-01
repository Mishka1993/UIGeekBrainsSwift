//
//  AuthViewController.swift
//  VK
//
//  Created by Екатерина on 15.12.2021.
//

import UIKit
import WebKit
import FirebaseDatabase

class AuthViewController: UIViewController {
    @IBOutlet var webView: WKWebView!{
        didSet{
            webView.navigationDelegate = self
        }
    }
    private var urlComponents: URLComponents = {
        var urlComp = URLComponents()
        urlComp.scheme = "https"
        urlComp.host = "oauth.vk.com"
        urlComp.path = "/authorize"
        urlComp.queryItems = [
            URLQueryItem(name: "client_id", value: "8027967"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "336918"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.130"),
        ]
        return urlComp
    }()
    private lazy var request = URLRequest(url: urlComponents.url!)
    private let ref = Database.database().reference(withPath: "vkUserAuthLog")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(request)
    }
}
extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment  else {
                  decisionHandler(.allow)
                  return
              }
        //  разбиваем строку ответа на массив строк
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in // собираем из массива словарь
                var dict = result // буфер
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        guard let token = params["access_token"],
              let userIDString = params["user_id"],
              let userID = Int(userIDString) else { return decisionHandler(.allow) }
        
        if token.count > 0 && userID > 0 {
            Session.instance.token = token
            Session.instance.userId = userIDString
            
            // Firebase auth log
            let dt = Int(NSDate().timeIntervalSince1970)
            let vkUserLog = FirebaseVkUserAuthLog(
                userId: userID,
                dt: dt
            )
            let cityRef = ref.child(String(dt))
            cityRef.setValue(vkUserLog.toAnyObject())
            
            performSegue(withIdentifier: "showTabBarSegue", sender: nil)
            
        }
        decisionHandler(.cancel)
    }
    //         print("token = \(token)")
    //         print("user Id = \(userID)")
    //
    //         Session.instance.token = token
    //         Session.instance.userId = userIDString
    //
    //         performSegue(withIdentifier: "showTabBarSegue", sender: nil)
    //
    //         decisionHandler(.cancel)
}
