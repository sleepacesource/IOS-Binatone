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
#import "CustomHeader.h"

enum {
    Section_24hourData = 0,
    Section_RealData,
    Section_Bottom
};

enum {
    RealtimeDataRow_Status = 0,
    RealtimeDataRow_HeartRate,
    RealtimeDataRow_BreathRate,
    RealtimeDataRow_24HourData,
    RealtimeDataRow_Bottom,
};

@interface RealTimeDataViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<RealtimeData *> *realtimeDataArray;

@property (nonatomic, strong) IBOutlet UIView *hour24SectionHeader;
@property (nonatomic, strong) IBOutlet UILabel *hour24SectionHeaderTitleLabel;

@property (nonatomic, strong) IBOutlet UIView *realtimeSectionHeader;
@property (nonatomic, strong) IBOutlet UILabel *deviceLabel;
@property (nonatomic, strong) IBOutlet UILabel *realtimeSectionHeaderTitleLabel;
@property (nonatomic, strong) IBOutlet UIButton *realtimeButton;



@end

@implementation RealTimeDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = LocalizedString(@"time_data");
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self setUI];
    [self showRealtimeButtonOn:SharedDataManager.inRealtime];
    
    [self addNotificationObserver];
}

- (void)initRealData{
    self.realtimeDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0; i<SharedDataManager.connectList.count; i++) {
        RealtimeData *real = [[RealtimeData alloc] init];
        [self.realtimeDataArray addObject:real];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initRealData];
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
    CBPeripheral *peripheral = notification.object;
    NSDictionary *userInfo = notification.userInfo;
    BinatoneRealTimeData *data = [userInfo objectForKey:kNotificationPostData];
    NSLog(@"st--->>%ld,b-->>%@,h--->>%@,off bed--->>%d",(long)data.status,data.breathRate,data.heartRate,data.isOffBed);
    NSString *subname = [peripheral.name componentsSeparatedByString:@"-"][1];
    for (int i = 0; i < SharedDataManager.connectList.count ; i++) {
        SLPPeripheralInfo *item = SharedDataManager.connectList[i];
        if ([item.name hasSuffix:subname]) {
            RealtimeData *real = [[RealtimeData alloc]init];
            if (data.isInit) {
                real.status = RealtimeDataStaus_Invalid;
            }else if (data.isOffBed) {
                real.status = RealtimeDataStaus_OffBed;
            }else{
                real.status = data.status;
            }
            real.breathRate = data.breathRate;
            real.heartRate = data.heartRate;
            [self.realtimeDataArray replaceObjectAtIndex:i withObject:real];
        }
    }
    [self.tableView reloadData];//
}

- (IBAction)realtimeButtonClicked:(id)sender {
    
   
}

- (void)startRealTime:(SLPPeripheralInfo *)info index:(NSInteger)index{
    if (![self checkAndShowAlertWithConnectStatus]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    BOOL inrealTime = [SharedDataManager.connectListInrealtime[index] boolValue];
    if (!inrealTime) {
        KFLog_Normal(YES, @"start realtime");
        [SLPBLESharedManager binatone:info.peripheral startRealTimeDataWithTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
            if (status == SLPDataTransferStatus_Succeed) {
                [SharedDataManager.connectListInrealtime replaceObjectAtIndex:index withObject:@"1"];
                [weakSelf.tableView reloadData];
            }else{
                [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            }
        }];
    }else{
        KFLog_Normal(YES, @"stop realtime");
        [SLPBLESharedManager binatone:info.peripheral stopRealTimeDataWithTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
            if (status == SLPDataTransferStatus_Succeed) {
                [weakSelf initRealData];
                [SharedDataManager.connectListInrealtime replaceObjectAtIndex:index withObject:@"0"];
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

- (void)get24HourData:(int)index {
    if (![self checkAndShowAlertWithConnectStatus]) {
        return;
    }
    SLPPeripheralInfo *info = SharedDataManager.connectList[index];
    NSDate *date = [NSDate date];
    NSInteger timestamp = [date timeIntervalSince1970];
    //    timestamp = [self get6Timestamp];
    __weak typeof(self) weakSelf = self;
    [self showLoadingView];
    KFLog_Normal(YES, @"get 24 hour data");
    [SLPBLESharedManager binatone:info.peripheral getLast24HourData:timestamp sex:1 callback:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            [Coordinate pushToHistoryData:data type:E_HistoryDataType_24HourData sender:weakSelf animated:YES];
        }else{
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }
        [weakSelf unshowLoadingView];
    }];
    
    
    //analyse original data
    //    [SLPBLESharedManager binatone:SharedDataManager.peripheral getLast24HourOriginalData:timestamp callback:^(SLPDataTransferStatus status, id data) {
    //        BinatoneHistoryData *history= [SLPBLESharedManager analyseOriginalData:data sex:1];
    //        [weakSelf unshowLoadingView];
    //    }];
    
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  SharedDataManager.connectList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 4;
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 150;
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    SLPPeripheralInfo *info = SharedDataManager.connectList[section];
    BOOL inrealTime = [SharedDataManager.connectListInrealtime[section] boolValue];
    NSString *device = info.name;
    CustomHeader *headView = [CustomHeader baseHeaderViewWithTitle:device];
    CGFloat shellAlpha = SharedDataManager.connected ? 1.0 : 0.3;
    [headView.button1 setAlpha:shellAlpha];
    if (inrealTime) {
        [Utils setButton:headView.button1 title:LocalizedString(@"end_real_data")];
    }
    else{
        [Utils setButton:headView.button1 title:LocalizedString(@"obtain_24data")];
    }
    __weak typeof(self) Myself=self;
    headView.myBlock = ^(BOOL click) {
        [Myself startRealTime:info index:section];
    };
    
    return  headView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier2 = @"identifier2";
    BaseTableViewCell *cell = nil;
    NSString *title = @"";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier2];
    }
    RealtimeData * realdata = self.realtimeDataArray[indexPath.section];
    RealtimeDataStaus status = realdata.status;
    [cell setUpLineHidden:YES];
    NSString *detail = @"--";
    BOOL inrealTime = [SharedDataManager.connectListInrealtime[indexPath.section] boolValue];
    switch (indexPath.row) {
        case RealtimeDataRow_Status:
        {
            title = LocalizedString(@"state");
            if (inrealTime) {
                switch (status) {
                    case RealtimeDataStaus_InBed:
                        detail = LocalizedString(@"in_bed");
                        break;
                    case RealtimeDataStaus_B_STOP:
                        detail = LocalizedString(@"breath_stop");
                        break;
                    case RealtimeDataStaus_H_STOP:
                        detail = LocalizedString(@"heart_stop");
                        break;
                    case RealtimeDataStaus_BODYMOVE:
                        detail = LocalizedString(@"body_move");
                        break;
                    case RealtimeDataStaus_TURN_OVER:
                        detail = LocalizedString(@"turn_over");
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
            if (status == RealtimeDataStaus_InBed||status == RealtimeDataStaus_B_STOP ||status == RealtimeDataStaus_H_STOP ||status == RealtimeDataStaus_BODYMOVE||status ==RealtimeDataStaus_TURN_OVER) {
                detail = [NSString stringWithFormat:@"%@%@",realdata.heartRate, LocalizedString(@"beats_min")];
            }
            break;
        case RealtimeDataRow_BreathRate:
            title = LocalizedString(@"real_breath");
            if (status == RealtimeDataStaus_InBed||status == RealtimeDataStaus_B_STOP ||status == RealtimeDataStaus_H_STOP ||status == RealtimeDataStaus_BODYMOVE||status ==RealtimeDataStaus_TURN_OVER) {
                detail = [NSString stringWithFormat:@"%@%@",realdata.breathRate, LocalizedString(@"times_min")];
            }
            break;
        case RealtimeDataRow_24HourData:
        {
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 7, 12)];
            [icon setImage:[UIImage imageNamed:@"common_list_icon_leftarrow.png"]];
            cell.accessoryView = icon;
            title = LocalizedString(@"look_24data");
            detail = @"";
            [Utils configCellTitleLabel:cell.textLabel];
            CGFloat shellAlpha = SharedDataManager.connected ? 1.0 : 0.3;
            [cell.textLabel setTextColor:[UIColor colorWithWhite:0 alpha:shellAlpha]];
        }
            break;
        default:
            break;
    }
    [cell.detailTextLabel setTextColor:Theme.C3];
    [cell.detailTextLabel setFont:Theme.T3];
    [cell.detailTextLabel setText:detail];
    [Utils configCellTitleLabel:cell.textLabel];
    [cell.textLabel setText:title];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == RealtimeDataRow_24HourData) {
        [self get24HourData:indexPath.section];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

@end
