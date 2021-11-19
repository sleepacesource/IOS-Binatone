//
//  DeviceViewController.m
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "DeviceViewController.h"
#import "SearchViewController.h"
#import <Binatone/Binatone.h>
#import "DatePickerPopUpView.h"
#import "ImageTableViewCell.h"

enum {
    Section_Title = 0,
    Section_Device,
    Section_Bottom
};

enum {
    SectionTitleRow_title = 0,
    SectionTitleRow_Btn,
    
    SectionTitleRow_Bottom
};

@interface DeviceViewController ()<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>
{
    int indexRow;
    int disconnectIndexRow;
}
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIButton *connectBtn;
@property (nonatomic, weak) IBOutlet UIView *userIDShell;
@property (nonatomic, weak) IBOutlet UILabel *userIDTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *userIDLabel;

@property (nonatomic, weak) IBOutlet UILabel *showConnectLabel;
@property (nonatomic, weak) IBOutlet UITableView *connectTableview;

//deviceInfo
@property (nonatomic, weak) IBOutlet UIView *deviceInfoShell;
@property (nonatomic, weak) IBOutlet UILabel *deviceInfoSectionLabel;
@property (nonatomic, weak) IBOutlet UIButton *getDeviceNameBtn;
@property (nonatomic, weak) IBOutlet UILabel *deviceNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *getDeviceIDBtn;
@property (nonatomic, weak) IBOutlet UILabel *deviceIDLabel;
@property (nonatomic, weak) IBOutlet UIButton *getBatteryBtn;
@property (nonatomic, weak) IBOutlet UILabel *batteryLabel;
@property (nonatomic, weak) IBOutlet UIButton *getMacBtn;
@property (nonatomic, weak) IBOutlet UILabel *macLabel;
//firmwareInfo
@property (nonatomic, weak) IBOutlet UIView *firmwareInfoShell;
@property (nonatomic, weak) IBOutlet UILabel *firmwareInfoSectionLabel;
@property (nonatomic, weak) IBOutlet UIButton *getFirmwareVersionBtn;
@property (nonatomic, weak) IBOutlet UILabel *firmwareVersionLabel;
@property (nonatomic, weak) IBOutlet UIButton *upgradeBtn;
//setting
@property (nonatomic, weak) IBOutlet UIView *settingShell;
@property (nonatomic, weak) IBOutlet UILabel *settingSectionLabel;
@property (nonatomic, weak) IBOutlet UIView *leftBedAlarmUpLine;
@property (nonatomic, weak) IBOutlet UILabel *leftBedAlarmTitleLabel;
@property (nonatomic, weak) IBOutlet UISwitch *leftBedAlarmEnableSwitch;
@property (nonatomic, weak) IBOutlet UIView *leftBedAlarmDownLine;
@property (nonatomic, weak) IBOutlet UIView *alarmUpLine;
@property (nonatomic, weak) IBOutlet UILabel *alarmTitleLabel;
@property (nonatomic, weak) IBOutlet UISwitch *alarmEnableSwitch;
@property (nonatomic, weak) IBOutlet UIView *alarmDownLine;
@property (nonatomic, weak) IBOutlet UILabel *alarmTimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *alarmTimeIcon;
@property (nonatomic, weak) IBOutlet UIView *alarmTimeDownLine;
@property (nonatomic, weak) IBOutlet UILabel *alarmTimeLabelValue;

@property (nonatomic, weak) IBOutlet UILabel *alarmTimeLabel2;
@property (nonatomic, weak) IBOutlet UILabel *alarmTimeLabelValue2;

@property (nonatomic, strong) BinatoneAlarm *alarmInfo;
@property (nonatomic, strong) BinatoneAlarm *leftBedAlarmInfo;
@property (nonatomic, assign) BOOL connected;

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = LocalizedString(@"device");
    
    self.alarmInfo = [BinatoneAlarm new];
    self.alarmInfo.enable = NO;
    self.alarmInfo.hour = 22;
    self.alarmInfo.minute = 0;
    self.alarmInfo.length = 600;
    
    self.leftBedAlarmInfo = [BinatoneAlarm new];
    self.leftBedAlarmInfo.enable = NO;
    self.leftBedAlarmInfo.hour = 22;
    self.leftBedAlarmInfo.minute = 0;
    self.leftBedAlarmInfo.length = 600;
    
    [self setUI];
    [self addNotificationObservre];
    [self showConnected:NO];
    
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    //    [self.contentView addGestureRecognizer:tap];
}

- (void)setUI {
    [Utils configNormalButton:self.connectBtn];
    [Utils configNormalButton:self.getDeviceNameBtn];
    [Utils configNormalButton:self.getDeviceIDBtn];
    [Utils configNormalButton:self.getBatteryBtn];
    [Utils configNormalButton:self.getFirmwareVersionBtn];
    [Utils configNormalButton:self.getMacBtn];
    [Utils configNormalButton:self.upgradeBtn];
    
    [Utils configNormalDetailLabel:self.deviceNameLabel];
    [Utils configNormalDetailLabel:self.deviceIDLabel];
    [Utils configNormalDetailLabel:self.batteryLabel];
    [Utils configNormalDetailLabel:self.firmwareVersionLabel];
    [Utils configNormalDetailLabel:self.macLabel];
    
    [Utils configSectionTitle:self.showConnectLabel];
    [Utils configSectionTitle:self.userIDTitleLabel];
    [Utils configSectionTitle:self.deviceInfoSectionLabel];
    [Utils configSectionTitle:self.firmwareInfoSectionLabel];
    [Utils configSectionTitle:self.settingSectionLabel];
    
    [Utils setButton:self.getDeviceNameBtn title:LocalizedString(@"device_id_clear")];
    [Utils setButton:self.getDeviceIDBtn title:LocalizedString(@"device_id_cipher")];
    [Utils setButton:self.getBatteryBtn title:LocalizedString(@"obtain_electricity")];
    [Utils setButton:self.getFirmwareVersionBtn title:LocalizedString(@"obtain_firmware")];
    [Utils setButton:self.getMacBtn title:LocalizedString(@"obtain_mac_address")];
    [Utils setButton:self.upgradeBtn title:LocalizedString(@"fireware_update")];
    
    [self.showConnectLabel setText:LocalizedString(@"show_connect_device")];
    [self.leftBedAlarmTitleLabel setText:LocalizedString(@"leaving_bed_alert")];
    [self.alarmTitleLabel setText:LocalizedString(@"apnea_alert")];
    [self.alarmTimeIcon setImage:[UIImage imageNamed:@"common_list_icon_leftarrow.png"]];
    [self.alarmTimeLabel setText:LocalizedString(@"set_alert_switch")];
    [self.alarmTimeLabel2 setText:LocalizedString(@"set_alert_switch")];
    
    [self.userIDTitleLabel setText:LocalizedString(@"userid_sync_sleep")];
    [self.deviceInfoSectionLabel setText:LocalizedString(@"device_infos")];
    [self.firmwareInfoSectionLabel setText:LocalizedString(@"firmware_info")];
    [self.settingSectionLabel setText:LocalizedString(@"setting")];
    
    [self.leftBedAlarmUpLine setBackgroundColor:Theme.normalLineColor];
    [self.leftBedAlarmDownLine setBackgroundColor:Theme.normalLineColor];
    [self.alarmUpLine setBackgroundColor:Theme.normalLineColor];
    [self.alarmDownLine setBackgroundColor:Theme.normalLineColor];
    [self.alarmTimeDownLine setBackgroundColor:Theme.normalLineColor];
    
    [Utils configCellTitleLabel:self.leftBedAlarmTitleLabel];
    [Utils configCellTitleLabel:self.alarmTitleLabel];
    [Utils configCellTitleLabel:self.alarmTimeLabel];
    [Utils configCellTitleLabel:self.alarmTimeLabelValue];
    [Utils configCellTitleLabel:self.alarmTimeLabel2];
    [Utils configCellTitleLabel:self.alarmTimeLabelValue2];
    
    self.userIDLabel.keyboardType = UIKeyboardTypeNumberPad;
    [self.userIDLabel setTextColor:Theme.C3];
    [self.userIDLabel setFont:Theme.T3];
    
    [self.userIDLabel.layer setMasksToBounds:YES];
    [self.userIDLabel.layer setCornerRadius:2.0];
    [self.userIDLabel.layer setBorderWidth:1.0];
    [self.userIDLabel.layer setBorderColor:Theme.normalLineColor.CGColor];
    [self.userIDLabel setText:[DataManager sharedDataManager].userID];
    [self.userIDLabel setPlaceholder:LocalizedString(@"enter_userid")];
    self.connectTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self reloadAlarmInfo];
}

- (void)tap:(UIGestureRecognizer *)gesture {
    [self.userIDLabel resignFirstResponder];
}

- (void)showConnected:(BOOL)connected {
    CGFloat shellAlpha = connected ? 1.0 : 0.3;
    [self.deviceInfoShell setAlpha:shellAlpha];
    [self.firmwareInfoShell setAlpha:shellAlpha];
    [self.settingShell setAlpha:shellAlpha];
    
    [self.deviceInfoShell setUserInteractionEnabled:connected];
    [self.firmwareInfoShell setUserInteractionEnabled:connected];
    [self.settingShell setUserInteractionEnabled:connected];
    
    if (!connected) {
        [self.deviceNameLabel setText:@""];
        [self.deviceIDLabel setText:@""];
        [self.batteryLabel setText:@""];
        [self.firmwareVersionLabel setText:@""];
        [self.macLabel setText:@""];
    }else{
        
    }
    [Utils setButton:self.connectBtn title:LocalizedString(@"connect_device")];
    [self.settingShell setUserInteractionEnabled:connected];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    [self.deviceIDLabel setText:SharedDataManager.deviceID];
    //    [self.deviceNameLabel setText:SharedDataManager.deviceName];
    indexRow = -1;
    [self showConnected:SharedDataManager.connected];
    
    if (SharedDataManager.connectList.count) {
        [self.connectTableview reloadData];
        [self showDevice];
    }
    if (SharedDataManager.connected) {
        [self getAlarmInfo:SharedDataManager.peripheral];
        [self getLeftBedAlarmInfo:SharedDataManager.peripheral];
    }
}

- (void)showDevice{
    self.showConnectLabel.text = [NSString stringWithFormat:@"%@%@",LocalizedString(@"show_connect_device"),SharedDataManager.deviceName?SharedDataManager.deviceName:@""];
}


- (void)selectIndexDevice:(int)index{
    if (SharedDataManager.connectList.count>index) {
        SLPPeripheralInfo *info = [SharedDataManager.connectList objectAtIndex:index];
        SharedDataManager.deviceName = info.name;
        SharedDataManager.peripheral = info.peripheral;
        [self showDevice];
    }
}

- (void)addNotificationObservre {
    NSNotificationCenter *notificationCeter = [NSNotificationCenter defaultCenter];
    [notificationCeter addObserver:self selector:@selector(deviceConnected:) name:kNotificationNameBLEDeviceConnected object:nil];
    [notificationCeter addObserver:self selector:@selector(deviceDisconnected:) name:kNotificationNameBLEDeviceDisconnect object:nil];
}


- (void)deviceConnected:(NSNotification *)notification {
    self.connected = YES;
    [self showConnected:YES];
    //    [self getAlarmInfo:notification.object];
    
    
}

- (void)deviceDisconnected:(NSNotification *)notfication {
    if (SharedDataManager.connectList.count>0) {
       NSString *deviceName =[notfication.object objectForKey:@"deviceName"];
        for (int i= 0; i< SharedDataManager.connectList.count; i++) {
            SLPPeripheralInfo *info = [SharedDataManager.connectList objectAtIndex:i];
            if ([info.name hasPrefix:deviceName]) {
                [SharedDataManager.connectList removeObjectAtIndex:i];
                [SharedDataManager.connectListInrealtime removeObjectAtIndex:i];
                [self.connectTableview reloadData];
                if([SharedDataManager.deviceName isEqualToString:info.name]) {
                    if (SharedDataManager.connectList.count>0) {
                        SLPPeripheralInfo *newinfo = [SharedDataManager.connectList objectAtIndex:0];
                        SharedDataManager.deviceName = newinfo.name;
                        SharedDataManager.peripheral = newinfo.peripheral;
                        [self showDevice];
                    }
                    else{
                        self.connected = NO;
                        [self showConnected:NO];
                        [self showDevice];
                        [SharedDataManager toInit];
                    }
                }
            }
        }
    }
}

- (void)reloadAlarmInfo {
    BOOL on = NO;
    if (self.alarmInfo) {
        on = self.alarmInfo.enable;
        int total = (self.alarmInfo.hour * 60 + self.alarmInfo.minute + self.alarmInfo.length);
        if (total >= 24*60) {
            total = total - 24*60;
        }
        int endHour = total/60;
        int endMint = total%60;
        self.alarmTimeLabelValue.text = [NSString stringWithFormat:@"%02d:%02d-%02d:%02d",self.alarmInfo.hour,self.alarmInfo.minute,endHour,endMint];
        
    }
    [self.alarmEnableSwitch setOn:on];
    
    on = NO;
    if (self.leftBedAlarmInfo) {
        on = self.leftBedAlarmInfo.enable;
        int total = (self.leftBedAlarmInfo.hour * 60 + self.leftBedAlarmInfo.minute + self.leftBedAlarmInfo.length);
        if (total >= 24*60) {
            total = total - 24*60;
        }
        int endHour = total/60;
        int endMint = total%60;
        self.alarmTimeLabelValue2.text = [NSString stringWithFormat:@"%02d:%02d-%02d:%02d",self.leftBedAlarmInfo.hour,self.leftBedAlarmInfo.minute,endHour,endMint];
    }
    [self.leftBedAlarmEnableSwitch setOn:on];
}

- (void)getAlarmInfo:(CBPeripheral *)sender {
    __weak typeof(self) weakSelf = self;
    [SLPBLESharedManager binatone:sender getApneaAlarmTimeOut:0 compeltion:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            weakSelf.alarmInfo = data;
            [weakSelf reloadAlarmInfo];
        }
    }];
}

- (void)getLeftBedAlarmInfo:(CBPeripheral *)sender {
    __weak typeof(self) weakSelf = self;
    [SLPBLESharedManager binatone:sender getLeftBedAlarmTimeOut:0 compeltion:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            weakSelf.leftBedAlarmInfo = data;
            [weakSelf reloadAlarmInfo];
        }
    }];
}

- (IBAction)connectDeviceClicked:(id)sender {
    [self.userIDLabel resignFirstResponder];
    if (SharedDataManager.connectList.count == 5) {
        return;
        //        [SLPBLESharedManager disconnectPeripheral:SharedDataManager.peripheral timeout:0 completion:nil];
    }else{
        //836408
        //832802
        NSString *userID = [self.userIDLabel text];
        if (!userID || userID.length == 0) {
            [Utils showAlertTitle:nil message:LocalizedString(@"userid_not_empty") confirmTitle:LocalizedString(@"confirm") atViewController:self];
            return;
        }
        if ([userID hasPrefix:@"0"]) {
            [Utils showAlertTitle:nil message:LocalizedString(@"userid_error") confirmTitle:LocalizedString(@"confirm") atViewController:self];
            return;
        }
        if (![SLPBLESharedManager blueToothIsOpen]) {
            [Utils showAlertTitle:nil message:LocalizedString(@"phone_bluetooth_not_open") confirmTitle:LocalizedString(@"confirm") atViewController:self];
            return;
        }
        [[DataManager sharedDataManager] setUserID:userID];
        [Coordinate pushViewControllerName:@"SearchViewController" sender:self animated:YES];
    }
}

- (IBAction)getDeviceNameClicked:(id)sender {
    NSString *deviceName = SharedDataManager.deviceName;
    [self.deviceNameLabel setText:deviceName];
}

- (IBAction)getDeviceIDClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    KFLog_Normal(YES, @"get deviceId");
    [SLPBLESharedManager binatone:SharedDataManager.peripheral getDeviceInfoTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            BinatoneDeviceInfo *deviceInfo = data;
            [self.deviceIDLabel setText:deviceInfo.deviceID];
        }else{
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }
    }];
}

- (IBAction)getBatteryClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    KFLog_Normal(YES, @"get batterry");
    [SLPBLESharedManager binatone:SharedDataManager.peripheral getBatteryWithTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            BinatoneBatteryInfo *info = data;
            NSString *text = nil;
            if (info.chargingState == 1) {
                text = LocalizedString(@"charging");
            }else{
                NSInteger quantity = info.quantity;
                text = [NSString stringWithFormat:@"%ld%%", (long)quantity];
            }
            self.batteryLabel.text = text;
        }else{
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }
    }];
}

- (IBAction)getDeviceVerionClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    KFLog_Normal(YES, @"get deviceVersion");
    [SLPBLESharedManager binatone:SharedDataManager.peripheral getDeviceVersionWithTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            BinatoneDeviceVersion *info = data;
            [self.firmwareVersionLabel setText:info.hardwareVersion];
        }else{
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }
    }];
}

- (IBAction)getDeviceMacAddress:(id)sender {
    KFLog_Normal(YES, @"get mac");
    __weak typeof(self) weakSelf = self;
    [SLPBLESharedManager binatone:SharedDataManager.peripheral getMACAddressTimeout:0 compeltion:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            KFLog_Normal(YES, @"get mac succedd");
            BinatoneMAC *mac = data;
            [self.macLabel setText:mac.mac];
        }else{
            KFLog_Normal(YES, @"get mac failed %d", status);
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }
    }];
}

//- (void)testRestoreFactorySetting {
//    __weak typeof(self) weakSelf = self;
//    SLPBLEManager *manager = SLPBLESharedManager;
//    CBPeripheral *peripheral = SharedDataManager.peripheral;
//    [manager binatone:peripheral setAlarmEnable:YES hour:11 minute:11 length:600 timeout:0 compeltion:^(SLPDataTransferStatus status, id data) {
//        [manager binatone:peripheral setBirthYear:2013 month:5 day:22 timeout:0 compeltion:^(SLPDataTransferStatus status, id data) {
//            [manager binatone:peripheral restoreFactorySettingsTimeout:0 completion:^(SLPDataTransferStatus status, id data) {
//                [manager binatone:peripheral getAlarmTimeout:0 compeltion:^(SLPDataTransferStatus status, id data) {
//                    BinatoneAlarm *alarm = data;
//                    [manager binatone:peripheral getBirthDateTimeout:0 compeltion:^(SLPDataTransferStatus status, id data) {
//                        BinatoneBirthDate *birth = data;
//                        NSString *alarmDescription = [NSString stringWithFormat:@"alarmInfo:\benable:%d\nhour:%d\nminute:%d\nlength:%d\n",alarm.enable,alarm.hour,alarm.minute,alarm.length];
//                        NSString *birthInfo = [NSString stringWithFormat:@"birth:\nyear:%d\nmonth:%d\nday:%d\n",birth.year,birth.month,birth.day];
//                        NSString *description = [NSString stringWithFormat:@"%@%@",alarmDescription, birthInfo];
//                        [Utils showAlertTitle:nil message:description confirmTitle:LocalizedString(@"confirm") atViewController:weakSelf];
//                    }];
//                }];
//            }];
//        }];
//    }];
//}

- (IBAction)upgradeClicked:(id)sender {
    KFLog_Normal(YES, @"upgrade");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MBP89SN-v1.53r(v2.0.02r)-gp-20211119" ofType:@"des"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    __weak typeof(self) weakSelf = self;
    SLPLoadingBlockView *loadingView = [self showLoadingView];
    [SLPBLESharedManager binatone:SharedDataManager.peripheral upgradeDeviceWithCrcDes:(long)2806082678 crcBin:(long)4130003188 upgradePackage:data callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed){
            [weakSelf unshowLoadingView];
            [Utils showAlertTitle:nil message:LocalizedString(@"up_failed") confirmTitle:LocalizedString(@"confirm") atViewController:weakSelf];
        }else{
            BinatoneUpgradeInfo *info = data;
            [loadingView setText:[NSString stringWithFormat:@"%2d%%", (int)(info.progress * 100)]];
            if (info.progress == 1) {
                [weakSelf unshowLoadingView];
                [Utils showAlertTitle:nil message:LocalizedString(@"up_success") confirmTitle:LocalizedString(@"confirm") atViewController:weakSelf];
            }
        }
    }];
}

- (IBAction)leftBedAlarmEnableValueChanged:(UISwitch *)sender {
    BOOL on = sender.on;
    __weak typeof(self) weakSelf = self;
    KFLog_Normal(YES, @"set left bed alarm");
    [SLPBLESharedManager binatone:SharedDataManager.peripheral setLeftBedAlarmEnable:on hour:self.leftBedAlarmInfo.hour minute:self.leftBedAlarmInfo.minute length:self.leftBedAlarmInfo.length timeout:0 compeltion:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            [sender setOn:on];
        }else{
            weakSelf.leftBedAlarmInfo.enable = on;
            [weakSelf reloadAlarmInfo];
        }
    }];
}

- (IBAction)alarmEnableValueChanged:(UISwitch *)sender {
    BOOL on = sender.on;
    __weak typeof(self) weakSelf = self;
    KFLog_Normal(YES, @"set alarm");
    [SLPBLESharedManager binatone:SharedDataManager.peripheral setApneaAlarmEnable:on hour:self.alarmInfo.hour minute:self.alarmInfo.minute length:self.alarmInfo.length timeout:0 compeltion:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            [sender setOn:on];
        }else{
            weakSelf.alarmInfo.enable = on;
            [weakSelf reloadAlarmInfo];
        }
    }];
}

- (IBAction)alarmTimeEdit:(id)sender {
    [Coordinate pushToAlarmTime:self.alarmInfo type:2 sender:self aniamted:YES];
}

- (IBAction)leftBedAlarmTimeEdit:(id)sender {
    [Coordinate pushToAlarmTime:self.leftBedAlarmInfo type:1 sender:self aniamted:YES];
}


#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return Section_Bottom;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 1;
    if (section == Section_Device) {
        row = SharedDataManager.connectList.count;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ImageTableViewCell";
    ImageTableViewCell *cell = (ImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ImageTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = (ImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    NSInteger row = indexPath.row;
    
    NSString *title = @"";
    switch (indexPath.section) {
        case Section_Title:
            switch (row) {
                case Section_Title:
                    title = LocalizedString(@"conected_device");
                    cell.cellImageView.hidden = YES;
                    
                    break;
                default:
                    break;
            }
            break;
        case Section_Device:
        {
            SLPPeripheralInfo *info = [SharedDataManager.connectList objectAtIndex:row];
            title = info.name;
            [cell.cellImageView setImage:[UIImage imageNamed:@"ic_shanchu.png"]];
            cell.cellImageView.hidden = NO;
            cell.cellClickBlock = ^(BOOL click){
                [self disconnectDevice:(int)indexPath.row];
            };
        }
            break;
        default:
            break;
    }
    [Utils configCellTitleLabel:cell.titleLabel];
    [cell.titleLabel setText:title];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL ret = YES;
    if (indexPath.section == Section_Title && indexPath.row == SectionTitleRow_title) {
        ret = NO;
    }
    return ret;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == Section_Device) {
        if (indexRow == (int)indexPath.row) {
            return;
        }
        indexRow = (int)indexPath.row;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"show_device_title") message:LocalizedString(@"show_device_message") delegate:self cancelButtonTitle:LocalizedString(@"cancel") otherButtonTitles:LocalizedString(@"confirm"), nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self selectIndexDevice:indexRow];
    }
}


- (void)disconnectDevice:(int)index{
    if (SharedDataManager.connectList.count>index) {
        disconnectIndexRow = index;
        SLPPeripheralInfo *info = [SharedDataManager.connectList objectAtIndex:index];
        [SLPBLESharedManager disconnectPeripheral:info.peripheral timeout:0 completion:^(SLPBLEDisconnectReturnCodes code, NSInteger disconnectHandleID) {
        }];
    }
}

@end
