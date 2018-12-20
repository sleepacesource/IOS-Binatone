//
//  BinatoneHistoryData.h
//  SDK
//
//  Created by Martin on 29/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BinatoneHistoryDataDetail.h"
#import "BinatoneHistoryDataAnalysis.h"
#import "BinatoneHistoryDataSummary.h"

@interface BinatoneHistoryData : NSObject
@property (nonatomic, strong) BinatoneHistoryDataDetail *detail;
@property (nonatomic, strong) BinatoneHistoryDataAnalysis *analysis;
@property (nonatomic, strong) BinatoneHistoryDataSummary *summary;
@end
