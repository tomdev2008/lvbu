//
//  TestBLEAdapter.m
//  quanchengrelian
//
//  Created by _xLonG on 13-11-23.
//  Copyright (c) 2013年 song. All rights reserved.
//

#import "TestBLEAdapter.h"

@implementation TestBLEAdapter


-(id)init
{
    if((self = [super init]))
    {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _data = [[NSMutableData alloc] init];
    }
    
    return self;
}

-(id)initWithDelegate:(id<CBCentralManagerDelegate, CBPeripheralDelegate>)delegate
{
    if((self = [super init]))
    {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:delegate queue:nil];
        _data = [[NSMutableData alloc] init];
    }
    
    return self;
}


//字符串转换为NSData
- (NSData *)dataFromHexString:(NSString *)string {
    string = [string lowercaseString];
    NSMutableData *data= [NSMutableData new];
    
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i = 0;
    int length = string.length;
    while (i < length-1) {
        char c = [string characterAtIndex:i++];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
            continue;
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
        
    }
    
    return data;
}



//写
-(void) writeValue:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID  orderType:(NSString *)orderType {

    CBUUID *su = [CBUUID UUIDWithString:serviceUUID];
    CBUUID *cu = [CBUUID UUIDWithString:characteristicUUID];

    //根据服务ID，获得当前周边的服务
    CBService *service = [self findServiceFromUUID:su p:self.discoveredPeripheral];
    if (!service) {
        NSLog(@"Could not find service'UUID %@ on peripheral'UUID %s",serviceUUID,[self UUIDToString:self.discoveredPeripheral.UUID]);
        return;
    }
    
    //根据特征ID，获得指定服务的特征
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        NSLog(@"Could not find characteristic'UUID %@ on service'UUID %@ on peripheral'UUID %s",serviceUUID,characteristicUUID, [self UUIDToString:self.discoveredPeripheral.UUID]);
        return;
    }
    
    NSData *data = [self dataFromHexString:orderType];
    [self.discoveredPeripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}


//读
-(void) readValue: (NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID {

    CBUUID *su = [CBUUID UUIDWithString:serviceUUID];
    CBUUID *cu = [CBUUID UUIDWithString:characteristicUUID];
    
    //获得服务
    CBService *service = [self findServiceFromUUID:su p:self.discoveredPeripheral];
    if (!service) {
        NSLog(@"Could not find service'UUID %@ on peripheral'UUID %s\r\n", serviceUUID,[self UUIDToString:self.discoveredPeripheral.UUID]);
        return;
    }
    
    
    //获得特征
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        NSLog(@"Could not find characteristic'UUID %@ on service'UUID %@ on peripheral'UUID %s\r\n",
              serviceUUID, characteristicUUID, [self UUIDToString:self.discoveredPeripheral.UUID]);
        return;
    }
    
    //读取数据
    [self.discoveredPeripheral readValueForCharacteristic:characteristic];
}


//通知
-(void) notification:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID on:(BOOL)on {
 
    
    CBUUID *su = [CBUUID UUIDWithString:serviceUUID];
    CBUUID *cu = [CBUUID UUIDWithString:characteristicUUID];
    
    //获得服务
    CBService *service = [self findServiceFromUUID:su p:self.discoveredPeripheral];
    if (!service) {
        NSLog(@"Could not find service'UUID %@ on peripheral'UUID %s\r\n", serviceUUID,[self UUIDToString:self.discoveredPeripheral.UUID]);
        return;
    }
    
    //获得特征
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        NSLog(@"Could not find characteristic'UUID %@ on service'UUID %@ on peripheral'UUID %s\r\n",
              serviceUUID, characteristicUUID, [self UUIDToString:self.discoveredPeripheral.UUID]);
        return;
    }
    
    //设置通知
    [self.discoveredPeripheral setNotifyValue:on forCharacteristic:characteristic];
}


//交换16位整数的高8位和低8位
-(UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}


//判断两UUID是否相等
- (int) UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2 {
    if(u1 && u2)
    {
        CFUUIDBytes b1 = CFUUIDGetUUIDBytes(u1);
        CFUUIDBytes b2 = CFUUIDGetUUIDBytes(u2);
        if (memcmp(&b1, &b2, 16) == 0) {
            return 1;
        }
        else return 0;
    }
    else
        return -1;
    
}


#pragma mark - 发现周边的服务和特征

//发现指定周边的所有服务
-(void) getAllServicesFromPeripheral:(CBPeripheral *)p{
    [p discoverServices:nil];
}

//发现指定服务的所有特征
-(void) getAllCharacteristicsForService:(CBPeripheral *)p service:(CBService *)s
{
    [p discoverCharacteristics:nil forService:s];
}

//发现指定周边的所有特征
-(void) getAllCharacteristicsFromPeripheral:(CBPeripheral *)p{
    for (int i=0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        printf("Fetching characteristics for service with UUID : %s\r\n",[self CBUUIDToString:s.UUID]);
        [p discoverCharacteristics:nil forService:s];
    }
}


#pragma mark - 获取周边的指定服务或者指定特征

//获得周边的指定服务
-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p {
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    return nil; //Service not found on this peripheral
}


//获得服务的指定特征
-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil; //Characteristic not found on this service
}




#pragma mark - public


- (void)connectPeripheral
{
    if (self.discoveredPeripheral != nil) {
        NSLog(@"connect started");
        [self.centralManager connectPeripheral:self.discoveredPeripheral options:nil];
    }
}


- (void)cancelConnectPeripheral
{
    if (self.discoveredPeripheral != nil) {
        NSLog(@"cancel connect peripheral");
        [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
    }
}

/** Scan for peripherals - specifically for our service's 128bit CBUUID
 */
- (void)startScan
{
    NSLog(@"Scanning started");
    [self.centralManager scanForPeripheralsWithServices:nil /*@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]*/
                                                options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
}


- (void)stopScan
{
    NSLog(@"scaning stoped");
    [self.centralManager stopScan];

}

- (BOOL)isConnected
{
    return [self.discoveredPeripheral isConnected];
}


#pragma mark - UUID相关操作
/*
 *  @method CBUUIDToString
 *
 *  @param UUID UUID to convert to string
 *
 *  @returns Pointer to a character buffer containing UUID in string representation
 *
 *  @discussion CBUUIDToString converts the data of a CBUUID class to a character pointer for easy printout using printf()
 *
 */

//CBUUID转换为char字符串
-(const char *) CBUUIDToString:(CBUUID *) UUID {
    return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}

//CBUUID转换为NSString字符串
-(NSString *) CBUUIDToNSString:(CBUUID *) UUID {
    return [UUID.data description];
}


/*
 *  @method UUIDToString
 *
 *  @param UUID UUID to convert to string
 *
 *  @returns Pointer to a character buffer containing UUID in string representation
 *
 *  @discussion UUIDToString converts the data of a CFUUIDRef class to a character pointer for easy printout using printf()
 *
 */
//CFUUIDRef转换为char字符串
-(const char *) UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);
    
}

/*
 *  @method compareCBUUID
 *
 *  @param UUID1 UUID 1 to compare
 *  @param UUID2 UUID 2 to compare
 *
 *  @returns 1 (equal) 0 (not equal)
 *
 *  @discussion compareCBUUID compares two CBUUID's to each other and returns 1 if they are equal and 0 if they are not
 *
 */

//比较两个CBUUID是否相等,相等返回1，不等返回0
-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2 {
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}

/*
 *  @method compareCBUUIDToInt
 *
 *  @param UUID1 UUID 1 to compare
 *  @param UUID2 UInt16 UUID 2 to compare
 *
 *  @returns 1 (equal) 0 (not equal)
 *
 *  @discussion compareCBUUIDToInt compares a CBUUID to a UInt16 representation of a UUID and returns 1
 *  if they are equal and 0 if they are not
 *
 */

//比较CBUUID和UInt16整数是否相等,相等返回1，不等返回0
-(int) compareCBUUIDToInt:(CBUUID *)UUID1 UUID2:(UInt16)UUID2 {
    char b1[16];
    [UUID1.data getBytes:b1];
    UInt16 b2 = [self swap:UUID2];
    if (memcmp(b1, (char *)&b2, 2) == 0) return 1;
    else return 0;
}
/*
 *  @method CBUUIDToInt
 *
 *  @param UUID1 UUID 1 to convert
 *
 *  @returns UInt16 representation of the CBUUID
 *
 *  @discussion CBUUIDToInt converts a CBUUID to a Uint16 representation of the UUID
 *
 */

//UUID转换为整数
-(UInt16) CBUUIDToInt:(CBUUID *) UUID {
    char b1[16];
    [UUID.data getBytes:b1];
    return ((b1[0] << 8) | b1[1]);
}

/*
 *  @method IntToCBUUID
 *
 *  @param UInt16 representation of a UUID
 *
 *  @return The converted CBUUID
 *
 *  @discussion IntToCBUUID converts a UInt16 UUID to a CBUUID
 *
 */

//整数转换为UUID
-(CBUUID *) IntToCBUUID:(UInt16)UUID {
    char t[16];
    t[0] = ((UUID >> 8) & 0xff); t[1] = (UUID & 0xff);
    NSData *data = [[NSData alloc] initWithBytes:t length:16];
    return [CBUUID UUIDWithData:data];
}



#pragma mark - CentralDelegate

/** centralManagerDidUpdateState is a required protocol method.
 *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
 *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
 *  the Central is ready to be used.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        // In a real app, you'd deal with all the states correctly
        NSLog(@"the centralManager powered off");
        return;
    } else {
        NSLog(@"the centralManager powered on");
        [[NSNotificationCenter defaultCenter] postNotificationName:CentralManagerStatePoweredOnNotify object:nil];
    }
}



/** This callback comes whenever a peripheral that is advertising the TRANSFER_SERVICE_UUID is discovered.
 *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is,
 *  we start the connection process
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    // Reject any where the value is above reasonable range
    //    if (RSSI.integerValue > -15) {
    //        return;
    //    }
    
    // Reject if the signal strength is too low to be close enough (Close is around -22dB)
    //    if (RSSI.integerValue < -35) {
    //        return;
    //    }
    
    
    //日志打印~~
//    NSLog(@"peripheral = %@", [peripheral description]);
//    printf("Discovered %s\n", [[peripheral name] cStringUsingEncoding: NSUTF8StringEncoding]);
//    printf("  RSSI: %s\n", [[RSSI stringValue] cStringUsingEncoding: NSUTF8StringEncoding]);
    
    NSArray *keys = [advertisementData allKeys];
    for (int i = 0; i < [keys count]; ++i) {
        
        id key = [keys objectAtIndex: i];
        NSString *keyName = (NSString *) key;
        NSObject *value = [advertisementData objectForKey: key];
        
        
        if ([keyName isEqualToString:@"kCBAdvDataManufacturerData"]) {
            
            printf("kCBAdvDataManufacturerData =");
            NSData *data = (NSData *)value;
            for (int j = 0; j < data.length; ++j)
                printf(" %02X", ((UInt8 *) data.bytes)[j]);
            printf("\n");
        }
        

//        if ([value isKindOfClass: [NSArray class]]) {
//            printf("   key: %s\n", [keyName cStringUsingEncoding: NSUTF8StringEncoding]);
//            NSArray *values = (NSArray *) value;
//            for (int j = 0; j < [values count]; ++j) {
//                if ([[values objectAtIndex: j] isKindOfClass: [CBUUID class]]) {
//                    CBUUID *uuid = [values objectAtIndex: j];
//                    NSData *data = uuid.data;
//                    printf("      uuid(%d):", j);
//                    for (int j = 0; j < data.length; ++j)
//                        printf(" %2X", ((UInt8 *) data.bytes)[j]);
//                    printf("\n");
//                } else {
//                    const char *valueString = [[value description] cStringUsingEncoding: NSUTF8StringEncoding];
//                    printf("      value(%d): %s\n", j, valueString);
//                }
//            }
//        } else {
//            const char *valueString = [[value description] cStringUsingEncoding: NSUTF8StringEncoding];
//            printf("   key: %s, value: %s\n", [keyName cStringUsingEncoding: NSUTF8StringEncoding], valueString);
//        }
    }

    
    // Ok, it's in range - have we already seen it?

//    if (self.discoveredPeripheral == nil) {
//        
//        self.discoveredPeripheral = peripheral;
//        [[NSNotificationCenter defaultCenter] postNotificationName:DidDiscoverPeripheralNotify object:peripheral];
//        [self.centralManager stopScan];
//    }
    

        [[NSNotificationCenter defaultCenter] postNotificationName:DidDiscoverPeripheralNotify
                                                            object:advertisementData];
}





/*!
 *  @method centralManager:didRetrievePeripherals:
 *
 *  @param central      The central manager providing this information.
 *  @param peripherals  A list of <code>CBPeripheral</code> objects.
 *
 *  @discussion         This method returns the result of a @link retrievePeripherals @/link call, with the peripheral(s) that the central manager was
 *                      able to match to the provided UUID(s).
 *
 */
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    for (int i = 0; i < [peripherals count]; ++i) {
        NSLog(@"peripheral = %@", [[peripherals objectAtIndex:i] description]);
    }
    
}

/*!
 *  @method centralManager:didRetrieveConnectedPeripherals:
 *
 *  @param central      The central manager providing this information.
 *  @param peripherals  A list of <code>CBPeripheral</code> objects representing all peripherals currently connected to the system.
 *
 *  @discussion         This method returns the result of a @link retrieveConnectedPeripherals @/link call.
 *
 */
- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    for (int i = 0; i < [peripherals count]; ++i) {
        NSLog(@"peripheral = %@", [[peripherals objectAtIndex:i] description]);
    }
}




/*!
 *  @method centralManager:didDisconnectPeripheral:error:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has disconnected.
 *  @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion         This method is invoked upon the disconnection of a peripheral that was connected by @link connectPeripheral:options: @/link. If the disconnection
 *                      was not initiated by @link cancelPeripheralConnection @/link, the cause will be detailed in the <i>error</i> parameter. Once this method has been
 *                      called, no more methods will be invoked on <i>peripheral</i>'s <code>CBPeripheralDelegate</code>.
 *
 */
/** Once the disconnection happens, we need to clean up our local copy of the peripheral
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected");
    NSLog(@"error = %@", [error description]);
    self.discoveredPeripheral = nil;
    
    
    // We're disconnected, so start scanning again
    [self startScan];
    [[NSNotificationCenter defaultCenter] postNotificationName:DidDisconnectPeripheralNotify object:nil];
}




/** If the connection fails for whatever reason, we need to deal with it.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //连接失败
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    [self cleanup];
    [[NSNotificationCenter defaultCenter] postNotificationName:DidFailToConnectPeripheralNotify object:nil];
}








/** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    //连接成功
    NSLog(@"Peripheral Connected");

    // Clear the data that we may already have
    [self.data setLength:0];
    
    // Make sure we get the discovery callbacks
    peripheral.delegate = self;
    
    // Search only for services that match our UUID
    [peripheral discoverServices:nil];
    //[peripheral discoverServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:DidConnectPeripheralSuccessNotify object:peripheral];
    


}





#pragma mark - PeripheralDelegate

/** The Transfer Service was discovered
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    // Discover the characteristic we want...
    for (CBService *service in peripheral.services) {
        NSLog(@"service uuid = %@", [self CBUUIDToNSString:[service UUID]]);
        [peripheral discoverCharacteristics:nil forService:service];
        //[peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]] forService:service];
    }
}


/** The Transfer characteristic was discovered.
 *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    // Deal with errors (if any)
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    // Again, we loop through the array, just in case.
    for (CBCharacteristic *characteristic in service.characteristics) {

//        NSLog(@"service uuid = %@, character uuid = %@", [self CBUUIDToNSString:[service UUID]], [self CBUUIDToNSString:[characteristic UUID]]);
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
//            [peripheral discoverDescriptorsForCharacteristic:characteristic];
//        }
//        
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_MAC_CHAR_UUID]]) {
//            //读取MAC地址
//            [self readValue:TRANSFER_DEVICEINFO_UUID characteristicUUID:TRANSFER_MAC_CHAR_UUID];
//        }
        
        
    }
    // Once this is complete, we just need to wait for the data to come in.
}




/** This callback lets us know more data has arrived via notification on the characteristic
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    NSLog(@"receive data:");
    //CFShow(characteristic.value);
    //Otherwise, just add the data on to what we already have
    [self.data appendData:characteristic.value];
    
    //NSString *chainId = [characteristic.value base64EncodedString];
    NSString *chainId = [characteristic.value hexString];
    [[NSNotificationCenter defaultCenter] postNotificationName:GetMacAddressNotify
                                                        object:chainId
                                                      userInfo:nil];
    

}


/** The peripheral letting us know whether our subscribe/unsubscribe happened or not
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    // Exit if it's not the transfer characteristic
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
        return;
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    } else {
        // Notification has stopped
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}





/** Call this when things either go wrong, or you're done with the connection.
 *  This cancels any subscriptions if there are any, or straight disconnects if not.
 *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
 */
- (void)cleanup
{
    // Don't do anything if we're not connected
    if (!self.discoveredPeripheral.isConnected) {
        return;
    }
    
    // See if we are subscribed to a characteristic on the peripheral
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            // It is notifying, so unsubscribe
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            
                            // And we're done.
                            return;
                        }
                    }
                }
            }
        }
    }
    
    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}

@end
