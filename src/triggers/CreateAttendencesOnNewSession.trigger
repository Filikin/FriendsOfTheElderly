trigger CreateAttendencesOnNewSession on Program_Session__c (after insert) 
{
    private Program_Session__c[] newSessions =Trigger.new;
    private Attendance__c[] attendances = new List<Attendance__c>();
    For (Program_Session__c sNew: newSessions)
    {
        CampaignMember [] youngPeople = [select ContactID from CampaignMember where CampaignID = :sNew.Programme_Event__c];
        for (CampaignMember onePersonEnrolment: youngPeople)
        {
        	if (onePersonEnrolment.ContactID!=null)
        	{
	            Attendance__c oneAttended = new Attendance__c (Young_Person__c=onePersonEnrolment.ContactID, Program_Session__c=sNew.id);
    	        attendances.add (oneAttended);
        	}
        } 
    }
    if (attendances.size()>0) insert attendances;
}