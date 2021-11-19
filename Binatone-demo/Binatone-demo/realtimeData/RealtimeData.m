//
//  RealtimeData.m
//  Binatone-demo
//
//  Created by Martin on 27/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "RealtimeData.h"

@implementation RealtimeData

- (id)init {
    if (self = [super init]) {
        [self toInit];
    }
    return self;
}

- (void)toInit {
    self.status = RealtimeDataStaus_Invalid;
    self.heartRate = @"--";
    self.breathRate = @"--";
}
@end
