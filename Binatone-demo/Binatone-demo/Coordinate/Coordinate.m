//
//  Coordinate.m
//  Binatone-demo
//
//  Created by Martin on 28/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "Coordinate.h"
#import "HistoryDataViewController.h"
#import "AlarmTimeViewController.h"

@implementation Coordinate

+ (void)pushViewControllerName:(NSString *)name sender:(UIViewController *)sender animated:(BOOL)animated{
    UIViewController *viewController = [NSClassFromString(name) new];
    [sender.navigationController pushViewController:viewController animated:animated];
}

+ (void)pushToHistoryData:(id)data type:(int)type sender:(UIViewController *)sender animated:(BOOL)animated {
    HistoryDataViewController *viewController = [[HistoryDataViewController alloc] initWithNibName:@"HistoryDataViewController" bundle:nil];
    [viewController setHistoryData:data];
    viewController.type = type;
    [sender.navigationController pushViewController:viewController animated:animated];
}

+ (void)pushToAlarmTime:(id)data type:(int)type sender:(UIViewController *)sender aniamted:(BOOL)animated {
    AlarmTimeViewController *viewController = [AlarmTimeViewController new];
    [viewController setTimeType:type];
    [viewController setAlarmData:data];
    [sender.navigationController pushViewController:viewController animated:animated];
}
@end
