//
//  VehicleViewController.h
//  MPGDatabase
//
//  Created by Axel Rivera on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VehicleDetailsViewControllerDelegate;

@interface VehicleDetailsViewController : UITableViewController

@property (nonatomic, assign) id <VehicleDetailsViewControllerDelegate> delegate;
@property (nonatomic, retain) NSDictionary *mpgDatabaseInfo;

- (id)initWithInfo:(NSDictionary *)info;

@end

@protocol VehicleDetailsViewControllerDelegate

- (void)vehicleDetailsViewControllerDidFinish:(VehicleDetailsViewController *)controller save:(BOOL)save;

@end
