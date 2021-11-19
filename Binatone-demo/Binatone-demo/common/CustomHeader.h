//
//  CustomHeader.h
//  Binatone-demo
//
//  Created by San on 19/11/2021.
//  Copyright © 2021 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickBlock)(BOOL click);

@interface CustomHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UIButton *button1;

@property (copy,nonatomic)ClickBlock myBlock;

+ (instancetype)baseHeaderViewWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
