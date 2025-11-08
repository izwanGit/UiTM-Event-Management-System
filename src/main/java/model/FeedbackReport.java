package model;

public class FeedbackReport{
	private String feedbackID;
	private String eventID;
	private int rating;
	private String comment;
	
	public FeedbackReport() {}
	
	public String getFeedbackID() {
		return feedbackID;
	}
	public void setFeedbackID(String feedbackID) {
		this.feedbackID = feedbackID;
	}
	public String getEventID() {
		return eventID;
	}
	public void setEventID(String eventID) {
		this.eventID = eventID;
	}
	public int getRating() {
		return rating;
	}
	public void setRating(int rating) {
		this.rating = rating;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	
	
}