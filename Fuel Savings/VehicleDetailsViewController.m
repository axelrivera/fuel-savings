//
//  VehicleViewController.m
//  MPGDatabase
//
//  Created by Axel Rivera on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VehicleDetailsViewController.h"

@implementation VehicleDetailsViewController

@synthesize mpgDatabaseInfo = _mpgDatabaseInfo;
@synthesize delegate = _delegate;

- (id)init
{
	self = [super initWithNibName:@"VehicleDetailsViewController" bundle:nil];
	if (self) {
		self.mpgDatabaseInfo = nil;
	}
	return self;
}

- (id)initWithInfo:(NSDictionary *)info
{
	self = [self init];
	if (self) {
		self.mpgDatabaseInfo = info;
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
	self.mpgDatabaseInfo = nil;
	[super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = [self.mpgDatabaseInfo objectForKey:@"model"];
	
	if (self.tabBarController == nil) {
		UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																					target:self
																					action:@selector(saveAction)];
		self.navigationItem.rightBarButtonItem = saveButton;
		[saveButton release];
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
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

#pragma mark - Action Methods

- (void)saveAction
{
	[self.delegate vehicleDetailsViewControllerDidFinish:self save:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSString *labelStr = nil;
	NSString *detailStr = nil;
	
	if (indexPath.row == 0) {
		labelStr = [NSString stringWithFormat:@"%@ %@ %@",
					[[self.mpgDatabaseInfo objectForKey:@"year"] stringValue],
					[self.mpgDatabaseInfo objectForKey:@"make"],
					[self.mpgDatabaseInfo objectForKey:@"model"]];
		detailStr = @"";
	} else if (indexPath.row == 1) {
		labelStr = @"City MPG";
		detailStr = [[self.mpgDatabaseInfo objectForKey:@"mpgCity"] stringValue];
	} else if (indexPath.row == 2) {
		labelStr = @"Highway MPG";
		detailStr = [[self.mpgDatabaseInfo objectForKey:@"mpgHighway"] stringValue];
	} else {
		labelStr = @"Combined MPG";
		detailStr = [[self.mpgDatabaseInfo objectForKey:@"mpgAverage"] stringValue];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	cell.textLabel.text = labelStr;
	cell.detailTextLabel.text = detailStr;
	
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
	 // ...
	 // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}

@end
