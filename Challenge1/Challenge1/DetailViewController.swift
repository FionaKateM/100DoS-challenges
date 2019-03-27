//
//  DetailViewController.swift
//  Challenge1
//
//  Created by Fiona Kate Morgan on 02/03/2019.
//  Copyright © 2019 Fiona Kate Morgan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var flagImage: UIImageView!
    @IBOutlet var flagTitle: UILabel!
    
    var selectedImage: UIImage?
    var selectedTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flagImage.layer.borderColor = UIColor.lightGray.cgColor
        flagImage.layer.borderWidth = 1

        flagImage.image = selectedImage
        flagTitle.text = selectedTitle
     
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        
    }

    @objc func share() {
    
        guard let image = selectedImage, let title = selectedTitle else {
            print ("problem with image or title")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, title], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
    }
}
