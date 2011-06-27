//
//  Vehicle.h
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Vehicle : NSObject {
    
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSInteger avgMPG;
@property (nonatomic) NSInteger cityMPG;
@property (nonatomic) NSInteger highwayMPG;

@end
