package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.EventFeedback;

import java.io.IOException;
import java.util.List;
import dao.FeedbackDAO;

public class EventFeedbackActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public EventFeedbackActionServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

      	HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp"); // Redirect if session expired
            return;
        }
        String participantId = (String) session.getAttribute("userId"); 

        String eventId = request.getParameter("eventId");
        String rating = request.getParameter("rating");
        String comment = request.getParameter("feedback");
        System.out.println("Inserting eventID: " + eventId);
        System.out.println("Inserting eventID: " + rating);
        System.out.println("Inserting eventID: " + comment);



        // Instantiate the DAO
        FeedbackDAO dao = new FeedbackDAO();
        boolean status = dao.insertFeedback(eventId, rating, comment);
        if(status) {
        	//System.out.println("BERJAYA TIME SQUARE");
            List<EventFeedback>feedback = dao.getNoFeedback(participantId); 

            // Set the events as a request attribute
            request.setAttribute("eventFeedback", feedback);

            // Forward to JSP
            request.getRequestDispatcher("views/give-feedback.jsp").forward(request, response);
        }

    }
}
