//
//  ViewController.swift
//  SalesMobiX
//
//  Created by SonalWararkar on 12/04/22.
//

import UIKit
import WebKit
import AVFoundation
import Photos
import Foundation
//To get call events
import CallKit
//To get location
import CoreLocation

import AdSupport


class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIBarPositioningDelegate, WKScriptMessageHandler {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var wkWebView: WKWebView!
    
    @IBOutlet weak var viewRegisterDevice: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var btnRegisterDevice: UIButton!
    
    @IBOutlet weak var viewLocationPermission: UIView!
    @IBOutlet weak var btnAllowLocationPermission: UIButton!
    @IBOutlet weak var btnOpenSettingsLocationPermission: UIButton!
    
    @IBOutlet weak var viewTicketCreation: UIView!
    @IBOutlet weak var lblTitle_TicketCreation: UILabel!
    @IBOutlet weak var lblDetail_TicketCreation: UILabel!
    @IBOutlet weak var txtEnterDetail_TicketCreation: UITextView!
    
    @IBOutlet weak var viewJailAlert: UIView!
    
    @IBOutlet weak var imgiconJailbreak: UIImageView!
    @IBOutlet weak var lblTitle_jailbreak: UILabel!
    
    
    //MARK: - Veriable
    var callObs : CXCallObserver!
    var locationManager: CLLocationManager!
    
    var callDuration = ""
    var started: Date? = nil
    var ended: Date? = nil
    var callEventsMessage = ""
    
    //Save details for Call Event
    var url = ""
    var token = ""
    var phone = ""
    var module = ""
    var recordId = ""
    var request : AnyObject = {} as AnyObject
    var hours = 0
    var minutes = 0
    var seconds  = 0
    var timeString = ""
    var obj : AnyObject = {} as AnyObject
    
    var timestampStart : Int64? = nil;
    
    let button = UIButton(frame: CGRect(x: 0,y: 0,width: 200,height: 60))
    
    let DEFAULT_URL : String = DEFAULT_INSTANCE_URL //Instance url mentioned in Config file
    
    var mNativeToWebHandler_FetchShowSettingsButton : String = "showChangeInstanceButtonIOS"
    var mNativeToWebHandler_FetchHideSettingsButton : String = "hideChangeInstanceButtonIOS"
    
    var mNativeToWebHandler_StartFetchingUserLocation : String = "getLocationButtonClickedIOS"
    var mNativeToWebHandler_StartDialingANumber : String = "callEventButtonClickedIOS"
    
    var mNativeToWebHandler_getDeviceId : String = "getDeviceId"
    var mNativeToWebHandler_getLoginUserID : String = "getLoginUserID"
    
    var mNativeToWebHandler_getEncryptedString : String = "getEncryptedString"
    var mNativeToWebHandler_getDecryptedString : String = "getDecryptedString"
    
    var webConsoleLogs : String = "logHandler"
    
    var locationTextField : String = ""
    
    let reachability = try! Reachability()
    
    var encryptionRequestFor = ""
    
    
    //MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        print("loadView")
        /*showLoader()*/
        
        initWkWebView()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        print("viewDidLoad")
        testButton.isHidden = true
        // Do any additional setup after loading the view.
        loadWebView()
        
        //Initialise the call event observer
        callObs = CXCallObserver()
        
        /*
        //----- Temp Comment For the Testing
        //Prevent taking screenshots
        ScreenGuardManager.shared.screenRecordDelegate = self
        ScreenGuardManager.shared.listenForScreenRecord()
        ScreenGuardManager.shared.guardScreenshot(for: self.view)
        */
        
        //        guard  let window = UIApplication.shared.windows.last else {
        //            return
        //        }
        //        ScreenGuardManager.shared.guardScreenshot(for: window)
        
//        if getJailbrokenStatus() {
//            //            let alertController = UIAlertController(title: "Jailbreak Device", message: "", preferredStyle: .alert)
//            //
//            //            let cancelAction = UIAlertAction(title: "OK", style: .cancel)
//            //            alertController.addAction(cancelAction)
//            //
//            //            self.present(alertController, animated: true, completion: nil)
//            viewJailAlert.isHidden = false
//        }else if getSIMULTORRUNAPP(){
//            viewJailAlert.isHidden = false
//            
//            imgiconJailbreak.image = UIImage(named: "ic_no_phone")
//            lblTitle_jailbreak.text = "Emulator detected, App is restricted to run on emulators.\n\nPlease use a smartphone to run the app."
//            
//        }else{
//            viewJailAlert.isHidden = true
//        }
        
        
        
        //--
        //askPermissionPhotos()
        
        //- Get Device UDID
        //getUniqueDeviceIdentifier()
        
        //- Check location permission
        //Setup the location manager
        //initCurrentLocation()
        //requestLocationPermission()
        
        

        //--
        NotificationCenter.default.addObserver(self, selector: #selector(self.ReceivePushNotification(notification:)), name: Notification.Name("ReceivePushNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.did_Check_Location_Permission(notification:)), name: Notification.Name("did_Check_Location_Permission"), object: nil)
        
        //-------------
        /*do {
            let plaintext = "{\n  \"firebase_registration_id\" : {\n    \"os\" : \"iOS\",\n    \"model\" : \"iPhone 8 Plus\",\n    \"os_version\" : \"1.0.4\",\n    \"token\" : \"dsXLO0nnJksphF8dvtrpU-:APA91bGzwUAnMjVUtP8N3bmaWcq8LaDdIjjSKZMIK2bMhxKI6tsAIDliupNm5RUS-GkHfrUPnRY4hTUg0taTK1UQiPuhd27ITPlgc1BlZYeot35XcumUxTfRasOL5CaVBLSo2CvZ8Eb4\"\n  },\n  \"lat_c\" : \"23.048468\",\n  \"longi_c\" : \"72.673050\"\n}"
            let key = "0123456789ABCDEF0123456789ABCDEF" //"0123456789ABCDEF0123456789ABCDEF" // 32-character key
            let iv = "0123456789ABCDEF" // 16-character IV
            //373632764d5243706c706d6973
            do {
                let encryptedText = try aesEncrypt(text: plaintext, key: key, iv: iv)
                print("Encrypted: \(encryptedText)")
                
                let decryptedText = try aesDecrypt(encryptedText: encryptedText, key: key, iv: iv)
                print("Decrypted: \(decryptedText)")
            } catch let error {
                print(error.localizedDescription)
            }
            
        } catch let error {
            print(error.localizedDescription)
        }*/
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        checkLocationPermission()
        
        //Internet check
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            //print("could not start reachability notifier")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print("viewDidAppear")
        //Do not initialise or load webview here, because it get called in many ways many time
        /*showInitialSettingsPopup()*/
        
        
        //--
        callObs.setDelegate(self, queue: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self);
    }
    
    
    //MARK: - Check Internet
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("") //"Reachable via WiFi"
        case .cellular:
            print("") //"Reachable via Cellular"
        case .unavailable:
            print("") //"Network not reachable"
        }
    }
    
    
    //MARK: - Custome Func
    @objc func ReceivePushNotification(notification: Notification) {
        //print("-----------------------Receive Push Notification-------------------------")
        if  let notiURL = UserDefaults.standard.object(forKey: "Notification_URL") as? String{
            
            
            loadWebView(notificationURL: notiURL)
            
            UserDefaults.standard.removeObject(forKey: "Notification_URL")
            UserDefaults.standard.synchronize()
        }
    }
    @objc func did_Check_Location_Permission(notification: Notification) {
        //--
        checkLocationPermission()
    }

    func getUniqueDeviceIdentifier()  {
        //let uniqueIdentifier = UIDevice.current.identifierForVendor!.uuidString
        //print("uniqueIdentifier ===>  " + uniqueIdentifier)
        
        //        let id_ = ASIdentifierManager.shared().advertisingIdentifier
        //        print("id_ ===>  " + "\(id_.description)")
        
        //let getUDID_ = getUUID()
        //lblDetail.text = replaceMiddleCharacter(of: getUDID_, withCharacter: "*", offset: 4)
        //print("UUID ===>  " + getUDID_)
        //viewRegisterDevice.isHidden = false
        
    }
    
    @objc func screenshotTaken(){
        //print("screenshotTaken: Screenshot taken!")
    }
    
    func getSIMULTORRUNAPP() -> Bool{
        print(TARGET_IPHONE_SIMULATOR)
        if TARGET_IPHONE_SIMULATOR != 1 {
            return false
        }else{
            return true
        }
    }
    
    private func getJailbrokenStatus() -> Bool {
        if TARGET_IPHONE_SIMULATOR != 1 {
            // Check 1 : existence of files that are common for jailbroken devices
            if FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
                || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
                || FileManager.default.fileExists(atPath: "/bin/bash")
                || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
                || FileManager.default.fileExists(atPath: "/etc/apt")
                || FileManager.default.fileExists(atPath: "/private/var/lib/apt/")
                || UIApplication.shared.canOpenURL(URL(string:"cydia://package/com.example.package")!) {
                return true
            }
            // Check 2 : Reading and writing in system directories (sandbox violation)
            let stringToWrite = "Jailbreak Test"
            do {
                try stringToWrite.write(toFile:"/private/JailbreakTest.txt", atomically:true, encoding:String.Encoding.utf8)
                //Device is jailbroken
                return true
            } catch {
                return false
            }
        }
        else {
            return false
        }
    }
    
    func loadWebView(notificationURL url_: String? = ""){
        /*let strings = UserDefaults.standard.value(forKey: "InstanceURL") as? String;*/
        if url_ != ""{
            let myURL = URL(string:url_ ?? self.DEFAULT_URL)
            let myRequest = URLRequest(url: myURL!)
            self.wkWebView.load(myRequest)
        }else{
            let url =  self.DEFAULT_URL
            let myURL = URL(string:url)
            let myRequest = URLRequest(url: myURL!)
            self.wkWebView.load(myRequest)
        }
        /*else if(strings != nil)
        {
            let url =  strings ?? self.DEFAULT_URL
            let myURL = URL(string:url)
            let myRequest = URLRequest(url: myURL!)
            self.wkWebView.load(myRequest)
        }*/
    }
    
    /*
    func showInitialSettingsPopup(){
        let strings = UserDefaults.standard.value(forKey: "InstanceURL") as? String;
        if(strings == nil){
            
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Instance URL", message: "Please enter an instance URL you would like to access.", preferredStyle: .alert)
            let strings = UserDefaults.standard.value(forKey: "InstanceURL") as? String;
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = strings
                textField.placeholder = "Instance URL"
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            
            let alertActionPositive = UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                //print("Text field: \(textField!.text)")
                
                if let userInput = textField!.text {
                    if userInput == "" {
                        self.present(alert!, animated: true, completion: nil)
                    }else{
                        //Save the Instance URL in User Defaults
                        let userDefaults = UserDefaults.standard
                        userDefaults.setValue(textField!.text, forKey: "InstanceURL")
                        
                        let url =  textField?.text ?? self.DEFAULT_URL
                        
                        let myURL = URL(string:url)
                        let myRequest = URLRequest(url: myURL!)
                        self.wkWebView.load(myRequest)
                    }
                }
                
            })
            //Set button text color
            let colorDefault = hexStringToUIColor(hex:"#4dc1f0")
            alertActionPositive.setValue(colorDefault, forKey: "titleTextColor")
            
            
            alert.addAction(alertActionPositive)
            
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
    }
    */
    /*
    func showLoader(){
        
        initLoader()
        //Hardcode the instance URL
        UserDefaults.standard.setValue(self.DEFAULT_URL, forKey: "InstanceURL")//##TEST HARDCODE THIS
        
        // Access Shared Defaults Object
        // Read/Get Dictionary
        let strings = UserDefaults.standard.value(forKey: "InstanceURL") as? String;
        //print("UserDefaultsDict InstanceURL: ",strings)
    }
    */
    
    func initWkWebView(){
        //print("initWkWebView")
        //Initialise
        wkWebView.navigationDelegate = self
        wkWebView.configuration.preferences.javaScriptEnabled = true
        wkWebView.isUserInteractionEnabled = true
        wkWebView.allowsBackForwardNavigationGestures = true
        wkWebView.allowsLinkPreview = true
        // Add observer
        wkWebView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        wkWebView.scrollView.bounces = false
        
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        //        wkWebView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        
        //Add Listeners for web to native communications
        let contentController = WKUserContentController()
        wkWebView.configuration.userContentController.add(self, name: mNativeToWebHandler_FetchShowSettingsButton)
        wkWebView.configuration.userContentController.add(self, name: mNativeToWebHandler_FetchHideSettingsButton)
        
        //Listen the Get User Location command from web
        wkWebView.configuration.userContentController.add(self, name: mNativeToWebHandler_StartFetchingUserLocation)
        
        //Listen the dial the number command from web
        wkWebView.configuration.userContentController.add(self, name: mNativeToWebHandler_StartDialingANumber)
        
        //Listen the device id
        wkWebView.configuration.userContentController.add(self, name: mNativeToWebHandler_getDeviceId)
        
        //Fetch login user token or id
        wkWebView.configuration.userContentController.add(self, name: mNativeToWebHandler_getLoginUserID)
        
        //Fetch Encription String
        wkWebView.configuration.userContentController.add(self, name: mNativeToWebHandler_getEncryptedString)
        
        //Fetch Decripted String
        wkWebView.configuration.userContentController.add(self, name: mNativeToWebHandler_getDecryptedString)
        
        
        // inject JS to capture console.log output and send to iOS
        let source = "function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        wkWebView.configuration.userContentController.addUserScript(script)
        // register the bridge script that listens for the output
        wkWebView.configuration.userContentController.add(self, name: webConsoleLogs)
        wkWebView.configuration.userContentController = contentController
    }
    
    /*
    @objc
    func buttonAction() {
        //print("Button pressed")
        showAlertForInstanceChange()
    }
    */
    
    func showAlertForCallLog(){
        //--- Api call for the Create call log
        if isEnableEncryption{
            //-- set create call log request
            let urlString = url
            let token = token
            print("urlString = \(urlString)")
            print("token = \(token)")
            
            
            
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
                attributesObj?["date_start"] = convertDateToString(dateToConvert: started)
                attributesObj?["date_end"] = convertDateToString(dateToConvert: ended)
            }
            
            attributesObj?["duration_hours"] = hours
            attributesObj?["duration_minutes"] =  minutes
            attributesObj?["voice_call_duration_c"] = timeString
            dataObj?["attributes"] = attributesObj
            requestObj?["data"] = dataObj
            
            requestObj?.removeValue(forKey: "dataCall")
            requestObj?.removeValue(forKey: "dataTicket")
            if let requestObj_ = requestObj{
                if let jsonObject = jsonBase64(object: requestObj_){
                    print("Update User Detail API Param jsonObject: \(jsonObject)")
                    encryptionRequestFor = "create_call_log"
                    apptoweb_sendJsonToEncrypt(strJson: jsonObject)
                }
            }
        }else{
            self.makeApiCallToCreateCallLog(strEncriptionString: "")
        }
        
        
        
        //---
        
        
        //-- Open Dialog for the Create Ticket
        let number = phone
        lblDetail_TicketCreation.text = "Was the call with "+number+" made successfully.Do you want to create a Ticket?"
        viewTicketCreation.isHidden = false
        
        
        /*
        let number = phone
        let alertController = UIAlertController(title: "Alert", message: "Was the call with "+number+" made successfully? Do you want to create a log?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Create Call Log", style: .destructive, handler: {(cAlertAction) in
            //Make an API call to create a log
            self.makeApiCallToCreateCallLog()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
         */
    }
    
    /*
    func makeApiCallToCreateCallLog(){
        
        let urlString = url
        let token = token
        let parameters: [String: Any] = [:]
        print("urlString = \(urlString)")
        print("token = \(token)")
        
        if(urlString == nil){
            return;
        }
        
        let duration =  calculateDuration(startTime: started, endTime: ended)
        var requestObj = request as? [String : Any]
        var dataObj = requestObj?["data"] as? [String : Any]
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
                        self.showAlertSuccess()
                        
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
    */
    
    func showAlertMessage(msg: String){
        let alertController = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlertSuccess(msg: String){
        let alertController = UIAlertController(title: "Success!", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertFail(){
        let alertController = UIAlertController(title: "Alert", message: "Failed to create call log", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*
    func showAlertForInstanceChange(){
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Change Instance URL", message: "Would you like to aceess different instance? If yes, enter new one.", preferredStyle: .alert)
        let strings = UserDefaults.standard.value(forKey: "InstanceURL") as? String;
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = strings
            textField.placeholder = "Instance URL"
        }
        
        let alertActionPositive = UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if let userInput = textField!.text {
                if userInput == "" {
                    self.present(alert!, animated: true, completion: nil)
                }else{
                    //Save the Instance URL in User Defaults
                    let userDefaults = UserDefaults.standard
                    userDefaults.setValue(textField!.text, forKey: "InstanceURL")
                    
                    let url =  textField?.text ?? self.DEFAULT_URL
                    
                    let myURL = URL(string:url)
                    let myRequest = URLRequest(url: myURL!)
                    self.wkWebView.load(myRequest)
                }
            }
            
            
        })
        //Set button text color
        let colorDefault = hexStringToUIColor(hex:"#4dc1f0")
        alertActionPositive.setValue(colorDefault, forKey: "titleTextColor")
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(alertActionPositive)
        
        let alertActionNegative = UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
        })
        //Set button text color
        alertActionNegative.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(alertActionNegative)
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    */
    
    //MARK: - @IBAction
    @IBAction func onButtonClicked(_ sender: Any) {
    }
    
    @IBAction func onCallClick(_ sender: Any) {
        //print("onCallClick")
    }
    
    @IBAction func onGetLocationClick(_ sender: Any) {
        //print("onGetLocationClick")
    }
    @IBAction func btnRegisterDevice(_ sender: Any) {
        viewRegisterDevice.isHidden = true
    }
    
    @IBAction func btnAllowLocationPermission(_ sender: Any) {
        //Setup the location manager
        initCurrentLocation()
        requestLocationPermission()
    }
    @IBAction func btnOpenSettingsLocationPermission(_ sender: Any) {
//        if let bundleId = Bundle.main.bundleIdentifier,
//            let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
//        {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        if let BUNDLE_IDENTIFIER = Bundle.main.bundleIdentifier,
            let url = URL(string: "\(UIApplication.openSettingsURLString)&root=Privacy&path=LOCATION/\(BUNDLE_IDENTIFIER)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

    }
    
    @IBAction func btnCancel_TicketCreation(_ sender: Any) {
        viewTicketCreation.isHidden = true
    }
    @IBAction func btnCreateTicket_TicketCreation(_ sender: Any) {
        viewTicketCreation.isHidden = true
        if isEnableEncryption{
            //-- set apiCall_CreateTicket request parameter
            let urlString = url
            let token = token
            //        print("urlString = \(urlString)")
            //        print("token = \(token)")
            
            let duration =  calculateDuration(startTime: started, endTime: ended)
            var requestObj = request as? [String : AnyObject]
            var dataObj = requestObj?["dataTicket"] as? [String : AnyObject]
            var attributesObj = dataObj?["attributes"] as? [String : AnyObject]
            
            attributesObj?["description"] = txtEnterDetail_TicketCreation.text as AnyObject
            
            dataObj?["attributes"] = attributesObj as AnyObject
            requestObj?["data"] = dataObj as AnyObject
            
            requestObj?.removeValue(forKey: "dataCall")
            requestObj?.removeValue(forKey: "dataTicket")
            if let requestObj_ = requestObj{
                if let jsonObject = jsonBase64(object: requestObj_){
                    print("Update User Detail API Param jsonObject: \(jsonObject)")
                    encryptionRequestFor = "create_ticket"
                    apptoweb_sendJsonToEncrypt(strJson: jsonObject)
                }
            }
        }else{
            apiCall_CreateTicket(strEncriptionString: "", description: txtEnterDetail_TicketCreation.text)
        }
        
        
        
        
    }
    
    
    //MARK: - Web To iOS Native Communication
    //default method to listen to web comminucation
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("---- Name ---- ", message.name)
        print("---- Body ---- ", message.body)
        
        //Listen the console logs
        if(message.name == webConsoleLogs){
//            print("---- webView ---- ", message.webView as Any)
//            print("---- frameInfo ---- ", message.frameInfo)
        }
        
        //Listen the event to start the Native work, do the work and send back the response
        if message.name == mNativeToWebHandler_StartFetchingUserLocation {
            //Start getting user's current location
            getLocationAndResponseSendBackToWeb()
        }
        
        if message.name == mNativeToWebHandler_StartDialingANumber {
            
           // print("mNativeToWebHandler_StartDialingANumber")
            //Start dialing the number and get duration of the call
            
            do{
                if let json = (message.body as AnyObject).data(using: String.Encoding.utf8.rawValue){
                    if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                        phone = jsonData["phone"] as! String
                        module = jsonData["module"] as! String
                        recordId = jsonData["recordId"] as! String
                        request = jsonData["request"] as AnyObject
                        url = jsonData["url"] as! String
                        token = jsonData["token"] as! String
                        
                        obj = jsonData as AnyObject
                    }
                }
                
            }catch {
                //print(error.localizedDescription)
            }
            
            
            dialTheNumberAndSendResponseBackToWeb(phoneNumber: phone, module:module, recordId: recordId, requestData: request)
        }
        
        //-- Device ID
        if message.name == mNativeToWebHandler_getDeviceId {
            //print("Device ID:\n\(message.name)\n\(message.body)")
            sendGetDeviceID()
        }
        
        //-- Login User ID
        if message.name == mNativeToWebHandler_getLoginUserID {
            //print("Get LoginUser ID:\n\(message.name)\n\(message.body)")
            /*
            if let dataBody = message.body as? [String : Any]{
                let token = dataBody["token"] as? String ?? ""
                    
                //Save Login User Token
                UserDefaults.standard.set(token, forKey: "LoginUserToken")
                UserDefaults.standard.synchronize()
            }
             */
            //Save Login User Token
            UserDefaults.standard.set(message.body, forKey: "LoginUserToken")
            UserDefaults.standard.synchronize()
            
            //Call API for send FCM Token detail server
            let coordinate = locationManager.location?.coordinate
            let latitude: String = String(format: "%f", coordinate?.latitude ?? "")
            let longitude: String = String(format: "%f", coordinate?.longitude ?? "")
            
            if isEnableEncryption{
                //--
                let devicetoken = UserDefaults.standard.object(forKey: "FirebaseToken") as? String ?? "default"
                let modelName = UIDevice.modelName
                
                //--
                let dicParam:[String:AnyObject] = ["lat_c":"\(latitude)" as AnyObject,
                                                   "longi_c":"\(longitude)" as AnyObject,
                                                   "firebase_registration_id":["token": "\(devicetoken)",
                                                                               "os":"iOS",
                                                                               "model":"\(modelName)",
                                                                               "os_version":"\(Bundle.main.releaseVersionNumber ?? "")"] as AnyObject]
                
                
                print("Update User Detail API Param: \(dicParam)")
                if let jsonObject = jsonBase64(object: dicParam){
                    print("Update User Detail API Param jsonObject: \(jsonObject)")
                    encryptionRequestFor = "update_login_user_Detail"
                    apptoweb_sendJsonToEncrypt(strJson: jsonObject)
                }
            }else{
                apiCall_UPDATE_USER_DETAILS(strEncriptionString: "", lat: latitude, longi: longitude)
            }
            
        }
        
        //-- Get Encryption String
        if message.name == mNativeToWebHandler_getEncryptedString {
            print(message.body)
            if encryptionRequestFor == "update_login_user_Detail"{
                apiCall_UPDATE_USER_DETAILS(strEncriptionString: "\(message.body)", lat: "", longi: "")
            }else if encryptionRequestFor == "create_ticket"{
                apiCall_CreateTicket(strEncriptionString: "\(message.body)", description: "")
            }else if encryptionRequestFor == "create_call_log"{
                makeApiCallToCreateCallLog(strEncriptionString: "\(message.body)")
            }
        }
        
        //-- Get Decryption String
        if message.name == mNativeToWebHandler_getDecryptedString {
            print(message.body)
            
            
        }
//        print(message.body)
    }
    
    //---
    //MARK: - App To Web Func
    func apptoweb_sendJsonToEncrypt(strJson: String){
        
        self.wkWebView.evaluateJavaScript("sendJsonToEncrypt('\(strJson)')", completionHandler:{(result , error) in
            if error == nil {
                print("sendJsonToEncrypt success: \(String(describing: result))")
                
            }
            else
            {
                print("sendJsonToEncrypt error: \(String(describing: error))")
            }
        })
    }
    
    func apptoweb_sendStringToDecrypt(strEnc: String){
        self.wkWebView.evaluateJavaScript("sendStringToDecrypt('\(strEnc)')", completionHandler:{(result , error) in
            if error == nil {
                print("sendStringToDecrypt success: \(String(describing: result))")
                
            }
            else
            {
                print("sendStringToDecrypt error: \(String(describing: error))")
            }
        })
    }
    
    //---
    
    typealias CompletionHandler = (_ locationText:String) -> Void
    
    private func getAddressFromLocation(myLocation: CLLocation? = nil , completionHandler: @escaping CompletionHandler) {
        var address: [String] = []
        
        if(myLocation == nil){
            completionHandler("")
            return
        }else{
            CLGeocoder().reverseGeocodeLocation(myLocation!, completionHandler: {(places, error) in
                guard error == nil else {
                    completionHandler("")
                    return
                }
                let place: CLPlacemark = places!.first!
                if place.subLocality != nil { address.append(place.subLocality!) }
                if place.locality != nil { address.append(place.locality!) }
                if place.postalCode != nil { address.append(place.postalCode!) }
                if place.country != nil { address.append(place.country!) }
                
                //print("address: \(address.joined(separator: ","))")
                completionHandler(address.joined(separator: ","))
            })
        }
    }
    
    
    
    
    func reverseGeocoding(myLocation: CLLocation? = nil ) -> String{
        if(myLocation == nil){
            self.locationTextField = ""
        }else{
            CLGeocoder().reverseGeocodeLocation(myLocation!, completionHandler:{(placemarks, error) in
                
                if ((error) != nil)  { print("Error: \(String(describing: error))") }
                else {
                    
                    let p = CLPlacemark(placemark: (placemarks?[0] as CLPlacemark?)!)
                    
                    var subThoroughfare:String = ""
                    var thoroughfare:String = ""
                    var subLocality:String = ""
                    var subAdministrativeArea:String = ""
                    var postalCode:String = ""
                    var country:String = ""
                    
                    // Use a series of ifs, or nil coalescing operators ??s, as per your coding preference.
                    
                    if ((p.subThoroughfare) != nil) {
                        subThoroughfare = (p.subThoroughfare)!
                    }
                    if ((p.thoroughfare) != nil) {
                        thoroughfare = p.thoroughfare!
                    }
                    if ((p.subLocality) != nil) {
                        subLocality = p.subLocality!
                    }
                    if ((p.subAdministrativeArea) != nil) {
                        subAdministrativeArea = p.subAdministrativeArea!
                    }
                    if ((p.postalCode) != nil) {
                        postalCode = p.postalCode!
                    }
                    
                    if ((p.country) != nil) {
                        country = p.country!
                    }
                    self.locationTextField  =  "\(subThoroughfare) \(thoroughfare)\n\(subLocality) \(subAdministrativeArea) \(postalCode)\n\(country)"
                    
                    
                    //print("self.locationTextField = \(self.locationTextField)")
                }   // end else no error
            }       // end CLGeocoder reverseGeocodeLocation
            )       // end CLGeocoder
        }
        return self.locationTextField
    }
    
    func getLocationAndResponseSendBackToWeb(){
        //print("getLocationAndResponseSendBackToWeb")
        let coordinate = locationManager.location?.coordinate
        
        let latitude: String = String(format: "%f", coordinate?.latitude ?? "")
        let longitude: String = String(format: "%f", coordinate?.longitude ?? "")
        
        //Send the lat/long to web
        self.wkWebView.evaluateJavaScript("getLatitudeLongitudeFromApp('\(latitude)','\(longitude)')", completionHandler:{(result , error) in
            if error == nil {
                //print("getLatitudeLongitudeFromApp success", result as Any)
            }
            else
            {
                //print("getLatitudeLongitudeFromApp error ", error as Any)
            }
            
        })
        
    }
    func convertDateToLocalDateString(dateToConvert: Date? = nil) -> String{
        // Create Date Formatter
        //print("dateToConvert = \(dateToConvert)")
        if(dateToConvert == nil){
            return ""
        }else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//HH - 24-hours clock, hh - 12 hours clock
            //        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone? //UTC timezone
            // Convert Date to String
            let stringDate: String =  dateFormatter.string(from: (dateToConvert!))
            //print("stringDate = \(stringDate)")
            
            return stringDate;
        }
    }
    
    
    
    
    func showSettingButton(){
        // Show the Settings button
        button.isHidden = false
    }
    
    @objc func hideSettingButton(){
        // Hide the settings button
        button.isHidden = true
    }
    
    /*
    func addButtonToView(){
        if #available(iOS 13.0, *) {
            let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
            let boldSearch = UIImage(systemName: "gearshape", withConfiguration: boldConfig)
            button.setImage(boldSearch, for: .normal)
            
        } else {
            // Fallback on earlier versions
            let boldSearch = UIImage(named: "gearshape.png")
            button.setImage(boldSearch, for: .normal)
        }
        
        
        
        button.tintColor = UIColor.white
        //Button click action
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        //Add button to main view
        self.view.addSubview(button)
        let bgColor = hexStringToUIColor(hex:"#4dc1f0")
        button.backgroundColor = bgColor
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        
        
    }*/
    
    
    //Set colors
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // Observe value
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = change?[NSKeyValueChangeKey.newKey] {
            //print("observeValue \(key)") // url value
        }
    }
    
    func setupCaptureSession(){
        //print("The Permission Granted!!!!")
    }
    
    func initLoader(){
    }
    
    func startLoader(){
        activityIndicator.startAnimating()
    }
    
    func stopLoader(){
        activityIndicator.stopAnimating()
    }
    
    //MARK: -  Webview Delegate Methods
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        //print("WKWebViewABC",#function)
        
        stopLoader()
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //print("WKWebViewABC",#function)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //print("WKWebViewABC",#function)
        stopLoader()
        
        let javascriptStyle = "var css = '*{-webkit-touch-callout:none;-webkit-user-select:none}'; var head = document.head || document.getElementsByTagName('head')[0]; var style = document.createElement('style'); style.type = 'text/css'; style.appendChild(document.createTextNode(css)); head.appendChild(style);"
        webView.evaluateJavaScript(javascriptStyle, completionHandler: nil)
        //Show the gear button on webview to change the instance url
        //            self.addButtonToView() //##TEST HIDE THIS
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       // print("WKWebViewABC",#function)
        startLoader()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
       // print("WKWebViewABC",#function)
        stopLoader()
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        //print("WKWebViewABC",#function)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
       // print("WKWebViewABC",#function)
        stopLoader()
        
        //Save the Instance URL in User Defaults
        // UserDefaults.standard.setValue(nil, forKey: "InstanceURL") //##TEST HIDE THIS
        
        
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        //print("WKWebViewABC",#function)
        completionHandler(.performDefaultHandling,nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //print("WKWebViewABC: WKNavigationAction: ",#function)
        //On click of call click open the existing app to dial the number
        if navigationAction.request.url?.scheme == "tel" && UIApplication.shared.canOpenURL( navigationAction.request.url!) {
            
            UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
            
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        //print("WKWebViewABC",#function)
        decisionHandler(.allow)
    }
    
    func webView(_: WKWebView, runJavaScriptAlertPanelWithMessage: String, initiatedByFrame: WKFrameInfo, completionHandler: () -> Void){
        //Displays a JavaScript alert panel.
       // print("WKWebViewABC Displays a JavaScript alert panel: ",#function)
        
    }
    func webView(_: WKWebView, runJavaScriptConfirmPanelWithMessage: String, initiatedByFrame: WKFrameInfo, completionHandler: (Bool) -> Void){
        //    Displays a JavaScript confirm panel.
       // print("WKWebViewABC: Displays a JavaScript confirm panel: ",#function)
        
    }
    func webView(_: WKWebView, runJavaScriptTextInputPanelWithPrompt: String, defaultText: String?, initiatedByFrame: WKFrameInfo, completionHandler: (String?) -> Void){
        //    Displays a JavaScript text input panel.
       // print("WKWebViewABC : Displays a JavaScript text input panel: ",#function)
        
    }
    
    //MARK: - App to Web Func
    func sendGetDeviceID(){
        let value3 = getUUID()
        //print("Device ID: " + value3)
        wkWebView.evaluateJavaScript("getDeviceID('\(value3)')", completionHandler:{(result , error) in
            if error == nil {
                //print("getDeviceID success ", result as Any)
            }
            else
            {
                //print("getDeviceID error ", error as Any)
            }
        })
    }
    
    //MARK: - Camera Permission
    func askPermissions(){
        //Request Permission for Photo Library Access
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    self.setupCaptureSession()
                } else {
                    //print("Permission Denied")
                }
            })
        }
        
    }
    
    
    
    
    //MARK: - Disable Copy Past
    func disableCopyPastConfig(){
        
    }
}



//Extension for screenshot/screenRecording prevention/////
extension ViewController: ScreenRecordDelegate {
    func screen(_ screen: UIScreen, didRecordStarted isRecording: Bool) {
       // print("Recording Started")
    }
    
    func screen(_ screen: UIScreen, didRecordEnded isRecording: Bool) {
      //  print("Recording ended")
    }
    
}
/////////////////////////////


//Listen the call events
extension ViewController : CXCallObserverDelegate
{
    //firstThing: Int? = nil
    func calculateDuration(startTime: Date? = nil, endTime: Date? = nil) -> String {
        //
        //print("calculateDuration: startTime \(startTime) endTime = \(endTime)")
        do {
            
            var startDateTime: Date? = nil
            startDateTime = startTime
            var endDateTime: Date? = nil
            endDateTime = endTime
            //print("calculateDuration: startDateTime \(startDateTime) endDateTime = \(endDateTime)")
            
            
            if(startDateTime == nil){
               // print("calculateDuration: startDateTime = is nill")
                
                return ""
            }else if(startDateTime == nil && endDateTime == nil){
                return ""
            }else{
                if(endDateTime == nil){
                    endDateTime = startDateTime
                }
                
                let elapsedTime = endDateTime!.timeIntervalSince(startDateTime! as Date)
                
                let hours1 = floor(elapsedTime / 60 / 60)
                let minutes1 = floor((elapsedTime - (hours1 * 60 * 60)) / 60)
                let seconds1 = floor((elapsedTime - (minutes1 * 60)))
                hours = Int(hours1)
                minutes = Int(minutes1)
                seconds = Int(seconds1)
                var timeString1 = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
                timeString = timeString1
                
                // return formated time string
                return timeString
            }
        } catch let error {
           // print(error.localizedDescription)
            return ""
        }
    }
    
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.isOutgoing == true && call.hasConnected == false && call.hasEnded == false {
            //.. 1. detect a dialing outgoing call
           // print("dialing outgoing")
        }
        if call.isOutgoing == true && call.hasConnected == true && call.hasEnded == false {
            //.. 2. outgoing call in process
           // print("outgoing in process")
        }
        
        if call.isOutgoing == true && call.hasConnected == true && call.hasEnded == false && call.isOnHold == false {
            //.. 7. call connected outgoing
           // print("call connected")
            started = Date()
            let testStartDate = Date()
            
            let localTestStartDate = self.convertDateToLocalDateString(dateToConvert: testStartDate as? Date)
            
            callEventsMessage.append(" START_CALL: testStartDate = \(testStartDate) (localTestStartDate = \(localTestStartDate))"+" call.isOutgoing = \(call.isOutgoing) call.hasConnected = \(call.hasConnected)  call.hasEnded = \(call.hasEnded) call.isOnHold = \(call.isOnHold)")
            
        }
        if call.isOutgoing == false && call.hasConnected == true && call.hasEnded == false && call.isOnHold == false {
            //.. 7. call connected incoming
           // print("call connected")
            
        }
        
        if call.isOutgoing == true && call.hasEnded == true {
            
            //.. 5. outgoing call ended.
            ended = Date()
           // print("outgoing ended")
            
            let testEndDate = Date()
            
            let localTestEndDate = self.convertDateToLocalDateString(dateToConvert: testEndDate as? Date)
            
            callEventsMessage.append(" END_CALL: testEndDate = \(testEndDate) (localTestEndDate = \(localTestEndDate))"+" call.isOutgoing = \(call.isOutgoing) call.hasConnected = \(call.hasConnected)  call.hasEnded = \(call.hasEnded) call.isOnHold = \(call.isOnHold)")
            
            //Show Alert for Call Log
            showAlertForCallLog()
            
        }
        
        if call.isOutgoing == false && call.hasEnded == true {
            //.. 5. Incoming call ended.
        }
        
    }
    
}

extension ViewController: CLLocationManagerDelegate{
    func checkLocationPermission(){
        initCurrentLocation()
        
        if locationManager == nil{
            viewLocationPermission.isHidden = false
            btnAllowLocationPermission.isHidden = false
            btnOpenSettingsLocationPermission.isHidden = true
        }else{
            viewLocationPermission.isHidden = true
        }

    }
    
    func initCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //requestLocationPermission()
    }
    
    func requestLocationPermission(){
        //print("Request permissions")
        self.locationManager.requestAlwaysAuthorization()
        //self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        //print("Location = ", location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       // print("Error - locationManager: \(error.localizedDescription)")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            //print("restricted/denied")
            // self.requestPermission()
            //self.showPermissionAlert()
            //self.viewLocationPermission.isHidden = true
            
             //Hide temporary
            viewLocationPermission.isHidden = false
            btnAllowLocationPermission.isHidden = true
            btnOpenSettingsLocationPermission.isHidden = false
             
            break
            
        case .authorizedWhenInUse:
           // print("authorizedWhenInUse")
            self.viewLocationPermission.isHidden = true
            self.locationManager.startUpdatingLocation()
            break
            
        case .authorizedAlways:
            //print("authorizedAlways")
            self.viewLocationPermission.isHidden = true
            self.locationManager.startUpdatingLocation()
            break
            
        case .notDetermined:
           // print("notDetermined")
            //self.showPermissionAlert()
            //self.viewLocationPermission.isHidden = true
            
             //Hide temporary
            viewLocationPermission.isHidden = false
            btnAllowLocationPermission.isHidden = false
            btnOpenSettingsLocationPermission.isHidden = true
            break
        @unknown default:
            fatalError()
        }
    }
     
    /*
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .authorizedAlways , .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            self.viewLocationPermission.isHidden = true
            break
        case .notDetermined , .denied , .restricted:
            viewLocationPermission.isHidden = false
            btnAllowLocationPermission.isHidden = false
            btnOpenSettingsLocationPermission.isHidden = true
            break
        default:
            break
        }
        
        switch manager.accuracyAuthorization {
        case .fullAccuracy:
            //self.viewLocationPermission.isHidden = true
            //self.locationManager.startUpdatingLocation()
            break
        case .reducedAccuracy:
            //self.viewLocationPermission.isHidden = true
            //self.locationManager.startUpdatingLocation()
            break
        default:
            break
        }
    }
    */
    func showPermissionAlert(){
        let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permission in settings.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
            //Redirect to Settings app
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        
        //        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        //        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK: -  Permission
extension ViewController{
    
    func askPermissionPhotos(){
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        PHPhotoLibrary.requestAuthorization({ [self]status in
            if status == .authorized{
                cameraPermission()
            }
//            else if status == .limited
//            {
//                cameraPermission()
//            }
            else {
                alertPromptToAllowCameraAccessViaSettings()
            }
        })
        
    }
    
    func cameraPermission() {
        // check if the device has a camera
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch authStatus {
            case .authorized:
                //print("camera permission is already granted")
                microphonePermission()
                
            case .denied:
                //alertPromptToAllowCameraAccessViaSettings()
               // print("camera permission is denied")
                permissionForCameraAccess()
                
            case .notDetermined:
                permissionForCameraAccess()
                
            default:
                permissionForCameraAccess()
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func permissionForCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
            DispatchQueue.main.async {
                //                self?.cameraPermission()
            }
        })
    }
    
    func microphonePermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            print("") //"microphone permission is already granted"
            
        case .denied:
            //alertPromptToAllowMicrophoneAccessViaSettings()
           // print("microphone permission is denied")
            permissionForMicrophoneAccess()
        case .undetermined:
            permissionForMicrophoneAccess()
            
        default:
            permissionForMicrophoneAccess()
        }
    }
    func permissionForMicrophoneAccess() {
        AVAudioSession.sharedInstance().requestRecordPermission({ granted in
            DispatchQueue.main.async {
                //                self?.microphonePermission()
            }
        })
    }
    
    func alertPromptToAllowCameraAccessViaSettings() {
        let alert = UIAlertController(title: "This app would like to access the camera", message: "Please grant permission to use the Camera.", preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: "Open Settings", style: .cancel) { alert in
            if let appSettingsURL = NSURL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettingsURL as URL)
            }
        })
        present(alert, animated: true, completion: nil)
    }
    func alertPromptToAllowMicrophoneAccessViaSettings() {
        let alert = UIAlertController(title: "This app would like to access the microphone", message: "Please grant permission to use the Microphone.", preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: "Open Settings", style: .cancel) { alert in
            if let appSettingsURL = NSURL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettingsURL as URL)
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
}
