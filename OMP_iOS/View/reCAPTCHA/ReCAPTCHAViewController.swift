import UIKit
import WebKit

final class ReCAPTCHAViewController: UIViewController {
    private var webView: WKWebView!
    private let viewModel: ReCAPTCHAViewModel

    init(viewModel: ReCAPTCHAViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("")
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        
        contentController.add(viewModel, name: "recaptcha")
        webConfiguration.userContentController = contentController

        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.backgroundColor = .cardsColor
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.loadHTMLString(viewModel.html, baseURL: viewModel.url)
    }
}

extension ReCAPTCHAViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        BaseModule.sharedInstance.loader.stopLoading()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        BaseModule.sharedInstance.loader.startLoading()
    }
}
