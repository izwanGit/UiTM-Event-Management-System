package model;

public class EventRegistration {
    private String registrationId;
    private String eventName;
    private String eventDate;
    private String registrationDate;
    private String eventLocation;
    private String eventStatus;
    private String eventId;



    // Default (no-argument) constructor required for <jsp:useBean>
    public EventRegistration() {}

    public EventRegistration(String registrationId, String eventName, String eventDate, String registrationDate, String eventLocation, String eventStatus, String eventId) {
    	this.registrationId = registrationId;
        this.eventName = eventName;
        this.eventDate = eventDate;
        this.registrationDate = registrationDate;
        this.eventLocation = eventLocation;
        this.eventStatus = eventStatus;
        this.eventId = eventId;


        
    }
    public String getRegistrationId() { return registrationId; }
    public String getEventName() { return eventName; }
    public String getEventDate() { return eventDate; }
    public String getRegistrationDate() { return registrationDate; }
    public String getEventLocation() { return eventLocation; }
    public String getEventStatus() { return eventStatus; }
    public String getEventId() { return eventId; }


    public void setRegistrationId(String registrationId) { this.registrationId = registrationId; }
    public void setEventName(String eventName) { this.eventName = eventName; }
    public void setEventDate(String eventDate) { this.eventDate = eventDate; }
    public void setRegistrationDate(String registrationDate) { this.registrationDate = registrationDate; }
    public void setEventLocation(String eventLocation) { this.eventLocation = eventLocation; }
    public void setEventStatus(String eventStatus) { this.eventStatus = eventStatus; }
    public void setEventId(String eventId) { this.eventId = eventId; }

}
