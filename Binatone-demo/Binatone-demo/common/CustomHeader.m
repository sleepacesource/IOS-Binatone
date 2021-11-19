//
//  CustomHeader.m
//  Binatone-demo
//
//  Created by San on 19/11/2021.
//  Copyright © 2021 Martin. All rights reserved.
//

#import "CustomHeader.h"

@implementation CustomHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    [Utils configSectionTitle:self.titleLabel1];
    [Utils configSectionTitle:self.titleLabel1];
    [Utils configNormalButton:self.button1];
    [self.titleLabel2 setText:LocalizedString(@"time_data")];
    
}

+ (instancetype)baseHeaderViewWithTitle:(NSString *)title{
    CustomHeader *header = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    header.titleLabel1.text = title;
    return header;
}


- (IBAction)clickButton:(id)sender
{
    self.myBlock(YES);
}


@end
