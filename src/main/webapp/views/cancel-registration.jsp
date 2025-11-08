<%@ page import="java.util.List" %>
<%@ page import="model.EventRegistration" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cancel Registration</title>
    <link rel="shortcut icon" type="image/x-icon" href="/UiTM_Event_Management_System/assets/images/uitm.png" />
    
    <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.19/dist/full.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    
    <style>
	    body {
	        display: flex;
	        flex-direction: column;
	        min-height: 100vh;
	    }
	    .content {
	        flex: 1;
	    }
	</style>
</head>
<body class="bg-base-200">
	<header class="bg-primary text-primary-content p-4 flex items-center justify-between">
		<img src="https://perak.uitm.edu.my/images/corporate/TAPAH-PUTIH.png"
			alt="UiTM Perak Logo" class="h-16">
		<h1 class="text-lg font-bold text-center flex-grow">Cancel Registration</h1>
		<nav class="flex gap-2">
			<a href="/UiTM_Event_Management_System/BrowseEventServlet" class="btn btn-sm btn-ghost">Browse Events</a> 
			<a href="/UiTM_Event_Management_System/TrackRegisteredServlet" class="btn btn-sm btn-ghost">Track Registration</a> 
			<a href="/UiTM_Event_Management_System/EventFeedbackServlet" class="btn btn-sm btn-ghost">Give Feedback</a> 
			<a href="/UiTM_Event_Management_System/CancelRegistrationServlet" class="btn btn-sm btn-ghost">Cancel Registration</a> 
			<a href="/UiTM_Event_Management_System/LogoutServlet" class="btn btn-sm btn-error">Logout</a>
		</nav>
	</header>

<div class="container mx-auto p-4">
    <h2 class="text-xl font-bold text-center mb-6">Cancel Event Registration</h2>
    
    <!-- Success and Error Messages -->
    <% String successMessage = (String) request.getAttribute("successMessage"); %>
    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>

    <% if (successMessage != null) { %>
        <div class="alert alert-success mb-4"><%= successMessage %></div>
    <% } %>
    
    <% if (errorMessage != null) { %>
        <div class="alert alert-error mb-4"><%= errorMessage %></div>
    <% } %>

    <div class="overflow-x-auto">
        <table class="table table-zebra w-full">
            <thead>
                <tr>
                    <th>Event Name</th>
                    <th>Event Date</th>
                    <th>Registration Date</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<EventRegistration> events = (List<EventRegistration>) request.getAttribute("registeredEvents");
                    if (events != null && !events.isEmpty()) {
                        for (EventRegistration event : events) {
                %>
                <tr>
                    <td><%= event.getEventName() %></td>
                    <td><%= event.getEventDate() %></td>
                    <td><%= event.getRegistrationDate() %></td>
                    <td>
                        <button type="button" class="btn btn-error btn-sm" 
                                onclick="cancelRegistration('<%= event.getEventName() %>', '<%= event.getRegistrationId() %>')">
                            Cancel
                        </button>
                    </td>
                </tr>
                <% 
                        } 
                    } else { 
                %>
                <tr><td colspan="4" class="text-center">No registered events found. Please register for an event first. </td></tr>
                <% } %>
                <tr><td></td></tr>
            </tbody>
        </table>
    </div>
</div>

<script>
    function cancelRegistration(eventName, registrationId) {
        const isConfirmed = confirm(`Are you sure you want to cancel your registration?`);

        if (isConfirmed) {
            const form = document.createElement('form');
            form.method = 'get';
            form.action = 'CancelRegistrationActionServlet';

            const hiddenField = document.createElement('input');
            hiddenField.type = 'hidden';
            hiddenField.name = 'registrationId';
            hiddenField.value = registrationId;
            form.appendChild(hiddenField);

            document.body.appendChild(form);
            form.submit();
        }
    }
</script>

    <footer class="bg-base-300 text-base-content p-4 text-center mt-auto">
        &copy; 2024 UiTM Event Management System
    </footer>

</body>
</html>
