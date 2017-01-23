//
//  AliYunOperation.swift
//  Capsule
//
//  Created by kunpeng on 2016/12/22.
//  Copyright © 2016年 liukunpeng. All rights reserved.
//

import UIKit
import AliyunOSSiOS

class AliYunOperation: Operation {
    
    typealias progressBlock = (_ percent: Float) -> Void
    var progress: progressBlock?
    
    fileprivate var fileData = Data()
    fileprivate var objectType = String()
    fileprivate var client = OSSClient()
    
    init(_ filedata: Data, _ objectType: String,
         _ client: OSSClient,progress: @escaping progressBlock) {
        
        self.client = client
        self.fileData = filedata
        self.objectType = objectType
        self.progress = progress
    }
    
    override func main() {
        
        performTask()
    }
    
    func performTask() {
        
        let putRequest = OSSPutObjectRequest()
        putRequest.bucketName = "swiftoss"
        putRequest.objectKey = self.objectType
        putRequest.uploadingData = self.fileData
        putRequest.uploadProgress = {(_ bytesSent: Int64, _ totalByteSent: Int64,
                                      _ totalBytesExpectedToSend: Int64) -> Void in
            
            let percent = Float(totalByteSent)/Float(totalBytesExpectedToSend)
            self.progress!(percent)
        }
        client.putObject(putRequest)
    }
}
