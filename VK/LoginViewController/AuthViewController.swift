//
//  AuthViewController.swift
//  VK
//
//  Created by Екатерина on 15.12.2021.
//

import UIKit
import WebKit
import Alamofire

class AuthViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet var webView: WKWebView!{
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeToVK()
    }
    func authorizeToVK() {

             var urlComponents = URLComponents()
             urlComponents.scheme = "https"
             urlComponents.host = "oauth.vk.com"
             urlComponents.path = "/authorize"
             urlComponents.queryItems = [
                 URLQueryItem(name: "client_id", value: "7822904"),
                 URLQueryItem(name: "display", value: "mobile"),
                 URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                 URLQueryItem(name: "scope", value: "262150"),
                 URLQueryItem(name: "response_type", value: "token"),
                 URLQueryItem(name: "revoke", value: "1"),
                 URLQueryItem(name: "v", value: "5.68")
             ]

             let request = URLRequest(url: urlComponents.url!)

             webView.load(request)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

             guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
                 decisionHandler(.allow)
                 return
             }
        let params = fragment
                             .components(separatedBy: "&")
                             .map { $0.components(separatedBy: "=") }
                             .reduce([String: String]()) { result, param in
                                             var dict = result //буфер
                                             let key = param[0]
                                             let value = param[1]
                                             dict[key] = value
                                             return dict
                                     }

                guard let token = params["access_token"], let userId = params["user_id"] else { return }

                Session.instance.token = token
                Session.instance.userId = Int(userId) ?? 0
        
                let networkServices = NetworkServices()
        
                networkServices.getFriends()
                networkServices.getGroups()
                networkServices.getPhotos()
                networkServices.searchGroups("Двач")
        
                performSegue(withIdentifier: "showProfileUser", sender: nil)

                print(url)

                decisionHandler(.cancel)
                

        }
}
