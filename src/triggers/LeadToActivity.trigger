trigger LeadToActivity on Lead (before insert) 
{
	private Lead[] newLeads =Trigger.new;
    For(Lead ld: newLeads)
    {
    	if (isValid(ld.Email) && isValid(ld.Older_person_ID__c))
    	{
	    	try
	    	{
	    		Contact volunteer = [select id, Name from Contact where EMail = :ld.EMail and GCT_Volunteer__c = true limit 1];
	    		Contact olderPerson = [select id, Action_required__c, Description_of_action_required__c from Contact where Contact_ID__c = :ld.Older_person_ID__c and (Volunteer_visitor__c=:volunteer.id or Volunteer_visitor2__c=:volunteer.id or Student_phone_caller__c=:volunteer.id) limit 1];
    			if (ld.Followup_required__c)
    			{
	    			if (isValid(ld.Comments_concerns_or_other_information__c))
	    			{
		    			if (!isValid(olderPerson.Description_of_action_required__c) || olderPerson.Action_required__c==False) olderPerson.Description_of_action_required__c = '';
				    	olderPerson.Description_of_action_required__c = system.today().format() + ' ' + volunteer.Name + ': ' + ld.Comments_concerns_or_other_information__c + '\r\n' + olderPerson.Description_of_action_required__c;
		    		}
		    		olderPerson.Action_required__c = True;
    			}
	    		
	    		update olderPerson;
	    		
	    		Task logContact = new Task (Subject=ld.Type_of_Contact__c, WhoID=olderPerson.Id, Status='Completed', Action_required_from_web__c=ld.Followup_required__c);
	    		if (isValid(ld.Comments_concerns_or_other_information__c)) logContact.Description=ld.Comments_concerns_or_other_information__c;
	    		if (isValid(ld.How_are_visits_going__c)) logContact.How_are_visits_going__c = ld.How_are_visits_going__c;
	    		if (isValid(ld.Behavioural_health_personality_changes__c)) logContact.Behavioural_health_personality_changes__c = ld.Behavioural_health_personality_changes__c;
	    		if (isValid(ld.Does_your_friend_have_a_hotmeal_everyday__c)) logContact.Does_the_person_have_a_hotmeal_everyday__c = ld.Does_your_friend_have_a_hotmeal_everyday__c;
	    		if (isValid(ld.Does_your_friend_have_other_visitors__c)) logContact.Does_your_friend_have_other_visitors__c = ld.Does_your_friend_have_other_visitors__c;
	    		if (isValid(ld.Do_you_enjoy_visiting_your_friend__c)) logContact.Do_you_enjoy_visiting_your_friend__c = ld.Do_you_enjoy_visiting_your_friend__c;
	    		if (isValid(ld.Do_you_have_visits_from__c)) logContact.Do_you_have_visits_from__c = ld.Do_you_have_visits_from__c;
	    		if (isValid(ld.Have_you_gotten_out_this_week__c)) logContact.Have_you_gotten_out_this_week__c = ld.Have_you_gotten_out_this_week__c;
	    		if (isValid(ld.How_do_you_feel_after_your_visits__c)) logContact.How_do_you_feel_after_your_visits__c = ld.How_do_you_feel_after_your_visits__c;
	    		if (isValid(ld.How_is_your_older_friend_feeling__c)) logContact.How_is_the_older_person_feeling__c = ld.How_is_your_older_friend_feeling__c;
	    		if (isValid(ld.Is_your_older_friend_keeping_warm__c)) logContact.Is_the_older_person_keeping_warm__c = ld.Is_your_older_friend_keeping_warm__c;
	    		if (isValid(ld.Number_of_visits_this_month__c)) logContact.Number_of_visits_this_month__c = ld.Number_of_visits_this_month__c;
	    		if (isValid(ld.The_condition_of_your_friend_s_home__c)) logContact.The_condition_of_your_friend_s_home__c = ld.The_condition_of_your_friend_s_home__c;
	    		if (isValid(ld.Visitors_during_the_day__c)) logContact.Visitors_during_the_day__c = ld.Visitors_during_the_day__c;
	    		if (isValid(ld.What_do_you_do_during_these__c)) logContact.What_do_you_do_during_these_visits__c = ld.What_do_you_do_during_these__c;
	    		if (isValidDate(ld.When_did_you_last_see_your_older_friend__c)) logContact.When_did_you_last_see_your_older_friend__c = ld.When_did_you_last_see_your_older_friend__c;
	    		if (isValid(ld.Would_you_like_us_to_call_you_again__c)) logContact.Would_you_like_us_to_call_you_again__c = ld.Would_you_like_us_to_call_you_again__c;
	       		insert logContact;
	    		
	    		ld.Status = 'Closed - Converted';
	    	}
	    	catch (Exception e)
	    	{ // assume contact not found or more than one matching email
	    		// do nothing
	    	}
    	}
    }

	public static boolean isValid (String text)
	{
		if (text <> null && text <> '' && text <> '[not provided]') return true;
		else return false;
	}

	public static boolean isValidDate (Date text)
	{
		if (text <> null) return true;
		else return false;
	}
}