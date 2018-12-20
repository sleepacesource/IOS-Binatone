//
//  HistoryDataViewController.h
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class BinatoneHistoryData;
@interface HistoryDataViewController : BaseViewController
@property (nonatomic, strong) BinatoneHistoryData *historyData;
@property (nonatomic, assign) NSInteger type;
@end
