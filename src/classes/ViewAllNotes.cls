public with sharing class ViewAllNotes 
{
	public List<Note> notes = new Note[]{};
    public ID recordID;
    public String recordName;
  	
    public ViewAllNotes(ApexPages.StandardController controller) 
    {
        notes = [SELECT Body, IsPrivate,CreatedBy.Name,CreatedDate,Title FROM Note where ParentId = :System.currentPageReference().getParameters().get('id') order by CreatedDate DESC];
        sObject con = controller.getRecord();
        recordID = con.id;
        recordName = [select Name from Contact where id = :con.id].Name;
    }
    
    public List<Note> getContactNotes() 
    {
        return notes;
    }
    
    public PageReference newNote() 
    {
    	String shortID = recordID;
    	shortID = shortID.substring(0,15);
        PageReference newNote = new PageReference('/002/e?parent_id=' + shortID + '&retURL=%2F' + recordID);
        
        return newNote;
    }
    
	public static testMethod viewAllNotes testViewAllNotes()
    {
        Contact Therapist = new Contact(lastname='Therapist',firstname='apex', MailingCountry='Ireland'); 
        insert Therapist;
        ApexPages.StandardController contactController = new ApexPages.StandardController(Therapist);
        return new viewAllNotes (contactController);
    }

    public static testMethod void testRemainingBits ()
    {
    	ViewAllNotes thisClass = testViewAllNotes();
    	thisClass.getContactNotes();
    	thisClass.newNote();
	}
}