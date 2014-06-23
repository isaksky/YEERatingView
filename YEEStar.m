//
//  YEEStar.m
//  YouEye Recorder
//
//  Created by Isak Sky on 5/12/14.
//
//

#import "YEEStar.h"

@interface YEEStar ()

@end

@implementation YEEStar

+ (void)initialize {
    YEEStarDefaultColorForStateNone =  [NSColor colorWithCalibratedWhite:1 alpha:0.4];
    YEEStarDefaultColorForStateMouseOver = [NSColor colorWithCalibratedWhite:1 alpha:0.8];
    YEEStarDefaultColorForStateOn = [NSColor colorWithCalibratedRed:1 green:0.82 blue:0.04 alpha:1];
    YEEStarDefaultColorForStateWillRemove = [NSColor colorWithCalibratedRed:1 green:0.82 blue:0.04 alpha:0.33];
}


- (id)init {
    self = [super initWithFrame:YEEStarBounds];
    if (self) {
        NSTrackingArea *trackingArea = [NSTrackingArea.alloc initWithRect:YEEStarBounds
                                                                  options:NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways
                                                                    owner:self
                                                                 userInfo:nil];
        [self addTrackingArea:trackingArea];
        
        self.colorForStateNone = YEEStarDefaultColorForStateNone;
        self.colorForStateMouseOver = YEEStarDefaultColorForStateMouseOver;
        self.colorForStateOn = YEEStarDefaultColorForStateOn;
        self.colorForStateWillRemove = YEEStarDefaultColorForStateWillRemove;
        
        self.state = YEEStarStateNone;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSColor *fillColor = nil;
    switch (self.state) {
        case YEEStarStateNone:
            fillColor = self.colorForStateNone;
            break;
        case YEEStarStateMouseOver:
            fillColor = self.colorForStateMouseOver;
            break;
        case YEEStarStateOn:
            fillColor = self.colorForStateOn;
            break;
        case YEEStarStateWillRemove:
            fillColor = self.colorForStateWillRemove;
            break;
        default:
            break;
    }
    
    NSBezierPath* starPath = [NSBezierPath bezierPath];
    [starPath moveToPoint: NSMakePoint(25, 38.5)];
    [starPath lineToPoint: NSMakePoint(32.05, 28.21)];
    [starPath lineToPoint: NSMakePoint(44.02, 24.68)];
    [starPath lineToPoint: NSMakePoint(36.41, 14.79)];
    [starPath lineToPoint: NSMakePoint(36.76, 2.32)];
    [starPath lineToPoint: NSMakePoint(25, 6.5)];
    [starPath lineToPoint: NSMakePoint(13.24, 2.32)];
    [starPath lineToPoint: NSMakePoint(13.59, 14.79)];
    [starPath lineToPoint: NSMakePoint(5.98, 24.68)];
    [starPath lineToPoint: NSMakePoint(17.95, 28.21)];
    [starPath closePath];
    [fillColor setFill];
    [starPath fill];

}

- (void)mouseEntered:(NSEvent *)theEvent{
    self.mouseInside = YES;
}

- (void)mouseExited:(NSEvent *)theEvent {
    self.mouseInside = NO;
}

- (id)initWithFrame:(NSRect)frameRect {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)setState:(YEEStarState)state {
    _state = state;
    self.needsDisplay = YES;
}

@end
