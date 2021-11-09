//
//  RealtimeData.h
//  Binatone-demo
//
//  Created by Martin on 27/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RealtimeDataStaus) {
    RealtimeDataStaus_Invalid = -1,
    RealtimeDataStaus_InBed = 0,
    RealtimeDataStaus_INIT,////初始化状态，约10秒时间
    RealtimeDataStaus_B_STOP,//呼吸暂停
    RealtimeDataStaus_H_STOP,//心跳暂停
    RealtimeDataStaus_BODYMOVE,//体动
    RealtimeDataStaus_OffBed,//离床
    RealtimeDataStaus_TURN_OVER,//翻身
};

@interface RealtimeData : NSObject
@property (nonatomic, assign) RealtimeDataStaus status;
@property (nonatomic, strong) NSString * heartRate;
@property (nonatomic, strong) NSString * breathRate;

- (void)toInit;
@end
