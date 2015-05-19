#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ExpansionDirection) {
    DirectionLeft = 0,
    DirectionRight,
    DirectionUp,
    DirectionDown
};


@class DWBubbleMenuButton;

@protocol DWBubbleMenuViewDelegate <NSObject>

@optional
- (void)bubbleMenuButtonWillExpand:(DWBubbleMenuButton *)expandableView;
- (void)bubbleMenuButtonDidExpand:(DWBubbleMenuButton *)expandableView;
- (void)bubbleMenuButtonWillCollapse:(DWBubbleMenuButton *)expandableView;
- (void)bubbleMenuButtonDidCollapse:(DWBubbleMenuButton *)expandableView;

@end

@interface DWBubbleMenuButton : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, weak, readonly) NSArray *buttons;
@property (nonatomic, strong) UIView *homeButtonView;
@property (nonatomic, readonly) BOOL isCollapsed;
@property (nonatomic, weak) id <DWBubbleMenuViewDelegate> delegate;
@property (nonatomic) enum ExpansionDirection direction;
@property (nonatomic) BOOL animatedHighlighting;
@property (nonatomic) BOOL collapseAfterSelection;
@property (nonatomic) float animationDuration;
@property (nonatomic) float standbyAlpha;
@property (nonatomic) float highlightAlpha;
@property (nonatomic) float buttonSpacing;

- (id)initWithFrame:(CGRect)frame expansionDirection:(ExpansionDirection)direction;

- (void)addButtons:(NSArray *)buttons;
- (void)addButton:(UIButton *)button;
- (void)showButtons;
- (void)dismissButtons;
@end
