
#import "NoteSelector.h"
#import "RecipeType.h"
#import "RecipeListTableViewController.h"
#import "Platform_pListWrapper.h"

#import "RecipeListTableViewController.h"
#import "NoteSelectorTableViewCell.h"

@implementation NoteSelector
static NoteSelector* InstanceofNoteSelector= nil;

static int underEditing = FALSE;

+(NoteSelector*) sharedInstance{
	if( nil == InstanceofNoteSelector){
		InstanceofNoteSelector = [[NoteSelector alloc] initWithStyle:UITableViewStyleGrouped];
	}
	return InstanceofNoteSelector;
}

- (void) add:(id)sender {
	Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];
	NSString* det = [pListObject getNotenameForIndex:0];
	if(TRUE == [det isEqualToString:@"+ add a note"] ) {
		return;
	}
	
	[pListObject addNotename:@"+ add a note"];
	NSInteger selected = [pListObject getCurrentNoteIndex];
	[pListObject setCurrentNoteIndex:(selected+1)];
	
	[self.tableView reloadData];
	
	[[RecipeListTableViewController getTableView] reloadData];
}

- (void) back:(id)sender {
	
	Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];
	NSInteger selected = [pListObject getCurrentNoteIndex];
	
	
	NSString* det = [pListObject getNotenameForIndex:0];
	NSLog(@"det [%@]", det);
	
	if(TRUE == [det isEqualToString:@"+ add a note"] ) {
		[pListObject delNotenameForIndex:0];
		
		if(selected > 0) {
			[pListObject setCurrentNoteIndex:(selected-1)];
		} else {
			[pListObject setCurrentNoteIndex:0];
		}
	}
	
	[self.tableView reloadData];
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
	
	[[RecipeListTableViewController getTableView] reloadData];
	[[RecipeListTableViewController getTableView] beginUpdates];
	[[RecipeListTableViewController getTableView] endUpdates];
	
	[self dismissModalViewControllerAnimated:YES];
	
}

/* Implement viewDidLoad to do additional setup after loading the view, typically from a nib. */
- (void)viewDidLoad {
	/* view etc */
	self.navigationItem.title = @"Notes";
	self.tableView.editing = NO;    
	
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] 
					   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
								target:self 
								action:@selector(add:)];
	self.navigationItem.leftBarButtonItem = addButtonItem;
	[addButtonItem release];
	
	UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
									   style:UIBarButtonItemStylePlain 
									  target:self 
									  action:@selector(back:)];
	
	self.navigationItem.rightBarButtonItem = doneButtonItem;
	[doneButtonItem release];
	
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

////////// table view ///////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];
	NSMutableArray* tt = [pListObject getArrayForKey:@"notes"];
	
	return [tt count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	printf("cellForRowAtIndexPath\n");
	static NSString* cellid = @"Cell";
	NoteSelectorTableViewCell* cell = (NoteSelectorTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:cellid];
	
	if(nil == cell) {
		cell = [[[NoteSelectorTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellid] autorelease];
	}
	
	Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];
	NSMutableArray* tt = [pListObject getArrayForKey:@"notes"];
	
	NSInteger selected = [pListObject getCurrentNoteIndex];
	printf("selected [%d] current index.row [%d]\n", selected, indexPath.row);
	
	if(selected == indexPath.row){
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	} else {
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}	
	
	NSString* txt = (NSString*) [tt objectAtIndex:indexPath.row];
	cell.name = txt;
	cell.addLabel.delegate = self;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];
		
	NSString* det = [pListObject getNotenameForIndex:indexPath.row];
	if(TRUE == [det isEqualToString:@"+ add a note"] ) {
		return;
	}
	
	[pListObject setCurrentNoteIndex:indexPath.row];
	NSInteger selected = [pListObject getCurrentNoteIndex];
	printf("didselectron current [%d]\n", selected);
	
	[self.tableView reloadData];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(underEditing == TRUE) {
		return UITableViewCellEditingStyleNone;
	} else {
		return UITableViewCellEditingStyleDelete;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
						forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];
		[pListObject delNotenameForIndex:indexPath.row];
		
		NSInteger selected = [pListObject getCurrentNoteIndex];
		
		if(indexPath.row == selected) {
			[pListObject setCurrentNoteIndex:0];
		} else if (indexPath.row < selected) {
			[pListObject setCurrentNoteIndex:(selected-1)];
		}
		
		[self.tableView reloadData];
	}
}

///////// TEXT FIELD DELEGATE ///////////////////////////////////////////////
- (void)textFieldDidBeginEditing:(UITextField  *)textField {
	if([textField.text isEqualToString:@"+ add a note"]){
		textField.text = @"";
		textField.textColor = [UIColor blackColor];
	}
	
	underEditing = TRUE;
}

- (void)textFieldDidEndEditing:(UITextField  *)textField {
	if([textField.text isEqualToString:@""]){
		textField.text = @"+ add a note";
		textField.textColor = [UIColor grayColor];
	} else {
		Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];
		[pListObject addNotename:textField.text];
	}
	
	underEditing = FALSE;
}
////////////////////////////////////////////////////////////////////////////


@end
