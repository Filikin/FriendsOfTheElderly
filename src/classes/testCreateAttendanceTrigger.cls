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
private class testCreateAttendanceTrigger 
{

    static testMethod void createAttendanceTest() 
    {
        Contact youngPerson = new Contact (LastName = 'Kelly');
        insert youngPerson;
        
        Campaign program = new Campaign (Name = 'Music');
        insert program;
        
        CampaignMember enrole = new CampaignMember (CampaignID=program.id, ContactID=youngPerson.id);
        insert enrole;
        
        Integer preAttendances = [select count() from Attendance__c];
        
        Program_Session__c session = new Program_Session__c (Programme_Event__c=program.id);
        insert session;
        
        Integer postAttendances = [select count() from Attendance__c];
        
        System.Assert (postAttendances == preAttendances + 1);
        
        ProgramAttendanceListView rsa = new ProgramAttendanceListView(session);
        rsa.submit();
        
        Attendance__c[] attends = rsa.getAttendanceList();
        for (Attendance__c oneAttend: attends)
        {
        	oneAttend.Attended__c = true;
        }
        update attends;
    }
}