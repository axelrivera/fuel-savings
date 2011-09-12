//
//  MPGDatabaseInfo.h
//  Fuel Savings
//
//  Created by Axel Rivera on 7/22/11.
//  Copyright (c) 2011 Axel Rivera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MPGDatabaseInfo : NSManagedObject

@property (nonatomic, retain) NSString *sizeClass;
@property (nonatomic, retain) NSNumber *year;
@property (nonatomic, retain) NSString *make;
@property (nonatomic, retain) NSString *model;
@property (nonatomic, retain) NSString *engine;
@property (nonatomic, retain) NSString *fuel;
@property (nonatomic, retain) NSString *cylinders;
@property (nonatomic, retain) NSString *transmission;
@property (nonatomic, retain) NSNumber *turbocharger;
@property (nonatomic, retain) NSNumber *supercharger;
@property (nonatomic, retain) NSString *drive;
@property (nonatomic, retain) NSNumber *mpgCity;
@property (nonatomic, retain) NSNumber *mpgHighway;
@property (nonatomic, retain) NSNumber *mpgAverage;
@property (nonatomic, retain) NSNumber *guzzler;

@end
