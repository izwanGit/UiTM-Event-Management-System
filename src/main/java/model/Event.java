package model;

import java.sql.Date;
import java.sql.Time;

import dao.RegistrationDAO;

public class Event {
    private String eventID;
    private String organiserID;
    private String eventName;
    private Date eventDate;
    private Time eventTime;
    private String eventLocation;
    private double eventPrice;
    private String eventStatus; // New field for event status
    private int maxParticipant;
    private String description;

    // Constructor with parameters
    public Event(String eventID, String organiserID, String eventName, Date eventDate, Time eventTime,
                 String eventLocation, double eventPrice, String eventStatus, int maxParticipant, String description) {
        this.eventID = eventID;
        this.organiserID = organiserID;
        this.eventName = eventName;
        this.eventDate = eventDate;
        this.eventTime = eventTime;
        this.eventLocation = eventLocation;
        this.eventPrice = eventPrice;
        this.eventStatus = eventStatus;
        this.maxParticipant = maxParticipant;
        this.description = description;
    }

    // Default constructor
    public Event() {}

    // Getters and setters
    public String getEventID() {
        return eventID;
    }

    public void setEventID(String eventID) {
        if (eventID == null || eventID.trim().isEmpty()) {
            throw new IllegalArgumentException("Event ID cannot be null or empty");
        }
        this.eventID = eventID.trim();
    }

    public String getOrganiserID() {
        return organiserID;
    }

    public void setOrganiserID(String organiserID) {
        if (organiserID == null || organiserID.trim().isEmpty()) {
            throw new IllegalArgumentException("Organiser ID cannot be null or empty");
        }
        this.organiserID = organiserID.trim();
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        if (eventName == null || eventName.trim().isEmpty()) {
            throw new IllegalArgumentException("Event name cannot be null or empty");
        }
        this.eventName = eventName.trim();
    }

    public Date getEventDate() {
        return new Date(eventDate.getTime()); // Defensive copy
    }

    public void setEventDate(Date eventDate) {
        if (eventDate == null) {
            throw new IllegalArgumentException("Event date cannot be null");
        }
        this.eventDate = new Date(eventDate.getTime()); // Defensive copy
    }

    public Time getEventTime() {
        return new Time(eventTime.getTime()); // Defensive copy
    }

    public void setEventTime(Time eventTime) {
        if (eventTime == null) {
            throw new IllegalArgumentException("Event time cannot be null");
        }
        this.eventTime = new Time(eventTime.getTime()); // Defensive copy
    }

    public String getEventLocation() {
        return eventLocation;
    }

    public void setEventLocation(String eventLocation) {
        if (eventLocation == null || eventLocation.trim().isEmpty()) {
            throw new IllegalArgumentException("Event location cannot be null or empty");
        }
        this.eventLocation = eventLocation.trim();
    }

    public double getEventPrice() {
        return eventPrice;
    }

    public void setEventPrice(double eventPrice) {
        if (eventPrice < 0) {
            throw new IllegalArgumentException("Event price cannot be negative");
        }
        this.eventPrice = eventPrice;
    }

    public String getEventStatus() {
        return eventStatus;
    }

    public void setEventStatus(String eventStatus) {
        if (eventStatus == null || eventStatus.trim().isEmpty()) {
            throw new IllegalArgumentException("Event status cannot be null or empty");
        }
        this.eventStatus = eventStatus.trim();
    }

    public int getMaxParticipant() {
        return maxParticipant;
    }

    public void setMaxParticipant(int maxParticipant) {
        if (maxParticipant < 0) {
            throw new IllegalArgumentException("Maximum participant cannot be negative");
        }
        this.maxParticipant = maxParticipant;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        if (description == null || description.trim().isEmpty()) {
            throw new IllegalArgumentException("Description cannot be null or empty");
        }
        this.description = description.trim();
    }

    @Override
    public String toString() {
        return "Event{" +
                "eventID='" + eventID + '\'' +
                ", organiserID='" + organiserID + '\'' +
                ", eventName='" + eventName + '\'' +
                ", eventDate=" + eventDate +
                ", eventTime=" + eventTime +
                ", eventLocation='" + eventLocation + '\'' +
                ", eventPrice=" + eventPrice +
                ", eventStatus='" + eventStatus + '\'' +
                ", maxParticipant=" + maxParticipant +
                ", description='" + description + '\'' +
                '}';
    }
    
}
