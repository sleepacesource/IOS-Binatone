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
@property (nonatomic,assign) UInt32 startPostion;
@property (nonatomic,assign) UInt16 recordNumber;
@property (nonatomic,strong) NSArray<BinatoneHistoryDataRecord *> *recordList;

@end

@interface BinatoneHistoryDataRecord : NSObject
@property (nonatomic,assign) UInt8 br;//呼吸率
@property (nonatomic,assign) UInt8 hr;//心率
@property (nonatomic,assign) UInt8 status;//状态
@property (nonatomic,assign) UInt8 statusValue;//状态值

+ (NSInteger)length;

- (id)initWithData:(NSData *)data;
@end
