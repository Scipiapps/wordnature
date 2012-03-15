#import "Platform_pListWrapper.h"

@implementation Platform_pListWrapper

static Platform_pListWrapper* InstanceofPlatform_pListWrapper= nil;

@synthesize defaults; 

- (id) init {
	static BOOL initialized = NO;
	if(NO == initialized) {
		self = [super init];
		InstanceofPlatform_pListWrapper = self;
		initialized = YES;
	}
	return self;
}

+ (id) allocWithZone:(NSZone*) zone{
	@synchronized (self){
		if( NO == InstanceofPlatform_pListWrapper){
			InstanceofPlatform_pListWrapper = [super allocWithZone:zone];
		}
	}
	return InstanceofPlatform_pListWrapper;
}

+(Platform_pListWrapper*) sharedInstance{
	if( nil == InstanceofPlatform_pListWrapper){
		InstanceofPlatform_pListWrapper = [[Platform_pListWrapper alloc] init];
	}
	return InstanceofPlatform_pListWrapper;
}

-(void) create:(NSString*)path {
	NSString* ibundlePath = [[NSBundle mainBundle] bundlePath];
	NSString* pListPath = [ibundlePath stringByAppendingPathComponent:path];
	NSLog(@"path %@", pListPath);
	NSDictionary* pListTimesheet = [NSDictionary dictionaryWithContentsOfFile:pListPath] ;
	
	NSLog(@"description %@", [pListTimesheet description]);
	
	self.defaults = [NSUserDefaults standardUserDefaults];
	[self.defaults registerDefaults:pListTimesheet];
	[self.defaults synchronize];
}

-(void) destroy{
	/* FIX ME - should be implemented */
}

-(NSMutableArray*) getArrayForKey:(NSString*)key {
	return [self.defaults objectForKey:key]; 
}

-(NSInteger) addNotename:(NSString*)noteName {
	
	NSMutableArray* array = [[NSMutableArray alloc] initWithArray:[self.defaults objectForKey:@"notes"]]; 
	
	[array insertObject:noteName
		    atIndex:0];
	
	[self.defaults setObject:array forKey:@"notes"];
	[self.defaults synchronize];
	
	return TRUE;
}

-(NSInteger) delNotenameForIndex:(NSInteger) index {
	printf("%s", __func__);
	
	NSMutableArray* array = [[NSMutableArray alloc] initWithArray:[self.defaults objectForKey:@"notes"]];
	
	if([array count] <= (index)){
		return FALSE;
	}
	
	[array removeObjectAtIndex:index];
	
	[self.defaults setObject:array forKey:@"notes"];
	[self.defaults synchronize];
	
	return TRUE;
}

-(NSString*) getNotenameForIndex:(NSInteger) index {
	NSString* ret = nil;
		
	NSMutableArray* array = [[NSMutableArray alloc] initWithArray:[self.defaults objectForKey:@"notes"]]; 

	printf("note count [%d] and index [%d]\n", [array count], index);
	if([array count] <= (index)){
		return nil;
	}
	
	ret = [array objectAtIndex:index];
	return ret;
}

-(NSInteger) setCurrentNoteIndex:(NSInteger) newvalue{
	NSInteger a = [self.defaults integerForKey:@"current_note_index"];
	printf("current note index [%d] and it will be changed to [%d]", a, newvalue);
	[self.defaults setInteger:newvalue forKey:@"current_note_index"];
	return TRUE;
}

-(NSInteger) getCurrentNoteIndex {
	NSInteger a = [self.defaults integerForKey:@"current_note_index"];
	return a;
}

-(NSInteger) getCount {
	
	if( nil == self.defaults ) {
		return -1;
	}
	
	return [[self.defaults objectForKey:@"notes"] count];
}

-(NSInteger) clear {
	NSMutableArray* array = [[NSMutableArray alloc] initWithArray:[self.defaults objectForKey:@"notes"]]; 
	[array removeAllObjects];
	
	[self.defaults setObject:array forKey:@"notes"];
	[self.defaults synchronize];
	
	return TRUE;
}

@end