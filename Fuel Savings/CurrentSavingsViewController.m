//
//  CurrentSavingsViewController.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrentSavingsViewController.h"
#import "NSMutableArray+Vehicle.h"
#import "NSDictionary+Section.h"
#import "RLCustomButton+Default.h"
#import "UIViewController+iAd.h"
#import "Fuel_SavingsAppDelegate.h"

static NSString * const typeKey = @"TypeKey";
static NSString * const fuelPriceKey = @"PriceKey";
static NSString * const distanceKey = @"DistanceKey";
static NSString * const carOwnershipKey = @"CarOwnershipKey";

static NSString * const vehicle1Key = @"Vehicle1Key";
static NSString * const vehicle2Key = @"Vehicle2Key";

static NSString * const vehicleNameKey = @"VehicleNameKey";
static NSString * const vehicleFuelPriceKey = @"VehicleFuelPriceKey";
static NSString * const vehicleAvgEfficiencyKey = @"VehicleAvgEfficiencyKey";
static NSString * const vehicleCityEfficiencyKey = @"VehicleCityEfficiencyKey";
static NSString * const vehicleHighwayEfficiencyKey = @"VehicleHighwayEfficiencyKey";

@interface CurrentSavingsViewController (Private)

- (void)reloadTableData;

- (NSArray *)informationArray;
- (NSArray *)vehicleArrayWithKey:(NSString *)key;

- (BOOL)validateControllerData;
- (void)displayErrorWithMessage:(NSString *)message;

@end

@implementation CurrentSavingsViewController

@synthesize delegate = delegate_;
@synthesize currentSavings = currentSavings_;
@synthesize contentView = contentView_;
@synthesize newTable = newTable_;
@synthesize newData = newData_;
@synthesize isEditingSavings = isEditingSavings_;

- (id)init
{
	self = [super initWithNibName:@"CurrentSavingsViewController" bundle:nil];
	if (self) {
		self.currentSavings = nil;
		isCar1Selected_ = NO;
		isCar2Selected_ = NO;
	}
	return self;
}

- (id)initWithSavings:(Savings *)savings
{
	self = [self init];
	if (self) {
		self.currentSavings = savings;
	}
	return self;
}

- (void)dealloc
{
	[currentSavings_ release];
	[contentView_ release];
	[newData_ release];
	[newTable_ release];
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
	
	newTable_.sectionHeaderHeight = 10.0;
	newTable_.sectionFooterHeight = 10.0;
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
	
	if (self.isEditingSavings) {
		self.title = @"Edit Savings";
	} else {
		self.title = @"New Savings";
	}
	
	ADBannerView *adBanner = SharedAdBannerView;
	adBanner.delegate = self;
	[self layoutCurrentOrientation:NO];
	
	if (self.currentSavings) {
		[self reloadTableData];
	}
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
		[self displayErrorWithMessage:@"Error. You should select the fuel efficiency for the shown cars."];
		return;
	}
	[self.delegate currentSavingsViewControllerDelegateDidFinish:self save:YES];
}

- (void)dismissAction
{
	[self.delegate currentSavingsViewControllerDelegateDidFinish:self save:NO];
}

- (void)selectCar1Action
{
	isCar1Selected_ = YES;
	isCar2Selected_ = NO;
	[self performSelector:@selector(selectCarAction)];
}

- (void)selectCar2Action
{
	isCar1Selected_ = NO;
	isCar2Selected_ = YES;
	[self performSelector:@selector(selectCarAction)];
}

- (void)selectCarAction
{
	VehicleSelectViewController *inputViewController = [[VehicleSelectViewController alloc] init];
	Fuel_SavingsAppDelegate *appDelegate = (Fuel_SavingsAppDelegate *)[[UIApplication sharedApplication] delegate];
	inputViewController.context = [appDelegate.coreDataObject managedObjectContext];
	inputViewController.currentSavingsViewController = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:inputViewController];
	
	[self presentModalViewController:navController animated:YES];
	
	[inputViewController release];
	[navController release];
}

- (void)resetCar2Action
{
	self.currentSavings.vehicle2.name = kSavingsVehicle2DefaultName;
	self.currentSavings.vehicle2.avgEfficiency = [NSNumber numberWithInteger:0];
	self.currentSavings.vehicle2.cityEfficiency = [NSNumber numberWithInteger:0];
	self.currentSavings.vehicle2.highwayEfficiency = [NSNumber numberWithInteger:0];
	self.currentSavings.vehicle2.fuelPrice = [self.currentSavings.vehicle2 defaultPrice];
	[self reloadTableData];
	[newTable_ reloadData];
}

- (void)resetCar2OptionsAction:(id)sender {
	// open a dialog with two custom buttons	
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"Reset Car 2 to its default settings."
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:@"Reset Car 2"
								  otherButtonTitles:nil];
	
	[actionSheet showInView:self.view];
	[actionSheet release];	
}

#pragma mark - Private Methods

- (void)reloadTableData
{
	NSArray *informationArray = [[self informationArray] retain];
	NSArray *vehicle1Array = [[self vehicleArrayWithKey:vehicle1Key] retain]; 
	NSArray *vehicle2Array = [[self vehicleArrayWithKey:vehicle2Key] retain];
	
	self.newData = [NSMutableArray arrayWithCapacity:0];
	
	[newData_ addObject:informationArray];
	[newData_ addObject:vehicle1Array];
	[newData_ addObject:vehicle2Array];
	
	[informationArray release];
	[vehicle1Array release];
	[vehicle2Array release];
}

- (NSArray *)informationArray
{	
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
	
	NSDictionary *dictionary = nil;
	
	NSString *typeStr = [NSString stringWithString:[self.currentSavings stringForCurrentType]];
	dictionary = [NSDictionary textDictionaryWithKey:typeKey text:@"Using" detail:typeStr];
	[array addObject:dictionary];
	
	dictionary = [NSDictionary textDictionaryWithKey:distanceKey
												text:@"Distance"
											  detail:[self.currentSavings stringForDistance]];
	[array addObject:dictionary];
	
	dictionary = [NSDictionary textDictionaryWithKey:carOwnershipKey
												text:@"Ownership"
											  detail:[self.currentSavings stringForCarOwnership]];
	[array addObject:dictionary];
	
	return array;
}

- (NSArray *)vehicleArrayWithKey:(NSString *)key
{
	Vehicle *vehicle = nil;
	NSString *titleText = nil;
	NSString *emptyStr = @"required";
	SEL titleSelector;
	
	if ([key isEqualToString:vehicle1Key]) {
		vehicle = self.currentSavings.vehicle1;
		titleText = kSavingsVehicle1DefaultName;
		titleSelector = @selector(selectCar1Action);
	} else {
		vehicle = self.currentSavings.vehicle2;
		titleText = kSavingsVehicle2DefaultName;
		titleSelector = @selector(selectCar2Action);
		emptyStr = @"optional";
	}
	
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
	
	NSDictionary *dictionary = nil;
	
	dictionary = [NSDictionary buttonDictionaryWithKey:key
												  text:titleText];
	
	UIButton *button = [dictionary objectForKey:dictionaryButtonKey];
	[button addTarget:self action:titleSelector forControlEvents:UIControlEventTouchDown];
	
	[array addObject:dictionary];
	
	dictionary = [NSDictionary textDictionaryWithKey:vehicleNameKey
												text:@"Name"
											  detail:[vehicle stringForName]];
	[array addObject:dictionary];
	
	dictionary = [NSDictionary textDictionaryWithKey:vehicleFuelPriceKey
												text:@"Fuel Price"
											  detail:[vehicle stringForFuelPrice]];
	[array addObject:dictionary];
	
	if (self.currentSavings.type == EfficiencyTypeAverage) {
		NSString *avgEfficiencyStr = emptyStr;
		if ([vehicle.avgEfficiency integerValue] > 0) {
			avgEfficiencyStr = [vehicle stringForAvgEfficiency];
		}
		dictionary = [NSDictionary textDictionaryWithKey:vehicleAvgEfficiencyKey
													text:@"Average MPG"
												  detail:avgEfficiencyStr];
		[array addObject:dictionary];
	} else {
		NSString *cityEfficiencyStr = emptyStr;
		NSString *highwayEfficiencyStr = emptyStr;
		
		NSInteger cityValue = [vehicle.cityEfficiency integerValue];
		NSInteger highwayValue = [vehicle.highwayEfficiency integerValue];
		
		if (cityValue == 0 && highwayValue > 0) {
			cityEfficiencyStr = @"required";
		} else if (cityValue > 0 & highwayValue == 0) {
			highwayEfficiencyStr = @"required";
		}
		
		if (cityValue > 0) {
			cityEfficiencyStr = [vehicle stringForCityEfficiency];
		}
		dictionary = [NSDictionary textDictionaryWithKey:vehicleCityEfficiencyKey
													text:@"City MPG"
												  detail:cityEfficiencyStr];
		[array addObject:dictionary];
		
		
		if (highwayValue > 0) {
			highwayEfficiencyStr = [vehicle stringForHighwayEfficiency];
		}
		dictionary = [NSDictionary textDictionaryWithKey:vehicleHighwayEfficiencyKey
													text:@"Highway MPG"
												  detail:highwayEfficiencyStr];
		[array addObject:dictionary];
	}
	
	return array;
}

- (BOOL)validateControllerData
{
	if (self.currentSavings.type == EfficiencyInputTypeAverage) {
		if ([self.currentSavings.vehicle1.avgEfficiency integerValue] > 0) {
			return YES;
		}
		return NO;
	}
	
	BOOL isVehicle1Ready = NO;
	BOOL isVehicle2Ready = NO;
	
	NSInteger vehicle1CityValue = [self.currentSavings.vehicle1.cityEfficiency integerValue];
	NSInteger vehicle1HighwayValue = [self.currentSavings.vehicle1.highwayEfficiency integerValue];
	NSInteger vehicle2CityValue = [self.currentSavings.vehicle2.cityEfficiency integerValue];
	NSInteger vehicle2HighwayValue = [self.currentSavings.vehicle2.highwayEfficiency integerValue];
	
	if (vehicle1CityValue == 0 && vehicle1HighwayValue > 0) {
		isVehicle1Ready = NO;
	} else if (vehicle1CityValue > 0 && vehicle1HighwayValue == 0) {
		isVehicle1Ready = NO;
	} else {
		isVehicle1Ready = YES;
	}
	
	if (vehicle2CityValue == 0 && vehicle2HighwayValue > 0) {
		isVehicle2Ready = NO;
	} else if (vehicle2CityValue > 0 && vehicle2HighwayValue == 0) {
		isVehicle2Ready = NO;
	} else {
		isVehicle2Ready = YES;
	}
	
	if (isVehicle1Ready && isVehicle2Ready) {
		return YES;
	}
	return NO;
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

#pragma mark - View Controller Delegates

- (void)typeInputViewControllerDidFinish:(TypeInputViewController *)controller save:(BOOL)save
{
	if (save) {
		self.currentSavings.type = controller.currentType;
		self.currentSavings.cityRatio = controller.currentCityRatio;
		self.currentSavings.highwayRatio = controller.currentHighwayRatio;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)priceInputViewControllerDidFinish:(PriceInputViewController *)controller save:(BOOL)save
{
	if (save) {
		Vehicle *vehicle = nil;
		if ([controller.key isEqualToString:vehicle1Key]) {
			vehicle = self.currentSavings.vehicle1;
		} else {
			vehicle = self.currentSavings.vehicle2;
		}
		vehicle.fuelPrice = controller.currentPrice;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)distanceInputViewControllerDidFinish:(DistanceInputViewController *)controller save:(BOOL)save
{
	if (save) {
		self.currentSavings.distance = controller.currentDistance;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)ownerInputViewControllerDidFinish:(OwnerInputViewController *)controller save:(BOOL)save
{
	if (save) {
		self.currentSavings.carOwnership = controller.currentOwnership;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)nameInputViewControllerDidFinish:(NameInputViewController *)controller save:(BOOL)save
{	
	if (save) {
		Vehicle *vehicle = nil;
		if ([controller.key isEqualToString:vehicle1Key]) {
			vehicle = self.currentSavings.vehicle1;
		} else {
			vehicle = self.currentSavings.vehicle2;
		}
		vehicle.name = controller.currentName;
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)efficiencyInputViewControllerDidFinish:(EfficiencyInputViewController *)controller save:(BOOL)save
{
	if (save) {
		Vehicle *vehicle = nil;
		if ([controller.key isEqualToString:vehicle1Key]) {
			vehicle = self.currentSavings.vehicle1;
		} else {
			vehicle = self.currentSavings.vehicle2;
		}
		
		if (controller.currentType == EfficiencyInputTypeAverage) {
			vehicle.avgEfficiency = controller.currentEfficiency;
			vehicle.cityEfficiency = vehicle.avgEfficiency;
			vehicle.highwayEfficiency = vehicle.avgEfficiency;
		} else {
			if (controller.currentType == EfficiencyInputTypeCity) {
				vehicle.cityEfficiency = controller.currentEfficiency;
			} else {
				vehicle.highwayEfficiency = controller.currentEfficiency;
			}
			NSInteger average = ([vehicle.cityEfficiency integerValue] + [vehicle.highwayEfficiency integerValue]) / 2;
			vehicle.avgEfficiency = [NSNumber numberWithInteger:average];
		}
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)vehicleDetailsViewControllerDidFinish:(VehicleDetailsViewController *)controller save:(BOOL)save
{
	if (save) {
		NSDictionary *info = controller.mpgDatabaseInfo;
		if (isCar1Selected_ == YES) {
			self.currentSavings.vehicle1.name = [NSString stringWithFormat:@"%@ %@",
												 [info objectForKey:@"year"],
												 [info objectForKey:@"model"]];
			self.currentSavings.vehicle1.avgEfficiency = [info objectForKey:@"mpgAverage"];
			self.currentSavings.vehicle1.cityEfficiency = [info objectForKey:@"mpgCity"];
			self.currentSavings.vehicle1.highwayEfficiency = [info	objectForKey:@"mpgHighway"];
		} else {
			self.currentSavings.vehicle2.name = [NSString stringWithFormat:@"%@ %@",
												 [info objectForKey:@"year"],
												 [info objectForKey:@"model"]];
			self.currentSavings.vehicle2.avgEfficiency = [info objectForKey:@"mpgAverage"];
			self.currentSavings.vehicle2.cityEfficiency = [info objectForKey:@"mpgCity"];
			self.currentSavings.vehicle2.highwayEfficiency = [info	objectForKey:@"mpgHighway"];
		}
	}
	isCar1Selected_ = NO;
	isCar2Selected_ = NO;
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [newData_ count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[newData_ objectAtIndex:section] count];
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

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIViewController *viewController = nil;
	
	NSDictionary *dictionary = [[newData_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	NSString *key = [dictionary objectForKey:dictionaryKey];
	
	if (indexPath.section == 0) {
		if ([key isEqualToString:typeKey]) {
			TypeInputViewController *inputViewController = [[TypeInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentType = self.currentSavings.type;
			inputViewController.currentCityRatio = self.currentSavings.cityRatio;
			inputViewController.currentHighwayRatio = self.currentSavings.highwayRatio;
			viewController = inputViewController;
		} else if ([key isEqualToString:distanceKey]) {
			DistanceInputViewController *inputViewController = [[DistanceInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentDistance = self.currentSavings.distance;
			inputViewController.distanceSuffix = @"miles/year";
			inputViewController.footerText = @"On average, how much do you drive your car every year?";
			viewController = inputViewController;
		} else {
			OwnerInputViewController *inputViewController = [[OwnerInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentOwnership = self.currentSavings.carOwnership;
			inputViewController.footerText = @"How long do you plan to own your car?";
			viewController = inputViewController;
		}
	} else {
		Vehicle *vehicle = nil;
		NSString *vehicleKey = nil;
		if (indexPath.section == 1) {
			vehicle = self.currentSavings.vehicle1;
			vehicleKey = vehicle1Key;
		} else {
			vehicle = self.currentSavings.vehicle2;
			vehicleKey = vehicle2Key;
		}
		
		if ([key isEqualToString:vehicleNameKey]) {
			NameInputViewController *nameViewController = [[NameInputViewController alloc] init];
			nameViewController.delegate = self;
			nameViewController.key = vehicleKey;
			nameViewController.footerText = @"Enter the Vehicle Name.";
			nameViewController.currentName = vehicle.name;
			
			UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:nameViewController];
			[nameViewController release];
			
			[self presentModalViewController:navController animated:YES];
			[navController release];
			
			return;
		}
		
		if ([key isEqualToString:vehicleFuelPriceKey]) {
			PriceInputViewController *inputViewController = [[PriceInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentPrice = vehicle.fuelPrice;
			inputViewController.key = vehicleKey;
			
			NSString *unitStr = kVolumeUnitsGallonKey;
			if ([self.currentSavings.country isEqualToString:kCountriesAvailablePuertoRico]) {
				unitStr = kVolumeUnitsLiterKey;
			}
			inputViewController.footerText = [NSString stringWithFormat:@"Enter the Price per %@ of fuel.", unitStr];
			viewController = inputViewController;
		} else if ([key isEqualToString:vehicleAvgEfficiencyKey]) {
			EfficiencyInputViewController *inputViewController = [[EfficiencyInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.key = vehicleKey;
			inputViewController.currentEfficiency = vehicle.avgEfficiency;
			inputViewController.currentType = EfficiencyInputTypeAverage;
			inputViewController.footerText = @"Average Fuel Efficiency in MPG.";
			viewController = inputViewController;
		} else if ([key isEqualToString:vehicleCityEfficiencyKey]) {
			EfficiencyInputViewController *inputViewController = [[EfficiencyInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.key = vehicleKey;
			inputViewController.currentEfficiency = vehicle.cityEfficiency;
			inputViewController.currentType = EfficiencyInputTypeCity;
			inputViewController.footerText = @"City Fuel Efficiency in MPG.";
			viewController = inputViewController;
		} else if ([key isEqualToString:vehicleHighwayEfficiencyKey]) {
			EfficiencyInputViewController *inputViewController = [[EfficiencyInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.key = vehicleKey;
			inputViewController.currentEfficiency = vehicle.highwayEfficiency;
			inputViewController.currentType = EfficiencyInputTypeHighway;
			inputViewController.footerText = @"Highway Fuel Efficiency in MPG.";
			viewController = inputViewController;
		}
	}
	
	if (viewController) {
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 2) {
		return @"Optional";
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	CGFloat height = 10.0;
	if (section == 0) {
		height = 24.0;
	} else if (section == 2) {
		height = 64.0;
	}
	return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSString *titleStr = nil;
	if (section == 0) {
		titleStr = @"You can analyze one or two cars.";
	}
	return titleStr;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	UIView *sectionView = nil;
	if (section == 2) {
		sectionView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		
		RLCustomButton *button = [[RLCustomButton resetCar2Button] retain];
		[button addTarget:self action:@selector(resetCar2OptionsAction:) forControlEvents:UIControlEventTouchDown];
		button.frame = CGRectMake(10.0,
								  10.0,
								  tableView.bounds.size.width - 20.0,
								  44.0);
		
		[sectionView addSubview:button];
		[button release];
	}
	return sectionView;
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[self performSelector:@selector(resetCar2Action)];
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
