//
//  VehicleSelectViewController.m
//  MPGDatabase
//
//  Created by Axel Rivera on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VehicleSelectViewController.h"
#import "CurrentSavingsViewController.h"
#import "CurrentTripViewController.h"
#import "VehicleDetailsViewController.h"
#import "UIViewController+iAd.h"
#import "Fuel_SavingsAppDelegate.h"

@interface VehicleSelectViewController (Private)

- (void)setupToolbarItems;
- (void)setupDataSourceAndFetchRequest;
+ (NSDictionary *)fuelDescription;

@end

@implementation VehicleSelectViewController

static NSDictionary *fuelDescription;

@synthesize contentView = contentView_;
@synthesize selectionTable = selectionTable_;
@synthesize selectionType = selectionType_;
@synthesize year = year_;
@synthesize make = make_;
@synthesize mpgDatabaseInfo = mpgDatabaseInfo_;
@synthesize context = context_;
@synthesize currentSavingsViewController = currentSavingsViewController_;
@synthesize currentTripViewController = currentTripViewController_;

+ (NSDictionary *)fuelDescription
{
	if (fuelDescription == nil) {
		fuelDescription = [[NSDictionary alloc] initWithObjectsAndKeys:
						   @"Electric", @"Electricity",
						   @"Natural Gas", @"Compressed Natural Gas",
						   @"Diesel", @"Diesel",
						   @"Ethanol", @"Ethanol",
						   @"Regular", @"Regular Gasoline",
						   @"Mid Grade", @"Gasoline Mid Grade",
						   @"Premium", @"Premium Gasoline", nil];
	}
	return fuelDescription;
}

- (id)init
{
	self = [super initWithNibName:@"VehicleSelectViewController" bundle:nil];
	if (self) {
		self.selectionType = VehicleSelectionTypeYear;
		self.year = @"";
		self.make = @"";
		self.mpgDatabaseInfo = nil;
		self.context = nil;
		self.currentSavingsViewController = nil;
		self.currentTripViewController = nil;
		isAdBannerVisible_ = NO;
	}
	return self;
}

- (id)initWithTabBar
{
	self = [self init];
	if (self) {
		self.title = @"Database";
		self.tabBarItem.image = [UIImage imageNamed:@"mpg_tab.png"];
	}
	return self;
}

- (id)initWithType:(VehicleSelectionType)type year:(NSString *)year make:(NSString *)make
{
	self = [self init];
	if (self) {
		self.selectionType = type;
		self.year = year;
		self.make = make;
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
	[year_ release];
	[make_ release];
	[mpgDatabaseInfo_ release];
	[context_ release];
	[super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	if (self.tabBarController == nil) {
		[self setupToolbarItems];
		isAdBannerVisible_ = NO;
	} else {
		isAdBannerVisible_ = YES;
	}
	
	if (selectionType_ == VehicleSelectionTypeModel) {
		selectionTable_.rowHeight = 48.0;
	}
	
	[self setupDataSourceAndFetchRequest];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.contentView = nil;
	self.selectionTable = nil;
	self.mpgDatabaseInfo = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[selectionTable_ reloadData];
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

- (void)cancelAction
{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Private Methods

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
	
	CGRect contentFrame = self.view.bounds;
	CGPoint toolbarOrigin = CGPointMake(CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
	CGFloat toolbarHeight = self.navigationController.toolbar.bounds.size.height;
	
	contentFrame.size.height -= toolbarHeight;
	toolbarOrigin.y -= toolbarHeight;
	contentView_.frame = contentFrame;
	[contentView_ layoutIfNeeded];
}

- (void)setupDataSourceAndFetchRequest
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MPGDatabaseInfo" inManagedObjectContext:context_];
	
	[fetchRequest setEntity:entity];
	
	[fetchRequest setResultType:NSDictionaryResultType];
	
	NSString *titleStr = nil;
	
	if (self.selectionType == VehicleSelectionTypeYear) {
		NSDictionary *properties = [entity propertiesByName];
		NSPropertyDescription *yearProperty = [properties objectForKey:@"year"];
		
		[fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:yearProperty]];
		[fetchRequest setReturnsDistinctResults:YES];
		
		NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"year" ascending:NO];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
		
		titleStr = @"Select Year";
		[sort release];
	} else if (self.selectionType == VehicleSelectionTypeMake) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@", self.year];
		[fetchRequest setPredicate:predicate];
		
		NSDictionary *properties = [entity propertiesByName];
		NSPropertyDescription *makeProperty = [properties objectForKey:@"make"];
		
		[fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:makeProperty]];
		[fetchRequest setReturnsDistinctResults:YES];
		
		NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"make" ascending:YES];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
		[sort release];
		
		titleStr = self.year;
	} else {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND make == %@", self.year, self.make];
		[fetchRequest setPredicate:predicate];
		
		NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"model" ascending:YES];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
		
		titleStr = self.make;
		[sort release];
	}
	
	NSError *error;
	self.mpgDatabaseInfo = [self.context executeFetchRequest:fetchRequest error:&error];
	
	self.navigationItem.title = titleStr;
	
	[fetchRequest release];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.mpgDatabaseInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
	
	if (self.selectionType == VehicleSelectionTypeModel) {
		cellStyle = UITableViewCellStyleSubtitle;
	}
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSDictionary *info = [self.mpgDatabaseInfo objectAtIndex:indexPath.row];
	
	NSString *labelStr = nil;
	NSString *detailStr = nil;
	
	UIFont *textLabelFont = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	
	if (self.selectionType == VehicleSelectionTypeYear) {
		labelStr = [[info objectForKey:@"year"] stringValue];
	} else if (self.selectionType == VehicleSelectionTypeMake) {
		labelStr = [info objectForKey:@"make"];
	} else {
		labelStr = [info objectForKey:@"model"];
		
		NSString *cylindersLabel = @"N/A Cyl";
		if (![[info objectForKey:@"cylinders"] isEqualToString:@""]) {
			cylindersLabel = [NSString stringWithFormat:@"%@ Cyl", [info objectForKey:@"cylinders"]];
		}
		
		NSString *engineLabel = @", N/A L";
		if (![[info objectForKey:@"engine"] isEqualToString:@""]) {
			engineLabel = [NSString stringWithFormat:@", %@ L", [info objectForKey:@"engine"]];
		}
		
		NSString *transmissionLabel = @"";
		if (![[info objectForKey:@"transmission"] isEqualToString:@""]) {
			transmissionLabel = [NSString stringWithFormat:@", %@", [info objectForKey:@"transmission"]];
		}
		
		NSString *description = [[[self class] fuelDescription] objectForKey:[info objectForKey:@"fuel"]];
		NSString *gasolineLabel = @"";
		if (description != nil) {
			gasolineLabel = [NSString stringWithFormat:@", %@", description];
		}
		
		detailStr = [NSString stringWithFormat:@"%@%@%@%@", cylindersLabel, engineLabel, transmissionLabel, gasolineLabel];
		
		textLabelFont = [UIFont systemFontOfSize:16.0];
	}
	
	cell.textLabel.font = textLabelFont;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = labelStr;
	
	if (detailStr) {
		cell.detailTextLabel.text = detailStr;
	}
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSDictionary *info = [self.mpgDatabaseInfo objectAtIndex:indexPath.row];
	UIViewController *viewController = nil;
	
	if (self.selectionType == VehicleSelectionTypeYear) {
		NSString *yearStr = [[info objectForKey:@"year"] stringValue];
		VehicleSelectViewController *selectController = [[VehicleSelectViewController alloc] initWithType:VehicleSelectionTypeMake
																									 year:yearStr
																									 make:nil];
		selectController.context = self.context;
		selectController.currentSavingsViewController = self.currentSavingsViewController;
		selectController.currentTripViewController = self.currentTripViewController;
		viewController = selectController;
	} else if (self.selectionType == VehicleSelectionTypeMake) {
		NSString *yearStr = self.year;
		NSString *makeStr = [info objectForKey:@"make"];
		VehicleSelectViewController *selectController = [[VehicleSelectViewController alloc] initWithType:VehicleSelectionTypeModel
																									 year:yearStr
																									 make:makeStr];
		selectController.context = self.context;
		selectController.currentSavingsViewController = self.currentSavingsViewController;
		selectController.currentTripViewController = self.currentTripViewController;
		viewController = selectController;
	} else {
		BOOL allowSelection = NO;
		if (self.currentTripViewController) {
			allowSelection = YES;
		}
		
		VehicleDetailsViewController *detailsController = [[VehicleDetailsViewController alloc] initWithInfo:info
																								   selection:allowSelection];
		detailsController.title = [NSString stringWithFormat:@"%@ %@", [info objectForKey:@"year"], [info objectForKey:@"make"]];
		
		if (self.currentSavingsViewController) {
			detailsController.delegate = self.currentSavingsViewController;
		}
		
		if (self.currentTripViewController) {
			detailsController.delegate = self.currentTripViewController;
		}
		
		viewController = detailsController;
	}
	
	if (viewController) {
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
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
