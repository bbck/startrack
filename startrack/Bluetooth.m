//
//  Bluetooth.m
//  StarTrack
//
//  Created by Chris Boyle on 11/18/14.
//  Copyright (c) 2014 UMass Amherst. All rights reserved.
//

#import "Bluetooth.h"

@implementation Bluetooth

- (id)init
{
    self.myCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    return self;
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"Found peropheral %@", peripheral.description);
//    [self.myCentralManager connectPeripheral:peripheral options:nil];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    NSLog(@"Peripheral connected");
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"centralManagerDidUpdateState");
    switch (self.myCentralManager.state) {
        case CBCentralManagerStatePoweredOn:
            [self.myCentralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString: @"46010CB0-8FC5-43B1-9FF8-0C65E88DCF34"]] options:nil];
            break;
            
        case CBCentralManagerStatePoweredOff:
        case CBCentralManagerStateResetting:
        case CBCentralManagerStateUnauthorized:
        case CBCentralManagerStateUnknown:
        case CBCentralManagerStateUnsupported:
            break;
            
        default:
            break;
    }
}

@end
