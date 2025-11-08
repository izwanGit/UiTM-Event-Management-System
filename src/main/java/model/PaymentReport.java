package model;

import java.sql.Time;
import java.util.Date;

public class PaymentReport {
    private String paymentID;
    private String eventID;
    private Date dateGenerate;
    private Time timeGenerate;
    private double totalAmount;

    public PaymentReport() {
    }

    public PaymentReport(String paymentID, String eventID, Date dateGenerate, Time timeGenerate, double totalAmount) {
        this.paymentID = paymentID;
        this.eventID = eventID;
        this.dateGenerate = new Date(dateGenerate.getTime()); // Defensive copy
        this.timeGenerate = new Time(timeGenerate.getTime()); // Defensive copy
        this.totalAmount = totalAmount;
    }

    public String getPaymentID() {
        return paymentID;
    }
    public void setPaymentID(String paymentID) {
        this.paymentID = paymentID;
    }
    public String getEventID() {
        return eventID;
    }
    public void setEventID(String eventID) {
        this.eventID = eventID;
    }
    public Date getDateGenerate() {
        return new Date(dateGenerate.getTime()); // Defensive copy
    }
    public void setDateGenerate(Date dateGenerate) {
        this.dateGenerate = new Date(dateGenerate.getTime()); // Defensive copy
    }
    public Time getTimeGenerate() {
        return new Time(timeGenerate.getTime()); // Defensive copy
    }
    public void setTimeGenerate(Time timeGenerate) {
        this.timeGenerate = new Time(timeGenerate.getTime()); // Defensive copy
    }
    public double getTotalAmount() {
        return totalAmount;
    }
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
    @Override
    public String toString() {
        return "PaymentReport [paymentID=" + paymentID + ", eventID=" + eventID + ", dateGenerate=" + dateGenerate
                + ", timeGenerate=" + timeGenerate + ", totalAmount=" + totalAmount + "]";
    }
}
