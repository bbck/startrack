//
//  DevicesViewController.m
//  StarTrack
//
//  Created by Chris Boyle on 2/14/15.
//  Copyright (c) 2015 UMass Amherst. All rights reserved.
//

#import "DevicesViewController.h"
#import "AppDelegate.h"

@interface DevicesViewController ()

@end

@implementation DevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.manager.delegate = self;
    [appDelegate.manager scanForMelody];
    [self.tableView reloadData];
}

-(void) viewWillDisappear:(BOOL)animated {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.manager stopScanning];
}

- (IBAction)refreshDevices:(id)sender {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.manager scanForMelody];
}

#pragma mark - Table view data source
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *cellIdentifier = @"HeaderCell";
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [MelodyManager numberOfFoundDevices];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Found Devices";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DeviceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    MelodySmart *device;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cellIdentifier];
    }
    
    device = [MelodyManager foundDeviceAtIndex:indexPath.row];
    cell.textLabel.text = [device name];
    cell.detailTextLabel.text = [[device RSSI] stringValue];
    
    return cell;
}

#pragma mark - Melody delegate
- (void) melodyManagerDiscoveryDidRefresh:(MelodyManager*)manager {
    [self.tableView reloadData];
}

@end
