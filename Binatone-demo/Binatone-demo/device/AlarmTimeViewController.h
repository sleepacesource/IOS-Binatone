//
//  AlarmTimeViewController.h
//  Binatone-demo
//
//  Created by Martin on 29/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "BaseViewController.h"

@class BinatoneAlarm;
@interface AlarmTimeViewController : BaseViewController
@property (nonatomic, strong)BinatoneAlarm *alarmData;
@property (nonatomic, assign)int timeType;
@end
