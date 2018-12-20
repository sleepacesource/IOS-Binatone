//
//  HistoryDataView.m
//  Binatone-demo
//
//  Created by Martin on 27/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "HistoryDataView.h"

@interface HistoryDataView ()
@property (nonatomic, weak) IBOutlet UIView *hLine0;
@property (nonatomic, weak) IBOutlet UIView *hLine1;
@property (nonatomic, weak) IBOutlet UIView *hLine2;
@property (nonatomic, weak) IBOutlet UIView *hLine3;

@property (nonatomic, weak) IBOutlet UIView *vLine0;
@property (nonatomic, weak) IBOutlet UIView *ball0;
@property (nonatomic, weak) IBOutlet UIView *vLine1;
@property (nonatomic, weak) IBOutlet UIView *ball1;

@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UIImageView *sleepIcon;
@property (nonatomic, weak) IBOutlet UILabel *sleepText;

@property (nonatomic, weak) IBOutlet UIImageView *awakeIcon;
@property (nonatomic, weak) IBOutlet UILabel *awakeText;

@property (nonatomic, weak) IBOutlet UIImageView *offBedIcon;
@property (nonatomic, weak) IBOutlet UILabel *offBedText;

@property (nonatomic, weak) IBOutlet UIImageView *notOnIcon;
@property (nonatomic, weak) IBOutlet UILabel *notOnText;
@end

@implementation HistoryDataView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUI];
    
//    [self test];
}

- (void)setUI {
    UIColor *lineColor = [Utils colorWithRGB:0xbcc8da alpha:1.0];
    self.hLine0.backgroundColor = lineColor;
    self.hLine1.backgroundColor = lineColor;
    self.hLine2.backgroundColor = lineColor;
    self.hLine3.backgroundColor = lineColor;
    self.vLine0.backgroundColor = lineColor;
    self.vLine1.backgroundColor = lineColor;
    [self.ball0 setBackgroundColor:lineColor];
    [self.ball1 setBackgroundColor:lineColor];
    [Utils setView:self.ball0 cornerRadius:5 borderWidth:0 color:nil];
    [Utils setView:self.ball1 cornerRadius:5 borderWidth:0 color:nil];
    [self.startTimeLabel setText:@"00:00"];
    [self.endTimeLabel setText:@"00:00"];
    [self configVerticalLable:self.startTimeLabel];
    [self configVerticalLable:self.endTimeLabel];
    
    [self.sleepIcon setBackgroundColor:[self colorOfState:SLPHistoryDataState_Sleep]];
    [self.awakeIcon setBackgroundColor:[self colorOfState:SLPHistoryDataState_Awake]];
    [self.offBedIcon setBackgroundColor:[self colorOfState:SLPHistoryDataState_Offbed]];
    [self.notOnIcon setBackgroundColor:[self colorOfState:SLPHistoryDataState_Noton]];
    [Utils setView:self.notOnIcon cornerRadius:0 borderWidth:1 color:[Utils colorWithRGB:0x8a9dba alpha:1]];
    
    [self configStateTextLabel:self.sleepText];
    [self configStateTextLabel:self.awakeText];
    [self configStateTextLabel:self.offBedText];
    [self configStateTextLabel:self.notOnText];
    [self.sleepText setText:LocalizedString(@"asleep")];
    [self.awakeText setText:LocalizedString(@"awake")];
    [self.offBedText setText:LocalizedString(@"left_bed")];
    [self.notOnText setText:LocalizedString(@"not_recorded")];
}

- (void)test {
    NSArray *list =
    @[
      [HistorySubData dataWithState:SLPHistoryDataState_Noton percentage:0.1],
      [HistorySubData dataWithState:SLPHistoryDataState_Offbed percentage:0.1],
      [HistorySubData dataWithState:SLPHistoryDataState_Sleep percentage:0.1],
      [HistorySubData dataWithState:SLPHistoryDataState_Awake percentage:0.1],
      [HistorySubData dataWithState:SLPHistoryDataState_Noton percentage:0.1],
      [HistorySubData dataWithState:SLPHistoryDataState_Offbed percentage:0.1],
      [HistorySubData dataWithState:SLPHistoryDataState_Sleep percentage:0.1],
      [HistorySubData dataWithState:SLPHistoryDataState_Awake percentage:0.1],
      [HistorySubData dataWithState:SLPHistoryDataState_Noton percentage:0.1],
      [HistorySubData dataWithState:SLPHistoryDataState_Offbed percentage:0.1],
      ];
    [self drawHistoryDataList:list];
}

- (void)configVerticalLable:(UILabel *)label {
    [label setFont:[UIFont systemFontOfSize:10.0]];
    [label setTextColor:Theme.C3];
}

- (void)configStateTextLabel:(UILabel *)label {
    [label setTextColor:Theme.C3];
    [label setFont:[UIFont systemFontOfSize:10.0]];
}

- (UIColor *)colorOfState:(NSInteger)state {
    UIColor *color = [UIColor clearColor];
    switch (state) {
        case SLPHistoryDataState_Sleep:
            color = [Utils colorWithRGB:0x3b83f7 alpha:1];
            break;
        case SLPHistoryDataState_Awake:
            color = [Utils colorWithRGB:0x86bbfa alpha:1];
            break;
        case SLPHistoryDataState_Offbed:
            color = [Utils colorWithRGB:0xdcecfd alpha:1];
            break;
        default:
            break;
    }
    return color;
}

- (CGFloat)heightPercentage:(NSInteger)state {
    CGFloat percentage = 1.0;
    switch (state) {
        case SLPHistoryDataState_Sleep:
            percentage = 1.0;
            break;
        case SLPHistoryDataState_Awake:
            percentage = 2.0/3;
            break;
        case SLPHistoryDataState_Offbed:
            percentage = 1.0/3;
            break;
        default:
            break;
    }
    return percentage;
}

- (UIView *)insertSubData:(HistorySubData *)data leftView:(UIView *)leftView {
    UIView *subView = [[UIView alloc] init];
    [subView setBackgroundColor:[self colorOfState:data.state]];
    [self.contentView addSubview:subView];
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    CGFloat heightPercentage = [self heightPercentage:data.state];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:heightPercentage constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:data.widthPercentage constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    if (leftView) {
        left = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    }
    
    NSArray *constraintList = @[bottom, height, width, left];
    [self.contentView addConstraints:constraintList];
    return subView;
}

- (void)drawHistoryDataList:(NSArray<HistorySubData *> *)dataList {
    [Utils removeAllSubViewsFrom:self.contentView];
    
    UIView *leftView = nil;
    for (HistorySubData *subData in dataList) {
        leftView = [self insertSubData:subData leftView:leftView];
    }
}
@end

@implementation HistorySubData
+ (HistorySubData *)dataWithState:(NSInteger)state percentage:(CGFloat)percentage {
    HistorySubData *data = [[HistorySubData alloc] initWithState:state widthPercentage:percentage];
    return data;
}

- (id)initWithState:(NSInteger)state widthPercentage:(CGFloat)widthPercentage {
    if (self = [super init]) {
        self.state = state;
        self.widthPercentage = widthPercentage;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"state:%d percentage: %f", self.state,self.widthPercentage];
}
@end
