//
//  ImageResizer.m
//  Halver
//
//  Created by Sean Dougall on 7/31/12.
//  Copyright (c) 2012 Figure 53. All rights reserved.
//
//  Reference: http://stackoverflow.com/questions/3038820/how-to-save-a-nsimage-as-a-new-file/3213017#3213017

#import "ImageResizer.h"

@implementation ImageResizer

- (void)resizeImageAtPath:(NSString *)inputImagePath
{
    NSString *newTwoXPath = [[inputImagePath stringByDeletingPathExtension] stringByAppendingString:@"@2x.jpg"];
    NSString *newNormalPath = inputImagePath;//[[inputImagePath stringByDeletingPathExtension] stringByAppendingString:@"_new.png"];
    
    NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithContentsOfFile:inputImagePath];
    if ( !bitmap )
    {
        NSLog( @"Error: Couldn't read input file." );
        return;
    }
    
    NSDictionary *imageProps = @{ NSImageCompressionFactor : @0.8 };
    [[bitmap representationUsingType:NSJPEGFileType properties:imageProps] writeToFile:newTwoXPath atomically:YES];
    
    NSImage *resizedImage = [[NSImage alloc] initWithSize:NSMakeSize( roundf( bitmap.size.width / 2.0 ), roundf( bitmap.size.height / 2.0 ) )];
    [resizedImage lockFocus];
    [[NSColor whiteColor] set];
    NSRectFill( NSMakeRect( 0, 0, resizedImage.size.width, resizedImage.size.height ) );
    [bitmap drawInRect:NSMakeRect( 0, 0, resizedImage.size.width, resizedImage.size.height )
              fromRect:NSMakeRect( 0, 0, bitmap.size.width, bitmap.size.height )
             operation:NSCompositeSourceAtop
              fraction:1.0
        respectFlipped:YES
                 hints:nil];
    [resizedImage unlockFocus];
    
    NSBitmapImageRep *newBitmap = [NSBitmapImageRep imageRepWithData:[resizedImage TIFFRepresentation]];
    [[newBitmap representationUsingType:NSPNGFileType properties:nil] writeToFile:newNormalPath atomically:YES];
}

@end
