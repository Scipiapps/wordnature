
/*
 복수 개의 네이게이터를 관리할 수 있어야 한다.
 */

@interface Platform_navWrapper : NSObject {
	//UINavigationController* navController; //deprecated
	NSMutableDictionary* navDictionary;
}

//@property (nonatomic, retain) UINavigationController* navController; //deprecated
@property (nonatomic, retain) NSMutableDictionary* navDictionary;

//+(Platform_navWrapper*) sharedInstance; //deprecated
+(Platform_navWrapper*) sharedInstance;
-(void) createWithRoot:(UIViewController*)root forKey:(NSString*)key;
-(UINavigationController*) getAtKey:(NSString*)key;

@end

