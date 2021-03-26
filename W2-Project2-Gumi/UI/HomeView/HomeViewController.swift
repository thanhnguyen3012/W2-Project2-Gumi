//
//  HomeViewController.swift
//  W2-Project2-Gumi
//
//  Created by Thành Nguyên on 22/03/2021.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupUI()
    }
    
    func setupUI() {
        textView.delegate = self
        textView.sizeToFit()
        textView.isEditable = true
        textView.isScrollEnabled = false
        
        label.isHidden = true
        label.isUserInteractionEnabled = true
        label.backgroundColor = .systemBackground
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        print("Button tapped.")
        convertTextViewToLabel()
    }
    
    func convertTextViewToLabel() {
        self.textViewDidEndEditing(textView)
        textView.isHidden = true
        
        saveButton.isEnabled = false
        
        label.text = textView.text
        label.textAlignment = .left
        label.numberOfLines = .max
        label.font = textView.font
        
        detectURLInlabel()
        label.isHidden = false
    }
    
    /// Change color for links in label
    func detectURLInlabel() {
        let text = textView.text!
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let links = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        let linkAttributedString = NSMutableAttributedString(string: text)
        label.textColor =  UIColor.black
        
        for link in links {
            linkAttributedString.addAttribute(.link, value: "google.com", range: link.range)
        }
        label.attributedText = linkAttributedString
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(recognizer:))))
    }
    
    /// Open Safari from a link
    func goToWebsite(url : String){
        print("Link tapped.")
        if let websiteUrl = URL(string: url){
            if #available(iOS 10, *) {
                UIApplication.shared.open(websiteUrl, options: [:], completionHandler: {
                    (success) in
                    print("Open \(websiteUrl): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(websiteUrl)
                print("Open \(websiteUrl): \(success)")
            }
        }
    }
    
    @objc func tapLabel(recognizer: UITapGestureRecognizer) {
        let text = textView.text!
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let links = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        for link in links{
//            print("Link.range: \(link.range)")
            if recognizer.didTapAttributedTextInLabel(label: label, inRange: link.range) {
                goToWebsite(url: String(text[Range(link.range, in: text)!]))
                return
            }
        }
        
        labelTapped()
    }
    
    /// User did not tap any link in label, this function will hide the label and show them textview (for edit)
    func labelTapped() {
        print("Label tapped.")
        label.isHidden = true
        self.textViewDidBeginEditing(textView)
        textView.isHidden = false
        saveButton.isEnabled = true
    }
}




extension HomeViewController: UITextViewDelegate {
    
    // Responding to Editing Notifications
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("textViewShouldBeginEditing")
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing")
        textView.isEditable = true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("textViewShouldEndEditing")
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        textView.isEditable = false
    }
    
    // Interacting with Text Data
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
}
