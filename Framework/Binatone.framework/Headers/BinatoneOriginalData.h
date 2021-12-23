//
//  BinatoneOriginalData.h
//  SDK
//
//  Created by Martin on 2017/7/28.
//  Copyright © 2017年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BinatoneHistoryDataRecord;
@interface BinatoneOriginalData : NSObject
@property (nonatomic,assign) UInt32 startTime;
@property (nonatomic,strong) NSArray<BinatoneHistoryDataRecord *> *recordList;


@end

@interface BinatoneHistoryDataRecord : NSObject
@property (nonatomic,assign) UInt32 br;//呼吸率 
@property (nonatomic,assign) UInt32 hr;//心率
@property (nonatomic,assign) UInt32 status;//状态
@property (nonatomic,assign) UInt32 statusValue;//状态值

+ (NSInteger)length;

- (id)initWithData:(NSData *)data;
@end
