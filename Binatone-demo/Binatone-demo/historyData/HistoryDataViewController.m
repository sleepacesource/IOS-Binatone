//
//  HistoryDataViewController.m
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "HistoryDataViewController.h"
#import "HistoryDataView.h"
#import "BaseTableViewCell.h"
#import <Binatone/Binatone.h>

enum{
    Row_Duration = 0,
    Row_Wake,
    Row_OffBed,
    Row_PowOff,
    Row_AvarageHr,
    Row_AvarageBr,
    
    Row_Bottom,
};

@interface HistoryDataViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HistoryDataView *historyView;
@end

@implementation HistoryDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.historyView = [[[NSBundle mainBundle] loadNibNamed:@"HistoryDataView" owner:self options:nil] firstObject];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.historyView setBackgroundColor:[UIColor whiteColor]];
    [self.titleLabel setText:[self titleOfType:self.type]];
    
    [self drawHistoryView];
}

- (NSArray<HistorySubData *> *)getHistoryDataList {
    NSMutableArray *subDataList = [NSMutableArray array];
    int sca = -1;
    int len = 0;
    CGFloat fCount = self.historyData.analysis.sca.count;
    for (int index = 0; index < fCount; index++) {
        NSNumber *number = self.historyData.analysis.sca[index];
        int aSca = [number intValue];
        BOOL last = (index == fCount - 1);
        if (sca < 0) {
            sca = aSca;
            len = 1;
        }else if (aSca == sca && !last){
            len++;
        }else {
            if (last) {
                len++;
            }
            HistorySubData *subData = [HistorySubData new];
            subData.state = sca;
            subData.widthPercentage = len/fCount;
            [subDataList addObject:subData];
            sca = aSca;
            len = 1;
        }
    }
    return subDataList;
}

- (void)drawHistoryView {
    NSArray *subDataList = [self getHistoryDataList];
    [self.historyView drawHistoryDataList:subDataList];
    
    NSInteger startTime = self.historyData.summary.startTime;
    NSInteger endTime = startTime + 24 * 3600;
    
    NSDate *startTimeDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSDate *endTimeDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *startCmps = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startTimeDate];
    NSDateComponents *endCmps = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:endTimeDate];
    
    NSString *startTimeString = [NSString stringWithFormat:@"%02d:%02d", (int)startCmps.hour, (int)startCmps.minute];
    NSString *endTimeString = [NSString stringWithFormat:@"%02d:%02d", (int)endCmps.hour, (int)endCmps.minute];
    [self.historyView.startTimeLabel setText:startTimeString];
    [self.historyView.endTimeLabel setText:endTimeString];
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 220.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.historyView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return Row_Bottom;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    [Utils configCellTitleLabel:cell.textLabel];
    [cell.detailTextLabel setTextColor:Theme.C3];
    [cell.detailTextLabel setNumberOfLines:2];
    [cell.detailTextLabel setFont:Theme.T3];
    [cell.textLabel setText:[self rowTitleAtRow:indexPath.row]];
    [cell.detailTextLabel setText:[self detailAtRow:indexPath.row]];
    
    BOOL upLineHidden = YES;
    if (indexPath.row == 0) {
        upLineHidden = NO;
    }
    [cell setUpLineHidden:upLineHidden];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSString *)titleOfType:(NSInteger)state {
    NSString *title = @"";
    switch (state) {
        case E_HistoryDataType_24HourData:
            title = LocalizedString(@"data24");
            break;
        case E_HistoryDataType_History:
            title = LocalizedString(@"Daily_Report");
            break;
        case E_HistoryDataType_Demo:
            title = LocalizedString(@"simulation_data");
            break;
        default:
            break;
    }
    return title;
}

- (NSString *)rowTitleAtRow:(NSInteger)row{
    NSString *title = @"";
    switch (row) {
        case Row_Duration:
            title = LocalizedString(@"total_sleep");
            break;
        case Row_Wake:
            title = LocalizedString(@"total_waking");
            break;
        case Row_OffBed:
            title = LocalizedString(@"left_bed_total");
            break;
        case Row_AvarageHr:
            title = LocalizedString(@"avg_heart");
            break;
        case Row_AvarageBr:
            title = LocalizedString(@"avg_breath");
            break;
        case Row_PowOff:
            title = LocalizedString(@"no_monitored_total");
            break;
        default:
            break;
    }
    return title;
}

- (NSString *)detailAtRow:(NSInteger)row {
    int value = 0;
    NSString *title = @"";
    switch (row) {
        case Row_Duration:
            value = self.historyData.analysis.duration;
            title = [NSString stringWithFormat:@"%d%@%d%@", value/60, LocalizedString(@"hour"),value%60,LocalizedString(@"min")];
            break;
        case Row_Wake:
            value = self.historyData.analysis.wake;
            title = [NSString stringWithFormat:@"%d%@%d%@", value/60, LocalizedString(@"hour"),value%60,LocalizedString(@"min")];
            break;
        case Row_OffBed:
            value = self.historyData.analysis.outOfBedDuration;
            title = [NSString stringWithFormat:@"%d%@%d%@", value/60, LocalizedString(@"hour"),value%60,LocalizedString(@"min")];
            break;
        case Row_AvarageHr:
            value = self.historyData.analysis.avgHeartRate;
            title = [NSString stringWithFormat:@"%d%@", value,LocalizedString(@"beats_min")];
            break;
        case Row_AvarageBr:
            value = self.historyData.analysis.avgBreathRate;
            title = [NSString stringWithFormat:@"%d%@", value,LocalizedString(@"times_min")];
            break;
        case Row_PowOff:
            value = self.historyData.analysis.discTime;
            if (value < 60) {
                title = [NSString stringWithFormat:@"%d%@", value,LocalizedString(@"min")];
            }else{
                title = [NSString stringWithFormat:@"%d%@%d%@", value/60, LocalizedString(@"hour"),value%60,LocalizedString(@"min")];
            }
            break;
        default:
            break;
    }
    return title;
}

@end
