//
//  BinatoneHistoryDataAnalysis.h
//  Binatone
//
//  Created by Martin on 29/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BinatoneHistoryDataAnalysis : NSObject
@property (nonatomic, assign) int avgBreathRate;//平均呼吸率
@property (nonatomic, assign) int avgHeartRate;//平均心率
@property (nonatomic, assign) int duration;//睡眠时长，单位分钟
@property (nonatomic, assign) int wake;//清醒时长，单位分钟
@property (nonatomic, assign) int outOfBedDuration;//离床时长，单位分钟
@property (nonatomic, assign) int discTime;//设备宕机时间，单位秒
@property (nonatomic, copy) NSArray *sca;//睡眠分期数组{0：设备未连接；1：不在床；2：清醒;3：睡着}；
@property (nonatomic, copy) NSString *algorithmVer;//算法版本
@end
