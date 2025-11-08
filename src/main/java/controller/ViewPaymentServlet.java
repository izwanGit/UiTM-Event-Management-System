package controller;

import dao.PaymentReportDAO;
import model.PaymentReport;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ViewPaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");

        if (userId == null) {
            // If user is not logged in, redirect to the login page
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Retrieve the eventID parameter from the request
        String eventID = request.getParameter("eventID");
        // If eventID is not provided, you can handle this case as needed (e.g., show an error or return all payments)
        if (eventID == null || eventID.isEmpty()) {
            // Optionally, set an error message in request attributes
            request.setAttribute("error", "Event ID is required.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
        // Retrieve the list of payments for the given eventID
        List<PaymentReport> payments = PaymentReportDAO.getAllPaymentsByEventID(eventID);
        
        // Set the list of payments as a request attribute
        request.setAttribute("payments", payments);

        // Forward the request to the JSP page to display the results
        RequestDispatcher dispatcher = request.getRequestDispatcher("view-payment.jsp");
        dispatcher.forward(request, response);
    }
}
