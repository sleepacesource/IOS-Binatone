//
//  ImageTableViewCell.h
//  Binatone-demo
//
//  Created by San on 28/10/2021.
//  Copyright © 2021 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickBlock)(BOOL click);

@interface ImageTableViewCell : UITableViewCell
@property(nonatomic , weak) IBOutlet UILabel *titleLabel;
@property(nonatomic , weak) IBOutlet UIButton *clickBtn;
@property(nonatomic , weak) IBOutlet UIImageView *cellImageView;
@property (nonatomic,copy)ClickBlock cellClickBlock;

@end

NS_ASSUME_NONNULL_END
