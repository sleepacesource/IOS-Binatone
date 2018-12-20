//
//  SLPBinatoneDef.h
//  Binatone
//
//  Created by Martin on 20/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#ifndef SLPBinatoneDef_h
#define SLPBinatoneDef_h

/*
 object: 蓝牙设备的句柄 CBPeripheral *peripheral
 userInfo: @{kNotificationPostData:BinatoneRealTimeData}
 */
#define kNotificationNameBinatoneRealtimeData @"kNotificationNameBinatoneRealtimeData" //实时数据

/*
 object: 蓝牙设备的句柄 CBPeripheral *peripheral
 userInfo: @{kNotificationPostData:[NSNumber numberWithInteger:电量(0~100)]}
 */
#define kNotificationNameBinatoneBattery @"kNotificationNameBinatoneBattery"//Binatone 电量

#endif /* SLPBinatoneDef_h */
