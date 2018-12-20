//
//  AppDelegate.m
//  Binatone-demo
//
//  Created by Martin on 22/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:bounds];
    UIViewController *rootViewController = [MainViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [nav setNavigationBarHidden:YES];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    return YES;
}
@end
