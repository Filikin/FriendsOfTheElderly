@isTest
private class TestCampaignMonitor 
{
    static testMethod void LeadCampaignMonitorTest()
    {
    	Lead testLead = new Lead (FirstName = 'Test', LastName = 'Testing123', Company = 'TestAccount', EMail = 'test@test123.com', Status='Sent');
    	insert testLead;
    	
    	Campaign camp = new Campaign (Name='Test', Monitor_Campaign__c=true);
    	insert camp;
    	CampaignMember cm = new CampaignMember (CampaignID=camp.id, LeadId=testLead.id);
    	insert cm;
    	
    	Lead tl = [select ID, Donation_requests_responded__c, Donation_requests_sent__c from Lead where ID=:testLead.id];
    	System.AssertEquals (1, tl.Donation_requests_sent__c);
    	System.AssertEquals (null, tl.Donation_requests_responded__c);
    	
    	cm.Status = 'Responded';
    	update cm;
    	
    	tl = [select ID, Donation_requests_responded__c, Donation_requests_sent__c from Lead where ID=:testLead.id];
    	System.AssertEquals (1, tl.Donation_requests_responded__c);
   
       	Campaign camp2 = new Campaign (Name='Test2', Monitor_Campaign__c=true);
    	insert camp2;
    	CampaignMember cm2 = new CampaignMember (CampaignID=camp2.id, LeadId=testLead.id);
    	insert cm2;
    	
    	Lead tl2 = [select ID, Donation_requests_responded__c, Donation_requests_sent__c from Lead where ID=:testLead.id];
    	System.AssertEquals (2, tl2.Donation_requests_sent__c);
    	System.AssertEquals (1, tl2.Donation_requests_responded__c);

    	cm2.Status = 'Responded';
    	update cm2;
    	
    	tl2 = [select ID, Donation_requests_responded__c, Donation_requests_sent__c from Lead where ID=:testLead.id];
    	System.AssertEquals (2, tl2.Donation_requests_responded__c);
    }

    static testMethod void ContactCampaignMonitorTest()
    {
    	Contact testContact = new Contact (FirstName = 'Test', LastName = 'Testing123', EMail = 'test@test123.com');
    	insert testContact;
    	
    	Campaign camp = new Campaign (Name='Test', Monitor_Campaign__c=true);
    	insert camp;
    	CampaignMember cm = new CampaignMember (CampaignID=camp.id, ContactId=testContact.id);
    	insert cm;
    	
    	Contact tl = [select ID, Donation_requests_responded__c, Donation_requests_sent__c from Contact where ID=:testContact.id];
    	System.AssertEquals (1, tl.Donation_requests_sent__c);
    	System.AssertEquals (null, tl.Donation_requests_responded__c);
    	
    	cm.Status = 'Responded';
    	update cm;
    	
    	tl = [select ID, Donation_requests_responded__c, Donation_requests_sent__c from Contact where ID=:testContact.id];
    	System.AssertEquals (1, tl.Donation_requests_responded__c);

    	Campaign camp2 = new Campaign (Name='Test2', Monitor_Campaign__c=true);
    	insert camp2;
    	CampaignMember cm2 = new CampaignMember (CampaignID=camp2.id, ContactId=testContact.id);
    	insert cm2;
    	
    	Contact tl2 = [select ID, Donation_requests_responded__c, Donation_requests_sent__c from Contact where ID=:testContact.id];
    	System.AssertEquals (2, tl2.Donation_requests_sent__c);
    	System.AssertEquals (1, tl2.Donation_requests_responded__c);

    	cm2.Status = 'Responded';
    	update cm2;
    	
    	tl2 = [select ID, Donation_requests_responded__c, Donation_requests_sent__c from Contact where ID=:testContact.id];
    	System.AssertEquals (2, tl2.Donation_requests_responded__c);
    }
}