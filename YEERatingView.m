//
//  YEERatingView.m
//  YouEye Recorder
//
//  Created by Isak Sky on 5/12/14.
//
//

#import "YEERatingView.h"
#import "YEEStar.h"

@interface YEERatingView ()

@property (nonatomic, strong) NSMutableArray *stars;
@property (nonatomic, weak) YEEStar *lastStarHit;

@end

@implementation YEERatingView

- (void)dealloc {
    if (_stars) {
        for (YEEStar *star in _stars) {
            @try {
                [star removeObserver:self forKeyPath:@"mouseInside"];
            } @catch (NSException *exception) {}
        }
    }
}

- (id)init {
    NSRect rect = {0, 0, 300, 50};
    self = [super initWithFrame:rect];
    if (self) {
        _rating = -1;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _stars = NSMutableArray.new;
        
        int i = 0;
        while (i < 5) {
            YEEStar *star = YEEStar.new;
            star.translatesAutoresizingMaskIntoConstraints = NO;
            
            [star addObserver:self forKeyPath:@"mouseInside" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
            
            [self addSubview:star];
            [_stars addObject:star];
            i += 1;
        }
        
        NSView *leadSpace = [NSView.alloc initWithFrame:NSZeroRect];
        leadSpace.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:leadSpace];
        
        NSView *trailSpace = [NSView.alloc initWithFrame:NSZeroRect];
        trailSpace.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:trailSpace];
        
        NSDictionary *views = @{@"firstStar": _stars[0],
                                @"leadSpace": leadSpace,
                                @"trailSpace": trailSpace,
                                @"lastStar": _stars[_stars.count - 1] };
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[leadSpace][firstStar]" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[firstStar]-|" options:0 metrics:nil views:views]];

        i = 0;
        while (i < 4) {
            YEEStar *star1 = _stars[i];
            NSParameterAssert(star1);
            YEEStar *star2 = _stars[i + 1];
            NSParameterAssert(star2);
            
            NSDictionary *views2 = NSDictionaryOfVariableBindings(star1, star2);
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[star1(==50)][star2(==50)]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views2]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[star1(==40)]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views2]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[star2(==40)]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views2]];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:star1
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:star2
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1
                                                              constant:0]];
            
            i += 1;
        }
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[lastStar][trailSpace]|" options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:leadSpace
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:trailSpace
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1
                                                          constant:0]];
    }
    return self;
}

- (NSView *)hitTest:(NSPoint)aPoint{
    NSView *view = [super hitTest:aPoint];
    if ([view isKindOfClass:[YEEStar class]]) {
        self.lastStarHit = (YEEStar *)view;
        return self;
    } else {
        self.lastStarHit = nil;
        return view;
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (self.lastStarHit) {
        for (int i = 0; i < self.stars.count; i += 1) {
            YEEStar *star = self.stars[i];
            star.state = YEEStarStateOn;
            
            if ( self.lastStarHit == star) {
                self.rating = i;
                while (i < self.stars.count - 1) {
                    i += 1;
                    star = self.stars[i];
                    star.state = YEEStarStateNone;
                }
            }
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    BOOL isMouseInsideNotification = [keyPath isEqualToString:@"mouseInside"];
    BOOL unrated = -1 == self.rating;
    
    if ([object isKindOfClass:[YEEStar class]]) {
        assert(isMouseInsideNotification); // we should not be getting any other notifications for YEEStar
        int changeKind = ((NSNumber *)change[NSKeyValueChangeKindKey]).intValue;
        BOOL passedSubjectStar = NO;
        BOOL mouseInside = ((NSNumber *)change[NSKeyValueChangeNewKey]).boolValue;
        
        if (NSKeyValueChangeSetting == changeKind) {
            for (int starIdx = 0; starIdx < self.stars.count; starIdx += 1) {
                YEEStar *star = self.stars[starIdx];
                BOOL isSubjectStar = object == star;
                
                if (mouseInside) { // mouse entered a star
                    if (unrated) {
                        if (passedSubjectStar) {
                            star.state = YEEStarStateNone;
                        } else {
                            star.state = YEEStarStateMouseOver;
                        }
                    } else { // control is rated
                        if (starIdx <= self.rating) {
                            if (passedSubjectStar) {
                                star.state = YEEStarStateWillRemove;
                            } else {
                                star.state = YEEStarStateOn;
                            }
                        } else {
                            if (passedSubjectStar) {
                                star.state = YEEStarStateNone;
                            } else {
                                star.state = YEEStarStateMouseOver;
                            }
                        }
                    }
                } else {
                    if (unrated) {
                        star.state = YEEStarStateNone;
                    } else {
                        if (starIdx <= self.rating) {
                            star.state = YEEStarStateOn;
                        } else {
                            star.state = YEEStarStateNone;
                        }
                    }

                }
                if (isSubjectStar) { passedSubjectStar = YES; }
            }
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (id)initWithFrame:(NSRect)frameRect {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
