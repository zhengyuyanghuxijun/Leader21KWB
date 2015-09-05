//
//  RC4.m
//  Enigma
//
//  Created by le grand fromage on 9/3/09.
//  Copyright 2009 WildMouse Solutions. All rights reserved.
//

#import "RC4.h"

@implementation RC4

//property synthesizers
@synthesize key;

- (id)init{
	if (self = [super init]) {
        //
    };
	return self;
}

- (id)initWithKey:(NSString *)initKey{
	if (self = [super init]) {
        self.key = initKey;
    };
	return self;
}


- (NSString *)encryptString:(NSString *)stringToEncrypt{

	[self initialize]; // set up an initialize state
	NSMutableString *rfunc = [[NSMutableString alloc] init]; // allocate the return string
	int iStringLength = [stringToEncrypt length]; // declare a variable to take the length of the incoming string
	unsigned char k;
	unsigned char t;
	
	// loop to grab all characters one at a time and send them through the array
	for (int c = 0; c < iStringLength; c++){
		k = abs ([self KSA]); // call the key stream selector
		t = [stringToEncrypt characterAtIndex:c]; // a temp variable to store the last taken in character from the array
		[rfunc appendFormat:@"%02x", (unsigned char)(k ^ t)]; // xor the characters, then into hexadecimal
		//[rfunc appendString:@" "]; // with spaces
	}
	return rfunc; // return the hexadecimal string with spaces
}

// initialize the array and work through key string
- (void)initialize{

	//set up array with 256 elements, numbered 0 through 255
	for (int a = 0; a < 256; a++)
	{
		s[a] = a;
	}
	/* set up array with 256 elements, numbered 0 through 255 for key string*/
	for (int b = 0; b < 256; b++)
	{
		j = (j + s[b] + [key characterAtIndex:(b % key.length)]) % 256;
		//	 [self swap( b, j)];
		[self swap:b swap2:j];
	}
	i = j = 0;
}


- (unsigned char)KSA{
	i = (i + 1) % 256;
	j = (j + s[i]) % 256;
	//	swap(
	[self swap:i swap2:j];
	return s[(s[i] + s[j]) % 256];
}


// swap the arguments to get them all
- (void)swap:(int)iFirstArgument swap2:(int)iSecondArgument{
	
	unsigned char tempVar; // make a temporary variable
	tempVar = s[iFirstArgument];
	s[iFirstArgument] = s[iSecondArgument];
	s[iSecondArgument] = tempVar;
}


- (NSString *)decryptString:(NSString *)stringToDecrypt{

	//TODO: Extra Credit: implement this function to decrypt stringToDecrypt using the RC4 algorithm.
	return @"";
}

@end
