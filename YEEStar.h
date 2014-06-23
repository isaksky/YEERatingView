//
//  YEEStar.h
//  YouEye Recorder
//
//  Created by Isak Sky on 5/12/14.
//
//

#import <Cocoa/Cocoa.h>

typedef enum { YEEStarStateNone, YEEStarStateOn, YEEStarStateMouseOver, YEEStarStateWillRemove } YEEStarState;

#define YEEStarBounds ((NSRect){0, 0, 50, 40})

static NSColor *YEEStarDefaultColorForStateNone;
static NSColor *YEEStarDefaultColorForStateOn;
static NSColor *YEEStarDefaultColorForStateMouseOver;
static NSColor *YEEStarDefaultColorForStateWillRemove;

@interface YEEStar : NSView

@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL mouseInside;
@property (nonatomic) BOOL higherStarHasMouseInside;

@property (nonatomic) YEEStarState state;

@property (nonatomic, strong) NSColor *colorForStateNone;
@property (nonatomic, strong) NSColor *colorForStateOn;
@property (nonatomic, strong) NSColor *colorForStateMouseOver;
@property (nonatomic, strong) NSColor *colorForStateWillRemove;

@end
