//
//  ForumCell.swift
//  mySqlExApp1.1copy
//
//  Created by imac on 02/05/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit
import WebKit
protocol cellDelegator
{
    func callSegueFromCell(url:Any)
    func tapOnWebViewInCellHandler()
}
class ForumCell: UITableViewCell,WKScriptMessageHandler {

    @IBAction func favoritesAction(_ sender: Any) {
        delegate.callSegueFromCell(url: link_to_favorite)
        print(link_to_favorite)
    }
    
    @IBOutlet weak var footerStackView: UIStackView!
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var authorLabelOutlet: UILabel!
     var WebHeightConstraint: NSLayoutConstraint!
    var forumContentOutlet: WKWebView!
    var link_to_favorite:String!
    var delegate:cellDelegator!
    override func awakeFromNib() {
         let config = WKWebViewConfiguration()
         let source = "document.addEventListener('click', function(){ window.webkit.messageHandlers.iosListener.postMessage('click clack!'); })"
         let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
         config.userContentController.addUserScript(script)
         config.userContentController.add(self, name: "iosListener")
        let font=UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        dateLabelOutlet.font=font
        authorLabelOutlet.font=font
        forumContentOutlet=WKWebView(frame: CGRect(), configuration: config)
        forumContentOutlet.scrollView.isScrollEnabled=false
        contentView.addSubview(forumContentOutlet)
        forumContentOutlet.translatesAutoresizingMaskIntoConstraints=false
        forumContentOutlet.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive=true
        forumContentOutlet.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive=true
        forumContentOutlet.topAnchor.constraint(equalTo: footerStackView.bottomAnchor).isActive=true
        WebHeightConstraint=forumContentOutlet.heightAnchor.constraint(equalToConstant: 0)
        WebHeightConstraint.isActive=true
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate.tapOnWebViewInCellHandler()
    }


}

