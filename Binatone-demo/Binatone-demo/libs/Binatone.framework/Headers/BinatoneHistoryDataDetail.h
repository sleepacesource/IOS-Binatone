//
//  BinatoneHistoryDataDetail.h
//  SDK
//
//  Created by Martin on 29/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BinatoneHistoryDataDetail : NSObject
@property (nonatomic, strong) NSArray<NSNumber *> *breathRate;//呼吸率
@property (nonatomic, strong) NSArray<NSNumber *> *heartRate;//心率
@property (nonatomic, strong) NSArray<NSNumber *> *status;//状态
@property (nonatomic, strong) NSArray<NSNumber *> *statusValue;//状态值
@end
