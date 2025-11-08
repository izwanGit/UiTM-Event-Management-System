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

public class EventFeedbackFilterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public EventFeedbackFilterServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

      	HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp"); // Redirect if session expired
            return;
        }
        String participantId = (String) session.getAttribute("userId"); 

        // Capture the category filter
        String category = request.getParameter("category"); // OrganiserID
        String searchQuery = request.getParameter("searchByName");
        System.out.println(searchQuery);
        // Instantiate the DAO
        FeedbackDAO dao = new FeedbackDAO();

        // Get the registered events for the participant, possibly filtered by category
        List<EventFeedback> feedback;
        feedback = dao.getFilteredEvents(participantId, category, searchQuery);  // Use a DAO method to filters

        // Set the events as a request attribute
        request.setAttribute("eventFeedback", feedback);

        // Forward to JSP
        request.getRequestDispatcher("views/give-feedback.jsp").forward(request, response);
    }
}
