//
//  TripViewController.m
//  Fuel Savings
//
//  Created by arn on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TripViewController.h"
#import "TotalView.h"
#import "TotalViewCell.h"
#import "TotalDetailViewCell.h"

#define TRIP_NEW_TAG 1
#define TRIP_DELETE_TAG 2

@implementation TripViewController

@synthesize newTrip	= newTrip_;
@synthesize currentTrip = currentTrip_;

- (id)init
{
	self = [super initWithNibName:@"TripViewController" bundle:nil];
	if (self) {
		savingsData_ = [SavingsData sharedSavingsData];
		currencyFormatter_ = [[NSNumberFormatter alloc] init];
		[currencyFormatter_ setNumberStyle:NSNumberFormatterCurrencyStyle];
		[currencyFormatter_ setMaximumFractionDigits:0];
		self.newTrip = nil;
		self.currentTrip = nil;
		isNewTrip_ = NO;
		showNewAction_ = NO;
		hasTabBar_ = NO;
	}
	return self;
}

- (id)initWithTabBar
{
	self = [self init];
	if (self) {
		self.title = @"Trip";
		self.navigationItem.title = @"Analyze Trip";
		self.tabBarItem.image = [UIImage imageNamed:@"trip_tab.png"];
		hasTabBar_ = YES;
	}
	return self;
}

- (void)dealloc
{
	[currencyFormatter_ release];
	[newTrip_ release];
	[currentTrip_ release];
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
	
	if (hasTabBar_) {
		UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
																					target:self
																					action:@selector(editAction)];
		self.navigationItem.rightBarButtonItem = editButton;
		[editButton release];
		
		UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"New"
																	  style:UIBarButtonItemStyleBordered
																	 target:self
																	 action:@selector(newCheckAction)];
		self.navigationItem.leftBarButtonItem = newButton;
		[newButton release];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	if (self.currentTrip) {
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if (showNewAction_ == YES) {
		showNewAction_ = NO;
		[self performSelector:@selector(newAction)];
	}
}

#pragma mark - Custom Actions

- (void)newCheckAction
{
	if (self.currentTrip == nil) {
		[self performSelector:@selector(newAction)];
	} else {
		[self performSelector:@selector(newOptionsAction:)];
	}
}

- (void)newAction
{
	self.newTrip = [Trip calculation];
	CurrentTripViewController *currentTripViewController = [[CurrentTripViewController alloc] initWithTrip:newTrip_];
	currentTripViewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:currentTripViewController];
	[self presentModalViewController:navController animated:YES];
	
	[currentTripViewController release];
	[navController release];
}

- (void)editAction
{
	self.newTrip = self.currentTrip;
	CurrentTripViewController *currentTripViewController = [[CurrentTripViewController alloc] initWithTrip:newTrip_];
	currentTripViewController.delegate = self;
	currentTripViewController.isEditingTrip = YES;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:currentTripViewController];
	[self presentModalViewController:navController animated:YES];
	
	[currentTripViewController release];
	[navController release];
}

- (void)saveAction
{
	[self performSelector:@selector(displayNameAction)];
}


- (void)deleteAction
{
	self.currentTrip = nil;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[self.tableView reloadData];
}

- (void)displayNameAction
{
	NameInputViewController *inputViewController = [[NameInputViewController alloc] initWithNavigationButtons];
	inputViewController.delegate = self;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	
	inputViewController.currentName = [NSString stringWithFormat:@"Untitled %@", [dateFormatter stringFromDate:[NSDate date]]];
	
	[dateFormatter release];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:inputViewController];
	[self presentModalViewController:navController animated:YES];
	
	[inputViewController release];
	[navController release];
}

- (void)newOptionsAction:(id)sender {	
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"You have a Current Trip. What would you like to do before creating a New Trip?"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:@"Delete Current"
								  otherButtonTitles:@"Save Current As...", nil];
	
	actionSheet.tag = TRIP_NEW_TAG;
	
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];	
}

- (void)deleteOptionsAction:(id)sender {
	// open a dialog with two custom buttons	
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"Are you sure? The information on your Current Trip will be lost."
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:@"Delete Current"
								  otherButtonTitles:nil];
	
	actionSheet.tag = TRIP_DELETE_TAG;
	
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];	
}

#pragma mark - View Controller Delegates

- (void)currentTripViewControllerDelegateDidFinish:(CurrentTripViewController *)controller save:(BOOL)save
{
	if (save) {
		self.currentTrip = controller.currentTrip;
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)nameInputViewControllerDidFinish:(NameInputViewController *)controller save:(BOOL)save
{
	if (save) {
		self.currentTrip.name = controller.currentName;
		Trip *trip = [self.currentTrip copy];
		[savingsData_.tripArray addObject:trip];
		[trip release];
		if (isNewTrip_) {
			isNewTrip_ = NO;
			showNewAction_ = YES;
		}
	}
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (self.currentTrip == nil) {
		return 0;
	}
	NSInteger sections = 2;
	if (hasTabBar_) {
		sections = sections + 1;
	}
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		static NSString *TotalCellIdentifier = @"TotalCell";
		
		TotalViewCell *totalCell = (TotalViewCell *)[tableView dequeueReusableCellWithIdentifier:TotalCellIdentifier];
		
		if (totalCell == nil) {
			totalCell = [[[TotalViewCell alloc] initWithTotalType:TotalViewTypeSingle reuseIdentifier:TotalCellIdentifier] autorelease];
		}
		
		totalCell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		NSString *imageStr = @"money.png";
		NSString *titleStr = @"Trip Cost";
		NSString *text1LabelStr = self.currentTrip.vehicle.name;
		
		NSNumber *cost = [self.currentTrip tripCost];
		NSString *detail1LabelStr = [currencyFormatter_ stringFromNumber:cost];
		
		totalCell.totalView.imageView.image = [UIImage imageNamed:imageStr];
		totalCell.totalView.titleLabel.text = titleStr;
		totalCell.totalView.text1Label.text = text1LabelStr;
		totalCell.totalView.detail1Label.text = detail1LabelStr;
		
		totalCell.totalView.text1Label.textColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:0.0 alpha:1.0];
		totalCell.totalView.detail1Label.textColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:0.0 alpha:1.0];
		
		return totalCell;
	}
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	cell.backgroundColor = [UIColor clearColor];
	cell.backgroundView = backView;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width - 20.0;
	
	if (indexPath.section == 1) {
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		textLabel.lineBreakMode = UILineBreakModeWordWrap;
		textLabel.numberOfLines = 2;
		textLabel.textAlignment = UITextAlignmentCenter;
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.textColor = [UIColor darkGrayColor];
		textLabel.font = [UIFont systemFontOfSize:14.0];
		textLabel.shadowColor = [UIColor whiteColor];
		textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		
		[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		
		NSString *fuelStr = [formatter stringFromNumber:self.currentTrip.fuelPrice];
		
		[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[formatter setMaximumFractionDigits:0];
		
		NSString *distanceStr = [formatter stringFromNumber:self.currentTrip.distance];
		
		textLabel.text = [NSString stringWithFormat:
						  @"Fuel Price - %@ /gallon\n"
						  @"Distance - %@ miles\n",
						  fuelStr,
						  distanceStr];
		
		textLabel.frame = CGRectMake(10.0, 0.0, contentWidth, 34.0);
		
		cell.accessoryView = textLabel;
		
		[textLabel release];
		[formatter release];
	} else {
		UIButton *leftButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		[leftButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchDown];
		[leftButton setTitle:@"Save As..." forState:UIControlStateNormal];
		
		UIButton *rightButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		[rightButton addTarget:self action:@selector(deleteOptionsAction:) forControlEvents:UIControlEventTouchDown];
		[rightButton setTitle:@"Delete" forState:UIControlStateNormal];
		
		UIView *buttonView = [[UIView alloc] initWithFrame:CGRectZero];
		buttonView.frame = CGRectMake(20.0, 0.0, contentWidth, 44.0);
		
		leftButton.frame = CGRectMake(0.0,
									  0.0,
									  (contentWidth / 2.0) - 5.0,
									  44.0);
		
		rightButton.frame = CGRectMake((contentWidth / 2.0) + 5.0,
									   0.0,
									   (contentWidth / 2.0) - 5.0,
									   44.0);
		
		[buttonView addSubview:leftButton];
		[buttonView addSubview:rightButton];
		
		cell.accessoryView = buttonView;
		
		[leftButton release];
		[rightButton release];
		[buttonView release];
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = 44.0;
	if (indexPath.section == 0) {
		height = 66.0;
	} else if (indexPath.section == 1) {
		height = 34.0;
	}
	return height;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
		return 13.0;
	}
    return 1.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
	NSInteger height = 13.0;
	if (section == 0 && section == 1) {
		height = 1.0;
	}
    return height;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

#pragma mark - Custom Setter

- (void)setCurrentTrip:(Trip *)currentTrip
{
	[currentTrip_ autorelease];
	currentTrip_ = [currentTrip copy];
	if (hasTabBar_) {
		savingsData_.currentTrip = [currentTrip copy];
	}
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.tag == TRIP_NEW_TAG) {
		if (buttonIndex == 0) {
			[self performSelector:@selector(newAction)];
		} else if (buttonIndex == 1) {
			isNewTrip_ = YES;
			[self performSelector:@selector(saveAction)];
		}
	} else {
		if (buttonIndex == 0) {
			[self performSelector:@selector(deleteAction)];
		}
	}
}

@end
