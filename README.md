# NatDam-Scalability-Scripts
Scripts used for setup of unix servers for my bachelor project

## About the project

For my bachelor project at the *National Museum of Denmark* in which the objective was to try and find an alternative cloud solution than *Microsoft Azure*, there was a need to be able to quickly and easily configure newly created virtual machines running *Ubuntu 18.04*. The project needed various servers to host different parts of the full-stack project that was created during my internship, and which would be used to meassure the performance of the server configuration, such as *Vertical*- and *Horizontal*-scalability. 

Instead of having to manually to setting up the new servers, hosted on sites such as [Digital Ocean](https://www.digitalocean.com/) and [Vultr](https://www.vultr.com/), I developed three scripts to try and automate the process of setting up the projects on their respective servers.

While the scripts were not completely automated (they are more semi-automated and needs a few user inputs), the scripts helped us save a lot of time to instead spent on other aspects of the project, rather than manually setting up every single of the the over 50+ servers we ended up using for the project.

**Please note that the files have been "cleaned" for potential user details and login credentials, so a few modifications are needed to make them work again.**

* **BackendSetup.sh**
  * Script used to setup a server as a Backend
    * Updates the Ubuntu Server
    * Downloads, installs and configures Nginx
    * Configures UFW
    * Downloads and installs support for running *.NET Core 2.2* projects
    * Edits parts of the project to work correctly (IP for Database, user login, etc.)
    * Downloads the Backend project from Github
    * Downloads and installs *Azure CLI*
    * Authenticates the Ubuntu server to communicate with *Microsoft Azure Key Vault*
    * Starts running the .NET Core 2.2-project
    
* **DataBaseSetpComplete**
  * Script used to setup a server as a Database
    * Updates the Ubuntu Server
    * Downloads and installs *MSSQL* server for Ubuntu
    * Configures UFW
    * Downloads and Installs *MSSQL Command Line*
    * Edits MSSQL program to make it compatible with *Ubuntu 18.04*
    
* **FrontendSetup**
  * Script used to setup a server as a Frontend
    * Updates the Ubuntu Server
    * Configures UFW
    * Downloads and installs *NodeJS 13*
    * Downloads and installs *Yarn Package Manager*
    * Downloads and installs *NginX*
    * Configures *NginX*
    * Downloads Frontend-project from Github
    * Configures the Frontend-project, a *VueJS* project, through *yarn install*
    * Edits project files to communicate with the correct IP
    * Builts the *VueJS*-project


