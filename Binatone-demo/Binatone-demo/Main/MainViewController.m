//
//  MainViewController.m
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "MainViewController.h"
#import "TabBarItemCell.h"
#import "TabBarItemCell.h"
#import <math.h>
#import <BluetoothManager/BluetoothManager.h>
#import <Binatone/Binatone.h>

#define kMenuItemHeight 49.0
#define kMenuItemID @"TabBarItemCell"

@interface MainViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIView *menuShell;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *menuHeight;
@property (nonatomic, weak) IBOutlet UICollectionView *menu;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *menuBottom;
@property (nonatomic, strong) NSArray<TabBarItem *> *tabItemList;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIViewController *selectedViewController;
@property (nonatomic, strong) NSArray *tabControllerItems;

@property (nonatomic, assign) BOOL showAlert;

@end

@implementation MainViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //must init BLE manager first
    SLPBLESharedManager;
    
    NSInteger logLevel = KFLogerLevel_All;
    KFSetLogerLevel(logLevel);
    
    [self setUI];
    self.selectedIndex = -1;
    self.tabItemList =
    @[
      [TabBarItem tabBarItemWithTitle:@"device" viewControllerClassString:@"DeviceViewController"],
      [TabBarItem tabBarItemWithTitle:@"time_data" viewControllerClassString:@"RealTimeDataViewController"],
      [TabBarItem tabBarItemWithTitle:@"history_data" viewControllerClassString:@"HistoryDataSectionVC"],
      ];
    
    self.tabControllerItems =
    @[
      [NSClassFromString(@"DeviceViewController") new],
      [NSClassFromString(@"RealTimeDataViewController") new],
      [NSClassFromString(@"HistoryDataSectionVC") new],
      ];
    
    [self showIndex:0];
//    [self showMenuEnable:NO];
    [self addNotificationObservre];
}

- (void)setUI {
    [self.menu setBackgroundColor:[UIColor clearColor]];
    [self.menu registerNib:[UINib nibWithNibName:@"TabBarItemCell" bundle:nil] forCellWithReuseIdentifier:kMenuItemID];
    self.menuHeight.constant = kMenuItemHeight + 1 + [Utils areaInsets].bottom;
    self.menuBottom.constant = [Utils areaInsets].bottom;
    self.menuShell.backgroundColor = Theme.normalLineColor;
}

- (void)showIndex:(NSInteger)index {
    if (self.selectedIndex == index) {
        return;
    }
    self.selectedIndex = index;
    [self.menu reloadData];
    [self showViewControllerAtIndex:index];
}

- (void)showViewControllerAtIndex:(NSInteger)index {
    if (self.selectedViewController){
        [self.selectedViewController willMoveToParentViewController:nil];
        [self.selectedViewController.view removeFromSuperview];
        [self.selectedViewController removeFromParentViewController];
        self.selectedViewController=nil;
    }
    self.selectedViewController = [self.tabControllerItems objectAtIndex:index];
    [self.selectedViewController willMoveToParentViewController:self];
    [self addChildViewController:self.selectedViewController];
    [Utils addSubView:self.selectedViewController.view suitableTo:self.contentView];
    [self.selectedViewController didMoveToParentViewController:self];
}

- (void)showMenuEnable:(BOOL)enable {
    [self.menuShell setUserInteractionEnabled:enable];
}

- (void)addNotificationObservre {
    NSNotificationCenter *notificationCeter = [NSNotificationCenter defaultCenter];
    [notificationCeter addObserver:self selector:@selector(deviceConnected:) name:kNotificationNameBLEDeviceConnected object:nil];
    [notificationCeter addObserver:self selector:@selector(deviceDisconnected:) name:kNotificationNameBLEDeviceDisconnect object:nil];
    [notificationCeter addObserver:self selector:@selector(breathAlarm:) name:kNotificationNameBinatoneBreathStopAlarm object:nil];
    [notificationCeter addObserver:self selector:@selector(leftBedAlarm:) name:kNotificationNameBinatoneLeftBedAlarm object:nil];
}

- (void)deviceConnected:(NSNotification *)notification {
    KFLog_Normal(YES, @"device did disconencted");
//    [self showMenuEnable:YES];
    SharedDataManager.connected = YES;
}

- (void)deviceDisconnected:(NSNotification *)notfication {
    KFLog_Normal(YES, @"device did disconnected");
//    [self showMenuEnable:NO];
//    [self showIndex:0];
//    [SharedDataManager toInit];
    SharedDataManager.connected = NO;
}

- (void)breathAlarm:(NSNotification *)notfication {
    if (self.showAlert) {
        return;
    }
    
    self.showAlert = YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"notice_apnea") message:nil delegate:self cancelButtonTitle:LocalizedString(@"confirm") otherButtonTitles:nil, nil];
    [alert show];
}

- (void)leftBedAlarm:(NSNotification *)notfication {
    if (self.showAlert) {
        return;
    }
    
    self.showAlert = YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"notice_leaving_bed") message:nil delegate:self cancelButtonTitle:LocalizedString(@"confirm") otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.showAlert = NO;
}

#pragma mark UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.tabItemList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    TabBarItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMenuItemID forIndexPath:indexPath];
    TabBarItem *cellInfo = [self.tabItemList objectAtIndex:index];
    NSString *sectionName = LocalizedString(cellInfo.title);
    [cell.titleLabel setText:sectionName];
    [cell setSelected:index == self.selectedIndex];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    [self showIndex:index];
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = kMenuItemHeight;
    CGSize screenSize = kPortraitScreenSize;
    CGFloat width =ceil(screenSize.width/self.tabItemList.count) - 1;
    CGSize size = CGSizeMake(width, height);
    return size;
}
@end

@implementation TabBarItem
+ (TabBarItem *)tabBarItemWithTitle:(NSString *)title viewControllerClassString:(NSString *)viewControllerClassString {
    TabBarItem *item = [TabBarItem new];
    [item setTitle:title];
    [item setViewControllerClassString:viewControllerClassString];
    return item;
}
@end
