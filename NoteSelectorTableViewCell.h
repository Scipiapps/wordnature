

@interface NoteSelectorTableViewCell : UITableViewCell {
	NSString* name;
	UITextField* addLabel;
	UILabel* nameLabel;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UITextField *addLabel;
@property (nonatomic, retain) UILabel *nameLabel;

@end
