#import "googleAPI.h"

NSString* CWCurrentLanguageIdentifier() {
	static NSString* currentLanguage = nil;
	if (currentLanguage == nil) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
		currentLanguage = [[languages objectAtIndex:0] retain];
	}
	return currentLanguage;
}

NSString* CWStringLanguageDetect(NSString* target_string) {
	static NSString* queryURL = @"http://ajax.googleapis.com/ajax/services/language/detect?v=1.0&q=%@";
	if (target_string == nil) {
		return @"Unknown";
	}
	NSString* escapedString = [target_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString* query = [NSString stringWithFormat:queryURL,
			   escapedString ];
	NSString* response = [NSString stringWithContentsOfURL:[NSURL URLWithString:query]
						      encoding:NSUTF8StringEncoding error:NULL];
	
	if (response == nil) {
		printf("no response\n");
		return @"Unknown";
	}
	
	
	NSScanner* scanner = [NSScanner scannerWithString:response];
	
	//NSLog(@"response %@", response);
	
	if (![scanner scanUpToString:@"\"language\":\"" intoString:NULL]) {
		printf("no scanner\n");
		return @"Unknown";
	}
	if (![scanner scanString:@"\"language\":\"" intoString:NULL]) {
		printf("no text\n");
		return @"Unknown";
	}
	 
	NSString* result = nil;
	if (![scanner scanUpToString:@"\"," intoString:&result]) {
		printf("err msg\n");
		return @"Unknown";
	}
	return result;
}

NSString* CWTranslatedString(NSString* string, NSString* sourceLanguageIdentifier) {
	NSString* lan_to = CWCurrentLanguageIdentifier();
	static NSString* queryURL = @"http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=%@&langpair=%@%%7C%@";
	if (sourceLanguageIdentifier == nil) {
		sourceLanguageIdentifier = @"en";
	}
	if (string == nil) {
		return string;
	}
	if ([sourceLanguageIdentifier isEqual:CWCurrentLanguageIdentifier()]) {
		lan_to = @"en";
	}
	NSString* escapedString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString* query = [NSString stringWithFormat:queryURL,
			   escapedString, sourceLanguageIdentifier, lan_to];
	NSString* response = [NSString stringWithContentsOfURL:[NSURL URLWithString:query]
						      encoding:NSUTF8StringEncoding error:NULL];
	if (response == nil) {
		printf("no response\n");
		return string;
	}
	
	NSLog(@"response %@", response);
	
	NSScanner* scanner = [NSScanner scannerWithString:response];
	if (![scanner scanUpToString:@"\"translatedText\":\"" intoString:NULL]) {
		printf("no scanner\n");
		return string;
	}
	if (![scanner scanString:@"\"translatedText\":\"" intoString:NULL]) {
		printf("no text\n");
		return string;
	}
	NSString* result = nil;
	if (![scanner scanUpToString:@"\"}" intoString:&result]) {
		printf("err msg\n");
		return string;
	}
	return result;
}