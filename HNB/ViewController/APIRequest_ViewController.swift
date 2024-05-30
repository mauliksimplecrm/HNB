//
//  APIRequest_ViewController.swift
//  HNB
//
//  Created by Maulik Vora on 16/08/23.
//

import Foundation
import UIKit
//import LaraCrypt
import CryptoSwift


extension ViewController{
    
    func apiCall_UPDATE_USER_DETAILS(strEncriptionString: String, lat: String, longi: String)  {
        //--
        let loginUserToken = UserDefaults.standard.object(forKey: "LoginUserToken") as? String ?? "default"
        let update_user_details = UserDefaults.standard.object(forKey: "update_user_details") as? String ?? ""
        
        
        
        //--
        var dicParam:[String:AnyObject] = [:]
        if isEnableEncryption{
            //--
            dicParam = ["data":strEncriptionString as AnyObject]
        }else{
            //--
            let devicetoken = UserDefaults.standard.object(forKey: "FirebaseToken") as? String ?? "default"
            let modelName = UIDevice.modelName

            //--
            dicParam = ["lat_c":"\(lat)" as AnyObject,
                        "longi_c":"\(longi)" as AnyObject,
                        "firebase_registration_id":["token": "\(devicetoken)",
                                                    "os":"iOS",
                                                    "model":"\(modelName)",
                                                    "os_version":"\(Bundle.main.releaseVersionNumber ?? "")"] as AnyObject]
        }
        
        HttpWrapper.requestWithPostMethod(url: update_user_details, dicsParams: dicParam, headers: ["Authorization":"Bearer \(loginUserToken)"], showProgress: false, completion: { (response) in
            print("++++++++++++ RESPONSE ++++++++++++++\n\(response as Any)")
            /*
             if let data_ = response as? [String : AnyObject]{
             print("\(data_["data"] as? String ?? "")")
             self.apptoweb_sendStringToDecrypt(strEnc: "\(data_["data"] as? String ?? "")")
             }
             */
            //                if let data_ = response as? [String : AnyObject]{
            //                    let res = data_["data"] as? String ?? ""
            
            //                    do {
            //                        let decryptedText = try aesDecryptWithoutIV(encryptedText: res, key: key)
            //                        print("Decrypted: \(decryptedText)")
            //                    } catch let error {
            //                        print(error.localizedDescription)
            //                    }
            // let decriptedStr : String = LaraCrypt().decrypt(Message: res, Key: encryptionKey)
            // print(decriptedStr)
            //                }
            
        }) { (error) in
            print(error)
        }
        
    }
    
    
    //------ API Call For The Create Ticket
    func apiCall_CreateTicket(strEncriptionString: String, description:String)
    {
        var dicParam:[String:AnyObject] = [:]
        
        //--
        let urlString = url
        
        if isEnableEncryption{
            dicParam = ["data":strEncriptionString as AnyObject]
        }else{
            let token = token
            
            let duration =  calculateDuration(startTime: started, endTime: ended)
            var requestObj = request as? [String : AnyObject]
            var dataObj = requestObj?["dataTicket"] as? [String : AnyObject]
            var attributesObj = dataObj?["attributes"] as? [String : AnyObject]
            
            attributesObj?["description"] = description as AnyObject
            
            dataObj?["attributes"] = attributesObj as AnyObject
            requestObj?["data"] = dataObj as AnyObject
            
            requestObj?.removeValue(forKey: "dataCall")
            requestObj?.removeValue(forKey: "dataTicket")
            
            dicParam = requestObj ?? [:]
        }

        //--
        HttpWrapper.requestWithPostMethod(url: urlString, dicsParams: dicParam, headers: ["Authorization":"Bearer \(token)"], showProgress: false, completion: { (response) in
            
            print("++++++++++++ RESPONSE ++++++++++++++\n\(response as Any)")
            if isEnableEncryption{
                if let data_ = response as? [String : AnyObject]{
                    print("\(data_["data"] as? String ?? "")")
                    self.apptoweb_sendStringToDecrypt(strEnc: "\(data_["data"] as? String ?? "")")
                }
            }else{
                
            }
            
            self.txtEnterDetail_TicketCreation.text = ""
            self.viewTicketCreation.isHidden = true
            self.showAlertSuccess(msg: "Ticket created successfully")
        }) { (error) in
            print(error)
        }
    }
    
    //------ API Call For The Create Call Log
    func makeApiCallToCreateCallLog(strEncriptionString: String){
        
        let urlString = url
        
        var dicParam:[String:AnyObject] = [:]
        
        if isEnableEncryption{
            dicParam = ["data":strEncriptionString as AnyObject]
        }else{
            
            
            let token = token
            print("urlString = \(urlString)")
            print("token = \(token)")
            
            if(urlString == nil){
                return;
            }
            
            let duration =  calculateDuration(startTime: started, endTime: ended)
            var requestObj = request as? [String : AnyObject]
            var dataObj = requestObj?["dataCall"] as? [String : AnyObject]
            var attributesObj = dataObj?["attributes"] as? [String : AnyObject]
            
            //Modify the request param data
            if(started == nil){
                attributesObj?["date_start"] = "" as AnyObject
                attributesObj?["date_end"] = "" as AnyObject
                attributesObj?["status"] = "Missed" as AnyObject
                
            }else{
                attributesObj?["date_start"] = convertDateToString(dateToConvert: started) as AnyObject
                attributesObj?["date_end"] = convertDateToString(dateToConvert: ended) as AnyObject
            }
            
            attributesObj?["duration_hours"] = hours as AnyObject
            attributesObj?["duration_minutes"] =  minutes as AnyObject
            attributesObj?["voice_call_duration_c"] = timeString as AnyObject
            dataObj?["attributes"] = attributesObj as AnyObject?
            requestObj?["data"] = dataObj as AnyObject?
            
            requestObj?.removeValue(forKey: "dataCall")
            requestObj?.removeValue(forKey: "dataTicket")
            
            dicParam = requestObj ?? [:]
        }
        
//        let jsonData1 = try! JSONSerialization.data(withJSONObject: requestObj)
//        let jsonString1 = NSString(data: jsonData1, encoding: String.Encoding.utf8.rawValue) as! String
//        print("makeApiCallToCreateCallLog: jsonString1 = \(jsonString1)")
        
        
        
        
        // create the url with URL
        let url = URL(string: urlString )!
        
        // create the session object
        let session = URLSession.shared
        
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        //        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.setValue("Bearer "+(token ), forHTTPHeaderField: "Authorization")
        
        do {
            // convert parameters to Data and assign dictionary to httpBody of request
            request.httpBody = try JSONSerialization.data(withJSONObject: dicParam, options: .prettyPrinted)
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
    
    
    
    
    
    //*************************************
    func aesEncrypt(text: String, key: String, iv: String) throws -> String {
        let data = text.data(using: .utf8)!
        let keyData = key.data(using: .utf8)!
        let ivData = iv.data(using: .utf8)!
        
        let aes = try AES(key: keyData.bytes, blockMode: CBC(iv: ivData.bytes), padding: .pkcs7)
        let encrypted = try aes.encrypt(data.bytes)
        let encryptedData = Data(encrypted)
        let base64String = encryptedData.base64EncodedString()
        
        return base64String
    }
    
    func aesDecrypt(encryptedText: String, key: String, iv: String) throws -> String {
        let encryptedData = Data(base64Encoded: encryptedText)!
        let keyData = key.data(using: .utf8)!
        let ivData = iv.data(using: .utf8)!
        
        let aes = try AES(key: keyData.bytes, blockMode: CBC(iv: ivData.bytes), padding: .pkcs7)
        let decrypted = try aes.decrypt(encryptedData.bytes)
        let decryptedData = Data(decrypted)
        
        if let decryptedText = String(data: decryptedData, encoding: .utf8) {
            return decryptedText
        } else {
            throw NSError(domain: "DecryptionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Decryption failed"])
        }
    }
    
    func jsonToString(json: [String:AnyObject]) -> String{
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: .utf8) // the data will be converted to the string
            print(convertedString) // <-- here is ur string
            return convertedString ?? ""
        } catch let myJSONError {
            print(myJSONError)
        }
        return ""
    }
}



