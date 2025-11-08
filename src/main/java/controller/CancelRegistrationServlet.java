package controller;

import dao.RegistrationDAO;
import model.EventRegistration;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

//@WebServlet("/CancelRegistrationServlet")  // Ensure this URL is mapped correctly in your web.xml or annotation
public class CancelRegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	
      	HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp"); // Redirect if session expired
            return;
        }
        String participantId = (String) session.getAttribute("userId"); 

        // Use the correct participant ID here (could be fetched from session or request)
        //String participantId = "2024108785"; // Replace this with the session participant ID

        // Instantiate the DAO
        RegistrationDAO dao = new RegistrationDAO();

        // Debugging - Check if the participant ID is being passed correctly
        //System.out.println("Participant ID: " + participantId); 

        // Get the registered events for the participant
        List<EventRegistration> events = dao.getCancelableEvents(participantId);  // Passing the participant ID to the DAO method

        /*Debugging - Check if the events are being retrieved
        if (events == null) {
            System.out.println("No events found.");
        } else {
            System.out.println("Events size: " + events.size()); // Debugging line to check how many events are fetched
        }
        */

        // Set the events as a request attribute
        request.setAttribute("registeredEvents", events);
        
        // Forward to JSP
        request.getRequestDispatcher("views/cancel-registration.jsp").forward(request, response);
    }
}
