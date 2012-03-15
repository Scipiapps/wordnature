
@interface NoteSelector : UITableViewController <NSFetchedResultsControllerDelegate,
						UITextFieldDelegate> {
}

+(NoteSelector*) sharedInstance;

@end
