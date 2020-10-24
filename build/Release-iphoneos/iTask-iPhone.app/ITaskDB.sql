CREATE TABLE tasks(
	taskID				INTEGER PRIMARY KEY AUTOINCREMENT,
	desktopID			TEXT,
	title			    TEXT,
	completionDate		REAL,
	priority			INTEGER,
	dueDate				REAL,
	calendar			TEXT,
	url					TEXT,
	notes				TEXT);

CREATE TABLE alarms(
	alarmID				INTEGER PRIMARY KEY AUTOINCREMENT,
	taskID				INTEGER,
	triggerDate			REAL,
	action				TEXT,
	email				TEXT,
	relativeDate		REAL,
	sound				TEXT,
	url					TEXT);