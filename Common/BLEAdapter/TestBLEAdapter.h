//
//  TestBLEAdapter.h
//  quanchengrelian
//
//  Created by _xLonG on 13-11-23.
//  Copyright (c) 2013年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "NSData+SSToolkitAdditions.h"

//UUID
#define TRANSFER_SERVICE_UUID           @"FFF0"
#define TRANSFER_DEVICEINFO_UUID        @"180A"
#define TRANSFER_CHARACTERISTIC_UUID    @"FFF1"
#define TRANSFER_MAC_CHAR_UUID          @"2A23"



//通知
#define CentralManagerStatePoweredOnNotify  @"CentralManagerStatePoweredOnNotify"       //初始化完成
#define DidDiscoverPeripheralNotify         @"DidDiscoverPeripheralNotify"              //发现周边
#define DidConnectPeripheralSuccessNotify   @"DidConnectPeripheralSuccessNotify"        //连接周边成功
#define DidFailToConnectPeripheralNotify    @"DidFailToConnectPeripheralNotify"         //连接周边失败
#define DidDisconnectPeripheralNotify       @"DidDisconnectPeripheralNotify"            //断开周边
#define GetMacAddressNotify                 @"GetMacAddressNotify"                      //获取MAC地址





@interface TestBLEAdapter : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager      *centralManager;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData         *data;



-(id)init;
-(id)initWithDelegate:(id<CBCentralManagerDelegate, CBPeripheralDelegate>)delegate;
- (void)connectPeripheral;
- (void)cancelConnectPeripheral;
- (void)startScan;
- (void)stopScan;
- (BOOL)isConnected;

//写
-(void) writeValue:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID  orderType:(NSString *)orderType;

//读
-(void) readValue: (NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID;

//通知
-(void) notification:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID on:(BOOL)on;


@end
