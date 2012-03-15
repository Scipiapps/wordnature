
#import "zedoul_common.h"
#import "NoteSelectorTableViewCell.h"
#import "Platform_textView.h"


@interface NoteSelectorTableViewCell (SubviewFrames)
- (CGRect)_nameLabelFrame;
- (CGRect)_addLabelFrame;
@end


@implementation NoteSelectorTableViewCell

@synthesize name;
@synthesize nameLabel;
@synthesize addLabel;

/* 폰트를 조절한다. */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	printf("initWithStyle\n");
	
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[nameLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
		[nameLabel setTextColor:[UIColor blackColor]];
		[self.contentView addSubview:nameLabel];
		
		addLabel = [[UITextField alloc] initWithFrame:CGRectZero];
		[addLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
		[addLabel setTextColor:[UIColor blackColor]];
		[self.contentView addSubview:addLabel];
	}
	
	return self;
}

- (void)layoutSubviews {
	printf("layoutSubviews\n");
	[super layoutSubviews];
	
	[nameLabel setFrame:[self _nameLabelFrame]];
	[addLabel setFrame:[self _addLabelFrame]];
}

- (CGRect)_nameLabelFrame {
	printf("_nameLabelFrame\n");
	
	if (self.tag == 1) {
		return CGRectZero;
	} else {
		return CGRectMake(30,7,200,30);
	}
}

- (CGRect)_addLabelFrame {
	printf("_addLabelFrame\n");
	
	if (self.tag == 1) {
		return CGRectMake(30,7,200,30);
	} else {
		return CGRectZero;
	}
}

- (void)setName:(NSString *)newName {
	printf("setName\n");
	
	[name release];
	name = [newName retain];
	
	if([newName isEqualToString:@"+ add a note"]){
		self.addLabel.text = newName;
		self.tag = 1;
		self.addLabel.textColor = [UIColor grayColor];
	} else {
	 
		self.nameLabel.text = newName;
		self.tag = 0;
	}
}

@end
