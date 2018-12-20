//
//  HistoryDataView.h
//  Binatone-demo
//
//  Created by Martin on 27/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
enum{
    SLPHistoryDataState_Noton = 0,
    SLPHistoryDataState_Offbed,
    SLPHistoryDataState_Awake,
    SLPHistoryDataState_Sleep,
};

@class HistorySubData;
@interface HistoryDataView : UIView
@property (nonatomic, weak) IBOutlet UILabel *startTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *endTimeLabel;

- (void)drawHistoryDataList:(NSArray<HistorySubData *> *)dataList;
@end

@interface HistorySubData: NSObject
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) CGFloat widthPercentage;

+ (HistorySubData *)dataWithState:(NSInteger)state percentage:(CGFloat)percentage;
@end
