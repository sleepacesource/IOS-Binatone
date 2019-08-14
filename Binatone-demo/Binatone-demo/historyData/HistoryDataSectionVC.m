//
//  HistoryDataSectionVC.m
//  Binatone-demo
//
//  Created by Martin on 29/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "HistoryDataSectionVC.h"
#import <Binatone/Binatone.h>
#import "DemoData.h"

enum {
    Row_Syn = 0,
    Row_Simulated,
    
    Row_Bottom,
};

@interface HistoryDataSectionVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) BinatoneHistoryData *demoData;
@end

@implementation HistoryDataSectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = LocalizedString(@"history_data");
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.demoData = [DemoData getDemoData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_list_icon_leftarrow.png"]];
    [imageView setFrame:CGRectMake(0, 0, 7, 12)];
    cell.accessoryView = imageView;
    [Utils configCellTitleLabel:cell.textLabel];
    NSString *title = LocalizedString(@"sync");
    if (indexPath.row == Row_Simulated) {
        title = LocalizedString(@"simulation_data");
    } else {
        CGFloat shellAlpha = SharedDataManager.connected ? 1.0 : 0.3;
        [cell.textLabel setTextColor:[UIColor colorWithWhite:0 alpha:shellAlpha]];
    }
    [cell.textLabel setText:title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == Row_Syn && SharedDataManager.connected) {
        [self synData];
    }else {
        [self goToDemo];
    }
}

- (void)synData {
    if (![self checkAndShowAlertWithConnectStatus]) {
        return;
    }
    
    SLPLoadingBlockView *loadingView = [self showLoadingView];
    __weak typeof(self) weakSelf = self;
    
    NSDate *date = [NSDate date];
    NSInteger timestamp = [date timeIntervalSince1970];
    UInt32 startTime = (UInt32)(timestamp - 24 * 3600 * 7);
    KFLog_Normal(YES, @"get history data");
    [SLPBLESharedManager binatone:SharedDataManager.peripheral getHistoryData:startTime endTime:timestamp sex:0 each:^(NSInteger index, NSInteger count, BinatoneHistoryData *data) {
        [loadingView setText:[NSString stringWithFormat:@"%ld/%ld", (long)index+1, (long)count]];
    } completion:^(SLPDataTransferStatus status, NSArray<BinatoneHistoryData *> *dataList) {
        KFLog_Normal(YES, @"download history data finished %d",status);
        [weakSelf unshowLoadingView];
        BinatoneHistoryData *data = [dataList lastObject];
        if (data) {
            [Coordinate pushToHistoryData:data type:E_HistoryDataType_History sender:weakSelf animated:YES];
        }else if (status != SLPDataTransferStatus_Succeed) {
            [Utils showAlertTitle:nil message:LocalizedString(@"sync_falied") confirmTitle:LocalizedString(@"confirm") atViewController:weakSelf];
        }
    }];
}

- (void)goToDemo {
    [Coordinate pushToHistoryData:self.demoData type:E_HistoryDataType_Demo sender:self animated:YES];
}
@end
