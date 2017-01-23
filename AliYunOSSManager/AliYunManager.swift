//
//  AliYunManager.swift
//  Capsule
//
//  Created by kunpeng on 2016/12/20.
//  Copyright © 2016年 liukunpeng. All rights reserved.
//

import UIKit
import AliyunOSSiOS

class AliYunManager {
    
    typealias progressBlock = (_ percent: Float) -> Void
    var progress: progressBlock?
    
    fileprivate var client = OSSClient()
    fileprivate let operationQueue = OperationQueue()
    fileprivate var sumPercent: Float = 0
    fileprivate var count = 0

    fileprivate let accessKey = "p2LrCunAYaVi0ZfR"
    fileprivate let secretKey = "QaUzWsNP1v0DewTpUDu8t7O6F1ihqk"
    fileprivate let endPoint = "https://oss-cn-hangzhou.aliyuncs.com"
    
    static let manager = AliYunManager()
    private init () {
    
        configClient()
    }
    
    private func configClient(){
        
        let credential: OSSCredentialProvider = OSSCustomSignerCredentialProvider {(contentToSign, error: NSErrorPointer) -> String? in
            
            let signture = OSSUtil.calBase64Sha1(withData: contentToSign, withSecret: self.secretKey)
            if signture == nil {
                print(error!)
                return nil
            }
            return "OSS \(self.accessKey):\(signture!)"
         }
    
        client = OSSClient(endpoint: endPoint, credentialProvider: credential)
    }
    
    private func performTask(data: Data,objectType: String) {
    
        let operation = AliYunOperation(data, objectType, client, progress: {
            percent in
            
            if percent == 1.0 {
                self.sumPercent += percent
                let totalProgress = self.sumPercent / Float(self.count)
                self.progress!(totalProgress)
            }
        })
        operationQueue.addOperation(operation)
    }
    
    private func calculateOperationCount(_ dataDic: NSDictionary) -> Int {
        
        var count = 0
        for key in dataDic.allKeys {
            let keyValue = key as! String
            switch keyValue {
            case "txt":
                
                count += 1
            case "image":
                
                let array = dataDic["image"] as! Array<Any>
                count += array.count
            case "video":
                
                count += 1
            default:
                break
            }
        }
        return count
    }
    
    func upload(_ dataDic: NSDictionary,progress: @escaping progressBlock) {
        
        self.progress = progress
        count = calculateOperationCount(dataDic)
        
        for key in dataDic.allKeys {
            let keyValue = key as! String
            let data = dataDic[key]
            switch keyValue {
            case "txt":
                
                performTask(data: data as! Data, objectType: "Files/txt.txt")
            case "image":
                
                let imageArray = data as! Array<Any>
                if imageArray.count != 0 {
                    for imageData in imageArray {
                        
                        performTask(data: imageData as! Data, objectType: "Files/image.png")
                    }
                }
            case "video":
                
                performTask(data: data as! Data, objectType: "Files/video.mp4")
            default:
                break
            }
        }
    }
}

