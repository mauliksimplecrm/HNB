//
//  APIRequest_ViewController.swift
//  HNB
//
//  Created by Maulik Vora on 16/08/23.
//

import Foundation
import UIKit

extension ViewController{
    
    func apiCall_UPDATE_USER_DETAILS(Latitude lat:String, Longitude longi:String)  {
        //--
        let devicetoken = UserDefaults.standard.object(forKey: "FirebaseToken") as? String ?? "default"
        let loginUserToken = UserDefaults.standard.object(forKey: "LoginUserToken") as? String ?? "default"
        let modelName = UIDevice.modelName
        
        //--
        let dicParam:[String:AnyObject] = ["lat_c":lat as AnyObject,
                                           "longi_c":longi as AnyObject,
                                           "firebase_registration_id":["token": devicetoken,
                                                                       "os":"iOS",
                                                                       "model":modelName,
                                                                       "os_version":"\(Bundle.main.releaseVersionNumber ?? "")"] as AnyObject]
        HttpWrapper.requestWithPostMethod(url: API_UPDATE_USER_DETAILS, dicsParams: dicParam, headers: ["Authorization":"Bearer \(loginUserToken)"], showProgress: false, completion: { (response) in
            print("++++++++++++ RESPONSE ++++++++++++++\n\(response as Any)")
            
        }) { (error) in
            print(error)
        }
    }
    
    //------ API Call For The Create Ticket
    func apiCall_CreateTicket(Description desc:String)
    {
        //--
        let urlString = url
        let token = token
        print("urlString = \(urlString)")
        print("token = \(token)")

        let duration =  calculateDuration(startTime: started, endTime: ended)
        var requestObj = request as? [String : AnyObject]
        var dataObj = requestObj?["dataTicket"] as? [String : AnyObject]
        var attributesObj = dataObj?["attributes"] as? [String : AnyObject]
       
        attributesObj?["description"] = desc as AnyObject
        
        dataObj?["attributes"] = attributesObj as AnyObject
        requestObj?["data"] = dataObj as AnyObject
        
        requestObj?.removeValue(forKey: "dataCall")
        requestObj?.removeValue(forKey: "dataTicket")
        
        //print("Request Parameter:\n\(requestObj ?? [:])")
        //--
        /*let dicParam:[String:AnyObject] = ["lat":lat as AnyObject,
                                           "longi":longi as AnyObject,
                                           "firebase_registration_id":["token": "",
                                                                       "os":"iOS",
                                                                       "model":"",
                                                                       "os_version":"\(Bundle.main.releaseVersionNumber ?? "")"] as AnyObject]*/
        HttpWrapper.requestWithPostMethod(url: urlString, dicsParams: requestObj ?? [:], headers: ["Authorization":"Bearer \(token)"], showProgress: false, completion: { (response) in
            
            print("++++++++++++ RESPONSE ++++++++++++++\n\(response as Any)")
            self.txtEnterDetail_TicketCreation.text = ""
            self.viewTicketCreation.isHidden = true
            self.showAlertSuccess(msg: "Ticket created successfully")
        }) { (error) in
            print(error)
        }
    }
    
    //------ API Call For The Create Call Log
    func makeApiCallToCreateCallLog(){
        
        let urlString = url
        let token = token
        print("urlString = \(urlString)")
        print("token = \(token)")
        
        if(urlString == nil){
            return;
        }
        
        let duration =  calculateDuration(startTime: started, endTime: ended)
        var requestObj = request as? [String : Any]
        var dataObj = requestObj?["dataCall"] as? [String : Any]
        var attributesObj = dataObj?["attributes"] as? [String : Any]
        
        //Modify the request param data
        if(started == nil){
            attributesObj?["date_start"] = ""
            attributesObj?["date_end"] = ""
            attributesObj?["status"] = "Missed"
            
        }else{
            attributesObj?["date_start"] = convertDateToString(dateToConvert: started as? Date)
            attributesObj?["date_end"] = convertDateToString(dateToConvert: ended as? Date)
        }
        
        attributesObj?["duration_hours"] = hours
        attributesObj?["duration_minutes"] =  minutes
        attributesObj?["voice_call_duration_c"] = timeString
        dataObj?["attributes"] = attributesObj
        requestObj?["data"] = dataObj
        
        requestObj?.removeValue(forKey: "dataCall")
        requestObj?.removeValue(forKey: "dataTicket")
        
        let jsonData1 = try! JSONSerialization.data(withJSONObject: requestObj)
        let jsonString1 = NSString(data: jsonData1, encoding: String.Encoding.utf8.rawValue) as! String
        print("makeApiCallToCreateCallLog: jsonString1 = \(jsonString1)")
        
        
        // create the url with URL
        let url = URL(string: urlString as! String)!
        
        // create the session object
        let session = URLSession.shared
        
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        //        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.setValue("Bearer "+(token as! String), forHTTPHeaderField: "Authorization")
        
        do {
            // convert parameters to Data and assign dictionary to httpBody of request
            request.httpBody = try JSONSerialization.data(withJSONObject: requestObj, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error in
            
            print("Response data = \(data) response = \(response) error = \(error)")
            
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    //Do UI Work
                    self.showAlertMessage(msg: "Error:  \(error.localizedDescription)")              }
                return
            }
            
            //ensure there is valid response code returned from this HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("Invalid Response received from the server")
                DispatchQueue.main.async {
                    //Do UI Work
                    self.showAlertMessage(msg: "Invalid Response")
                }
                return
            }
            //
            // ensure there is data returned
            guard let responseData = data else {
                print("nil Data received from the server")
                DispatchQueue.main.async {
                    //Do UI Work
                    self.showAlertMessage(msg: "Nil data received")
                }
                return
            }
            
            do {
                // create json object from data or use JSONDecoder to convert to Model stuct
                if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
                    print("Success! jsonResponse = \(jsonResponse)")
                    // handle json response
                    DispatchQueue.main.async {
                        //Do UI Work
                        //self.showAlertSuccess(msg: "Call log created successfully")
                        
                    }
                    //Show alert that call log success
                } else {
                    print("data maybe corrupted or in wrong format")
                    DispatchQueue.main.async {
                        //Do UI Work
                        self.showAlertMessage(msg: "Failed:  wrong format")
                    }
                }
            } catch let error {
                print(error.localizedDescription)
                
                DispatchQueue.main.async {
                    //Do UI Work
                    self.showAlertMessage(msg: "Failed: error = \(error.localizedDescription)")
                }
            }
        }
        // perform the task
        task.resume()
        
    }
    
    
}
