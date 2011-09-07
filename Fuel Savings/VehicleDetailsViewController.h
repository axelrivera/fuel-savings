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

@interface VehicleDetailsViewController : UIViewController {
	BOOL allowSelection_;
	NSInteger selectedIndex_;
	NSArray *efficiencyArray_;
}

@property (nonatomic, assign) id <VehicleDetailsViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *detailsTable;
@property (nonatomic, retain) RLTopBarView *topBarView;
@property (nonatomic, retain) NSDictionary *mpgDatabaseInfo;
@property (nonatomic, retain) NSNumber *selectedEfficiency;

- (id)initWithInfo:(NSDictionary *)info;
- (id)initWithInfo:(NSDictionary *)info selection:(BOOL)selection;

@end

@protocol VehicleDetailsViewControllerDelegate

- (void)vehicleDetailsViewControllerDidFinish:(VehicleDetailsViewController *)controller save:(BOOL)save;

@end
