//
//  BinatoneAlarm.h
//  Binatone
//
//  Created by Martin on 21/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BinatoneAlarm : NSObject
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) int hour;
@property (nonatomic, assign) int minute;
@property (nonatomic, assign) int length;
@end
