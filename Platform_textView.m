#import "Platform_textView.h"

@implementation Platform_textView


-(UIEdgeInsets) contentInset {
		printf("textView:contentInset\n");
	return UIEdgeInsetsZero;
}
 

-(void) setContentOffset:(CGPoint)s {
	printf("textView:setContentOffset\n");
	
	[self setContentInset:UIEdgeInsetsZero];//, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
	[super setContentOffset:s];
	/*
	printf("textView:setContentOffset");
	if(self.tracking || self.decelerating){
		self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	} else {
		
		float bottomOffset = (self.contentSize.height - self.frame.size.height + self.contentInset.bottom);
		if(s.y < bottomOffset && self.scrollEnabled){
			self.contentInset = UIEdgeInsetsMake(0, 0, 8, 0); //maybe use scrollRangeToVisible?
		}
	}
	
	[super setContentOffset:s];
	 */
}

-(void) setContentInset:(UIEdgeInsets) s {
	printf("textView:setContentInset");
	UIEdgeInsets insets = s;
	if(s.bottom > 8){
		insets.bottom = 0;
	}
	insets.top = 0;
	
	[super setContentInset:insets];
}
/*
-(void) scrollRectToVisible:(CGRect) rect animated:(BOOL) animated {
	printf("textView:scrollRectToVisible");
	return;
}*/


-(void) deadlloc {
	[super dealloc];
}
@end
