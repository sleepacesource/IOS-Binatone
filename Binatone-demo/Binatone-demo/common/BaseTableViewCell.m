//
//  BaseTableViewCell.m
//  Binatone-demo
//
//  Created by Martin on 27/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell ()
@property (nonatomic, strong) UIView *upLine;
@property (nonatomic, strong) UIView *downLine;
@end

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addLine];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addLine];
    }
    return self;
}

- (void)addLine {
    self.upLine = [UIView new];
    self.downLine = [UIView new];
    [self.upLine setBackgroundColor:Theme.normalLineColor];
    [self.downLine setBackgroundColor:Theme.normalLineColor];
    
    [self addSubView:self.upLine toSuperView:self.contentView up:YES];
    [self addSubView:self.downLine toSuperView:self.contentView up:NO];
}

- (void)addSubView:(UIView *)subView toSuperView:(UIView *)superView up:(BOOL)up{
    if (!subView || !superView){
        return;
    }
    
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [superView addSubview:subView];
    NSDictionary *subViews = NSDictionaryOfVariableBindings(subView,superView);
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[subView]-15-|" options:0 metrics:nil views:subViews]];
    [subView addConstraint:[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:1.0]];
    if (up) {
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    }else{
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    }
}

- (void)setUpLineHidden:(BOOL)hidden {
    [self.upLine setHidden:hidden];
}

- (void)setDownLineHidden:(BOOL)hidden {
    [self.downLine setHidden:hidden];
}

- (void)setAllLineHidden:(BOOL)hidden {
    [self setUpLineHidden:hidden];
    [self setDownLineHidden:hidden];
}

@end
