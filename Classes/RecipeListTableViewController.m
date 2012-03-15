#import "zedoul_common.h"

#import "googleAPI.h"
#import "RecipeListTableViewController.h"
#import "Recipe.h"
#import "RecipeTableViewCell.h"
#import "NoteSelector.h"
#import "Platform_pListWrapper.h"


#define _ONEVIEW

@implementation RecipeListTableViewController

@synthesize managedObjectContext, fetchedResultsController;

static NSFetchedResultsController* fetch = NULL;
static NSManagedObjectContext* context = NULL;
static UITableView* tbv = NULL;
static int addIsActivate = false;

////////// API ////////////////////////////////////////////////////////////////////////////////////////////
+ (NSFetchedResultsController*)getFetch {
	return fetch;
}
+ (NSManagedObjectContext*)getContext {
	return context;
}
+ (NSIndexPath*) getIndexPath {
	CGPoint a = tbv.contentOffset;
	printf("* currentTableViewPoint %f %f\n", a.x, a.y);
	return [tbv indexPathForRowAtPoint:a];
}
+ (UITableView*) getTableView {
	return tbv;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController overrides
- (void)viewDidLoad {
	__COMMON_FUNC_ENTER__

	
	// Configure the navigation bar
	self.title = @"Words";
	
	self.tableView.editing = NO;
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] 
					  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
					  target:self 
					  action:@selector(add:)];
	self.navigationItem.rightBarButtonItem = addButtonItem;
	[addButtonItem release];
	
	UIBarButtonItem *noteButtonItem = [[UIBarButtonItem alloc] 
					   initWithTitle:@"Notes" 
					   style:UIBarButtonItemStylePlain 
					   target:self 
					   action:@selector(notes:)];
	self.navigationItem.leftBarButtonItem = noteButtonItem;
	[noteButtonItem release];
	
	/* set statics */
	fetch = fetchedResultsController;
	context = managedObjectContext;
	tbv = self.tableView;
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"ㅠㅠ Unresolved error %@, %@", error, [error userInfo]);
		__COMMON_FUNC_EXIT__
		abort();
	}
	
	NSLog(@"=============================================");
	NSLog(@"== print inside core data =========================");
	NSInteger i = 0;
	NSInteger j = 0;
	NSInteger seccount = [[fetchedResultsController sections] count];//[pListObject getCount];
	printf("seccount [%d]\n", seccount);
	
	if(0 == seccount) {
		printf("Fetched is Empty\n");
		__COMMON_FUNC_EXIT__
		return;
	}
	
	for(i=0; i<seccount; i++){
		
		NSString* det = [[[fetchedResultsController sections] objectAtIndex:i] name];
		NSLog(@"* det :[%@]", det);
		
		id <NSFetchedResultsSectionInfo> si = [[fetchedResultsController sections] objectAtIndex:i];
		NSInteger rowcount = [si numberOfObjects];
		printf("** it`s count [%d]\n", rowcount);
		
		for(j=0; j<rowcount; j++) {
			NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j
								    inSection:i];
			
			Recipe *recipe = (Recipe *)[fetchedResultsController objectAtIndexPath:indexPath];
			
			printf("===========Recipe to View===========\n");
			printf("* index path section[%d] row[%d]\n", i, j);
			NSLog(@"* note %@", recipe.noteName);
			NSLog(@"* name %@", recipe.name);
			NSLog(@"* desc %@", recipe.overview);
			printf("=================================\n");
		}
	}
	__COMMON_FUNC_EXIT__
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

//// section get ///////////////////////////////////////////////////////////////////////////////////
/// return section : if selected Name is in Fetched
/// return -1 : if selected Name is not in Fetched
/// return 0 : if Fetched is empty
- (NSInteger) getSectionForNoteSelected:(NSInteger) selected {
	__COMMON_FUNC_ENTER__
	NSInteger ret = -1;

	Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];
	NSString* target = [pListObject getNotenameForIndex:selected];
	NSLog(@"target :[%@]", target);
	
	NSInteger i = 0;
	NSInteger count = [[fetchedResultsController sections] count];//[pListObject getCount];
	printf("count [%d]\n", count);
	
	if(0 == count) {
		printf("Fetched is Empty\n");
		ret = 0;
	}
	
	for(i=0; i<count; i++){
		NSString* det = [[[fetchedResultsController sections] objectAtIndex:i] name];
		NSLog(@"* det :[%@]", det);
		
		if(TRUE == [det isEqualToString:target]){
			printf("get it!! section:[%d]\n", i);
			ret = i;
			break;
		}
	}
	
	if(ret == -1){
		printf("selected Section is new one so not in Fetched\n");
	}
	
	printf("section:[%d]\n", ret);
	__COMMON_FUNC_EXIT__
	return ret; 
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	__COMMON_FUNC_ENTER__
	__COMMON_FUNC_EXIT__
	// Support all orientations except upside down
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Recipe support
- (void)notes:(id)sender {
	__COMMON_FUNC_ENTER__
	NoteSelector* ns = [NoteSelector sharedInstance];
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ns];
	[self presentModalViewController:navigationController animated:YES];
	
	[navigationController release];
	__COMMON_FUNC_EXIT__
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)add:(id)sender {
	__COMMON_FUNC_ENTER__
	
	printf("=======log current database========\n");
	NSInteger seccount = [[fetchedResultsController sections] count];
	printf("* section count [%d]\n", seccount);
	int i=0;
	int j=0;
	for(i=0; i<seccount; i++){
		
		NSString* det = [[[fetchedResultsController sections] objectAtIndex:i] name];
		NSLog(@"* note name :[%@]", det);
		
		id <NSFetchedResultsSectionInfo> si = [[fetchedResultsController sections] objectAtIndex:i];
		NSInteger rowcount = [si numberOfObjects];
		printf("* it`s count [%d]\n", rowcount);
		
		for(j=0; j<rowcount; j++) {
			NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j
								    inSection:i];
			
			Recipe *recipe = (Recipe *)[fetchedResultsController objectAtIndexPath:indexPath];
			
			printf("===========Inside===========\n");
			printf("** index path section[%d] row[%d]\n", i, j);
			NSLog(@"** note %@", recipe.noteName);
			NSLog(@"** name %@", recipe.name);
			NSLog(@"** desc %@", recipe.overview);
			printf("=================================\n");
		}
	}
	printf("======================================\n");
	
	Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];
	NSInteger selected = [pListObject getCurrentNoteIndex];
	NSInteger sec = [self getSectionForNoteSelected:selected];
	
	if ([[fetchedResultsController sections] count] > 0 && [[fetchedResultsController sections] count] > selected) {
		id <NSFetchedResultsSectionInfo> si = [[fetchedResultsController sections] objectAtIndex:selected];
		NSInteger count = [si numberOfObjects];
		printf("* current object in selected section row-count is [%d]\n", count);	
		
		if (sec == -1) {
			/* continue */
			
		} else if (count > 0) {
			/* 이미 새 입력이 준비되었다면, 또 띄우지 않는다 */
			printf("* row count > 0\n");
			NSIndexPath* idp = [NSIndexPath indexPathForRow:0 inSection:sec];
			Recipe *recipe = (Recipe *)[fetchedResultsController objectAtIndexPath:idp];
			
			if(recipe != nil) {
				if(YES == [@"+ add a new one" isEqualToString:recipe.name]) {
					printf("* already +add new word inserted\n");
					
					__COMMON_FUNC_EXIT__
					return;
				}
			}
			
		} else {
			
		}
	} else {
		printf("newly created object in empty section [%d]\n", selected);
	}
	
	NSInteger count = [[fetchedResultsController sections] count];
	printf("* count of the sections [%d]\n", count);
	
	Recipe *newRecipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" 
						 inManagedObjectContext:self.managedObjectContext];
	
	NSTimeInterval curdate = [[NSDate date] timeIntervalSince1970];
	
	printf("========================================\n");
	printf("=== ADD new word =====================\n");
	printf("* selected [%d]\n", selected);
	NSString* det = [pListObject getNotenameForIndex:selected];
	NSLog(@"* note name [%@]", det);
	newRecipe.name =@"+ add a new one";
	newRecipe.prepTime = [@"" stringByAppendingString:[NSString stringWithFormat:@"%f", curdate]];
	NSLog(@"* prepTime [%@]", newRecipe.prepTime);
	printf("========================================\n");
	newRecipe.overview = @"";
	newRecipe.instructions = @"";
	newRecipe.noteName = det;

	NSError *error = nil;
	
	addIsActivate = true;
	
	if (![newRecipe.managedObjectContext save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		__COMMON_FUNC_EXIT__
		abort();
	}
	
	addIsActivate = false;
		
	[self.tableView reloadData];
	
	__COMMON_FUNC_EXIT__
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view methods
//////// number Of /////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	__COMMON_FUNC_ENTER__
	NSInteger count = [[fetchedResultsController sections] count];
	printf("* count of the sections [%d]\n", count);
	__COMMON_FUNC_EXIT__
#ifdef _ONEVIEW
	return 1; //무조건 하나의 그룹만을 띄운다. /* 이건 추후 수정되어야 할 수도 있다 */
#else
	return count;
#endif
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	__COMMON_FUNC_ENTER__
	NSArray* det = [fetchedResultsController sections];
	NSInteger numberOfRows = 0;
	
#ifdef _ONEVIEW
	Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];
	NSInteger selected = [pListObject getCurrentNoteIndex];
	NSInteger sec = [self getSectionForNoteSelected:selected];

	printf("=========== numberOfRowsInSection ==========\n");
	printf("* section-index [%d] total section-count [%d]\n", sec, [det count]); 
	if ([det count] > 0 && [det count] > sec) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [det objectAtIndex:sec];
		numberOfRows = [sectionInfo numberOfObjects];
		NSLog(@"* section name [%@] ", [pListObject getNotenameForIndex:sec]);
	} else {
		NSLog(@"Errr!");
	}
	printf("* numberOfRowsInSection count [%d]\n", numberOfRows); 
	printf("========================================\n");
	__COMMON_FUNC_EXIT__
	return numberOfRows;
#else
	__COMMON_FUNC_ENTER__	
	printf("=========== numberOfRowsInSection ==========\n");
	printf("* section-index [%d] total section-count [%d]\n", section, [det count]); 
	if ([det count] > 0) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [det objectAtIndex:section];
		numberOfRows = [sectionInfo numberOfObjects];
	} else {
		NSLog(@"Errr!");
	}
	printf("* numberOfRowsInSection count [%d]\n", numberOfRows); 
	printf("========================================\n");
	__COMMON_FUNC_EXIT__
	return numberOfRows;
#endif
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

//////// height decision ///////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)pindexPath {
	
	__COMMON_FUNC_ENTER__
	Recipe *recipe = nil;
	NSIndexPath* indexPath = nil;

	//// create indexpath /////
#ifdef _ONEVIEW
	Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];
	NSInteger selected = [pListObject getCurrentNoteIndex];
	NSInteger sec = [self getSectionForNoteSelected:selected];
	indexPath = [NSIndexPath indexPathForRow:pindexPath.row
						    inSection:sec];
#else
	indexPath = pindexPath;
#endif
	////////////////////////////
	
	recipe = (Recipe *)[fetchedResultsController objectAtIndexPath:indexPath];
	printf("========================================\n");
	printf("=== word for height =====================\n");
	NSLog(@"* name [%@]", recipe.name);
	NSLog(@"* preptime [%@]", recipe.prepTime);
	printf("========================================\n");
	
	if(YES == [@"+ add a new one" isEqualToString:recipe.name]) {
		printf("height update : add a new one\n");
		__COMMON_FUNC_EXIT__
	 	return RECIPE_TABLEVIEWCELL_NAME_HEIGHT;
	}
	
	printf("========================================\n");
	NSLog(@"note [%@]", recipe.noteName);
	NSLog(@"name [%@]", recipe.name);
	NSLog(@"overview [%@]", recipe.overview);
	NSLog(@"instructions [%@]", recipe.instructions);
	printf("========================================\n");
	
	
	int relsize = 0;
	
	CGSize new_size;
	new_size = [recipe.instructions  
		    sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]
		    constrainedToSize:CGSizeMake(DESCRIPTION_LINE_WIDTH_MAX,9999) 
		    lineBreakMode:DESCRIPTION_LINE_METHOD];
	relsize = new_size.height;
	
	//if (TRUE == self.editing) {
		relsize = relsize + 48;
	//}
	
	printf("[height]new size %d \n", relsize);
	
	__COMMON_FUNC_EXIT__
	return RECIPE_TABLEVIEWCELL_NAME_HEIGHT + RECIPE_TABLEVIEWCELL_SEPERATOR_HEIGHT + relsize + RECIPE_TABLEVIEWCELL_SEPERATOR_HEIGHT + RECIPE_TABLEVIEWCELL_COUNT_HEIGHT;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

//////// cell object decision ///////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)pindexPath {
	__COMMON_FUNC_ENTER__
	
	
	NSIndexPath* indexPath = nil;
	
#ifdef _ONEVIEW
	//// create indexpath //////
	Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];
	NSInteger selected = [pListObject getCurrentNoteIndex];
	NSInteger sec = [self getSectionForNoteSelected:selected];
	indexPath = [NSIndexPath indexPathForRow:pindexPath.row
						    inSection:sec];
	////////////////////////////
#else
	indexPath = pindexPath;
#endif
	
	// Dequeue or if necessary create a RecipeTableViewCell, then set its recipe to the recipe for the current row.
	static NSString *RecipeCellIdentifier = @"RecipeCellIdentifier";
	
	printf("cellForRowAtIndexPath: row [%d] section [%d]\n", indexPath.row, indexPath.section);
		
	RecipeTableViewCell *recipeCell = (RecipeTableViewCell *)[tableView 
								  dequeueReusableCellWithIdentifier:RecipeCellIdentifier];

	if (recipeCell == nil) {
		recipeCell = [[[RecipeTableViewCell alloc] 
				initWithStyle:UITableViewCellStyleDefault 
			       reuseIdentifier:RecipeCellIdentifier] 
				autorelease];
	}
	
	recipeCell.tt.delegate = self;
	recipeCell.nameLabel.delegate = self;
	
	[self configureCell:recipeCell atIndexPath:indexPath];
	
	/** upper bg */
	UIView *bgColor = [recipeCell viewWithTag:100];
	if (!bgColor) {
		CGRect frame = CGRectMake(0, 
					  0, 
					  320, 
					  40);
		bgColor = [[UIView alloc] initWithFrame:frame];
		bgColor.tag = 100; //tag id to access the view later
		[recipeCell addSubview:bgColor];
		[recipeCell sendSubviewToBack:bgColor];
		[bgColor release];
	}
	
	bgColor.backgroundColor = [UIColor colorWithRed:205.0/255.0
						  green:205.0/255.0
						   blue:203.0/255.0
						  alpha:0.9];	
	__COMMON_FUNC_EXIT__
	return recipeCell;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)configureCell:(RecipeTableViewCell *)cell atIndexPath:(NSIndexPath *)pindexPath {
	__COMMON_FUNC_ENTER__
	
	NSIndexPath* indexPath = nil;
	
	printf("===========Recipe to View===========\n");
#ifdef _ONEVIEW
	//// create indexpath /////////////////////////////////////////////////////////////
	Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];
	NSInteger selected = [pListObject getCurrentNoteIndex];
	NSInteger sec = [self getSectionForNoteSelected:selected];
	indexPath = [NSIndexPath indexPathForRow:pindexPath.row
						    inSection:sec];
	////////////////////////////////////////////////////////////////////////////////////
		printf("* index path section[%d] row[%d]\n", sec, indexPath.row);
#else
	indexPath = pindexPath;
		printf("* index path section[%d] row[%d]\n", indexPath.section , indexPath.row);
#endif
	
	Recipe *recipe = (Recipe *)[fetchedResultsController objectAtIndexPath:indexPath];
	
	NSLog(@"* note %@", recipe.noteName);
	NSLog(@"* name %@", recipe.name);
	NSLog(@"* desc %@", recipe.overview);
	NSLog(@"* temp %@", recipe.instructions);
	printf("=================================\n");
	cell.recipe = recipe;
	
	__COMMON_FUNC_EXIT__
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

//////// height decision ///////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	__COMMON_FUNC_ENTER__
	printf("didselectron\n");
	__COMMON_FUNC_EXIT__
}
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Override to support editing the table view. ////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
						forRowAtIndexPath:(NSIndexPath *)pindexPath {
	__COMMON_FUNC_ENTER__
	NSIndexPath* indexPath = nil;
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
#ifdef _ONEVIEW
		///////// create indexpath /////////////////////////////////////////////////////////////
		Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];
		NSInteger selected = [pListObject getCurrentNoteIndex];
		NSInteger sec = [self getSectionForNoteSelected:selected];
		indexPath = [NSIndexPath indexPathForRow:pindexPath.row
							    inSection:sec];
		////////////////////////////////////////////////////////////////////////////////////
#else
		indexPath = pindexPath;
#endif
		
		//////// Delete the managed object for the given index path ////////////////////////////
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		////////////////////////////////////////////////////////////////////////////////////
		
		// Save the context. ////////////////////////////////////////////////////////
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			__COMMON_FUNC_EXIT__
			abort();
		}
		////////////////////////////////////////////////////////////////////////////////////
	}
	
	__COMMON_FUNC_EXIT__
	return;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark Fetched results controller
- (NSFetchedResultsController *)fetchedResultsController {
	__COMMON_FUNC_ENTER__
	
	// Set up the fetched results controller if needed.
	if (fetchedResultsController == nil) {
		NSLog(@"$$$$$$$$ coredata init ##########");
		// Create the fetch request for the entity.
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		// Edit the entity name as appropriate.
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" 
							inManagedObjectContext:managedObjectContext];
		[fetchRequest setEntity:entity];
		
		// Edit the sort key as appropriate.
		NSSortDescriptor *noteDescriptor = [[NSSortDescriptor alloc] initWithKey:@"noteName" ascending:NO];
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"prepTime" ascending:NO];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:noteDescriptor, sortDescriptor, nil];
		
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		// Edit the section name key path and cache name if appropriate.
		// nil for section name key path means "no sections".
		NSFetchedResultsController *aFetchedResultsController 
		= [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
						      managedObjectContext:managedObjectContext 
							sectionNameKeyPath:@"noteName"  
								 cacheName:nil];
		
		aFetchedResultsController.delegate = self;
		self.fetchedResultsController = aFetchedResultsController;
		
		[aFetchedResultsController release];
		[fetchRequest release];
	}
	
	__COMMON_FUNC_EXIT__
	return fetchedResultsController;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	__COMMON_FUNC_ENTER__
	/*
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	
	NSSortDescriptor *noteDescriptor = [[NSSortDescriptor alloc] initWithKey:@"noteName" ascending:NO];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"prepTime" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, noteDescriptor, nil];
	
	
	[[fetchedResultsController fetchRequest] setSortDescriptors:sortDescriptors];
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Handle you error here
	}
	
	[self.tableView reloadData];
	 */
	
	if(false == addIsActivate){
		NSLog(@"beginupdate!!!");
		[self.tableView beginUpdates];
	} else {
		NSLog(@"no beginupdate");
	}
	__COMMON_FUNC_EXIT__
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	__COMMON_FUNC_ENTER__
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	if(false ==  addIsActivate){
		NSLog(@"endupdate!!!");
		[self.tableView endUpdates];
	} else {
		NSLog(@"no endupdate");
	}
	__COMMON_FUNC_EXIT__
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject 
								atIndexPath:(NSIndexPath *)pindexPath 
								forChangeType:(NSFetchedResultsChangeType)type 
								newIndexPath:(NSIndexPath *)newIndexPath {
	__COMMON_FUNC_ENTER__
	
	if(true ==  addIsActivate){
		__COMMON_FUNC_EXIT__
		return;
	}
	
	printf("* at indexPath row[%d] section[%d]\n", pindexPath.section, pindexPath.row);
	printf("* change type [%d]\n", type);
	
	UITableView *tableView = self.tableView;
	
	NSIndexPath* indexPath = nil;
	
#ifdef _ONEVIEW
	//// create indexpath /////
	Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];	
	NSInteger selected = [pListObject getCurrentNoteIndex];
	NSInteger sec = [self getSectionForNoteSelected:selected];
	indexPath = [NSIndexPath indexPathForRow:pindexPath.row
						    inSection:sec];
	///////////////////////////
#else
	indexPath = pindexPath;
#endif
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			NSLog(@"$$$$  NSFetchedResultsChangeInsert  $$$$");
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
								withRowAnimation:UITableViewRowAnimationFade];
			 
			__COMMON_FUNC_EXIT__
			return;
			
		case NSFetchedResultsChangeDelete:
			NSLog(@"$$$$  NSFetchedResultsChangeDelete  $$$$");
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
								withRowAnimation:UITableViewRowAnimationFade];
			__COMMON_FUNC_EXIT__
			return;
			
		case NSFetchedResultsChangeUpdate:
			NSLog(@"$$$$  NSFetchedResultsChangeUpdate  $$$$");
			[self configureCell:(RecipeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] 
								atIndexPath:indexPath];
			__COMMON_FUNC_EXIT__
			return;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
								withRowAnimation:UITableViewRowAnimationFade];
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
								withRowAnimation:UITableViewRowAnimationFade];
			__COMMON_FUNC_EXIT__
			return;
		default:
			__COMMON_FUNC_EXIT__			
			return;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo 
								atIndex:(NSUInteger)sectionIndex 
								forChangeType:(NSFetchedResultsChangeType)type {
	__COMMON_FUNC_ENTER__
	printf("* sectionIndex [%d]\n", sectionIndex);
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			/*
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] 
				      withRowAnimation:UITableViewRowAnimationFade];
			 */
			/*
			 Nothing to insert section - only one section currently
			 */
			__COMMON_FUNC_EXIT__
			return;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] 
				      withRowAnimation:UITableViewRowAnimationFade];
			__COMMON_FUNC_EXIT__
			return;
		default:
			__COMMON_FUNC_EXIT__
			return;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark -
#pragma mark UITableViewDelegate

static UITextView* temp = NULL;

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	__COMMON_FUNC_ENTER__
	NSString* det = nil;
	Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];
	
	printf("=========================================\n");
#ifdef _ONEVIEW
	NSInteger selected = [pListObject getCurrentNoteIndex];
	det = [pListObject getNotenameForIndex:selected];
#else
	det = [pListObject getNotenameForIndex:section];
#endif
	NSLog(@"* HEADER TITLE [%@]", det);
	printf("=========================================\n");	
	__COMMON_FUNC_EXIT__
	return det;
	
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	__COMMON_FUNC_ENTER__
	// Detemine if it's in editing mode
	if (temp == NULL) {
		__COMMON_FUNC_EXIT__
		return UITableViewCellEditingStyleDelete;
	} else {
		__COMMON_FUNC_EXIT__
		return UITableViewCellEditingStyleNone;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

static CGFloat savedHeight = 0.0;

- (void) done {
	__COMMON_FUNC_ENTER__
	[temp resignFirstResponder];
	
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
	self.navigationItem.rightBarButtonItem = addButtonItem;
	
	temp = NULL;
	[addButtonItem release];
	__COMMON_FUNC_EXIT__
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////// 슈드 다음부터 불림 //////////////////////////////////////////////////////////////////////////////
- (void)textViewDidChange:(UITextView *)textView {
	__COMMON_FUNC_ENTER__
	printf("textViewDidChange\n");
	
	RecipeTableViewCell *det = (RecipeTableViewCell*) textView.superview.superview;
	NSIndexPath* kk = [self.tableView indexPathForCell:det];
	Recipe *recipe = (Recipe *)[fetchedResultsController objectAtIndexPath:kk];
	
	if(det.nameLabel == textView) {
		__COMMON_FUNC_EXIT__
		return;
		
	} else {
		CGSize new_size = [ textView.text  
				   sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]
				   constrainedToSize:CGSizeMake(DESCRIPTION_LINE_WIDTH_MAX,9999) 
				   lineBreakMode:DESCRIPTION_LINE_METHOD];
		
		printf("* current size [%f]\n", new_size.height);
		
		if(savedHeight != new_size.height) {
			printf("* prev %f current %f\n", savedHeight, new_size.height);
			savedHeight = new_size.height;
			recipe.instructions = [NSString stringWithFormat:@"%@", det.tt.text];
		}

		__COMMON_FUNC_EXIT__
		return;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)textViewDidBeginEditing:(UITextView *)textView {
	__COMMON_FUNC_ENTER__
	savedHeight = 0.0;
	
	RecipeTableViewCell *det = (RecipeTableViewCell*) textView.superview.superview;
	
	UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
										      target:self 
										      action:@selector(done)] autorelease];
	
	self.navigationItem.rightBarButtonItem = rightButton;
	
	RecipeTableViewCell *recipeCell = (RecipeTableViewCell*) textView.superview.superview;

	NSLog(@"name: %@", recipeCell.nameLabel.text);
	NSLog(@"desc: %@", recipeCell.tt.text);
	
	Recipe* recipe = nil;
	NSIndexPath* kk = [self.tableView indexPathForCell:det];
	
	printf("indpath %d and %d\n", kk.row, kk.section);
#ifdef _ONEVIEW
	
	Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];	
	NSInteger selected = [pListObject getCurrentNoteIndex];
	NSInteger sec = [self getSectionForNoteSelected:selected];
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:kk.row
						    inSection:sec];
	printf("* indexPath row:[%d] section:[%d]\n", indexPath.row, indexPath.section);
	recipe = (Recipe *)[fetchedResultsController objectAtIndexPath:indexPath];

	NSLog(@"-note [%@]", recipe.noteName);
	NSLog(@"-name [%@]", recipe.name);
	NSLog(@"-desc [%@]", recipe.overview);
	NSLog(@"-temp [%@]", recipe.instructions);
#else
#endif
	
	if(YES == [@"+ add a new one" isEqualToString:recipeCell.nameLabel.text]) {
		recipeCell.nameLabel.text = @"";
		recipeCell.nameLabel.textColor = [UIColor blackColor];
	}
	
	if(YES == [@"+ add a new descriptions" isEqualToString:recipeCell.tt.text]) {
		recipeCell.tt.text = @"";
		recipeCell.tt.textColor = [UIColor blackColor];
	}
	
	if(textView != det.nameLabel) {
		int total = 0;
		/* count '\n' */
		int i =0;
		for(i=0;i<det.tt.text.length;i++) {
			total++;
		}
		det.wordcount.text = [NSString stringWithFormat:@"%d", total];	
	}
	
	
	temp = textView;
	
	__COMMON_FUNC_EXIT__
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)textViewDidEndEditing:(UITextView *)textView {
	__COMMON_FUNC_ENTER__
	printf("===========================================\n");
	printf("* edit finish\n");
	printf("===========================================\n");
	
	RecipeTableViewCell *det = (RecipeTableViewCell*) textView.superview.superview;
	
	if(YES == [@"" isEqualToString:det.nameLabel.text]) {
		det.nameLabel.text = @"+ add a new one";
		det.nameLabel.textColor = [UIColor grayColor];
		__COMMON_FUNC_EXIT__
		return;
	}
	
	if(YES == [@"" isEqualToString:det.tt.text]) {
		det.tt.text = @"+ add a new descriptions";
		det.tt.textColor = [UIColor grayColor];
	}
	
	NSIndexPath* kk = [self.tableView indexPathForCell:det];
	Recipe* recipe = nil;
	printf("* indexPath row:[%d] section:[%d]\n", kk.row, kk.section);
	
#ifdef _ONEVIEW
	Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];	
	NSInteger selected = [pListObject getCurrentNoteIndex];
	NSInteger sec = [self getSectionForNoteSelected:selected];
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:kk.row
						    inSection:sec];
	printf("* indexPath row:[%d] section:[%d]\n", indexPath.row, indexPath.section);
	recipe = (Recipe *)[fetchedResultsController objectAtIndexPath:indexPath];

#else
	recipe = (Recipe *)[fetchedResultsController objectAtIndexPath:kk];
#endif
	
	printf("===========================================\n");
	printf("* original\n");
	NSLog(@"-note [%@]", recipe.noteName);
	NSLog(@"-name [%@]", recipe.name);
	NSLog(@"-desc [%@]", recipe.overview);
	NSLog(@"-temp [%@]", recipe.instructions);
	printf("===========================================\n");
	printf("* To fix\n");
	NSLog(@"-name [%@]", det.nameLabel.text);
	NSLog(@"-desc [%@]", det.tt.text);
	NSLog(@"-temp [%@]", det.tt.text);
	printf("===========================================\n");
	recipe.name = det.nameLabel.text;
	recipe.overview = det.tt.text;
	recipe.instructions = det.tt.text;
	
	NSError *error = nil;
	if (![recipe.managedObjectContext save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		__COMMON_FUNC_EXIT__
		abort();
	}
	
	det.wordcount.text = @"";
	
	temp = NULL;
	__COMMON_FUNC_EXIT__
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////단어 하나마다 불림/////////////////////////////////////////////////////////////////////////////
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	printf("shouldChangeTextInRange\n");
	if(textView.tag == 1){ // title
		
		if([text isEqualToString:@"\n"]) {
			printf("* return key pushed!!! (name)\n");
			
			RecipeTableViewCell *det = (RecipeTableViewCell*) textView.superview.superview;
			NSIndexPath* kk = [self.tableView indexPathForCell:det];
			Recipe *recipe = (Recipe *)[fetchedResultsController objectAtIndexPath:kk];
			recipe.name = [NSString stringWithFormat:@"%@", det.nameLabel.text];
			
			/* same as done */
			[temp resignFirstResponder];
			
			UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] 
							  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
							  target:self 
							  action:@selector(add:)];
			
			self.navigationItem.rightBarButtonItem = addButtonItem;
			
			[addButtonItem release];
			
			/* 나중에 타이머로 바꿔야 함 */
			/* 현재 저장 기능 빠져있음. 넣어야 함 */
			/*
			NSString* lan = CWStringLanguageDetect(recipe.name);
			NSLog(@"ret %@", lan);
			NSString* tzt = CWTranslatedString(recipe.name, lan);
			NSLog(@"ret %@", tzt);
			recipe.overview = tzt;
			det.tt.text = recipe.overview;
			 */
		}
	} else { // details
		
		RecipeTableViewCell *det = (RecipeTableViewCell*) textView.superview.superview;
		
		int total = 0;
		int line = 1;
		/* count '\n' */
		int i =0;
		for(i=0;i<det.tt.text.length;i++) {
			if('\n' == [det.tt.text characterAtIndex:i]) {
				line += 1;
			}
			total++;
		}
		
		NSLog(@"* input char [%@]", text);
		printf("* key pushed!!! (detail) total (%d) line[%d]\n", total, line);
		
		det.wordcount.text = [NSString stringWithFormat:@"%d", total];
	}

	return TRUE;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Memory management
- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
	[super dealloc];
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
