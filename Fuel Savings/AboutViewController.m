//
//  AboutViewController.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController (Private)

- (void)displayComposerSheet;
- (void)gotoTwitter;
- (void)gotoProductWebsite;
- (void)gotoSupport;
- (void)gotoWebsite;

@end

@implementation AboutViewController

- (id)init
{
	self = [super initWithNibName:@"AboutViewController" bundle:nil];
	if (self) {
		// initialization code
	}
	return self;
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
	self.title = @"About";
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Custom Methods

- (void)displayComposerSheet {
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	NSArray *toRecipients = [NSArray arrayWithObject:@"apps@riveralabs.com"];
	[picker setToRecipients:toRecipients];
	
	[picker setSubject:@"Fuel Savings Feedback"];
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

- (void)gotoTwitter
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://twitter.com/riveralabs"]];
}

- (void)gotoProductWebsite
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://riveralabs.com/apps/fuel-savings"]];
}

- (void)gotoSupport
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://riveralabs.com/contact"]];
}

- (void)gotoWebsite
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://riveralabs.com"]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = 1;
	if (section == 0) {
		rows = 2;
	} else if (section == 1) {
		rows = 2;
	} else {
		rows = 3;
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		NSString *NameCellIdentifier = nil;
		UITableViewCellStyle nameCellStyle;
		
		if (indexPath.row == 0) {
			NameCellIdentifier = @"NameCell";
			nameCellStyle = UITableViewCellStyleSubtitle;
		} else {
			NameCellIdentifier = @"VersionCell";
			nameCellStyle = UITableViewCellStyleValue1;
		}
		
		UITableViewCell *nameCell = [tableView dequeueReusableCellWithIdentifier:NameCellIdentifier];
		if (nameCell == nil) {
			nameCell = [[[UITableViewCell alloc] initWithStyle:nameCellStyle reuseIdentifier:NameCellIdentifier] autorelease];
		}
		
		nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
		nameCell.accessoryType = UITableViewCellAccessoryNone;
		
		NSString *textLabelStr = nil;
		NSString *detailLabelStr = nil;
		
		if (indexPath.row == 0) {
			textLabelStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
			detailLabelStr = @"Rivera Labs";
		} else {
			textLabelStr = @"Version";
			detailLabelStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
		}
		
		nameCell.textLabel.text = textLabelStr;
		nameCell.detailTextLabel.text = detailLabelStr;
		
		return nameCell;
	}
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSString *textLabelStr = nil;
	
	if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			textLabelStr = @"Email Rivera Labs";
		} else {
			textLabelStr = @"Twitter @RiveraLabs";
		}
	} else {
		if (indexPath.row == 0) {
			textLabelStr = @"Fuel Savings Website";
		} else if (indexPath.row == 1) {
			textLabelStr = @"Support Website";
		} else {
			textLabelStr = @"Rivera Labs Website";
		}
	}
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	cell.textLabel.textAlignment = UITextAlignmentCenter;
	cell.textLabel.text = textLabelStr;
	
	return cell;	
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if (section == 0) {
		return @"Copyright © 2011, Axel Rivera";
	}
	return nil;
}

#pragma mark - Table view delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0 && indexPath.row == 0) {
		return 54.0;
	}
	return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return;
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			[self displayComposerSheet];
		} else {
			[self gotoTwitter];
		}
	} else {
		if (indexPath.row == 0) {
			[self gotoProductWebsite];
		} else if (indexPath.row == 1) {
			[self gotoSupport];
		} else {
			[self gotoWebsite];
		}
	}
}

#pragma mark - MFMailComposeViewController Delegate

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	NSString *errorString = nil;
	
	BOOL showAlert = NO;
	// Notifies users about errors associated with the interface
	switch (result)  {
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			errorString = [NSString stringWithFormat:@"E-mail failed: %@", 
						   [error localizedDescription]];
			showAlert = YES;
			break;
		default:
			errorString = [NSString stringWithFormat:@"E-mail was not sent: %@", 
						   [error localizedDescription]];
			showAlert = YES;
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
	if (showAlert == YES) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-mail Error"
														message:errorString
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

@end
