trigger MonitorCampaignMembers on CampaignMember (after insert, after update) 
{
	// If Monitor_Campaign__c is true
	// then for both leads and contacts
	// on insert, increment the sent counter on the lead or contact
	// on update, if the status has changed and responded is true, increment the responded counter on the lead or contact
	Set<ID>LeadIDs = new Set<ID>();
	Set<ID>ContactIDs = new Set<ID>();
	Set<ID>CampaignIDs = new Set<ID>();
	
	for (CampaignMember oneMember: Trigger.new)
	{
		CampaignIDs.add (oneMember.CampaignId);
		if (oneMember.LeadId != null) LeadIDs.add(oneMember.LeadId);	
		else if (oneMember.ContactId != null) ContactIDs.add(oneMember.ContactId);	
	}
	Map<ID,Lead>Leads = new Map<ID,Lead>([select ID, Donation_requests_responded__c, Donation_requests_sent__c from Lead where ID in :LeadIDs]);
	Map<ID,Contact>Contacts = new Map<ID,Contact>([select ID, Donation_requests_responded__c, Donation_requests_sent__c from Contact where ID in :ContactIDs]);
	Map<ID,Campaign>Campaigns = new Map<ID,Campaign>([Select ID, Monitor_Campaign__c from Campaign where ID in :CampaignIDs]);
	
	for (CampaignMember oneMember: Trigger.new)
	{
		Campaign camp = Campaigns.get(oneMember.CampaignID);
		if (camp != null && camp.Monitor_Campaign__c)
		{
			Lead oneLead = oneMember.LeadID == null ? null : Leads.get(oneMember.LeadID);
			Contact oneContact = oneMember.ContactID == null ? null : Contacts.get(oneMember.ContactID);
			if (Trigger.isInsert)
			{
				if (oneLead != null) 
				{
					if (oneLead.Donation_requests_sent__c == null) oneLead.Donation_requests_sent__c=1;
					else oneLead.Donation_requests_sent__c++;
				}
				else if (oneContact != null) 
				{
					if (oneContact.Donation_requests_sent__c == null) oneContact.Donation_requests_sent__c=1;
					else oneContact.Donation_requests_sent__c++;
				}
			}
			else if (oneMember.HasResponded)
			{
				CampaignMember oldMember = Trigger.oldMap.get (oneMember.id);
				if (oldMember == null || !oldMember.HasResponded)
				{
					if (oneLead != null) 
					{
						if (oneLead.Donation_requests_responded__c == null) oneLead.Donation_requests_responded__c=1;
						else oneLead.Donation_requests_responded__c++;
					}
					else if (oneContact != null) 
					{
						if (oneContact.Donation_requests_responded__c == null) oneContact.Donation_requests_responded__c=1;
						else oneContact.Donation_requests_responded__c++;
					}
				}
			}
		}
	}
	if (Leads.size() > 0) update Leads.Values();
	if (Contacts.size() > 0) update Contacts.Values();
}