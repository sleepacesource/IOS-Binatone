//
//  BinatoneRealTimeData.h
//  SDK
//
//  Created by Martin on 2017/7/28.
//  Copyright © 2017年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BinatoneRealTimeData : NSObject

@property (nonatomic,assign) UInt8 breathRate;//呼吸率
@property (nonatomic,assign) UInt8 heartRate;//心率
@property (nonatomic,assign) NSInteger status;//状态
@property (nonatomic,assign) NSInteger statusValue;//状态值

@property (nonatomic,readonly) BOOL isOffBed;//是否为离床
@property (nonatomic,readonly) BOOL isInit;
@end
