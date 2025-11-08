<%@ page import="java.util.List" %>
<%@ page import="model.EventRegistration" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Track Registered Events</title>
<link rel="shortcut icon" type="image/x-icon" href="/UiTM_Event_Management_System/assets/images/uitm.png" />

<!-- DaisyUI and TailwindCSS -->
<link
    href="https://cdn.jsdelivr.net/npm/daisyui@4.12.19/dist/full.min.css"
    rel="stylesheet" type="text/css" />
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
    .clickable-card {
        cursor: pointer;
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .clickable-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
</style>
</head>
<body class="bg-base-200">

    <header
        class="bg-primary text-primary-content p-4 flex items-center justify-between">
        <img src="https://perak.uitm.edu.my/images/corporate/TAPAH-PUTIH.png"
            alt="UiTM Perak Logo" class="h-16">
        <h1 class="text-lg font-bold text-center flex-grow">Track Registered Events</h1>
        <nav class="flex gap-2">
            <a href="/UiTM_Event_Management_System/BrowseEventServlet" class="btn btn-sm btn-ghost">Browse Events</a> 
            <a href="/UiTM_Event_Management_System/TrackRegisteredServlet" class="btn btn-sm btn-ghost">Track Registration</a> 
            <a href="/UiTM_Event_Management_System/EventFeedbackServlet" class="btn btn-sm btn-ghost">Give Feedback</a> 
            <a href="/UiTM_Event_Management_System/CancelRegistrationServlet" class="btn btn-sm btn-ghost">Cancel Registration</a> 
            <a href="/UiTM_Event_Management_System/LogoutServlet" class="btn btn-sm btn-error">Logout</a>
        </nav>
    </header>

    <div class="container mx-auto p-4 max-w-2xl">
        <h2 class="text-center text-2xl font-bold mb-8">Your Registered Events</h2>

        <div class="space-y-4">
            <%
                List<EventRegistration> events = (List<EventRegistration>) request.getAttribute("trackRegistered");
                if (events != null && !events.isEmpty()) {
                    for (EventRegistration event : events) {
                        String status = event.getEventStatus();
                        String badgeClass = "badge-secondary";
                        if ("Coming".equals(status)) {
                            badgeClass = "badge-warning";
                        } else if ("Ongoing".equals(status)) {
                            badgeClass = "badge-success";
                        } else if ("Ended".equals(status)) {
                            badgeClass = "badge-error";
                        }
            %>
            <!-- Event Card -->
            <div class="card bg-base-100 shadow-xl clickable-card"
                 onclick="document.getElementById('modal_<%= event.getEventId() %>').showModal()">
                <figure>
                    <img src="/UiTM_Event_Management_System/assets/images/posters/<%= event.getEventId() %>.jpg" 
                        alt="<%= event.getEventName() %>" class="h-48 object-cover w-full">
                </figure>
                <div class="card-body">
                    <div class="flex items-center justify-between">
                        <h3 class="card-title text-lg"><%= event.getEventName() %></h3>
                        <span class="badge <%= badgeClass %>"><%= status %></span>
                    </div>
                    <p class="text-sm text-gray-500">Date: <%= event.getEventDate() %></p>
                </div>
            </div>

            <!-- Modal -->
            <dialog id="modal_<%= event.getEventId() %>" class="modal">
                <div class="modal-box max-w-2xl">
                    <h3 class="font-bold text-2xl mb-4"><%= event.getEventName() %></h3>
                    <figure class="mb-4">
                        <img src="/UiTM_Event_Management_System/assets/images/posters/<%= event.getEventId() %>.jpg" 
                            alt="<%= event.getEventName() %>" class="w-full h-64 object-cover rounded-lg">
                    </figure>
                    <div class="space-y-3 text-lg">
                        <p><strong class="text-primary">Event Date:</strong> 
                            <span class="ml-2"><%= event.getEventDate() %></span></p>
                        <p><strong class="text-primary">Registered Date:</strong> 
                            <span class="ml-2"><%= event.getRegistrationDate() %></span></p>
                        <p><strong class="text-primary">Location:</strong> 
                            <span class="ml-2"><%= event.getEventLocation() %></span></p>
                        <p><strong class="text-primary">Status:</strong> 
                            <span class="ml-2 badge <%= badgeClass %>"><%= status %></span></p>
                    </div>
                    <div class="modal-action">
                        <form method="dialog">
                            <button class="btn">Close</button>
                        </form>
                    </div>
                </div>
            </dialog>
            <%
                    }
                } else {
            %>
            <div class="text-center w-full">
                <p class="text-xl text-gray-500">No registered events found.</p>
            </div>
            <%
                }
            %>
        </div>
    </div>

    <footer class="bg-base-300 text-base-content p-4 text-center mt-auto">
        &copy; 2024 UiTM Event Management System
    </footer>
</body>
</html>