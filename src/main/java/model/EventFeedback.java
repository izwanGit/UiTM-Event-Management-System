package model;

public class EventFeedback {
    private String eventId;
    private String participantID;
    private String eventName;
    private String eventDate;
    private int rating;  // Assuming rating is an integer
    private String comment;
    private String organiserId;

    // Default (no-argument) constructor required for <jsp:useBean>
    public EventFeedback() {}

    // Constructor with all the attributes
    public EventFeedback(String eventId, String participantID, String eventName, String eventDate, int rating, String comment, String organiserId) {
        this.eventId = eventId;
        this.participantID = participantID;
        this.eventName = eventName;
        this.eventDate = eventDate;
        this.rating = rating;
        this.comment = comment;
        this.organiserId = organiserId;

    }

    // Getter methods
    public String getEventId() { return eventId; }
    public String getParticipantID() { return participantID; }
    public String getEventName() { return eventName; }
    public String getEventDate() { return eventDate; }
    public int getRating() { return rating; }
    public String getComment() { return comment; }
    public String getOrganiserId() { return organiserId; }


    // Setter methods
    public void setEventId(String eventId) { this.eventId = eventId; }
    public void setParticipantID(String participantID) { this.participantID = participantID; }
    public void setEventName(String eventName) { this.eventName = eventName; }
    public void setEventDate(String eventDate) { this.eventDate = eventDate; }
    public void setRating(int rating) { this.rating = rating; }
    public void setComment(String comment) { this.comment = comment; }
    public void setOrganiserId(String organiserId) { this.organiserId = organiserId; }

}
