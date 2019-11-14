//
//  LocationDetailViewController.swift
//  Ass1
//
//  Created by haofang Liu on 3/9/19.
//  Copyright © 2019 haofang Liu. All rights reserved.
//

import UIKit

class LocationDetailViewController: UIViewController {
    
    
    @IBOutlet weak var siteNameTextField: UILabel!
    
    @IBOutlet weak var siteDescription: UILabel!
    
    
    @IBOutlet weak var siteImage: UIImageView!
    
    var annotation: LocationAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if annotation != nil{
            siteNameTextField.text = "\(annotation?.title ?? "this is name" )"
            siteDescription.text = "\(annotation?.subtitle ?? "this is description" )"
            loadImageData(fileName: annotation!.siteFile!)
        }
        
    }
    
    func loadImageData(fileName: String) -> UIImage? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                       .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        var image: UIImage?
        if let pathComponent = url.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            let fileData = fileManager.contents(atPath: filePath)
            image = UIImage(data: fileData!)
        }
        
        return image
    }
    
//    func loadImage(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
