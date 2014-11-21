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
    _myCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    return self;
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"Found peropheral %@", peripheral.description);
    _peripheral = peripheral;
    [_myCentralManager connectPeripheral:_peripheral options:nil];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [_myCentralManager stopScan];
    _peripheral.delegate = self;
    [_peripheral discoverServices:nil];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"centralManagerDidUpdateState");
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            [_myCentralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString: @"46010CB0-8FC5-43B1-9FF8-0C65E88DCF34"]] options:nil];
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

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service %@", service);
        [_peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"Discovered characteristic %@", characteristic);
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"46010CB0-8FC5-43B1-9FF8-0C65E88DCF34"]]) {
            _characteristic = characteristic;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error == nil) {
        NSLog(@"Wrote value");
    } else {
        NSLog(@"%@", error);
    }
}

@end
