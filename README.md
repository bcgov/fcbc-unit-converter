# FCBC Unit Converter

A simple and efficient web-based unit converter application. This tool allows users to quickly convert values between various commonly used units.

## Overview

The FCBC Unit Converter is a frontend application designed to provide a user-friendly interface for converting measurements. It aims to be an accessible and straightforward tool for everyday conversion needs.

## Features

* **Multiple Unit Categories:** Supports conversions for various types of units (e.g., length, weight, temperature, volume - *please verify and update based on actual categories available in the app*).
* **User-Friendly Interface:** Clean and intuitive design for easy input and clear display of results.
* **Real-time Conversion:** Converts values instantly as the user types.
* **Responsive Design:** Adapts to different screen sizes for use on desktops, tablets, and mobile devices.
* **Lightweight & Fast:** Built with a focus on performance.

## Technologies Used

* **HTML5:** For the basic structure of the web page.
* **CSS3:** For styling and layout.
* **JavaScript (Vanilla):** For the conversion logic and interactivity.
* **Docker:** For containerizing the application.
* **Caddy Web Server:** For serving the static files and managing HTTP/S.

## Getting Started / Usage

To use the unit converter, simply open the `index.html` file in your web browser.

Alternatively, if the project is hosted (e.g., on GitHub Pages or another hosting service), provide the direct URL here:

* **Live Demo:** [https://unit-converter-dabb52-dev.apps.silver.devops.gov.bc.ca/]

**Steps for local use:**

1.  **Clone the repository (optional):**
    ```bash
    git clone [https://github.com/bcgov/fcbc-unit-converter.git](https://github.com/bcgov/fcbc-unit-converter.git)
    cd fcbc-unit-converter
    ```
2.  **Open `index.html`:**
    Navigate to the project directory and open the `index.html` file in your preferred web browser.

**Running with Docker (locally):**

1.  Ensure you have Docker installed.
2.  Clone the repository:
    ```bash
    git clone [https://github.com/bcgov/fcbc-unit-converter.git](https://github.com/bcgov/fcbc-unit-converter.git)
    cd fcbc-unit-converter
    ```
3.  Build the Docker image:
    ```bash
    docker build -t fcbc-unit-converter .
    ```
4.  Run the Docker container:
    ```bash
    docker run -d -p 8080:80 fcbc-unit-converter
    ```
    You can then access the converter at `http://localhost:8080`.

## Deploying to OpenShift

This application includes a `Dockerfile` and `Caddyfile` and can be deployed to an OpenShift cluster.

### Using the `oc` CLI

1.  **Log in to OpenShift:**
    Ensure you are logged into your OpenShift cluster using the `oc` CLI.
    ```bash
    oc login --token=<your-token> --server=<your-openshift-api-server-url>
    ```

2.  **Create a new project (or use an existing one):**
    ```bash
    oc new-project fcbc-unit-converter-dev
    ```
    (Replace `fcbc-unit-converter-dev` with your desired project name).

3.  **Deploy the application from the Git repository:**
    Navigate to the root directory of your cloned repository or use the remote Git URL. OpenShift will detect the `Dockerfile` and build the image.
    ```bash
    # From your local clone
    oc new-app . --name=unit-converter
    # OR directly from GitHub
    # oc new-app [https://github.com/bcgov/fcbc-unit-converter.git](https://github.com/bcgov/fcbc-unit-converter.git) --name=unit-converter
    ```
    This command creates a build configuration, deployment configuration, and a service. The `--name` flag sets the name for these resources.

4.  **Expose the service to create a route:**
    Once the build and deployment are complete, expose the service to make it accessible via a URL.
    ```bash
    oc expose svc/unit-converter
    ```
    OpenShift will generate a hostname for your application.

5.  **Check the status and URL:**
    * To find the URL of your deployed application:
        ```bash
        oc get route unit-converter
        ```
    * To monitor build logs:
        ```bash
        oc logs -f bc/unit-converter
        ```
    * To monitor application (Caddy) logs:
        ```bash
        oc logs -f dc/unit-converter
        ```

### Using the OpenShift Web GUI (Import from Git)

1.  **Log in to the OpenShift Web Console.**
2.  **Select your Project:**
    * If you need to create a new project, do so (e.g., click "Create Project", give it a name like `fcbc-unit-converter-dev`, and click "Create").
    * Otherwise, select your existing project from the project list.
3.  **Add to Project:**
    * Navigate to the "Developer" perspective if you are not already there (usually a toggle in the top-left).
    * Click on "+Add" in the left-hand navigation panel.
4.  **Select "Import from Git":**
    * In the "Developer Catalog", find and select the "Import from Git" option.
5.  **Configure Git Import:**
    * **Git Repo URL:** Enter the URL of this repository: `https://github.com/bcgov/fcbc-unit-converter.git`
    * **Git Reference (Optional):** Leave blank to use the default branch (e.g., `main` or `master`), or specify a branch or tag.
    * **Context Dir (Optional):** Leave blank if the Dockerfile is in the root of the repository. If it's in a subdirectory, specify the path here.
    * **Application Name:** Enter a name for your application (e.g., `unit-converter`). This will be used for labeling resources.
    * **Name:** Enter a name for the component (e.g., `unit-converter-app`). This will be used for the deployment, service, etc.
6.  **Builder Image Detection:**
    * OpenShift should automatically detect the `Dockerfile` in the repository and select "Dockerfile" as the build strategy.
    * **Port:** Ensure the port is set to `80` (as Caddy is configured to listen on this port within the container).
7.  **Advanced Options (Optional but Recommended):**
    * **Create a route to the Application:** Ensure this checkbox is **selected** to make your application accessible via a URL.
    * **Secure Route (Optional):** If your OpenShift cluster's router is configured for it, you can select options for TLS termination (e.g., Edge).
    * Review other options like Build Configuration, Deployment Configuration, Scaling, and Labels as needed.
8.  **Click "Create":**
    * OpenShift will start the build process. You can monitor its progress in the "Builds" section of your project and the "Topology" view.
    * Once the build is complete, the deployment will start.
9.  **Access your Application:**
    * Once deployed, navigate to the "Topology" view. Click on your application. The route (URL) to access the unit converter will be displayed in the right-hand panel or by clicking the "Open URL" icon.

**Notes for OpenShift Deployment:**
* The `Dockerfile` exposes port `80`, which Caddy uses by default as configured in the `Caddyfile`. OpenShift's service will map to this port.
* The `Caddyfile` is configured to serve traffic over HTTP on port 80. For HTTPS, you would typically rely on OpenShift's router to handle TLS termination if you selected "Secure Route" or if it's the default behavior for your cluster.
* Ensure your OpenShift project has the necessary quotas and permissions to build images and deploy applications.

## How It Works

The application uses JavaScript to:
1.  Define a set of units and their conversion factors relative to a base unit within each category.
2.  Listen for user input in the designated fields.
3.  Calculate the converted value based on the selected units and input.
4.  Update the corresponding output field with the result.

The static files are served by Caddy, which is configured via the `Caddyfile` to apply security headers and serve the content efficiently.
