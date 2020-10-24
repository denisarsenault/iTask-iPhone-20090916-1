//
//  AlarmCell.m
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/12/08.
//  
//

#import "AlarmCell.h"
#import "Alarm.h"

@implementation AlarmCell

@synthesize alarm, label, relativeDateLabel,  dateOffset, emailLabel, soundLabel, urlLabel, alarmActionLabel, dueDate, dateFormatter;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
	{
		self.target = self;
		self.accessoryType = UITableViewCellAccessoryNone;
		self.accessoryAction = @selector(onClick:);
		
		// cell's  label
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.backgroundColor = [UIColor clearColor];
		label.opaque = NO;
		label.textColor = [UIColor blackColor];
		label.highlightedTextColor = [UIColor whiteColor];
		label.font = [UIFont boldSystemFontOfSize:14.0];
		label.text = NSLocalizedString( @"Alarm", @"");
		[self.contentView addSubview:label];
		
		
		//action value
		alarmActionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		alarmActionLabel.backgroundColor = [UIColor clearColor];
		alarmActionLabel.opaque = NO;
		alarmActionLabel.textColor = [UIColor blueColor];
		alarmActionLabel.textAlignment = UITextAlignmentLeft;
		alarmActionLabel.highlightedTextColor = [UIColor whiteColor];
		alarmActionLabel.font = [UIFont systemFontOfSize:14.0];
		alarmActionLabel.text = NSLocalizedString( @"None", @"");
		[self.contentView addSubview:alarmActionLabel];
		
		
		
		// relative date  value
		dateOffset = [[UILabel alloc] initWithFrame:CGRectZero];
		dateOffset.backgroundColor = [UIColor clearColor];
		dateOffset.opaque = NO;
		dateOffset.textColor = [UIColor darkGrayColor];
		dateOffset.highlightedTextColor = [UIColor whiteColor];
		dateOffset.font = [UIFont systemFontOfSize:14.0];
		[self.contentView addSubview:dateOffset];
		
		
		
		// relative date  value
		relativeDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		relativeDateLabel.backgroundColor = [UIColor clearColor];
		relativeDateLabel.opaque = NO;
		relativeDateLabel.textColor = [UIColor darkGrayColor];
		relativeDateLabel.highlightedTextColor = [UIColor whiteColor];
		relativeDateLabel.font = [UIFont systemFontOfSize:14.0];
		[self.contentView addSubview:relativeDateLabel];
		
		// emailLabel  value
		emailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		emailLabel.backgroundColor = [UIColor clearColor];
		emailLabel.opaque = NO;
		emailLabel.textColor = [UIColor darkGrayColor];
		emailLabel.highlightedTextColor = [UIColor whiteColor];
		emailLabel.font = [UIFont systemFontOfSize:14.0];
		[self.contentView addSubview:emailLabel];

		
		// soundLabel  value
		soundLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		soundLabel.backgroundColor = [UIColor clearColor];
		soundLabel.opaque = NO;
		soundLabel.textColor = [UIColor darkGrayColor];
		soundLabel.highlightedTextColor = [UIColor whiteColor];
		soundLabel.font = [UIFont systemFontOfSize:14.0];
		[self.contentView addSubview:soundLabel];

		
		// time  value
		urlLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		urlLabel.backgroundColor = [UIColor clearColor];
		urlLabel.opaque = NO;
		urlLabel.textColor = [UIColor darkGrayColor];
		urlLabel.highlightedTextColor = [UIColor whiteColor];
		urlLabel.font = [UIFont systemFontOfSize:14.0];
		[self.contentView addSubview:urlLabel];
		
		
		
		// Create a date formatter to convert the date to a string format.
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
	return self;
}

- (void)dealloc {
    // Release allocated resources.
    [alarmActionLabel release];
	[label release];
	[dateOffset release];
	[relativeDateLabel release];
//	[timeLabel release];
	[emailLabel release];
    [super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
    CGRect contentRect = [self.contentView bounds];
	
	// layout the label
	CGRect frame = CGRectMake(contentRect.origin.x + 10.0, 5.0, 100, 30.0);
	label.frame = frame;
	
	// layout the alarmActionLabel field
	frame = CGRectMake(contentRect.size.width - 180, 5.0, contentRect.size.width - 10, 30.0);
	alarmActionLabel.frame = frame;
	
	if(alarm){
		alarmActionLabel.text = [alarm getActionString];
		relativeDateLabel.text = [alarm getAlarmDateStringWithDueDate:dueDate];
//		timeLabel.text = [alarm getAlarmTimeStringWithDueDate:dueDate];
		emailLabel.text = alarm.email;
		soundLabel.text = alarm.sound;
		urlLabel.text = alarm.url;
		
			
		
		// The alarm action determins which of the following fields will appear below, and their relative position.
		switch (alarm.alarmActionType) {
				
			case alarmActionNone:
				break;
				
			case alarmActionMessage:

				// layout the relativeDateLabel field
				frame = CGRectMake(contentRect.size.width - 200, 23.0, 150, 30.0);
				relativeDateLabel.frame = frame;
				
				// layout the timeLabel field
//				frame = CGRectMake(contentRect.size.width - 200, 41.0, 150, 30.0);
//				timeLabel.frame = frame;
				
				break;
				
			case alarmActionEmail:
				
				// layout the emailLabel recipient field
				frame = CGRectMake(contentRect.size.width - 200, 23.0, 150, 30.0);
				emailLabel.frame = frame;
				
				// layout the relativeDateLabel field
				frame = CGRectMake(contentRect.size.width - 200, 41.0, 150, 30.0);
				relativeDateLabel.frame = frame;

				
				// layout the timeLabel field
//				frame = CGRectMake(contentRect.size.width - 200, 59.0, 150, 30.0);
//				timeLabel.frame = frame;

				break;
				
			case alarmActionRunScript:
				
				// layout the urlLabel  field
				frame = CGRectMake(contentRect.size.width - 200, 23.0, 150, 30.0);
				urlLabel.frame = frame;
				
				// layout the timeLabel field
				frame = CGRectMake(contentRect.size.width - 200, 41.0, 150, 30.0);
				relativeDateLabel.frame = frame;
				
				
				// layout the timeLabel field
//				frame = CGRectMake(contentRect.size.width - 200, 59.0, 150, 30.0);
//				timeLabel.frame = frame;
				break;
				
			case alarmActionMessageWithSound:
				
				// layout the soundLabel  field
				frame = CGRectMake(contentRect.size.width - 200, 23.0, 150, 30.0);
				soundLabel.frame = frame;
				
				// layout the timeLabel field
				frame = CGRectMake(contentRect.size.width - 200, 41.0, 150, 30.0);
				relativeDateLabel.frame = frame;
				
				
				// layout the timeLabel field
	//			frame = CGRectMake(contentRect.size.width - 200, 59.0, 150, 30.0);
	//			timeLabel.frame = frame;
				break;
				break;
				
			default:
				break;
		}
		
		
	}
	
}




@end
