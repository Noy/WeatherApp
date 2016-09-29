//
//  ViewController.swift
//  Weather App
//
//  Created by Noy Hillel on 29/09/2016.
//  Copyright © 2016 Inscriptio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var resultLabel: UILabel!
    
    @IBAction func submit(_ sender: AnyObject) {
        // Getting our URL - using the weather forecast website
        if let url = URL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
        
            // Getting our request for the website
            let request = NSMutableURLRequest(url: url)
        
            // Casting that request and setting the task.
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
            
                var message = ""
            
                // Checking if there IS an error
                if error != nil {
                    // For now, just log it
                    print(error)
                } else {
                    if let unwrappedData = data {
                        // Getting the dataString, with our UTF-8 Encoding (default)
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        // Seperating the String that we need
                        var stringSeparetor = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        if let contentArray = dataString?.components(separatedBy: stringSeparetor) {
                            if contentArray.count > 1 {
                                // Using that string to end at </span> which is where we need it to end (just for the weather to show up, not the whole site lol"
                                stringSeparetor = "</span>"
                                // We use this new Array then as a variable
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparetor)
                                if newContentArray.count > 1 {
                                    // Replace the &deg; with the symbol
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    print(message)
                                }
                            }
                        }
                    }
                }
                // Checking if the message is empty
                if message == "" {
                    // Error message
                    message = "The weather couldn't be found for that location, please try again"
                }
                DispatchQueue.main.sync(execute: {
                    // referencing our label variable, using "self" as it's within this task
                    self.resultLabel.text = message
                })
            }
            task.resume()
        } else {
            resultLabel.text = "The weather couldn't be found for that location, please try again"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    // this listens to when someone taps on the return key, could be used to do something like a google search
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

