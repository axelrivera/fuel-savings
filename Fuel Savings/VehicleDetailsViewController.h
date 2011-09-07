//
//  VehicleViewController.h
//  MPGDatabase
//
//  Created by Axel Rivera on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLTopBarView.h"

@protocol VehicleDetailsViewControllerDelegate;

@interface VehicleDetailsViewController : UIViewController

@property (nonatomic, assign) id <VehicleDetailsViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *detailsTable;
@property (nonatomic, retain) RLTopBarView *topBarView;
@property (nonatomic, retain) NSDictionary *mpgDatabaseInfo;

- (id)initWithInfo:(NSDictionary *)info;

@end

@protocol VehicleDetailsViewControllerDelegate

- (void)vehicleDetailsViewControllerDidFinish:(VehicleDetailsViewController *)controller save:(BOOL)save;

@end
