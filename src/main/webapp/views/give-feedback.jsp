<%@ page import="java.util.List" %>
<%@ page import="model.EventFeedback" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Feedback Form</title>
<link rel="shortcut icon" type="image/x-icon" href="/UiTM_Event_Management_System/assets/images/uitm.png" />

<!-- DaisyUI and TailwindCSS -->
<link
    href="https://cdn.jsdelivr.net/npm/daisyui@4.12.19/dist/full.min.css"
    rel="stylesheet" type="text/css" />
<script src="https://cdn.tailwindcss.com"></script>
<style>
    .toast {
        animation: slideIn 0.5s ease-out;
        z-index: 1000; /* Ensures the toast is above other elements */
    }
    
    @keyframes slideIn {
        from { transform: translateY(-100%); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
    }
    
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
    <header
        class="bg-primary text-primary-content p-4 flex items-center justify-between">
        <img src="https://perak.uitm.edu.my/images/corporate/TAPAH-PUTIH.png"
            alt="UiTM Perak Logo" class="h-16">
        <h1 class="text-lg font-bold text-center flex-grow">Feedback Form</h1>
        <nav class="flex gap-2">
            <a href="/UiTM_Event_Management_System/BrowseEventServlet" class="btn btn-sm btn-ghost">Browse Events</a> 
            <a href="/UiTM_Event_Management_System/TrackRegisteredServlet" class="btn btn-sm btn-ghost">Track Registration</a> 
            <a href="/UiTM_Event_Management_System/EventFeedbackServlet" class="btn btn-sm btn-ghost">Give Feedback</a> 
            <a href="/UiTM_Event_Management_System/CancelRegistrationServlet" class="btn btn-sm btn-ghost">Cancel Registration</a> 
            <a href="/UiTM_Event_Management_System/LogoutServlet" class="btn btn-sm btn-error">Logout</a>
        </nav>
    </header>

    <div class="container mx-auto p-4">
        <!-- Filters Section -->
        <form id="filterForm" method="get" action="${pageContext.request.contextPath}/EventFeedbackFilterServlet">
            <div class="bg-base-100 p-6 rounded-lg shadow-md mb-6">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <!-- Organiser/Category Filter -->
                    <div>
                        <label class="block text-sm font-medium mb-1">Category</label>
                        <select name="category" id="category" class="select select-bordered w-full" onchange="submitFilterForm()">
                            <option value="">All Categories</option>
                            <option value="ORG001" <%= "ORG001".equals(request.getParameter("category")) ? "selected" : "" %>>MPP</option>
                            <option value="ORG002" <%= "ORG002".equals(request.getParameter("category")) ? "selected" : "" %>>JSP</option>
                            <option value="ORG003" <%= "ORG003".equals(request.getParameter("category")) ? "selected" : "" %>>BASCO</option>
                        </select>
                    </div>
                    
                    <!-- Search by Event Name -->
                    <div>
                        <label class="block text-sm font-medium mb-1">Search by Name</label>
                        <input type="text" class="input input-bordered w-full" 
                               name="searchByName" 
                               id="searchByName"
                               placeholder="Event name" 
                               value="<%= request.getParameter("searchByName") != null ? request.getParameter("searchByName") : "" %>"
                               oninput="submitFilterForm()">
                    </div>
        
                    <!-- Reset Filters Button -->
                    <div class="flex items-end">
                        <button type="button" onclick="resetFilters()" class="btn btn-outline w-full">
                            Reset Filters
                        </button>
                    </div>
                </div>
            </div>
        </form>
            <!-- Added Filter Script -->
	    <script>
	        // Filter form auto-submit
	        const filterForm = document.getElementById('filterForm');
	        const categorySelect = document.getElementById('category');
	        const searchInput = document.getElementById('searchByName');
	
	        // Auto-submit on any filter change
	        categorySelect.addEventListener('change', () => filterForm.submit());
	        searchInput.addEventListener('input', () => filterForm.submit());
	
	        // Reset filters function
	        function resetFilters() {
	            categorySelect.value = '';
	            searchInput.value = '';
	            filterForm.submit();
	        }
	    </script>

        <!-- Event Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <%
                List<EventFeedback> events = (List<EventFeedback>) request.getAttribute("eventFeedback");
                String searchQuery = request.getParameter("search");
                if (events != null && !events.isEmpty()) {
                    for (int i = 0; i < events.size(); i++) {
                        request.setAttribute("event", events.get(i)); // Set the bean for <jsp:useBean>
            %>
            <jsp:useBean id="event" class="model.EventFeedback" scope="request" />
            
            <%
                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    if (!event.getEventName().toLowerCase().contains(searchQuery.toLowerCase())) {
                        continue; // Skip events that don't match the search
                    }
                }
            %>
            <!-- Event Card -->
            <div class="card bg-base-100 shadow-xl">
                <figure>
                    <img src="/UiTM_Event_Management_System/assets/images/posters/<jsp:getProperty name="event" property="eventId" />.jpg" alt="<jsp:getProperty name="event" property="eventName" /> image" class="h-48 object-cover w-full">
                </figure>
                <div class="card-body">
                    <h2 class="card-title"><jsp:getProperty name="event" property="eventName" /></h2>
                    <p class="text-sm text-secondary">Date: <jsp:getProperty name="event" property="eventDate" /></p>
                    <div class="flex justify-end">
                        <button class="btn btn-primary" 
                            onclick="openModal('<jsp:getProperty name="event" property="eventName" />', '<jsp:getProperty name="event" property="eventId" />')">
                            Give Feedback
                        </button>
                    </div>
                </div>
            </div>
				<%
                        } 
                    }else{
                %>
                    	No registered events found.
                <%
                    }
                %>
        </div>
    </div>

    <!-- Feedback Modal -->
    <div id="feedbackModal" class="modal">
        <div class="modal-box">
            <button
                class="btn btn-sm btn-circle btn-error absolute right-2 top-2"
                onclick="closeModal()">&times;</button>
            <h2 id="eventTitle" class="text-2xl font-bold mb-4">Event Feedback</h2>

            <!-- Star Rating -->
            <div class="star-rating flex justify-center gap-2">
                <span class="star cursor-pointer text-3xl" data-value="1">&#9733;</span>
                <span class="star cursor-pointer text-3xl" data-value="2">&#9733;</span>
                <span class="star cursor-pointer text-3xl" data-value="3">&#9733;</span>
                <span class="star cursor-pointer text-3xl" data-value="4">&#9733;</span>
                <span class="star cursor-pointer text-3xl" data-value="5">&#9733;</span>
            </div>

            <!-- Feedback Box -->
            <div class="feedback-box mt-4">
                <textarea class="textarea textarea-bordered w-full"
                    placeholder="Write your feedback here..."></textarea>
            </div>

            <!-- Submit Button -->
            <button class="btn btn-primary mt-4 w-full"
                onclick="submitFeedback()">Submit Feedback</button>
        </div>
    </div>

    <!-- Success Toast Container -->
	<div id="toastContainer" class="toast toast-top toast-center z-[10000]"></div>
    <script>
        // Profanity filter list
        const bannedWords = [
            'babi', 'sial', 'celaka', 'pukimak', 'bodoh', 'bangang', 'bahlul', 'setan', 
            'jahanam', 'anjing', 'kepala bana', 'lahanat', 'sundal', 'lancau', 'kote', 
            'puki', 'pantat', 'haram jadah', 'gampang', 'cibai', 'pepek', 'butoh', 
            'bangsat', 'barua', 'mak kau hijau', 'palat', 'tetek', 'jubur', 'puaka', 
            'sakai', 'bedebah', 'ct', 'fk', 'fuck', 'shit', 'burit', 'belen', 
            'shit', 'butuh', 'buto', 'butoh', 'kote', 'lancau', 'konek', 'bontot'
        ];

        // Declare currentEventId globally
        let currentEventId = '';

        // Toast notification functions
        // Toast notification functions
        function showSuccessToast(message) {
            const toast = document.createElement('div');
            toast.className = 'alert alert-success shadow-lg text-white';
            toast.innerHTML = `
                <div class="flex items-center">
                    <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <span class="ml-2"></span>
                </div>
            `;
            toast.querySelector('span').innerText = message;
            console.log(message);

            const container = document.getElementById('toastContainer');
            container.appendChild(toast);
            
            setTimeout(() => {
                toast.remove();
            }, 3000);
        }

        function showErrorToast(message) {
            const toast = document.createElement('div');
            toast.className = 'alert alert-error shadow-lg text-white';
            toast.innerHTML = `
                <div class="flex items-center">
                    <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <span class="ml-2"></span>
                </div>
            `;
            toast.querySelector('span').innerText = message;
            console.log(message);
            const container = document.getElementById('toastContainer');
            container.appendChild(toast);
            
            setTimeout(() => {
                toast.remove();
            }, 3000);
        }

        // Feedback submission logic
        function submitFeedback() {
            const feedback = document.querySelector('textarea').value;
            const currentRating = document.querySelectorAll('.star.text-yellow-500').length;

            if (currentRating === 0) {
                showErrorToast('Please select a rating.');
                return;
            }

            if (feedback.trim() === '') {
                showErrorToast('Please provide feedback.');
                return;
            }

            // Profanity check
            for (const word of bannedWords) {
                if (feedback.toLowerCase().includes(word.toLowerCase())) {
                    showErrorToast('Please avoid using inappropriate language.');
                    return;
                }
            }

            // Create form
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'EventFeedbackActionServlet';

            // Add hidden inputs
            const addInput = (name, value) => {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = name;
                input.value = value;
                form.appendChild(input);
            };

            addInput('rating', currentRating);
            addInput('feedback', feedback);
            addInput('eventId', currentEventId);

            document.body.appendChild(form);
            
            // Show success message
            showSuccessToast('Feedback submitted successfully!');
            
            // Submit form after short delay
            setTimeout(() => {
                form.submit();
            }, 1500);
        }

        // Updated DOMContentLoaded listener
        document.addEventListener("DOMContentLoaded", function () {
            const stars = document.querySelectorAll('.star');
            let currentRating = 0;
            const modal = document.getElementById('feedbackModal');
            const eventTitle = document.getElementById('eventTitle');

            function openModal(eventName, eventId) {
                modal.classList.add('modal-open');
                eventTitle.textContent = eventName;
                currentEventId = eventId;
            }

            function closeModal() {
                modal.classList.remove('modal-open');
                currentRating = 0;
                document.querySelector('textarea').value = '';
                highlightStars(0);
            }

            function highlightStars(rating) {
                stars.forEach(star => {
                    const value = parseInt(star.getAttribute('data-value'));
                    if (value <= rating) {
                        star.classList.add('text-yellow-500');
                    } else {
                        star.classList.remove('text-yellow-500');
                    }
                });
            }

            stars.forEach(star => {
                star.addEventListener('mouseover', () => {
                    const value = parseInt(star.getAttribute('data-value'));
                    highlightStars(value);
                });

                star.addEventListener('mouseout', () => {
                    highlightStars(currentRating);
                });

                star.addEventListener('click', () => {
                    currentRating = parseInt(star.getAttribute('data-value'));
                    highlightStars(currentRating);
                });
            });

            window.openModal = openModal;
            window.closeModal = closeModal;
        });
    </script>

    <footer class="bg-base-300 text-base-content p-4 text-center mt-auto">
        &copy; 2024 UiTM Event Management System
    </footer>
</body>
</html>