package model;

import java.sql.Date;

public class Registration {
	
	private String registrationID;
	private String participantID;
	private String eventID;
	private Date registrationDate;
	
	public Registration() {
    }

    public Registration(String registrationID, String participantID, String eventID, Date registrationDate) {
        this.registrationID = registrationID;
        this.participantID = participantID;
        this.eventID = eventID;
		this.registrationDate = new Date(registrationDate .getTime()); // Defensive copy
    }
    
	public String getRegistrationID() {
		return this.registrationID;
	}
	public String getParticipantID() {
		return this.participantID;
	}
	public String getEventID() {
		return this.eventID;
	}
	public Date getRegistrationDate() {
		return new Date(registrationDate .getTime());
	}
	
	public void setRegistrationID(String registrationID) {
		this.registrationID = registrationID;
	}
	public void setParticipantID(String participantID) {
		this.participantID = participantID;
	}
	public void setEventID(String eventID) {
		this.eventID = eventID;
	}
	public void setRegistrationDate(Date registrationDate) {
		this.registrationDate = new Date(registrationDate .getTime());
	}



}

