package com.uitm.eventmanagement.model;
public class GmailEvent {
    private String eventID;
    private String eventName;
    private String eventDate;
    private String eventTime;
    private String eventLocation;

	public GmailEvent(String eventID, String eventName, String eventDate, String eventTime, String eventLocation) {
	this.eventID = eventID;
	this.eventName = eventName;
	this.eventDate = eventDate;
	this.eventTime = eventTime;
	this.eventLocation = eventLocation;
	}
	// Getters
    public String getEventID() {
        return eventID;
    }
    public String getEventName() {
        return eventName;
    }
    public String getEventDate() {
        return eventDate;
    }
    public String getEventTime() {
        return eventTime;
    }
    public String getEventLocation() {
        return eventLocation;
    }
    // Setters
    public void setEventID(String eventID) {
        this.eventID = eventID;
    }
    public void setEventName(String eventName) {
        this.eventName = eventName;
    }
    public void setEventDate(String eventDate) {
        this.eventDate = eventDate;
    }
    public void setEventTime(String eventTime) {
        this.eventTime = eventTime;
    }
    public void setEventLocation(String eventLocation) {
        this.eventLocation = eventLocation;
    }
}