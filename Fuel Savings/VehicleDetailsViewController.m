//
//  VehicleViewController.m
//  MPGDatabase
//
//  Created by Axel Rivera on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VehicleDetailsViewController.h"
#import "UIViewController+iAd.h"
#import "Fuel_SavingsAppDelegate.h"

static NSString * const yesStr = @"Yes";
static NSString * const noStr = @"No";

@interface VehicleDetailsViewController (Private)

- (void)fixTopToolbarView;
- (void)setupToolbarItems;

@end

@implementation VehicleDetailsViewController

@synthesize delegate = delegate_;
@synthesize contentView = contentView_;
@synthesize detailsTable = detailsTable_;
@synthesize topBarView = topBarView_;
@synthesize mpgDatabaseInfo = mpgDatabaseInfo_;
@synthesize selectedEfficiency = selectedEfficiency_;

- (id)init
{
	self = [super initWithNibName:@"VehicleDetailsViewController" bundle:nil];
	if (self) {
		mpgDatabaseInfo_ = nil;
		allowSelection_ = NO;
		selectedEfficiency_ = nil;
		selectedIndex_ = 0;
		efficiencyArray_ = nil;
		isAdBannerVisible_ = NO;
	}
	return self;
}

- (id)initWithInfo:(NSDictionary *)info
{
	return [self initWithInfo:info selection:NO];
}

- (id)initWithInfo:(NSDictionary *)info selection:(BOOL)selection
{
	self = [self init];
	if (self) {
		mpgDatabaseInfo_ = [info retain];
		allowSelection_ = selection;
		efficiencyArray_ = [[NSArray alloc] initWithObjects:
							[mpgDatabaseInfo_ objectForKey:@"mpgCity"],
							[mpgDatabaseInfo_ objectForKey:@"mpgHighway"],
							[mpgDatabaseInfo_ objectForKey:@"mpgAverage"],
							nil];
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
	[efficiencyArray_ release];
	[contentView_ release];
	[detailsTable_ release];
	[topBarView_ release];
	[mpgDatabaseInfo_ release];
	[selectedEfficiency_ release];
	[super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	if (self.navigationController) {
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
																	   style:UIBarButtonItemStyleBordered
																	  target:self
																	  action:@selector(backAction)];
		self.navigationItem.leftBarButtonItem = backButton;
		[backButton release];
	}
	
	if (self.tabBarController == nil) {
		[self setupToolbarItems];
		
		UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																					target:self
																					action:@selector(saveAction)];
		self.navigationItem.rightBarButtonItem = saveButton;
		[saveButton release];
		
		isAdBannerVisible_ = NO;
	} else {
		isAdBannerVisible_ = YES;
	}
	
	self.topBarView = [[[RLTopBarView alloc] initWithFrame:CGRectZero] autorelease];
	topBarView_.titleLabel.text = [mpgDatabaseInfo_ objectForKey:@"model"];
	[self.view addSubview:topBarView_];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.contentView = nil;
	self.detailsTable = nil;
	self.topBarView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self fixTopToolbarView];
	selectedIndex_ = [efficiencyArray_ count] - 1;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if (isAdBannerVisible_) {
		ADBannerView *adBanner = SharedAdBannerView;
		adBanner.delegate = self;
		[self.view addSubview:adBanner];
		[self layoutContentViewForCurrentOrientation:contentView_ animated:NO];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if (isAdBannerVisible_) {
		ADBannerView *adBanner = SharedAdBannerView;
		[self hideBannerView:contentView_ animated:NO];
		adBanner.delegate = ApplicationDelegate;
		if ([adBanner isDescendantOfView:self.view]) {
			[adBanner removeFromSuperview];
		}
	}
}

#pragma mark - Action Methods

- (void)backAction
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction
{
	[self.delegate vehicleDetailsViewControllerDidFinish:self save:YES];
}

- (void)cancelAction
{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Private Methods

- (void)fixTopToolbarView
{	
	CGRect viewFrame = self.view.frame;
	viewFrame.origin.y = topBarView_.frame.size.height;
	viewFrame.size.height = self.view.frame.size.height - topBarView_.frame.size.height;
	detailsTable_.frame = viewFrame;
}

- (void)setupToolbarItems
{
	[self.navigationController setToolbarHidden:NO];
	
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																				   target:nil
																				   action:nil];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				  target:self
																				  action:@selector(cancelAction)];
	
	NSArray *items = [[NSArray alloc] initWithObjects:flexibleSpace, cancelButton, nil];
	
	[self setToolbarItems:items];
	
	[flexibleSpace release];
	[cancelButton release];
	[items release];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = 0;
	if (section == 0) {
		rows = 3;
	} else {
		rows = 11;
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		NSString *CellIdentifier = @"EfficiencyCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
		}
		
		NSString *labelStr = nil;
		NSString *detailStr = nil;
		
		if (indexPath.row == 0) {
			labelStr = @"City";
			detailStr = [[self.mpgDatabaseInfo objectForKey:@"mpgCity"] stringValue];
		} else if (indexPath.row == 1) {
			labelStr = @"Highway";
			detailStr = [[self.mpgDatabaseInfo objectForKey:@"mpgHighway"] stringValue];
		} else {
			labelStr = @"Average";
			detailStr = [[self.mpgDatabaseInfo objectForKey:@"mpgAverage"] stringValue];
		}
		
		cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
		cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		if (allowSelection_) {
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			if (indexPath.row == selectedIndex_) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			}
		}
		
		cell.textLabel.text = labelStr;
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ MPG", detailStr];
		
		return cell;
	}
	
	NSString *CellIdentifier = @"DetailsCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSString *labelStr = nil;
	NSString *detailStr = nil;
	
	if (indexPath.row == 0) {
		labelStr = @"Year";
		detailStr = [[mpgDatabaseInfo_ objectForKey:@"year"] stringValue];
	} else if (indexPath.row == 1) {
		labelStr = @"Make";
		detailStr = [mpgDatabaseInfo_ objectForKey:@"make"];
	} else if (indexPath.row == 2) {
		labelStr = @"Class";
		detailStr = [mpgDatabaseInfo_ objectForKey:@"sizeClass"];
	} else if (indexPath.row == 3) {
		labelStr = @"Fuel";
		detailStr = [mpgDatabaseInfo_ objectForKey:@"fuel"];
	} else if (indexPath.row == 4) {
		labelStr = @"Engine Size";
		detailStr = [NSString stringWithFormat:@"%@ liters", [mpgDatabaseInfo_ objectForKey:@"engine"]];
	} else if (indexPath.row == 5) {
		labelStr = @"Cylinders";
		detailStr = [mpgDatabaseInfo_ objectForKey:@"cylinders"];
	} else if (indexPath.row == 6) {
		labelStr = @"Transmission";
		detailStr = [mpgDatabaseInfo_ objectForKey:@"transmission"];
	} else if (indexPath.row == 7) {
		labelStr = @"Drive";
		detailStr = [mpgDatabaseInfo_ objectForKey:@"drive"];
	} else if (indexPath.row == 8) {
		labelStr = @"Gas Guzzler";
		detailStr = noStr;
		if ([[mpgDatabaseInfo_ objectForKey:@"guzzler"] boolValue] == YES) {
			detailStr = yesStr;
		}
	} else if (indexPath.row == 9) {
		labelStr = @"Turbocharger";
		detailStr = noStr;
		if ([[mpgDatabaseInfo_ objectForKey:@"turbocharger"] boolValue] == YES) {
			detailStr = yesStr;
		}
	} else  {
		labelStr = @"Supercharger";
		detailStr = noStr;
		if ([[mpgDatabaseInfo_ objectForKey:@"supercharger"] boolValue] == YES) {
			detailStr = yesStr;
		}
	}
	
	cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.text = labelStr;
	cell.detailTextLabel.text = detailStr;
	
	return cell;
}

#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *titleStr = nil;
	if (section == 0) {
		titleStr = @"Fuel Efficiency";
	} else {
		titleStr = @"Details";
	}
	return titleStr;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSString *titleStr = nil;
	if (allowSelection_ && section == 0) {
		titleStr = @"Select one of the Fuel Efficiency options.";
	}
	return titleStr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!allowSelection_ || indexPath.section > 0) {
		return;
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSInteger localIndex = selectedIndex_;
	if (localIndex == indexPath.row) {
		return;
	}
	
	NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:localIndex inSection:indexPath.section];
	
	UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
	if (newCell.accessoryType == UITableViewCellAccessoryNone) {
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		selectedIndex_ = indexPath.row;
		self.selectedEfficiency = [efficiencyArray_ objectAtIndex:selectedIndex_];
	}
	
	UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
	if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
		oldCell.accessoryType = UITableViewCellAccessoryNone;
	}
}

#pragma mark - ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	[self layoutContentViewForCurrentOrientation:contentView_ animated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	[self layoutContentViewForCurrentOrientation:contentView_ animated:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	// Stop or Pause Stuff Here
	return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
	// Get things back up running again!
}

@end
