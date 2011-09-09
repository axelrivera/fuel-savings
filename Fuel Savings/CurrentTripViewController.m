//
//  CurrentTripViewController.m
//  Fuel Savings
//
//  Created by arn on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrentTripViewController.h"
#import "NSDictionary+Section.h"
#import "VehicleSelectViewController.h"
#import "Fuel_SavingsAppDelegate.h"
#import "Settings.h"
#import "UIViewController+iAd.h"
#import "Fuel_SavingsAppDelegate.h"

static NSString * const tripNameKey = @"TripNameKey";
static NSString * const distanceKey = @"DistanceKey";

static NSString * const vehicleKey = @"VehicleKey";
static NSString * const vehicleNameKey = @"VehicleNameKey";
static NSString * const vehicleFuelPriceKey = @"VehicleFuelPriceKey";
static NSString * const vehicleAvgEfficiencyKey = @"VehicleAvgEfficiencyKey";

@interface CurrentTripViewController (Private)

- (NSArray *)informationArray;
- (NSArray *)vehicleArray;

- (BOOL)validateControllerData;
- (void)displayErrorWithMessage:(NSString *)message;

@end

@implementation CurrentTripViewController

@synthesize delegate = delegate_;
@synthesize currentTrip = currentTrip_;
@synthesize contentView = contentView_;
@synthesize newTable = newTable_;
@synthesize newData = newData_;
@synthesize isEditingTrip = isEditingTrip_;

- (id)init
{
	self = [super initWithNibName:@"CurrentTripViewController" bundle:nil];
	if (self) {
		currentTrip_ = nil;
	}
	return self;
}

- (id)initWithTrip:(Trip *)trip
{
	self = [self init];
	if (self) {
		currentTrip_ = [trip retain];
	}
	return self;
}

- (void)dealloc
{
	[currentTrip_ release];
	[contentView_ release];
	[newTable_ release];
	[newData_ release];
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.contentView.tag = kAdContentViewTag;
	
 	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				  target:self
																				  action:@selector(dismissAction)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																				target:self
																				action:@selector(saveAction)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.contentView = nil;
	self.newTable = nil;
	self.newData = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (self.isEditingTrip) {
		self.title = @"Edit Trip";
	} else {
		self.title = @"New Trip";
	}
	
	ADBannerView *adBanner = SharedAdBannerView;
	adBanner.delegate = self;
	[self layoutCurrentOrientation:NO];
	
	self.newData = [NSMutableArray arrayWithCapacity:0];
	
	[newData_ addObject:[self informationArray]];
	[newData_ addObject:[self vehicleArray]];
	
	[newTable_ reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	ADBannerView *adBanner = SharedAdBannerView;
	adBanner.delegate = nil;
}

#pragma mark - Custom Actions

- (void)saveAction
{
	if (![self validateControllerData]) {
		[self displayErrorWithMessage:@"Error. You should select the fuel efficiency for My Car."];
		return;
	}
	[self.delegate currentTripViewControllerDelegateDidFinish:self save:YES];
}

- (void)dismissAction
{
	[self.delegate currentTripViewControllerDelegateDidFinish:self save:NO];
}

- (void)selectCarAction
{
	VehicleSelectViewController *inputViewController = [[VehicleSelectViewController alloc] init];
	Fuel_SavingsAppDelegate *appDelegate = (Fuel_SavingsAppDelegate *)[[UIApplication sharedApplication] delegate];
	inputViewController.context = [appDelegate.coreDataObject managedObjectContext];
	inputViewController.currentTripViewController = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:inputViewController];
	
	[self presentModalViewController:navController animated:YES];
	
	[inputViewController release];
	[navController release];
}

#pragma mark - Private Methods

- (NSArray *)informationArray
{	
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
	
	NSDictionary *dictionary = nil;
	
	dictionary = [NSDictionary textDictionaryWithKey:tripNameKey
												text:@"Trip Name"
											  detail:[self.currentTrip stringForName]];
	
	[array addObject:dictionary];
	
	dictionary = [NSDictionary textDictionaryWithKey:distanceKey
												text:@"Distance"
											  detail:[self.currentTrip stringForDistance]];
	[array addObject:dictionary];
	
	return array;
}

- (NSArray *)vehicleArray
{	
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
	
	NSDictionary *dictionary = nil;
	
	dictionary = [NSDictionary buttonDictionaryWithKey:vehicleKey
												  text:@"My Car"];
	
	UIButton *button = [dictionary objectForKey:dictionaryButtonKey];
	[button addTarget:self action:@selector(selectCarAction) forControlEvents:UIControlEventTouchDown];
	
	[array addObject:dictionary];
	
	dictionary = [NSDictionary textDictionaryWithKey:vehicleNameKey
												text:@"Name"
											  detail:[self.currentTrip.vehicle stringForName]];
	[array addObject:dictionary];
	
	dictionary = [NSDictionary textDictionaryWithKey:vehicleFuelPriceKey
												text:@"Fuel Price"
											  detail:[self.currentTrip.vehicle stringForFuelPrice]];
	[array addObject:dictionary];
	
	NSString *efficiencyStr = @"required";
	if ([self.currentTrip.vehicle.avgEfficiency integerValue] > 0) {
		efficiencyStr = [self.currentTrip.vehicle stringForAvgEfficiency];
	}
	
	dictionary = [NSDictionary textDictionaryWithKey:vehicleAvgEfficiencyKey
												text:@"Fuel Efficiency"
											  detail:efficiencyStr];
	[array addObject:dictionary];
	
	return array;
}

- (BOOL)validateControllerData
{
	if ([self.currentTrip.vehicle.avgEfficiency integerValue] < 1) {
		return NO;
	}
	return YES;
}

- (void)displayErrorWithMessage:(NSString *)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
													message:message
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles: nil];
	[alert show];	
	[alert release];
}

#pragma mark - UIViewController Delegates

- (void)priceInputViewControllerDidFinish:(PriceInputViewController *)controller save:(BOOL)save
{
	if (save) {
		self.currentTrip.vehicle.fuelPrice = controller.currentPrice;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)distanceInputViewControllerDidFinish:(DistanceInputViewController *)controller save:(BOOL)save
{
	if (save) {
		self.currentTrip.distance = controller.currentDistance;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)nameInputViewControllerDidFinish:(NameInputViewController *)controller save:(BOOL)save
{
	if (save) {
		if ([controller.key isEqualToString:tripNameKey]) {
			self.currentTrip.name = controller.currentName;
		} else {
			self.currentTrip.vehicle.name = controller.currentName;
		}
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)efficiencyInputViewControllerDidFinish:(EfficiencyInputViewController *)controller save:(BOOL)save
{
	if (save) {
		self.currentTrip.vehicle.avgEfficiency = controller.currentEfficiency;
		self.currentTrip.vehicle.cityEfficiency = controller.currentEfficiency;
		self.currentTrip.vehicle.highwayEfficiency = controller.currentEfficiency;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)vehicleDetailsViewControllerDidFinish:(VehicleDetailsViewController *)controller save:(BOOL)save
{
	if (save) {
		NSDictionary *info = controller.mpgDatabaseInfo;
		self.currentTrip.vehicle.name = [NSString stringWithFormat:@"%@ %@",
										 [info objectForKey:@"year"],
										 [info objectForKey:@"model"]];
		
		NSNumber *number = nil;
		if (controller.selectedEfficiency) {
			number = controller.selectedEfficiency;
		} else {
			number = [info objectForKey:@"mpgAverage"];
		}
		
		self.currentTrip.vehicle.avgEfficiency = number;
		self.currentTrip.vehicle.cityEfficiency = number;
		self.currentTrip.vehicle.highwayEfficiency = number;
	}
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger sections = [newData_ count];
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = [[newData_ objectAtIndex:section] count]; 
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *dictionary = [[newData_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	if (indexPath.section > 0 && indexPath.row == 0) {
		static NSString *TitleCellIdentifier = @"TitleCell";
		
		UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:TitleCellIdentifier];
		
		if (titleCell == nil) {
			titleCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TitleCellIdentifier] autorelease];
		}
		
		titleCell.accessoryView = [dictionary objectForKey:dictionaryButtonKey];
		titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		titleCell.textLabel.textColor = [UIColor colorWithRed:57.0/255.0 green:85.0/255.0 blue:135.0/255.0 alpha:1.0];
		
		titleCell.textLabel.text = [dictionary objectForKey:dictionaryTextKey];
		
		return titleCell;
	}
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
	
	NSString *textLabelStr = [dictionary objectForKey:dictionaryTextKey];
	NSString *detailTextStr = [dictionary objectForKey:dictionaryDetailKey];
	
	UIColor *textColor = [UIColor blackColor];
	UIColor *detailTextColor = [UIColor colorWithRed:57.0/255.0 green:85.0/255.0 blue:135.0/255.0 alpha:1.0];
	
	if ([detailTextStr isEqualToString:@"required"]) {
		textColor = [UIColor redColor];
		detailTextColor = [UIColor redColor];
		
	}
	
	cell.textLabel.textColor = textColor;
	cell.detailTextLabel.textColor = detailTextColor;
	
	cell.textLabel.text = textLabelStr;
	cell.detailTextLabel.text = detailTextStr;
	
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIViewController *viewController = nil;
	
	NSDictionary *dictionary = [[newData_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	NSString *key = [dictionary objectForKey:dictionaryKey];
	
	if (indexPath.section == 0) {
		if ([key isEqualToString:tripNameKey]) {
			NameInputViewController *inputViewController = [[NameInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentName = self.currentTrip.name;
			inputViewController.key = tripNameKey;
			inputViewController.footerText = @"Enter a Name for the Trip.";
			
			UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:inputViewController];
			[inputViewController release];
			
			[self presentModalViewController:navController animated:YES];
			[navController release];
			
			return;
		} else {
			DistanceInputViewController *inputViewController = [[DistanceInputViewController alloc] initWithType:DistanceInputTypeTrip];
			inputViewController.delegate = self;
			inputViewController.currentDistance = self.currentTrip.distance;
			inputViewController.distanceSuffix = @"miles";
			inputViewController.footerText = @"On average, how much will you drive?";
			viewController = inputViewController;
		}
	} else {
		if ([key isEqualToString:vehicleNameKey]) {
			NameInputViewController *nameViewController = [[NameInputViewController alloc] init];
			nameViewController.delegate = self;
			nameViewController.currentName = self.currentTrip.vehicle.name;
			nameViewController.footerText = @"Enter the Vehicle Name.";
			
			UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:nameViewController];
			[nameViewController release];
			
			[self presentModalViewController:navController animated:YES];
			[navController release];
			
			return;
		}
		
		if ([key isEqualToString:vehicleFuelPriceKey]) {
			PriceInputViewController *inputViewController = [[PriceInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentPrice = self.currentTrip.vehicle.fuelPrice;
			
			NSString *unitStr = kVolumeUnitsGallonKey;
			if ([self.currentTrip.country isEqualToString:kCountriesAvailablePuertoRico]) {
				unitStr = kVolumeUnitsLiterKey;
			}
			inputViewController.footerText = [NSString stringWithFormat:@"Enter the Price per %@ of fuel.", unitStr];
			viewController = inputViewController;
		} else if ([key isEqualToString:vehicleAvgEfficiencyKey]) {
			EfficiencyInputViewController *inputViewController = [[EfficiencyInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentEfficiency = self.currentTrip.vehicle.avgEfficiency;
			inputViewController.currentType	= EfficiencyInputTypeAverage;
			inputViewController.footerText = @"Fuel Efficiency in MPG.";
			viewController = inputViewController;
		}
	}
	
	if (viewController) {
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
}

#pragma mark - ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	[self layoutCurrentOrientation:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	[self layoutCurrentOrientation:YES];
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
