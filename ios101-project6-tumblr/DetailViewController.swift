//
//  DetailViewController.swift
//  ios101-project6-tumblr
//
//  Created by Michael Elder on 7/22/25.
//

import UIKit
import NukeExtensions

class DetailViewController: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    
    var post: Post?

    override func viewDidLoad() {
        super.viewDidLoad()

        captionTextView.isEditable = false

        postImageView.layer.cornerRadius = 12
        postImageView.layer.shadowColor = UIColor.black.cgColor
        postImageView.layer.shadowOpacity = 0.25
        postImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        postImageView.layer.shadowRadius = 6
        postImageView.clipsToBounds = false
        
        postImageView.layer.borderColor = UIColor.lightGray.cgColor
        postImageView.layer.borderWidth = 0.5
        
        if let post = post {
           // captionTextView.text = post.caption //! THIS CAUSES RAW HMTL TO BE RENDERED
        
            
            // this resolves that issue
            
            if let data = post.caption.data(using: .utf8),
               let attributedHTML = try? NSMutableAttributedString(
                   data: data,
                   options: [
                       .documentType: NSAttributedString.DocumentType.html,
                        .characterEncoding: String.Encoding.utf8.rawValue
                   ],
                   documentAttributes: nil
               ) {

                let fullRange = NSRange(location: 0, length: attributedHTML.length)
                
                if let markerFont = UIFont(name: "MarkerFelt-Wide", size: 12) {
                    attributedHTML.addAttribute(.font, value: markerFont, range: fullRange)
                }
                attributedHTML.addAttribute(.foregroundColor, value: UIColor.blue, range: fullRange)
                attributedHTML.addAttribute(.kern, value: 0.4, range: fullRange)

                captionTextView.attributedText = attributedHTML

            } else {
                captionTextView.text = post.caption
            }
            
            
            if let photo = post.photos.first {
                NukeExtensions.loadImage(with: photo.originalSize.url, into: postImageView)
            }
        }
    }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

