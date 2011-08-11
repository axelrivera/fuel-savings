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
#import "Fuel_SavingsAppDelegate.h"

static NSString * const typeKey = @"TypeKey";
static NSString * const fuelPriceKey = @"PriceKey";
static NSString * const distanceKey = @"DistanceKey";
static NSString * const ratioKey = @"RatioKey";
static NSString * const carOwnershipKey = @"CarOwnershipKey";

static NSString * const vehicle1Key = @"Vehicle1Key";
static NSString * const vehicle2Key = @"Vehicle2Key";

static NSString * const vehicleNameKey = @"VehicleNameKey";
static NSString * const vehicleAvgEfficiencyKey = @"VehicleAvgEfficiencyKey";
static NSString * const vehicleCityEfficiencyKey = @"VehicleCityEfficiencyKey";
static NSString * const vehicleHighwayEfficiencyKey = @"VehicleHighwayEfficiencyKey";

@interface CurrentSavingsViewController (Private)

- (NSArray *)informationArray;
- (NSArray *)vehicleArrayWithKey:(NSString *)key;

- (void)displayErrorWithMessage:(NSString *)message;

@end

@implementation CurrentSavingsViewController

@synthesize delegate = delegate_;
@synthesize currentSavings = currentSavings_;
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
	
	self.newData = [NSMutableArray arrayWithCapacity:0];
	
	if (self.currentSavings) {
		NSArray *informationArray = [[self informationArray] retain];
		NSArray *vehicle1Array = [[self vehicleArrayWithKey:vehicle1Key] retain]; 
		
		[newData_ addObject:informationArray];
		[newData_ addObject:vehicle1Array];
		
		[informationArray release];
		[vehicle1Array release];
		
		if ([self.currentSavings.vehicle2 hasDataReady]) {
			NSArray *vehicle2Array = [[self vehicleArrayWithKey:vehicle2Key] retain];
			[newData_ addObject:vehicle2Array];
			[vehicle2Array release];
		}
	}
	
	[newTable_ reloadData];	
}

#pragma mark - Custom Actions

- (void)saveAction
{
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

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger sections = [newData_ count];
	if (sections == 2) {
		sections++;
	}
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = 0;
	if (section == 2 && [newData_ count] == 2) {
		rows = 1;
	} else {
		rows = [[newData_ objectAtIndex:section] count];
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 2 && [newData_ count] == 2) {
		static NSString *AddCellIdentifier = @"AddCell";
		
		UITableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:AddCellIdentifier];
		
		if (addCell == nil) {
			addCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddCellIdentifier] autorelease];
		}
	
		addCell.selectionStyle = UITableViewCellSelectionStyleBlue;
		addCell.imageView.image = [UIImage imageNamed:@"add.png"];
		addCell.textLabel.text = @"Add Car 2 (Optional)";
		
		return addCell;
	}
	
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
	
	cell.textLabel.text = [dictionary objectForKey:dictionaryTextKey];
	cell.detailTextLabel.text = [dictionary objectForKey:dictionaryDetailKey];
	
	return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 2 && [newData_ count] == 2) {
		[newData_ addObject:[self vehicleArrayWithKey:vehicle2Key]];
				
		[tableView beginUpdates];
		
		[tableView deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
		[tableView insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationTop];
		
		[tableView endUpdates];
		
		NSInteger lastRow = [[newData_ objectAtIndex:2] count] - 1;
		NSIndexPath *lastCell = [NSIndexPath indexPathForRow:lastRow inSection:2];
		
		[tableView scrollToRowAtIndexPath:lastCell atScrollPosition:UITableViewScrollPositionBottom animated:YES];
		
		return;
	}
	
	UIViewController *viewController = nil;
	
	NSDictionary *dictionary = [[newData_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	NSString *key = [dictionary objectForKey:dictionaryKey];
	
	if (indexPath.section == 0) {
		if ([key isEqualToString:typeKey]) {
			TypeInputViewController *inputViewController = [[TypeInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentType = self.currentSavings.type;
			inputViewController.footerText = @"You can calculate the cost of fuel by selecting one of these options.";
			viewController = inputViewController;
		} else if ([key isEqualToString:fuelPriceKey]) {
			PriceInputViewController *inputViewController = [[PriceInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentPrice = self.currentSavings.fuelPrice;
			viewController = inputViewController;
		} else if ([key isEqualToString:distanceKey]) {
			DistanceInputViewController *inputViewController = [[DistanceInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentDistance = self.currentSavings.distance;
			inputViewController.distanceSuffix = @"miles/year";
			inputViewController.footerText = @"On average, how much do you drive your car every year?";
			viewController = inputViewController;
		} else if ([key isEqualToString:ratioKey]) {
			RatioInputViewController *inputViewcontroller = [[RatioInputViewController alloc] init];
			inputViewcontroller.delegate = self;
			inputViewcontroller.currentCityRatio = self.currentSavings.cityRatio;
			inputViewcontroller.currentHighwayRatio = self.currentSavings.highwayRatio;
			inputViewcontroller.footerText = @"On average, how much do you drive in both city and highway?";
			viewController = inputViewcontroller;
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
			NameInputViewController *inputViewController = [[NameInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.key = vehicleKey;
			inputViewController.footerText = @"Enter the Vehicle Name";
			inputViewController.currentName = vehicle.name;
			viewController = inputViewController;
		} else if ([key isEqualToString:vehicleAvgEfficiencyKey]) {
			EfficiencyInputViewController *inputViewController = [[EfficiencyInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.key = vehicleKey;
			inputViewController.currentEfficiency = vehicle.avgEfficiency;
			inputViewController.currentType = EfficiencyInputTypeAverage;
			inputViewController.footerText = @"Average Fuel Efficiency in MPG";
			viewController = inputViewController;
		} else if ([key isEqualToString:vehicleCityEfficiencyKey]) {
			EfficiencyInputViewController *inputViewController = [[EfficiencyInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.key = vehicleKey;
			inputViewController.currentEfficiency = vehicle.cityEfficiency;
			inputViewController.currentType = EfficiencyInputTypeCity;
			inputViewController.footerText = @"City Fuel Efficiency in MPG";
			viewController = inputViewController;
		} else if ([key isEqualToString:vehicleHighwayEfficiencyKey]) {
			EfficiencyInputViewController *inputViewController = [[EfficiencyInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.key = vehicleKey;
			inputViewController.currentEfficiency = vehicle.highwayEfficiency;
			inputViewController.currentType = EfficiencyInputTypeHighway;
			inputViewController.footerText = @"Highway Fuel Efficiency in MPG";
			viewController = inputViewController;
		}
	}
	
	if (viewController) {
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
}

#pragma mark - View Controller Delegates

- (void)typeInputViewControllerDidFinish:(TypeInputViewController *)controller save:(BOOL)save
{
	if (save) {
		self.currentSavings.type = controller.currentType;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)priceInputViewControllerDidFinish:(PriceInputViewController *)controller save:(BOOL)save
{
	if (save) {
		self.currentSavings.fuelPrice = controller.currentPrice;
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

- (void)ratioInputViewControllerDidFinish:(RatioInputViewController *)controller save:(BOOL)save
{
	if (save) {
		self.currentSavings.cityRatio = controller.currentCityRatio;
		self.currentSavings.highwayRatio = controller.currentHighwayRatio;
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
	[self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Private Methods

- (NSArray *)informationArray
{	
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
	
	NSDictionary *dictionary = nil;
	
	NSString *typeStr = [NSString stringWithString:[self.currentSavings stringForCurrentType]];
	dictionary = [NSDictionary textDictionaryWithKey:typeKey text:@"Using" detail:typeStr];
	[array addObject:dictionary];
	
	NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
	[priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	
	NSString *priceStr = [priceFormatter stringFromNumber:self.currentSavings.fuelPrice];
	[priceFormatter release];
	
	dictionary = [NSDictionary textDictionaryWithKey:fuelPriceKey
												text:@"Fuel Price"
											  detail:[NSString stringWithFormat:@"%@ /gallon", priceStr]];
	[array addObject:dictionary];
	
	NSNumberFormatter *distanceFormatter = [[NSNumberFormatter alloc] init];
	[distanceFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[distanceFormatter setMaximumFractionDigits:0];
	
	NSString *distanceStr = [distanceFormatter stringFromNumber:self.currentSavings.distance];
	[distanceFormatter release];
	
	dictionary = [NSDictionary textDictionaryWithKey:distanceKey
												text:@"Distance"
											  detail:[NSString stringWithFormat:@"%@ miles/year", distanceStr]];
	[array addObject:dictionary];
	
	if (self.currentSavings.type == EfficiencyTypeCombined) {
		NSNumberFormatter *ratioFormatter = [[NSNumberFormatter alloc] init];
		[ratioFormatter setNumberStyle:NSNumberFormatterPercentStyle];
		[ratioFormatter setMaximumFractionDigits:0];
		
		NSString *ratioStr = [NSString stringWithFormat:@"%@ City / %@ Highway",
							  [ratioFormatter stringFromNumber:self.currentSavings.cityRatio],
							  [ratioFormatter stringFromNumber:self.currentSavings.highwayRatio]];
		[ratioFormatter release];
		
		dictionary = [NSDictionary textDictionaryWithKey:ratioKey
													text:@"Ratio"
												  detail:ratioStr];
		[array addObject:dictionary];
	}
	
	NSString *ownershipStr = nil;
	
	if ([self.currentSavings.carOwnership integerValue] > 1) {
		ownershipStr = [NSString stringWithFormat:@"%@ years", [self.currentSavings.carOwnership stringValue]];
	} else {
		ownershipStr = [NSString stringWithFormat:@"%@ year", [self.currentSavings.carOwnership stringValue]];					
	}
	
	dictionary = [NSDictionary textDictionaryWithKey:carOwnershipKey
												text:@"Ownership"
											  detail:ownershipStr];
	[array addObject:dictionary];
	
	return array;
}

- (NSArray *)vehicleArrayWithKey:(NSString *)key
{
	Vehicle *vehicle = nil;
	NSString *titleText = nil;
	SEL titleSelector;
	
	if ([key isEqualToString:vehicle1Key]) {
		vehicle = self.currentSavings.vehicle1;
		titleText = @"Car 1";
		titleSelector = @selector(selectCar1Action);
	} else {
		vehicle = self.currentSavings.vehicle2;
		titleText = @"Car 2";
		titleSelector = @selector(selectCar2Action);
	}
	
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
	
	NSDictionary *dictionary = nil;
	
	dictionary = [NSDictionary buttonDictionaryWithKey:key
												  text:titleText];
	
	UIButton *button = [dictionary objectForKey:dictionaryButtonKey];
	[button addTarget:self action:titleSelector forControlEvents:UIControlEventTouchDown];
	
	[array addObject:dictionary];
	
	NSString *nameStr = [NSString stringWithString:vehicle.name];
	dictionary = [NSDictionary textDictionaryWithKey:vehicleNameKey
												text:@"Name"
											  detail:nameStr];
	[array addObject:dictionary];
	
	NSString *efficiencyFormatString = @"%@ MPG";
	
	if (self.currentSavings.type == EfficiencyTypeAverage) {
		NSString *combinedStr = [NSString stringWithFormat:efficiencyFormatString, [vehicle.avgEfficiency stringValue]];
		dictionary = [NSDictionary textDictionaryWithKey:vehicleAvgEfficiencyKey
													text:@"Average MPG"
												  detail:combinedStr];
		[array addObject:dictionary];
	} else {
		NSString *cityStr = [NSString stringWithFormat:efficiencyFormatString, [vehicle.cityEfficiency stringValue]];
		dictionary = [NSDictionary textDictionaryWithKey:vehicleCityEfficiencyKey
													text:@"City MPG"
												  detail:cityStr];
		[array addObject:dictionary];
		
		NSString *highwayStr = [NSString stringWithFormat:efficiencyFormatString, [vehicle.highwayEfficiency stringValue]];
		dictionary = [NSDictionary textDictionaryWithKey:vehicleHighwayEfficiencyKey
													text:@"Highway MPG"
												  detail:highwayStr];
		[array addObject:dictionary];
	}
	
	return array;
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

@end
