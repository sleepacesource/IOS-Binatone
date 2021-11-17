//
//  Coordinate.h
//  Binatone-demo
//
//  Created by Martin on 28/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coordinate : NSObject

+ (void)pushViewControllerName:(NSString *)name sender:(UIViewController *)sender animated:(BOOL)animated;
+ (void)pushToHistoryData:(id)data type:(int)type sender:(UIViewController *)sender animated:(BOOL)animated;
+ (void)pushToAlarmTime:(id)data type:(int)type sender:(UIViewController *)sender aniamted:(BOOL)animated;
@end
