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
    RealtimeDataStaus_OffBed
};


@interface RealtimeData : NSObject
@property (nonatomic, assign) RealtimeDataStaus status;
@property (nonatomic, strong) NSString * heartRate;
@property (nonatomic, strong) NSString * breathRate;

- (void)toInit;
@end
