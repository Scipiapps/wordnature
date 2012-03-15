#import "zedoul_common.h"

#import "RecipesAppDelegate.h"
#import "RecipeListTableViewController.h"
#import "CardViewController.h"
#import "Platform_tabWrapper.h" 
#import "Platform_navWrapper.h" 
#import "NoteSelector.h"
#import "Platform_pListWrapper.h"
#import "SettingView.h"
#import "Custom_UIToolbar.h"

@implementation RecipesAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize recipeListController;

- (void)test {
	__COMMON_FUNC_ENTER__
	NSLog(@"asdfsdaf\n");
	__COMMON_FUNC_EXIT__
}

//#define _TEST_VIEW

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	//// pList loading ///////////////////////////////////////////////////////////////////////////
	Platform_pListWrapper* pListObject = [Platform_pListWrapper sharedInstance];
	[pListObject create:@"notes.plist"];
	//////////////////////////////////////////////////////////////////////////////////////////////
	
	/* word view setting */
	recipeListController = [[RecipeListTableViewController alloc] initWithStyle:UITableViewStylePlain];
	recipeListController.title = @"words";
	recipeListController.managedObjectContext = self.managedObjectContext;
	/* navigator setting */
	Platform_navWrapper* InstanceofnavWrapper = [Platform_navWrapper sharedInstance];
	[InstanceofnavWrapper createWithRoot:recipeListController forKey:@"words"];
	
#ifdef _TEST_VIEW
	/* card view test */
	CardViewController* yy = [[CardViewController alloc] init];
	yy.title = @"Card";
	
	/* setting view test */
	SettingView* settingview = [[SettingView alloc] init];
	settingview.title = @"Test";
	
	
	/* tab setting */
	Platform_tabWrapper* InstanceoftabWrapper = [Platform_tabWrapper sharedInstance];
	
	InstanceoftabWrapper.tabController.viewControllers = [NSArray arrayWithObjects:[InstanceofnavWrapper getAtKey:@"words"], 
											yy,
											settingview,
											nil];
	
	//[InstanceofnavWrapper.tabController.viewControllers addSubview:];// .backGroundColor setColor:[UIColor blueColor]];
	
	/* View showing */
	[window addSubview:InstanceoftabWrapper.tabController.view];
#else
	
	Custom_UIToolbar *toolbar;
	toolbar = [Custom_UIToolbar new];
	toolbar.barStyle = UIBarStyleDefault;
	toolbar.backgroundColor = [UIColor redColor]; 
	[toolbar sizeToFit];
	CGFloat toolbarHeight = [toolbar frame].size.height;
	CGRect mainViewBounds = [InstanceofnavWrapper getAtKey:@"words"].view.bounds;
	[toolbar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
				     CGRectGetMaxY(mainViewBounds) - toolbarHeight,
				     CGRectGetWidth(mainViewBounds),
				     toolbarHeight)];
	
	// create a bordered style button with custom title
	UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithTitle:@"Setting"
								     style:UIBarButtonItemStyleBordered
								    target:self
								    action:@selector(test)];
	UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
								    target:self
								    action:@selector(test)];
	UIBarButtonItem *searchstopItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
										    target:self
										    action:@selector(test)];
	// flex item used to separate the left groups items and right grouped items
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
										  target:nil
										  action:nil];
	UIBarButtonItem *testItem = [[UIBarButtonItem alloc] initWithTitle:@"Test"
								       style:UIBarButtonItemStylePlain
								      target:self
								      action:@selector(test)];
	
	NSArray *toolbaritems = [NSArray arrayWithObjects: settingItem, 
				 flexItem, 
				 searchItem,
				 flexItem,  
				 searchstopItem, 
				 flexItem, 
				 testItem,
				 nil];
	
	[toolbar setItems:toolbaritems animated:NO];
	
	
	
	
	
	[window addSubview:[InstanceofnavWrapper getAtKey:@"words"].view];
	[window addSubview:toolbar];
#endif
	[window makeKeyAndVisible];
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        }
    }
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
		printf("%s %d\n", __func__, __LINE__);
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [NSManagedObjectContext new];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
		printf("%s %d\n", __func__, __LINE__);
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
		printf("%s %d\n", __func__, __LINE__);
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
		
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Recipes.sqlite"];
	/*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Recipes" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
		
    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
    [recipeListController release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end
