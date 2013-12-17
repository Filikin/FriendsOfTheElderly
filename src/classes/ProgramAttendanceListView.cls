public with sharing class ProgramAttendanceListView 
{
    private Program_Session__c session = null;
    private Attendance__c [] attendances = null;
    public ProgramAttendanceListView (ApexPages.StandardController controller)
    {
        session = (Program_Session__c)controller.getRecord();
        Initialise ();
    }
    
    public ProgramAttendanceListView (Program_Session__c sess)
    {
        session = sess;
        Initialise ();
    }
    
    private void Initialise ()
    {
        attendances = [select Name, id, Young_Person_Name__c, young_person__c, attended__c, comment__c from Attendance__c where Program_Session__c = :session.id];
    }
    
    public Attendance__c [] getAttendanceList ()
    {
        return attendances;
    }
    
    public PageReference submit ()
    {
        update attendances;
        String theId = ApexPages.currentPage().getParameters().get('id');
 
        // Redirect the user back to the original page
        PageReference pageRef = new PageReference('/' + theId);
        pageRef.setRedirect(true);
        return pageRef;
    }
}