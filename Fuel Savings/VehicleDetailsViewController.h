//
//  VehicleViewController.h
//  MPGDatabase
//
//  Created by Axel Rivera on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehicleDetailsViewController : UITableViewController

@property (nonatomic, retain) NSDictionary *mpgDatabaseInfo;

- (id)initWithInfo:(NSDictionary *)info;

@end
