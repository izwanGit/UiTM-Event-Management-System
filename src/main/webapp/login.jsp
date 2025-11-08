<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="shortcut icon" type="image/x-icon" href="/UiTM_Event_Management_System/assets/images/uitm.png" />
    
    <!-- DaisyUI and TailwindCSS -->
    <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.19/dist/full.min.css" rel="stylesheet" type="text/css" />
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-base-200 flex flex-col justify-center items-center min-h-screen">

    <!-- UiTM Logo and System Name -->
    <div class="text-center mb-8">
        <!-- Light Theme Logo -->
        <img src="https://perak.uitm.edu.my/images/corporate/TAPAH-WARNA.png" 
             alt="UiTM Logo Light Theme" 
             class="w-60 h-auto mx-auto dark:hidden">
             
        <!-- Dark Theme Logo -->
        <img src="https://perak.uitm.edu.my/images/corporate/TAPAH-PUTIH.png" 
             alt="UiTM Logo Dark Theme" 
             class="w-60 h-auto mx-auto hidden dark:block">
             
        <h3 class="text-2xl font-bold mt-4">UiTM Event Management System</h3>
    </div>

    <!-- Login Card -->
    <div class="card bg-base-100 shadow-lg max-w-md w-full p-6">
        <h2 class="card-title text-center text-2xl mb-6">Login</h2>

        <!-- Display error message if login fails -->
        <p class="text-red-500 text-sm text-center mb-4">
            <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
        </p>

        <!-- Login Form -->
        <form action="LoginServlet" method="post">
            <div class="form-control mb-4">
                <label for="username" class="label">
                    <span class="label-text">Username:</span>
                </label>
                <input type="text" id="username" name="username" class="input input-bordered w-full" required>
            </div>

            <div class="form-control mb-6">
                <label for="password" class="label"> 
                    <span class="label-text">Password:</span>
                </label>
                <input type="password" id="password" name="password" class="input input-bordered w-full" required>
            </div>

            <button type="submit" class="btn btn-primary w-full">Login</button>
        </form>
    </div>

    <!-- Footer -->
    <footer class="bg-base-300 text-base-content p-4 text-center fixed bottom-0 w-full">
        &copy; 2024 UiTM Event Management System
    </footer>
</body>
</html>
