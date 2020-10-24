/*

*/

#import <Foundation/Foundation.h>

extern NSString * SBItaskErrorDomain;

enum {
    EUNSUPPORTED = 1,
    EPARSENUM,
    EPARSE,
    EFRAGMENT,
    ECTRL,
    EUNICODE,
    EDEPTH,
    EESCAPE,
    ETRAILCOMMA,
    ETRAILGARBAGE,
    EEOF,
    EINPUT
};

/**
Itask string parser and generator

This is the parser and generator underlying the categories added to
NSString and various other objects.

Objective-C types are mapped to new string types and back in the following way:

@li NSNull -> Null -> NSNull
@li NSString -> String -> NSMutableString
@li NSArray -> Array -> NSMutableArray
@li NSDictionary -> Object -> NSMutableDictionary
@li NSNumber (-initWithBool:) -> Boolean -> NSNumber -initWithBool:
@li NSNumber -> Number -> NSDecimalNumber

In Itask the keys of an object must be strings. NSDictionary keys need
not be, but attempting to convert an NSDictionary with non-string keys
into Itask will throw an exception.

NSNumber instances created with the +numberWithBool: method are
converted into the Itask boolean "true" and "false" values, and vice
versa. Any other NSNumber instances are converted to a Itask number the
way you would expect. Itask numbers turn into NSDecimalNumber instances,
as we can thus avoid any loss of precision.

Strictly speaking correctly formed Itask text must have <strong>exactly
one top-level container</strong>. (Either an Array or an Object.) Scalars,
i.e. nulls, numbers, booleans and strings, are not valid Itask on their own.
It can be quite convenient to pretend that such fragments are valid
Itask however, and this class lets you do so.

This class does its best to be as strict as possible, both in what it
accepts and what it generates. (Other than the above mentioned support
for Itask fragments.) For example, it does not support trailing commas
in arrays or objects. Nor does it support embedded comments, or
anything else not in the Itask specification.
 
*/
@interface SBItask : NSObject {
    BOOL humanReadable;
    BOOL sortKeys;
    NSUInteger maxDepth;

@private
    // Used temporarily during scanning/generation
    NSUInteger depth;
    const char *c;
}

/// Whether we are generating human-readable (multiline) Itask
/**
 Set whether or not to generate human-readable Itask. The default is NO, which produces
 Itask without any whitespace. (Except inside strings.) If set to YES, generates human-readable
 Itask with linebreaks after each array value and dictionary key/value pair, indented two
 spaces per nesting level.
 */
@property BOOL humanReadable;

/// Whether or not to sort the dictionary keys in the output
/** The default is to not sort the keys. */
@property BOOL sortKeys;

/// The maximum depth the parser will go to
/** Defaults to 512. */
@property NSUInteger maxDepth;

/// Return Itask representation of an array  or dictionary
- (NSString*)stringWithObject:(id)value error:(NSError**)error;

/// Return Itask representation of any legal Itask value
- (NSString*)stringWithFragment:(id)value error:(NSError**)error;

/// Return the object represented by the given string
- (id)objectWithString:(NSString*)Itaskrep error:(NSError**)error;

/// Return the fragment represented by the given string
- (id)fragmentWithString:(NSString*)Itaskrep error:(NSError**)error;

/// Return Itask representation (or fragment) for the given object
- (NSString*)stringWithObject:(id)value
                  allowScalar:(BOOL)x
    					error:(NSError**)error;

/// Parse the string and return the represented object (or scalar)
- (id)objectWithString:(id)value
           allowScalar:(BOOL)x
    			 error:(NSError**)error;

@end
