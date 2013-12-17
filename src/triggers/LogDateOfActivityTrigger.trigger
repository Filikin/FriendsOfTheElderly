trigger LogDateOfActivityTrigger on Task (before insert) 
{
	List<Task> TaskList = new List<Task>();
    Map<Id, Task> mapTasks = new Map<Id, Task>();
    Set<Id> whoIds = new Set<Id>();

    for(Task t : Trigger.new)
    {
        if (t.WhoId != null)
        {
	        //Add the task to the Map and Set
            mapTasks.put(t.WhoId, t);
            whoIds.add(t.WhoId);
        }
    }
    
    List<Contact> olderPeople = [select Id, Donation_requests_sent__c, Date_of_last_phone_call__c, Date_of_last_visit__c, Date_of_last_email__c, Date_of_last_event_attended__c, Date_of_last_card_or_letter__c from Contact where ID in :whoIDs];
    for (Contact olderPerson: olderPeople)
    {
    	Task tsk = mapTasks.get(olderPerson.Id);
	    if (tsk.Subject == 'Phone call') olderPerson.Date_of_last_phone_call__c=system.today();
	    else if (tsk.Subject == 'Visit') olderPerson.Date_of_last_visit__c = system.today();
	    else if (tsk.Subject.Contains('Email:')) olderPerson.Date_of_last_email__c = system.today();
	    else if (tsk.Subject.Contains('Event:')) olderPerson.Date_of_last_event_attended__c = system.today();
	    else if (tsk.Subject.Contains('Letter')) olderPerson.Date_of_last_card_or_letter__c = system.today();
	    
	    if (tsk.Subject.Contains('Donor Letter')) olderPerson.Donation_requests_sent__c = olderPerson.Donation_requests_sent__c==null ? 1 : olderPerson.Donation_requests_sent__c+1;
    }
    update olderPeople;
}