//
//  DataManager.h
//  Binatone-demo
//
//  Created by Martin on 28/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SharedDataManager [DataManager sharedDataManager]
@class CBPeripheral;
@interface DataManager : NSObject
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *deviceID;
@property (nonatomic, assign) BOOL inRealtime;
@property (nonatomic, assign) BOOL connected;
@property (nonatomic, strong) NSString *userID;

+ (DataManager *)sharedDataManager;

- (void)toInit;
@end
