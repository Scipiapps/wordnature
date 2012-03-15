#import "Recipe.h"
#import "Platform_textView.h";

#define RECIPE_TABLEVIEWCELL_SEPERATOR_HEIGHT 15
#define RECIPE_TABLEVIEWCELL_NAME_HEIGHT 48
#define RECIPE_TABLEVIEWCELL_COUNT_HEIGHT 30


#define DESCRIPTION_LINE_WIDTH_MAX 300
#define DESCRIPTION_LINE_METHOD UILineBreakModeWordWrap

/**
 * set this at tag of self.
 */
typedef enum {
	RecipeTableViewCellTypeNull=0,
	RecipeTableViewCellTypeNormal,
	RecipeTableViewCellTypeEditing,
	RecipeTableViewCellTypeTestWord,
	RecipeTableViewCellTypeTestDesc,
	RecipeTableViewCellTypeMax,
	
} RecipeTableViewCellType;

/**
 * 
 */
@interface RecipeTableViewCell : UITableViewCell {
	Recipe *recipe;
	Platform_textView *tt;
	Platform_textView *nameLabel;
	UIView* menubar;
	UITextView *wordcount;
}

@property (nonatomic, retain) Recipe *recipe;
@property (nonatomic, retain) Platform_textView *tt;
@property (nonatomic, retain) UIView* menubar;
@property (nonatomic, retain) Platform_textView *nameLabel;
@property (nonatomic, retain) UITextView *wordcount;

@end