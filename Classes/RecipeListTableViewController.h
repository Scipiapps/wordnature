//@protocol RecipeAddDelegate;

@class Recipe;
@class RecipeTableViewCell;

@interface RecipeListTableViewController : UITableViewController <
								NSFetchedResultsControllerDelegate,
								UITextViewDelegate> {
	//@private
        NSFetchedResultsController *fetchedResultsController;
        NSManagedObjectContext *managedObjectContext;
}

//@property(nonatomic, assign) id <RecipeAddDelegate> delegate;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

+ (NSFetchedResultsController*)getFetch ;
+ (NSManagedObjectContext*)getContext ;
+ (NSIndexPath*) getIndexPath;
+ (UITableView*) getTableView;
- (void)configureCell:(RecipeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

//@protocol RecipeAddDelegate <NSObject>
//
//@end
