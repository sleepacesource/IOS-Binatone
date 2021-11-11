//
//  AlarmTimeViewController.m
//  Binatone-demo
//
//  Created by Martin on 29/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "AlarmTimeViewController.h"
#import <Binatone/Binatone.h>
#import "DatePickerPopUpView.h"

enum {
    Row_StartTime = 0,
    Row_EndTime,
    
    Row_Bottom
};

@interface AlarmTimeViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    BinatoneAlarm *_alarmData;
}
@property (nonatomic, weak) IBOutlet UIButton *saveBtn;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDateComponents *beginTime;
@property (nonatomic, strong) NSDateComponents *endTime;
@property (nonatomic, assign) BOOL enable;
@end

@implementation AlarmTimeViewController
@synthesize alarmData = _alarmData;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI {
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.titleLabel setText:LocalizedString(@"set_alert_switch")];
    [Utils setButton:self.saveBtn title:LocalizedString(@"save")];
}

- (void)setAlarmData:(BinatoneAlarm *)alarmData {
    _alarmData = alarmData;
    NSDateComponents *cmps = [[NSDateComponents alloc] init];
    cmps.hour = alarmData.hour;
    cmps.minute = alarmData.minute;
    self.beginTime = [cmps copy];
    cmps.minute += alarmData.length;
    NSCalendar *currentCalender = [NSCalendar currentCalendar];
    NSDate *date = [currentCalender dateFromComponents:cmps];
    cmps = [currentCalender components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    self.endTime = cmps;
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return Row_Bottom;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    [Utils configCellTitleLabel:cell.textLabel];
    [cell.detailTextLabel setTextColor:Theme.C3];
    [cell.detailTextLabel setFont:Theme.T3];
    NSString *title = LocalizedString(@"start_time");
    NSString *detail = [self timeStringFrom:self.beginTime.hour minute:self.beginTime.minute];
    if (indexPath.row == Row_EndTime) {
        title = LocalizedString(@"end_time");
        detail = [self timeStringFrom:self.endTime.hour minute:self.endTime.minute];
    }
    [cell.textLabel setText:title];
    [cell.detailTextLabel setText:detail];
    return cell;
}

- (NSString *)timeStringFrom:(NSInteger)hour minute:(NSInteger)minute {
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)hour, (long)minute];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showDatePickerOfRow:indexPath.row];
}

- (void)showDatePickerOfRow:(NSInteger)row {
    NSString *title = LocalizedString(@"set_start_time");
    NSDateComponents *cmps = self.beginTime;
    if (row == Row_EndTime) {
        cmps = self.endTime;
        title = LocalizedString(@"set_end_time");
    }
    NSCalendar *currentCalender = [NSCalendar currentCalendar];
    NSDate *date = [currentCalender dateFromComponents:cmps];
    
    DatePickerPopUpView *datePicker = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerPopUpView" owner:self options:nil] firstObject];
    [datePicker.titleLabel setText:title];
    datePicker.datePicker.date = date;
    datePicker.datePicker.datePickerMode = UIDatePickerModeTime;
    __weak typeof(self) wekSelf = self;
    [datePicker showInViewController:self animated:YES confirmCallback:^(NSDate *date) {
        NSDateComponents *cmps = [currentCalender components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
        if (row == Row_StartTime) {
            wekSelf.beginTime = cmps;
        }else{
            wekSelf.endTime = cmps;
        }
        [wekSelf.tableView reloadData];
    }];
}

- (IBAction)save:(id)sender {
    if (![self checkAndShowAlertWithConnectStatus]) {
        return;
    }
    
    BOOL on = self.alarmData.enable;
    NSInteger len = self.endTime.hour * 60 + self.endTime.minute - self.beginTime.hour * 60 - self.beginTime.minute;
    if (len < 0) {
        len += 24 * 60;
    }
    __weak typeof(self) weakSelf = self;
    KFLog_Normal(YES, @"save alarm");
    [SLPBLESharedManager binatone:SharedDataManager.peripheral setApneaAlarmEnable:on hour:self.beginTime.hour minute:self.beginTime.minute length:len timeout:0 compeltion:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }else{
            weakSelf.alarmData.hour = weakSelf.beginTime.hour;
            weakSelf.alarmData.minute = weakSelf.beginTime.minute;
            weakSelf.alarmData.length = len;
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            NSString *setTime = [NSString stringWithFormat:@"%02d:%02d-%02d:%02d",weakSelf.beginTime.hour,weakSelf.beginTime.minute,weakSelf.endTime.hour,weakSelf.endTime.minute];
            [[NSUserDefaults standardUserDefaults] setObject:setTime forKey:@"TimeString"];
        }
    }];
}
@end
