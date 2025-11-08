package controller;
import jakarta.servlet.http.Cookie;

import dao.EventDAO;
import dao.RegistrationDAO;
import dao.UserDAO;
import model.Event;
import model.Participant;
import model.Registration;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;


public class RegisterEventServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	// doGet method to serve the event registration form
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
    	HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            // If user is not logged in, redirect to the login page
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String eventID = request.getParameter("eventID");
        
        if (eventID != null && !eventID.isEmpty()) {
        	
        	EventDAO eventDAO = new EventDAO();
            Event event = eventDAO.getEventByID(eventID);
            
            if (event != null) {
                // Pass event details to the JSP
                request.setAttribute("event", event);
                request.setAttribute("eventID", eventID);  // Set the eventID for the form
                
                if (userId != null) {
                    Participant participant = new UserDAO().getParticipantById(userId);
                    request.setAttribute("participant", participant); // Pass participant details to JSP
                }
                // Forward to the event registration page
                RequestDispatcher dispatcher = request.getRequestDispatcher("/views/register-event.jsp");
                dispatcher.forward(request, response);
            } else {
                // Event not found, redirect or show error
                request.setAttribute("errorMessage", "Event not found.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/views/register-event.jsp");
                dispatcher.forward(request, response);
            }
        } else {
            // If eventID is not provided, show an error or redirect
            request.setAttribute("errorMessage", "Invalid event selection.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/register-event.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    // doPost method for handling registration form submissions
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    	HttpSession session = request.getSession();
    	String userID = (String) session.getAttribute("userId");
        String eventID = request.getParameter("eventID");
        
        if (userID == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        EventDAO eventDAO = new EventDAO();
        Event event = eventDAO.getEventByID(eventID);
        RegistrationDAO registrationDAO = new RegistrationDAO();
        UserDAO userDAO = new UserDAO();

        if (event != null) {
        	
        	String name = request.getParameter("name");
        	String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            
            Participant participant = new Participant();
            participant.setParticipantID(userID);
            participant.setParticipantName(name);
            participant.setParticipantNoTel(phone);
            participant.setParticipantEmail(email);
            
            if (phone == null || !phone.matches("^[0-9]{10,11}$") || email == null) {
            	request.setAttribute("errorMessage", "Fill in the forms correctly");
                request.setAttribute("participant", participant); // Pass the participant data
                request.setAttribute("eventID", eventID); // Pass the eventID
                response.sendRedirect(request.getContextPath() + "/RegisterEventServlet?eventID=" + eventID);
                return;
            }
            
            boolean userSuccess = userDAO.updateParticipantDetails(participant);
            
            if (userSuccess) {
            	 
                // Generate registration ID and register participant
                String registrationID = registrationDAO.generateNextRegistrationID();
                Date registrationDate = new Date(System.currentTimeMillis()); // Current date

                Registration registration = new Registration(registrationID, userID, eventID, registrationDate);
                boolean regSuccess = registrationDAO.registerForEvent(registration);

                if (regSuccess) {
                	
                	// Store the organiser ID of the last registered event in a cookie
                    Cookie lastPickCookie = new Cookie("lastPick", event.getOrganiserID());
                    lastPickCookie.setMaxAge(60 * 60 * 24 * 30); // 30 days expiry
                    lastPickCookie.setPath("/");
                    response.addCookie(lastPickCookie);
                    
                    if (event.getEventPrice() > 0) {
                        // If event requires payment, redirect to payment page
                        response.sendRedirect(request.getContextPath() + "/views/payment.jsp?eventID=" + eventID + "&registrationID=" + registrationID);
                    } else {
                        // If event does not require payment, show success message and redirect
                        session.setAttribute("registrationStatus", "Registration successful!");
                        response.sendRedirect(request.getContextPath() + "/BrowseEventServlet");
                    }
                } else {
                    request.setAttribute("errorMessage", "Registration failed. Please try again.");
                    request.setAttribute("participant", participant); // Pass the participant data
                    request.setAttribute("eventID", eventID); // Pass the eventID
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/views/register-event.jsp");
                    dispatcher.forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Failed to update participant details.");
                request.setAttribute("participant", participant); // Pass the participant data
                request.setAttribute("eventID", eventID); // Pass the eventID
                RequestDispatcher dispatcher = request.getRequestDispatcher("/views/register-event.jsp");
                dispatcher.forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Event not found.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/register-event.jsp");
            dispatcher.forward(request, response);
        }
    }
}
