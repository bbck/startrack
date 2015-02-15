//
//  AppDelegate.h
//  startrack
//
//  Created by Chris Boyle on 11/9/14.
//  Copyright (c) 2014 UMass Amherst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MelodyManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) MelodySmart *melody;
@property (nonatomic, strong) MelodyManager *manager;

@property (strong, nonatomic) UIWindow *window;


@end

