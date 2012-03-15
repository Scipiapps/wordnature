
@interface Platform_pListWrapper : NSObject {
	NSUserDefaults* defaults;
}

@property (nonatomic, retain) NSUserDefaults* defaults;

+(Platform_pListWrapper*) sharedInstance;

-(void) create:(NSString*)path;
-(void) destroy;

-(NSMutableArray*) getArrayForKey:(NSString*)key;
-(NSInteger) addNotename:(NSString*)noteName;
-(NSInteger) delNotenameForIndex:(NSInteger) index;
-(NSString*) getNotenameForIndex:(NSInteger) index;
-(NSInteger) setCurrentNoteIndex:(NSInteger) newvalue;
-(NSInteger) getCurrentNoteIndex;
-(NSInteger) getCount;
-(NSInteger) clear;

@end
