//
//  BaseTableViewCell.h
//  Binatone-demo
//
//  Created by Martin on 27/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

- (void)setUpLineHidden:(BOOL)hidden;
- (void)setDownLineHidden:(BOOL)hidden;
- (void)setAllLineHidden:(BOOL)hidden;
@end
