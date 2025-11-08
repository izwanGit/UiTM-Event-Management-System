<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.EventDAO, model.Event" %>
<%
    HttpSession sessionStatus = request.getSession();
	sessionStatus.setAttribute("registrationStatus", "Payment received! Your registration is confirmed.");
%>
<%
    String eventID = request.getParameter("eventID");
    String registrationID = request.getParameter("registrationID");

// Retrieve event details
    EventDAO eventDAO = new EventDAO();
    Event event = eventDAO.getEventByID(eventID);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Payment</title>
<link rel="shortcut icon" type="image/x-icon" href="/UiTM_Event_Management_System/assets/images/uitm.png" />

<!-- DaisyUI and TailwindCSS -->
<link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.19/dist/full.min.css" rel="stylesheet" type="text/css" />
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-base-200">

    <!-- Header -->
    <header class="bg-primary text-primary-content p-4 flex items-center justify-between">
        <img src="https://perak.uitm.edu.my/images/corporate/TAPAH-PUTIH.png" alt="UiTM Perak Logo" class="h-16">
        <h1 class="text-lg font-bold text-center flex-grow">Payment</h1>
		<nav class="flex gap-2">
			<a href="/UiTM_Event_Management_System/BrowseEventServlet" class="btn btn-sm btn-ghost">Browse Events</a> 
			<a href="/UiTM_Event_Management_System/TrackRegisteredServlet" class="btn btn-sm btn-ghost">Track Registration</a> 
			<a href="/UiTM_Event_Management_System/EventFeedbackServlet" class="btn btn-sm btn-ghost">Give Feedback</a> 
			<a href="/UiTM_Event_Management_System/CancelRegistrationServlet" class="btn btn-sm btn-ghost">Cancel Registration</a> 
			<a href="/UiTM_Event_Management_System/LogoutServlet" class="btn btn-sm btn-error">Logout</a>
		</nav>
    </header>

    <!-- Payment Container -->
    <div class="container mx-auto p-4">
        <!-- Event Summary -->
        <div class="card bg-base-100 shadow-xl p-4 mb-6">
            <h3 class="text-lg font-semibold mb-4">Event Summary</h3>
            <div class="space-y-4">
                <p><strong>Event Name:</strong> <%= event.getEventName() %></p>
                <p><strong>Date:</strong> <%= event.getEventDate() %></p>
                <p><strong>Total Amount:</strong> RM <%= event.getEventPrice() %></p>
            </div>
        </div>

        <!-- Price Section -->
        <div class="card bg-base-100 shadow-xl p-4 mb-6">
            <h3 class="text-lg font-semibold mb-4">Total Price</h3>
            <p class="text-2xl font-bold text-primary">RM <%= event.getEventPrice() %></p>
        </div>

        <!-- Payment Method -->
        <h2 class="text-lg font-semibold mb-4">Scan QR Code Below To Make Payment</h2>
        <div class="flex justify-center mb-6">
            <img src="../assets/images/QR.png" height="300" width="300" alt="QR Code" class="cursor-pointer">
        </div>

        <!-- Receipt Upload Section -->
        <form action="${pageContext.request.contextPath}/BrowseEventServlet" method="POST" enctype="multipart/form-data">
        <input type="hidden" name="eventID" value="<%= eventID %>">
            <input type="hidden" name="registrationID" value="<%= registrationID %>">

            <div class="mb-6">
                <label for="receipt" class="block text-lg font-semibold mb-2">Upload Your Payment Receipt</label>
                <input type="file" id="receipt" name="receipt" class="file-input file-input-bordered w-full max-w-xs" required />
            </div>

            <!-- Payment Button -->
            <button type="submit" class="btn btn-primary w-full">Proceed</button>
        </form>
    </div>

    <!-- Footer -->
    <footer class="bg-base-300 text-base-content p-4 text-center">
        &copy; 2024 UiTM Event Management System
    </footer>
</body>
</html>