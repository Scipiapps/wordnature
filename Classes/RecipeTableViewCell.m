#import "RecipeTableViewCell.h"
#import "zedoul_common.h"

#pragma mark -
#pragma mark SubviewFrames category

@interface RecipeTableViewCell (SubviewFrames)
- (CGRect)_nameLabelFrame; /** name */
//- (CGRect)_abstractFrame; /** abstract */
- (CGRect)_menuFrame; /** menu */
- (CGRect)_ttFrame; /** description */
- (CGRect)_wordcountFrame; /** count */
@end


#pragma mark -
#pragma mark RecipeTableViewCell implementation
@implementation RecipeTableViewCell

@synthesize recipe, imageView, tt, nameLabel, wordcount, menubar;//, description_temp;

#pragma mark -
#pragma mark Initialization

#define NAME_TEXT_FONT_SIZE 16.0
#define DETAIL_TEXT_FONT_SIZE 14.0

/* 폰트를 조절한다. */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	__COMMON_FUNC_ENTER__
	printf("initWithStyle\n");
	
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		/* 좌측 첫 번째 */
		nameLabel = (Platform_textView*)[[UITextView alloc] initWithFrame:CGRectZero];
		[nameLabel setFont:[UIFont boldSystemFontOfSize:NAME_TEXT_FONT_SIZE]];
		[nameLabel setTextColor:[UIColor blackColor]];
		nameLabel.contentInset = UIEdgeInsetsZero;
		[self.contentView addSubview:nameLabel];
		nameLabel.tag = 1;
		
		/* 좌측 하단 */
		tt = (Platform_textView*)[[UITextView alloc] initWithFrame:CGRectZero];
		tt.textAlignment = UITextAlignmentLeft;
		[tt setFont:[UIFont systemFontOfSize:DETAIL_TEXT_FONT_SIZE]];
		[tt setTextColor:[UIColor blackColor]];
		tt.contentInset = UIEdgeInsetsZero;
		[self.contentView addSubview:tt];
		
		/* bottom */
		wordcount = [[UITextView alloc] initWithFrame:CGRectZero];
		wordcount.textAlignment = UITextAlignmentLeft;
		[wordcount setFont:[UIFont systemFontOfSize:DETAIL_TEXT_FONT_SIZE]];
		[wordcount setTextColor:[UIColor blackColor]];
		wordcount.contentInset = UIEdgeInsetsZero;
		wordcount.scrollEnabled = NO;
		wordcount.text = @"";
		wordcount.editable = NO;
		[self.contentView addSubview:wordcount];
		
		menubar = [[UIView alloc] initWithFrame:CGRectZero];
//		menubar.tag = 101;
		/*
		if (!menubar) {
			CGRect frame = CGRectMake(0,
						  self.contentView.bounds.size.height,
						  320,
						  50);
			menubar = [[UIView alloc] initWithFrame:frame];
			menubar.tag = 101; //tag id to access the view later
			//[wordcount addSubview:menubar];
			//[self sendSubviewToBack:bgColor2];
			[menubar release];
		}
		*/
		menubar.backgroundColor = [UIColor colorWithRed:23.0/255.0
							   green:23.0/255.0
							    blue:203.0/255.0
							   alpha:0.7];
		[self.contentView addSubview:menubar];
		
		/*
		UIView *bgColor2 = [self viewWithTag:101];
		if (!bgColor2) {
			CGRect frame = CGRectMake(0,
						  self.contentView.bounds.size.height,
						  320,
						  50);
			bgColor2 = [[UIView alloc] initWithFrame:frame];
			bgColor2.tag = 101; //tag id to access the view later
			[wordcount addSubview:bgColor2];
			//[self sendSubviewToBack:bgColor2];
			[bgColor2 release];
		}
		
		bgColor2.backgroundColor = [UIColor colorWithRed:23.0/255.0
							   green:23.0/255.0
							    blue:203.0/255.0
							   alpha:0.7];
		 */
	}
	__COMMON_FUNC_EXIT__
	return self;
}


#pragma mark -
#pragma mark Laying out subviews

/*
 To save space, the prep time label disappears during editing.
 */
- (void)layoutSubviews {
	__COMMON_FUNC_ENTER__
	printf("layoutSubviews\n");
	[super layoutSubviews];
	
	[nameLabel setFrame:[self _nameLabelFrame]];
	[menubar setFrame:[self _menuFrame]];
	[tt setFrame:[self _ttFrame]];
	[wordcount setFrame:[self _wordcountFrame]];
	__COMMON_FUNC_EXIT__
}


#define EDITING_INSET       10.0
#define TEXT_LEFT_MARGIN    8.0
#define TEXT_RIGHT_MARGIN   5.0

- (CGRect)_nameLabelFrame {
	__COMMON_FUNC_ENTER__
	
	if (self.editing) {
		__COMMON_FUNC_EXIT__
		return CGRectMake(EDITING_INSET + TEXT_LEFT_MARGIN, 
				  4.0, 
				  self.contentView.bounds.size.width - EDITING_INSET - TEXT_LEFT_MARGIN, 
				  NAME_TEXT_FONT_SIZE*2);
	}
	else {
		__COMMON_FUNC_EXIT__
		return CGRectMake(TEXT_LEFT_MARGIN, 
				  4.0, 
				  self.contentView.bounds.size.width - TEXT_RIGHT_MARGIN * 3, 
				  NAME_TEXT_FONT_SIZE*2);
	}
}

- (CGRect) _menuFrame {
	__COMMON_FUNC_ENTER__
	
	if (self.editing) {
		__COMMON_FUNC_EXIT__
		return CGRectMake(0,
				  48, 
				  320,
				  NAME_TEXT_FONT_SIZE*2);
	}
	else {
		__COMMON_FUNC_EXIT__
		return CGRectMake(0,
				  0, 
				  0,
				  0);
	}
}

- (CGRect) _ttFrame {
	__COMMON_FUNC_ENTER__
	
	if(YES == [@"+ add a new one" isEqualToString:nameLabel.text]) {
		__COMMON_FUNC_EXIT__
	 	return CGRectMake(0, 
				  0, 
				  0.0, 
				  0.0);
	} else {
		CGSize new_size = [tt.text 
				   sizeWithFont:[UIFont fontWithName:@"Helvetica" size:DETAIL_TEXT_FONT_SIZE]
				   constrainedToSize:CGSizeMake(DESCRIPTION_LINE_WIDTH_MAX,9999) 
				   lineBreakMode:DESCRIPTION_LINE_METHOD];
		
		printf("new size %f %f\n", new_size.height, new_size.width);
		__COMMON_FUNC_EXIT__
		return CGRectMake(10, 
				  48.0 + 20.0, 
				  300.0 , 
				  new_size.height + 38);
	}
}

/*
 Return the frame of the various subviews -- these are dependent on the editing state of the cell.
 */ 
- (CGRect)_wordcountFrame {
	__COMMON_FUNC_ENTER__
	printf("_wordcountFrame\n");
	/*
	if(self.editing) {
		
		CGRect frame;
		UIView *bgColor = [self viewWithTag:100];
		if (!bgColor) {
			frame = CGRectMake(0, 
						  self.contentView.bounds.size.height-30, 
						  320, 
						  40);
			bgColor = [[UIView alloc] initWithFrame:frame];
			bgColor.tag = 100; //tag id to access the view later
			
			[self addSubview:bgColor];
			[self sendSubviewToBack:bgColor];
			[bgColor release];
		}
		
		bgColor.backgroundColor = [UIColor colorWithRed:23.0/255.0
							  green:23.0/255.0
							   blue:183.0/255.0
							  alpha:0.7];
		
		return frame;
		
	} else {
	*/
	
	
		if(YES == [@"+ add a new one" isEqualToString:nameLabel.text]) {
			__COMMON_FUNC_EXIT__
			return CGRectMake(0, 0, 0.0, 0.0);
		} else {
			__COMMON_FUNC_EXIT__	
			return CGRectMake(0,
					  self.contentView.bounds.size.height-70, 
					  self.contentView.bounds.size.width, 
					  70);
		}
	//}

}

#pragma mark -
#pragma mark Recipe set accessor

- (void)setRecipe:(Recipe *)newRecipe {
	__COMMON_FUNC_ENTER__
	if (newRecipe != recipe) {
		[recipe release];
		recipe = [newRecipe retain];
	}
	
	imageView.image = recipe.thumbnailImage;
	
	if(YES == [recipe.overview isEqualToString:recipe.instructions]) {
		printf("* change!!! \n");
		tt.text = recipe.overview;
	}
	
	tt.scrollEnabled = NO;
	
	nameLabel.text = recipe.name;
	nameLabel.scrollEnabled = NO;
	
	if(YES == [@"+ add a new one" isEqualToString:nameLabel.text]) {
	 	nameLabel.textColor = [UIColor grayColor];
	} else {
		nameLabel.textColor = [UIColor blackColor];
	}
	
	if(YES == [@"+ add a new descriptions" isEqualToString:tt.text]) {
	 	tt.textColor = [UIColor grayColor];
	} else {
		tt.textColor = [UIColor blackColor];
	}
	
	
	__COMMON_FUNC_EXIT__
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	__COMMON_FUNC_ENTER__
	[recipe release];
	[imageView release];
	[tt release];
	[nameLabel release];
	[super dealloc];
	__COMMON_FUNC_EXIT__
}

@end
