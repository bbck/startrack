//
//  Bluetooth.h
//  StarTrack
//
//  Created by Chris Boyle on 11/18/14.
//  Copyright (c) 2014 UMass Amherst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface Bluetooth : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *myCentralManager;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) CBCharacteristic *characteristic;

+ (id) sharedInstance;

@end
