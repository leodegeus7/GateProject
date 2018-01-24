//
//  ViewController.swift
//  OpenDoorIoT
//
//  Created by Leonardo Geus on 23/01/2018.
//  Copyright © 2018 Leonardo Geus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!
    
    var lastId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        requests()
        cleanInterface()
        
        updateInterface(tag: "64d64fff")
    }


    @IBAction func acceptButtonTap(_ sender: Any) {
        self.view.backgroundColor = UIColor.green
        useDoor(int: 8) { (bool) in
            self.cleanInterface()
        }
    }
    
    @IBAction func clean(_ sender: Any) {
        cleanInterface()
    }
    
    @IBAction func denyButtonTap(_ sender: Any) {
        self.view.backgroundColor = UIColor.red
        useDoor(int: 3) { (bool) in
            self.cleanInterface()
        }
    }
    
    func useDoor(int:Int, completion: @escaping (Bool) -> ()) {
        let url = URL(string: "http://172.20.10.3:8080/movePos/\(int)")!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if (error != nil) {
                print("")
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    print(json as NSDictionary)
                } catch let error as NSError{
                    print(error)
                }
                completion(true)
            }
        }).resume()
    }
    
    func cleanInterface() {
        DispatchQueue.main.async {
            self.view.backgroundColor = UIColor.black
            self.acceptButton.isHidden = true
            self.denyButton.isHidden = true
            self.imageUser.image = nil
            
        }
    }
    
    func updateInterface(tag:String) {
        DispatchQueue.main.async {
            self.view.backgroundColor = UIColor.black
            self.denyButton.isHidden = false
            self.acceptButton.isHidden = false
        if tag == "44628614" {
            self.imageUser.image = UIImage(named: "carol.png")
        } else if tag == "64d64fff" {
            self.imageUser.image = UIImage(named: "leo.jpg")
        } else if tag == "14554a49" {
            self.imageUser.image = UIImage(named: "diler.png")
        }
        print("Mudouuu")
        }
    }
    
    func requests() {
        getLastRecord { (tag) in
            if tag != "" {
                self.updateInterface(tag: tag)
            }
            sleep(2)
            self.requests()
        }
    }
    
    
    func getLastRecord(completion: @escaping (String) -> ()) {
        let url = URL(string: "http://172.20.10.2:8000/api/task")!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if (error != nil) {
                print("172.20.10.2:8000/api/task")
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    // For count
                    let id = json["id"] as! Int
                    let tag = json["tag"] as! String
                    if self.lastId != id {
                        self.lastId = id
                        completion(tag)
                    } else {
                        self.lastId = id
                        completion("")
                    }
                } catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
    }
}

