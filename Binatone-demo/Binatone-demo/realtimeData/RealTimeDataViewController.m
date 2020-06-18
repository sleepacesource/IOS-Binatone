//
//  RealTimeDataViewController.m
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "RealTimeDataViewController.h"
#import "BaseTableViewCell.h"
#import "RealtimeData.h"
#import <Binatone/Binatone.h>

enum {
    Section_24hourData = 0,
    Section_RealData,
    Section_Bottom
};

enum {
    RealtimeDataRow_Status = 0,
    RealtimeDataRow_HeartRate,
    RealtimeDataRow_BreathRate,
    
    RealtimeDataRow_Bottom,
};

@interface RealTimeDataViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RealtimeData *realtimeData;

@property (nonatomic, strong) IBOutlet UIView *hour24SectionHeader;
@property (nonatomic, strong) IBOutlet UILabel *hour24SectionHeaderTitleLabel;

@property (nonatomic, strong) IBOutlet UIView *realtimeSectionHeader;
@property (nonatomic, strong) IBOutlet UILabel *realtimeSectionHeaderTitleLabel;
@property (nonatomic, strong) IBOutlet UIButton *realtimeButton;
@end

@implementation RealTimeDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.realtimeData = [RealtimeData new];
    self.titleLabel.text = LocalizedString(@"time_data");
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self setUI];
    [self showRealtimeButtonOn:SharedDataManager.inRealtime];
    
    [self addNotificationObserver];
    self.realtimeData = [RealtimeData new];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showRealtimeButtonOn:SharedDataManager.inRealtime];
    [self.tableView reloadData];
}

- (void)setUI {
    [Utils configSectionTitle:self.hour24SectionHeaderTitleLabel];
    [Utils configSectionTitle:self.realtimeSectionHeaderTitleLabel];
    [Utils configNormalButton:self.realtimeButton];
    [self.hour24SectionHeaderTitleLabel setText:LocalizedString(@"look_24data")];
    [self.realtimeSectionHeaderTitleLabel setText:LocalizedString(@"time_data")];
}

- (void)showRealtimeButtonOn:(BOOL)on {
    
    CGFloat shellAlpha = SharedDataManager.connected ? 1.0 : 0.3;
    
    [self.realtimeButton setAlpha:shellAlpha];
    [self.realtimeSectionHeader setUserInteractionEnabled:SharedDataManager.connected];
    
    NSString *title = LocalizedString(@"obtain_24data");
    if (SharedDataManager.connected) {
        if (on) {
            title = LocalizedString(@"end_real_data");
        }
    }
    [Utils setButton:self.realtimeButton title:title];
}

- (void)addNotificationObserver {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(realtimeDataNotification:) name:kNotificationNameBinatoneRealtimeData object:nil];
}

- (void)realtimeDataNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    BinatoneRealTimeData *data = [userInfo objectForKey:kNotificationPostData];
    NSLog(@"st--->>%ld,b-->>%@,h--->>%@,off bed--->>%d",(long)data.status,data.breathRate,data.heartRate,data.isOffBed);
    if (data.isInit) {
        self.realtimeData.status = RealtimeDataStaus_Invalid;
    }else if (data.isOffBed) {
        self.realtimeData.status = RealtimeDataStaus_OffBed;
    }else{
        self.realtimeData.status = RealtimeDataStaus_InBed;
    }
    self.realtimeData.breathRate = data.breathRate;
    self.realtimeData.heartRate = data.heartRate;
    
    [self.tableView reloadData];
}

- (IBAction)realtimeButtonClicked:(id)sender {
    if (![self checkAndShowAlertWithConnectStatus]) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    if (!SharedDataManager.inRealtime) {
        KFLog_Normal(YES, @"start realtime");
        [SLPBLESharedManager binatone:SharedDataManager.peripheral startRealTimeDataWithTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
            if (status == SLPDataTransferStatus_Succeed) {
                SharedDataManager.inRealtime = YES;
                [weakSelf showRealtimeButtonOn:YES];
            }else{
                [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            }
        }];
    }else{
        KFLog_Normal(YES, @"stop realtime");
        [SLPBLESharedManager binatone:SharedDataManager.peripheral stopRealTimeDataWithTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
            if (status == SLPDataTransferStatus_Succeed) {
                SharedDataManager.inRealtime = NO;
                [weakSelf showRealtimeButtonOn:NO];
                [weakSelf.realtimeData toInit];
                [weakSelf.tableView reloadData];
            }else{
                [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            }
        }];
    }
}

- (NSInteger)get6Timestamp {
    NSDateComponents *cmps = [[NSDateComponents alloc] init];
    cmps.year = 2018;
    cmps.month = 9;
    cmps.day = 6;
    cmps.hour = 0;
    cmps.minute = 0;
    cmps.second = 0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateFromComponents:cmps];
    return [date timeIntervalSince1970];
}

- (void)get24HourData {
    if (![self checkAndShowAlertWithConnectStatus]) {
        return;
    }
    
    NSDate *date = [NSDate date];
    NSInteger timestamp = [date timeIntervalSince1970];
//    timestamp = [self get6Timestamp];
    __weak typeof(self) weakSelf = self;
    [self showLoadingView];
    KFLog_Normal(YES, @"get 24 hour data");
    [SLPBLESharedManager binatone:SharedDataManager.peripheral getLast24HourData:timestamp sex:1 callback:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            [Coordinate pushToHistoryData:data type:E_HistoryDataType_24HourData sender:weakSelf animated:YES];
        }else{
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }
        [weakSelf unshowLoadingView];
    }];
    
    
//    [SLPBLESharedManager binatone:SharedDataManager.peripheral getLast24HourData:timestamp sex:1 callback:^(SLPDataTransferStatus status, id data) {
//        if (status == SLPDataTransferStatus_Succeed) {
//            [Coordinate pushToHistoryData:data type:E_HistoryDataType_24HourData sender:weakSelf animated:YES];
//        }else{
//            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
//        }
//        [weakSelf unshowLoadingView];
//    }];
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return Section_Bottom;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 1;
    if (section == Section_RealData) {
        row = RealtimeDataRow_Bottom;
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 60.0;
    if (section == Section_RealData) {
        height = 110;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = nil;
    switch (section) {
        case Section_24hourData:
            header = self.hour24SectionHeader;
            break;
        case Section_RealData:
            header = self.realtimeSectionHeader;
            break;
        default:
            break;
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier1 = @"identifier1";
    NSString *identifier2 = @"identifier2";
    
    BaseTableViewCell *cell = nil;
    NSString *title = @"";
    if (indexPath.section == Section_24hourData) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 7, 12)];
        [icon setImage:[UIImage imageNamed:@"common_list_icon_leftarrow.png"]];
        cell.accessoryView = icon;
        title = LocalizedString(@"look_24data");
        
        [Utils configCellTitleLabel:cell.textLabel];
        CGFloat shellAlpha = SharedDataManager.connected ? 1.0 : 0.3;
        [cell.textLabel setTextColor:[UIColor colorWithWhite:0 alpha:shellAlpha]];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!cell) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier2];
        }
        RealtimeDataStaus status = self.realtimeData.status;
        [cell setUpLineHidden:YES];
        NSString *detail = @"--";
        switch (indexPath.row) {
            case RealtimeDataRow_Status:
            {
                title = LocalizedString(@"state");
                if (SharedDataManager.inRealtime) {
                    switch (status) {
                        case RealtimeDataStaus_InBed:
                            detail = LocalizedString(@"in_bed");
                            break;
                        case RealtimeDataStaus_OffBed:
                            detail = LocalizedString(@"left_bed");
                            break;
                        default:
                            break;
                    }
                }
            }
                break;
            case RealtimeDataRow_HeartRate:
                title = LocalizedString(@"real_heart");
                if (status == RealtimeDataStaus_InBed) {
                    detail = [NSString stringWithFormat:@"%@%@",self.realtimeData.heartRate, LocalizedString(@"beats_min")];
                }
                break;
            case RealtimeDataRow_BreathRate:
                title = LocalizedString(@"real_breath");
                if (status == RealtimeDataStaus_InBed) {
                    detail = [NSString stringWithFormat:@"%@%@",self.realtimeData.breathRate, LocalizedString(@"times_min")];
                }
                break;
            default:
                break;
        }
        [cell.detailTextLabel setTextColor:Theme.C3];
        [cell.detailTextLabel setFont:Theme.T3];
        [cell.detailTextLabel setText:detail];
        [Utils configCellTitleLabel:cell.textLabel];
    }
    [cell.textLabel setText:title];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == Section_24hourData && SharedDataManager.connected) {
        [self get24HourData];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL ret = NO;
    if (indexPath.section == Section_24hourData) {
        ret = YES;
    }
    return ret;
}

@end
