trigger AttendanceNotedTrigger on Attendance__c (after insert, after update) 
{
	List<Task> newTasks = new List<Task>(); 
	Program_Session__c current_session=null;
	Program_Session__c previous_session=null;
	String subject = 'Unknown event';
	for (Attendance__c attend: Trigger.new)
	{
		if (attend.Attended__c)
		{
    		Task logContact = new Task (Subject='Event: ' + attend.Event_name__c, WhoID=attend.Young_Person__c, Status='Completed');
    		logContact.Description = attend.Comment__c;
    		newTasks.add(logContact);

		}
	}
	if (newTasks.size() > 0) insert newTasks;
}