//
//  Config.swift
//  HNB
//
//  Created by Sonal Air New on 03/05/23.
//

import Foundation
let DEFAULT_INSTANCE_URL : String = "https://hnbsuperrm.simplecrmdev.com/"
//"https://crmportaluat.hnb.lk" //"https://hnbsuperrm.simplecrmdev.com" //"https://hnbupgradeuatcp.simplecrmdev.com"
// "https://hnbsuperrm.simplecrmdev.com"
// "https://simplecrmperformance.com:4008/"
// "https://hnbportaladminv300.simplecrmdev.com/"



//MARK: - API NAME
let api_BASEURL = "https://hnbupgradeuatcp.simplecrmdev.com" //UserDefaults.standard.value(forKey: "InstanceURL") as? String ?? DEFAULT_INSTANCE_URL
let API_UPDATE_USER_DETAILS = api_BASEURL + "/Api/V8/update_user_details"
