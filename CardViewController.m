
#import "CardView.h"
#import "CardViewController.h"
#import "RecipeListTableViewController.h"
#import "Recipe.h"

@implementation CardViewController

@synthesize section;
@synthesize row;
@synthesize containerView;
@synthesize reflectionView;
@synthesize flipIndicatorButton;

#define reflectionFraction 0.35
#define reflectionOpacity 0.5

-(void) refresh {
	
	NSInteger numberOfRows = 0;
	NSFetchedResultsController *fetchedResultsController = [RecipeListTableViewController getFetch];
	
	if ([[fetchedResultsController sections] count] > 0) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:self.section];
		numberOfRows = [sectionInfo numberOfObjects];
	}
	
	UIScrollView *scrollView = [[UIScrollView alloc] init];
	[scrollView setBackgroundColor:[UIColor whiteColor]];
	[scrollView setCanCancelContentTouches:NO];
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;	// default is NO, we want to restrict drawing within our scrollview
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	
	NSInteger index = 0;
	
	// create and store a container view
	UIView *localContainerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.containerView = localContainerView;
	[localContainerView release];
	
	//background
	containerView.backgroundColor = [UIColor blackColor];
	//self.view = self.containerView;
	
	for(index =0 ; index < numberOfRows; index++){
		
		printf("sec[%d]. row[%d] (%d)\n", 0, index, numberOfRows);
		
		NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index
							    inSection:0];
		
		NSFetchedResultsController *fetchedResultsController = [RecipeListTableViewController getFetch];
		
		Recipe *recipe = (Recipe *)[fetchedResultsController objectAtIndexPath:indexPath];
		
		//	if(YES == [@"+ add a new one" isEqualToString:recipe.name]) {
		//		self.row = self.row + 1;
		//		indexPath = [NSIndexPath indexPathForRow:self.row inSection:self.section];
		//		recipe = (Recipe *)[fetchedResultsController objectAtIndexPath:indexPath];
		//	}
		
		//self.navigationController.navigationBarHidden = YES;
		
		//word text
		//CGRect viewRect = CGRectMake((self.containerView.bounds.size.width-256)/2, (self.containerView.bounds.size.height-256-50)/2, 256, 256);
		CGRect viewRect = CGRectMake(0, 0, self.containerView.bounds.size.width, self.containerView.bounds.size.height);
		CardView *cardview = [[CardView alloc] initWithFrame:viewRect];
		cardview.card_name = recipe.name;
		cardview.card_description = recipe.overview;
		cardview.tag = 1;
		cardview.viewController = self;
		
		NSLog(@"name %@", recipe.name);
		
		
		// create the reflection view
		/*
		 CGRect reflectionRect=viewRect;
		 // the reflection is a fraction of the size of the view being reflected
		 reflectionRect.size.height=reflectionRect.size.height*reflectionFraction;
		 // and is offset to be at the bottom of the view being reflected
		 reflectionRect=CGRectOffset(reflectionRect,0,viewRect.size.height);
		 
		 UIImageView *localReflectionImageView = [[UIImageView alloc] initWithFrame:reflectionRect];
		 self.reflectionView = localReflectionImageView;
		 [localReflectionImageView release];
		 
		 // determine the size of the reflection to create
		 NSUInteger reflectionHeight=cardview.bounds.size.height*reflectionFraction;
		 // create the reflection image, assign it to the UIImageView and add the image view to the containerView
		 reflectionView.image=[cardview reflectedImageRepresentationWithHeight:reflectionHeight];
		 reflectionView.alpha=reflectionOpacity;
		 */
		//[self.containerView addSubview:reflectionView];
		
		//if(NO == [@"+ add a new one" isEqualToString:recipe.name]) {
			[scrollView addSubview:cardview];
		//}
		[cardview release];
	}
	
	UIImageView *zview = nil;
	NSArray *subviews = [scrollView subviews];
	
	CGFloat curXLoc = 0.0;// self.containerView.bounds.size.width * t.row * -1;//0.0;
	for (zview in subviews) {
		printf("z set \n");
		if ([zview isKindOfClass:[UIView class]] && zview.tag == 1) {
			printf("frame set [%f]\n", curXLoc);
			CGRect frame = zview.frame;
			frame.origin = CGPointMake( curXLoc, 0);
			zview.frame = frame;
			curXLoc += (self.containerView.bounds.size.width);
		}
	}
	
	[scrollView setContentSize:CGSizeMake((320.0 * numberOfRows),
					      [scrollView bounds].size.height)];
	
	NSIndexPath* t = [RecipeListTableViewController getIndexPath];
	printf("========== index path %d %d \n", t.row, t.section);
	
	CGPoint newc;
	newc.x = (self.containerView.bounds.size.width) * t.row;
	newc.y = 0;
//	[scrollView setCenter:newc];
	[scrollView setContentOffset:newc animated:NO];
	printf("* center %f %f\n", scrollView.center.x, scrollView.center.y);
	
	self.view = scrollView;
}

- (void)loadView {
	[self refresh];


	return;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


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

- (void)myTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	// re-enable user interaction when the flip is completed.
	//containerView.userInteractionEnabled = YES;
	//flipIndicatorButton.userInteractionEnabled = YES;
	
}

- (void) flip {
	printf("Asfdsm\n");
	
	// setup the animation group
	/*
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(myTransitionDidStop:finished:context:)];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:containerView cache:YES];
	[UIView commitAnimations];
	*/
}

@end
