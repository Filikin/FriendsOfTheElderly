/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class testLeadToActivityTrigger 
{
	static testMethod void ConvertLeadToActivityTest()
    {
    	Contact volunteer = new Contact (FirstName='Fred', LastName='Volunteer', Volunteer_Type__c='Home', Email='someone@somewhere.com', GCT_Volunteer__c=true);
    	insert volunteer;
 	
		Contact olderPerson = new Contact (FirstName='Agnes', LastName='OldPerson', GCT_OAP__c=True, Status_of_OAP__c='Active', Volunteer_visitor__c=volunteer.id);
		insert olderPerson;
		olderPerson = [select id, Contact_ID__c from Contact where id=:olderPerson.ID];
		    	
    	Lead[] leadsbefore = [select ID, Name from Lead];

    	Lead testLead = new Lead (Type_of_Contact__c='Visit', FirstName = 'Test', LastName = 'Testing123', Company = 'TestAccount', EMail = 'someone@somewhere.com', How_are_visits_going__c='Well', Keeping_warm__c=True, Older_person_ID__c=olderPerson.Contact_ID__c, Followup_required__c=True, Comments_concerns_or_other_information__c='Please Ring');
    	insert testLead;
    	
    	Lead[] leadsafter = [select ID, Name from Lead];
    	System.Assert (leadsafter.size() > leadsbefore.size());
    	
    	Contact updatedContact = [select ID, Date_of_last_visit__c, Action_required__c, Description_of_action_required__c from Contact where Contact_ID__c=:olderPerson.Contact_ID__c limit 1];
    	System.Assert (updatedContact.Action_required__c, 'Action required not updated');
    	System.Assert (updatedContact.Description_of_action_required__c.contains(testLead.Comments_concerns_or_other_information__c), 'Lead comment not in updated contact');
    	
    	Task createdTask = [select ID, Keeping_warm__c from Task where Subject='Visit' and WhoID=:olderPerson.Id limit 1];
    	
    	System.AssertEquals (updatedContact.Date_of_last_visit__c, system.today());
    }
    
    static testMethod void CreateAccountOnRelatedOrgTest()
    {
    	Contact volunteer = new Contact (FirstName='Fred', LastName='Volunteer', Volunteer_Type__c='Home', Email='someone@somewhere.com', Related_Org_name__c='Test org23');
    	insert volunteer;
    	
    	Account orgCreated = [select id, Name from Account where Name='Test org23' limit 1];
    	volunteer = [select id, Related_Organisation__c from Contact where id=:volunteer.id limit 1];
    	
    	System.AssertEquals (volunteer.Related_Organisation__c, orgCreated.Id);
    }
}