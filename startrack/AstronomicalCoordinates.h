//
//  AstronomicalCoordinates.h
//  StarTrack
//
//  Created by Chris Boyle on 2/15/15.
//  Copyright (c) 2015 UMass Amherst. All rights reserved.
//

#import <foundation/Foundation.h>

@interface AstronomicalCoordinates : NSObject

+ (NSNumber *)julianDayFor:(NSDate *)date;

@end
