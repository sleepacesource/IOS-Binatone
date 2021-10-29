//
//  ImageTableViewCell.m
//  Binatone-demo
//
//  Created by San on 28/10/2021.
//  Copyright © 2021 Martin. All rights reserved.
//

#import "ImageTableViewCell.h"

@implementation ImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)musicDownloadAction:(id)sender
{
    self.cellClickBlock(YES);
}

@end
