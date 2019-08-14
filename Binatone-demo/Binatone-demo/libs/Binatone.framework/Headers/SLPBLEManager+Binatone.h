//
//  SLPBLEManager+Binatone.h
//  SDK
//
//  Created by Martin on 20/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <BluetoothManager/BluetoothManager.h>
#import "BinatoneDeviceInfo.h"
#import "BinatoneBatteryInfo.h"
#import "BinatoneDeviceVersion.h"
#import "BinatoneRealTimeData.h"
#import "BinatoneUpgradeInfo.h"
#import "BinatoneBirthDate.h"
#import "BinatoneAlarm.h"
#import "BinatoneHistoryData.h"
#import "BinatoneMAC.h"

@interface SLPBLEManager (Binatone)


/**
 获取SDK版本号

 @return SDK版本号
 */
- (NSString *)binatoneGetSDKVersion;

/*deviceName 设备名称 和设备ID区分一下
 userId 用户ID
 timeoutInterval 超时时间，如果为0时则用默认超时时间10秒
 DSTOffset  特殊时令时间偏移
 回调值为 BinatoneDeviceInfo
 */
- (void)binatone:(CBPeripheral *)peripheral loginWithDeviceName:(NSString *)deviceName
          userId:(NSInteger)userId time:(NSInteger)time timezone:(NSInteger)timezone
       DSTOffset:(NSInteger)DSTOffset
      callback:(SLPTransforCallback)handle;

/*获取设备信息
 回调返回BinatoneDeviceInfo
 */
- (void)binatone:(CBPeripheral *)peripheral getDeviceInfoTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*获取电量
 回调返回 BinatoneBatteryInfo
 */
- (void)binatone:(CBPeripheral *)peripheral getBatteryWithTimeout:(CGFloat)timeout
      callback:(SLPTransforCallback)handle;

/*获取设备版本信息
 回调返回 BinatoneDeviceVersion
 */
- (void)binatone:(CBPeripheral *)peripheral getDeviceVersionWithTimeout:(CGFloat)timeout
      callback:(SLPTransforCallback)handle;

/**
 获取出生日期
 @param peripheral 蓝牙句柄
 @param timeout 超时 单位秒
 @param handle 回调返回BinatoneBirthDate
 */
- (void)binatone:(CBPeripheral *)peripheral getBirthDateTimeout:(CGFloat)timeout
      compeltion:(SLPTransforCallback)handle;

/**
 设置出生日期
 
 @param peripheral 蓝牙句柄
 @param year 年
 @param month 月
 @param day 日
 @param timeout 超时
 @param handle 返回
 */
- (void)binatone:(CBPeripheral *)peripheral setBirthYear:(int)year month:(int)month day:(int)day timeout:(CGFloat)timeout
      compeltion:(SLPTransforCallback)handle;

/**
 获取呼吸暂停警报
 
 @param peripheral 蓝牙句柄
 @param timeout 超时
 @param handle 返回BinatoneAlarm
 */
- (void)binatone:(CBPeripheral *)peripheral getApneaAlarmTimeOut:(CGFloat)timeout
      compeltion:(SLPTransforCallback)handle;

/**
 设置呼吸暂停警报
 
 @param peripheral 蓝牙句柄
 @param enable 是否打开
 @param hour 小时
 @param minute 分钟
 @param timeout 超时
 @param handle 返回
 */
- (void)binatone:(CBPeripheral *)peripheral setApneaAlarmEnable:(BOOL)enable hour:(int)hour minute:(int)minute length:(int)length
         timeout:(CGFloat)timeout compeltion:(SLPTransforCallback)handle;


/**
 获取离床警报
 
 @param peripheral 蓝牙句柄
 @param timeout 超时
 @param handle 返回BinatoneAlarm
 */
- (void)binatone:(CBPeripheral *)peripheral getLeftBedAlarmTimeOut:(CGFloat)timeout
      compeltion:(SLPTransforCallback)handle;

/**
 设置离床警报
 
 @param peripheral 蓝牙句柄
 @param enable 是否打开
 @param hour 小时
 @param minute 分钟
 @param timeout 超时
 @param handle 返回
 */
- (void)binatone:(CBPeripheral *)peripheral setLeftBedAlarmEnable:(BOOL)enable hour:(int)hour minute:(int)minute length:(int)length
         timeout:(CGFloat)timeout compeltion:(SLPTransforCallback)handle;

/**
 获取mac地址

 @param peripheral 蓝牙句柄
 @param timeout 超时
 @param handle 返回BinatoneMAC
 */
- (void)binatone:(CBPeripheral *)peripheral getMACAddressTimeout:(CGFloat)timeout compeltion:(SLPTransforCallback)handle;


/**
 恢复出厂设置

 @param peripheral 蓝牙句柄
 @param timeout 超时
 @param handle 返回
 */
- (void)binatone:(CBPeripheral *)peripheral restoreFactorySettingsTimeout:(CGFloat)timeout completion:(SLPTransforCallback)handle;

/*开始查看实时数据
 */
- (void)binatone:(CBPeripheral *)peripheral startRealTimeDataWithTimeout:(CGFloat)timeout
      callback:(SLPTransforCallback)handle;

/*结束查看实时数据
 实时数据通过通知kNotificationNameBinatoneRealtimeData 广播出<kNotificationPostData:BinatoneRealTimeData>
 */
- (void)binatone:(CBPeripheral *)peripheral stopRealTimeDataWithTimeout:(CGFloat)timeout
      callback:(SLPTransforCallback)handle;

/*升级
 crcDes:加密包CRC32
 crcBin:原始包CRC32
 package:升级包
 回调返回 BinatoneUpgradeInfo
 */
- (void)binatone:(CBPeripheral *)peripheral upgradeDeviceWithCrcDes:(long)crcDes
        crcBin:(long)crcBin
upgradePackage:(NSData *)package
      callback:(SLPTransforCallback)handle;


/**
 获取最近24小时历史数据

 @param peripheral 蓝牙句柄
 @param currentTime 结束时间 （获取当前往前24小时的数据）
 @param sex 性别 (0:女 1：男)
 @param handle 历史数据返回句柄 回调返回data: BinatoneHistoryData
 */
- (void)binatone:(CBPeripheral *)peripheral getLast24HourData:(NSInteger)currentTime sex:(int)sex callback:(SLPTransforCallback)handle;



/**
 同步历史数据

 @param peripheral 蓝牙句柄
 @param startTime 报告开始时间
 @param endTime 报告结束时间
 @param sex 性别 (0:女 1：男)
 @param eachHandle 每获取一条数据返回
 NSInteger index :这条数据的序号
 NSInteger count :本次数据下载的总条数
 BinatoneHistoryData *data :该条历史数据
 @param completion 历史数据下载完成返回
 */
- (void)binatone:(CBPeripheral *)peripheral getHistoryData:(NSInteger)startTime endTime:(NSInteger)endTime sex:(int)sex each:(void(^)(NSInteger index, NSInteger count, BinatoneHistoryData *data))eachHandle completion:(void(^)(SLPDataTransferStatus status, NSArray<BinatoneHistoryData *> *dataList))completion;
@end
