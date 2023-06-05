//
//  GetIp.swift
//  playground-3
//
//  Created by Rizki Judojono on 5/6/2023.
//

import Foundation

func GetIpAddress(completion: @escaping (String) -> Void) {
    let url = URL(string: "https://api.ipify.org?format=json")!
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print ("Error fetching ip address: \(error)")
        } else if let data = data {
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let dictionary = json as? [String: Any], let ip = dictionary["ip"] as? String {
                DispatchQueue.main.async {
                    completion(ip)
                }
            }
        }
    }
    task.resume()
}


func BuildLanRoom(ipAddr: String) -> String {
    var networkPrefix = ""
    
    if ipAddr.contains(".") {
        // IPV4
        
        let octets: [String] = ipAddr.split(separator: ".").map(String.init)
        
        if let firstOctet = Int(octets[0]) {
            if (firstOctet < 128) {
                networkPrefix = "\(firstOctet)"
            }
            else if (firstOctet < 192) {
                networkPrefix = "\(octets[0]).\(octets[1])"
            }
            else {
                networkPrefix = "\(octets[0]).\(octets[1]).\(octets[2])"
            }
        }
    }
    else if ipAddr.contains(":") {
        // IPV6
        
        let groupsStr: [String] = ipAddr.split(separator: ":").map(String.init)
        
        networkPrefix = "\(groupsStr[0]):\(groupsStr[1]):\(groupsStr[2]):\(groupsStr[3])"
    }
    else {
        print("Ip Address is Invalid")
    }
    
    return "PUBLIC_LAN__\(networkPrefix)"
    
}
 
