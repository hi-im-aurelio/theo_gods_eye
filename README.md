# Theo

   Theo (God's Eye) is a script that sends information from your server (local/remote) to a specified location (until the current version, information is sent to a specified discord channel).

   Theo has two main tools, `Processes` and `Watch Dog`.

   Processes Features:

      1. CPU Usage
      2. RAM memory usage
      3. Disk Usage
      4. Running processes
      5. System Logs

   Watch Dog Features:

      1. Listen to .log file creation events in a folder

## Sections

- **[Problems that may occour](#problems-that-may-occur-when-installing-plugins)**
- **[SELinux Permissions](#selinux-permissions-for-systemd-services)**
- **[Using Watch Dog to listen for events from .logs in a folder](#watch-dog)**
- **[Consclusion](#conclusion)**

### Problems that may occur when installing plugins

   1. The error: "Neither a valid executable name nor an absolute path: $HOME/theo_gods_eye/bin/watch_dog.exe", to solve it, just replace $HOME with the absolute path of the executable.

### SELinux Permissions for Systemd Services

   When trying to run a service from a home directory on Linux, you may face permissions issues due to SELinux. To solve the problem:

   1. **Move the Executable to `/usr/local/bin`:**

   - Move your service executable to the default system binaries directory, such as `/usr/local/bin`. This ensures that the file has the appropriate security context to be executed by systemd.

   ```bash
   sudo mv /home/ivy/theo_gods_eye/bin/watch_dog.exe /usr/local/bin/
   ```

   And also move the .env to the same directory:

   ```bash
   sudo mv /home/ivy/theo_gods_eye/bin/.env /usr/local/bin/
   ```

   2. **Update the SELinux Context of the Executable:**

   - Use `restorecon` to update the file security context to `bin_t`, which is appropriate for binary executables.

   ```bash
   sudo restorecon -Rv /usr/local/bin
   ```

   3. **Edit the Systemd Service File:**

   - Open the `watch_dog.service` service file to edit and update the executable path to reflect the new location at `/usr/local/bin`.

   ```bash
   sudo nano /etc/systemd/system/watch_dog.service
   ```

   - Update the `ExecStart` section to point to the new executable location:

   ```ini
   [Service]
   ExecStart=/usr/local/bin/watch_dog.exe
   WorkingDirectory=/usr/local/bin/
   Restart=always
   Environment=DOTENV_PATH=/usr/local/bin/.env
   User=you_user
   StandardOutput=journal
   StandardError=journal
   ExecStartPre=/bin/echo "Starting Watch Dog Service..."
   ExecStartPost=/bin/echo "Watch Dog Service started."
   EnvironmentFile=-/usr/local/bin/.env
   ```

   4. **Reload the Systemd Daemon:**

   - After editing the service file, reload the systemd daemon to apply the changes.

   ```bash
   sudo systemctl daemon-reload
   ```

   5. **Restart the Service:**

   - Restart the `watch_dog` service so that it starts using the new executable and settings.

   ```bash
   sudo systemctl restart watch_dog.service
   ```

   6. **Check Service Status:**

   - Check that the service is up and running to ensure everything is configured correctly.

   ```bash
   sudo systemctl status watch_dog.service
   ```


### Watch Dog

1. **Clone the repository (main):**

   Go to your $HOME directory and clone the repository:

   ```sh
   git clone https://github.com/fariosofernando/theo_gods_eye.git
   ```

   After the clone, you should be able to locate the folder by running:

   ```sh
   cd $HOME/theo_gods_eye/
   ```

2. **Create a service file for `systemd`:**

 First, create a service file in the `/etc/systemd/system/` directory:

 ```sh
 sudo nano /etc/systemd/system/watch_dog.service
 ```

3. **Edit the service file:**

   Add the following content to the file. Be sure to adjust the paths as needed.

   ```ini
   [Unit]
   Description=Watch Dog Service
   After=network.target

   [Service]
   ExecStart=$HOME/theo_gods_eye/bin/watch_dog.exe
   WorkingDirectory=$HOME/theo_gods_eye/bin/
   Restart=always
   Environment=DOTENV_PATH=$HOME/theo_gods_eye/.env
   User=your_user

   [Install]
   WantedBy=multi-user.target
   ```

4. **Reload the `systemd` service files:**

   After creating and editing the service file, reload the service files so that `systemd` recognizes the new configuration.

   ```sh
   sudo systemctl daemon-reload
   ```

5. **Enable and start the service:**

   Enable the service so that it starts automatically at system startup and then starts the service.

   ```sh
   sudo systemctl enable watch_dog.service
   sudo systemctl start watch_dog.service
   ```

6. **Check service status:**

   To check if the service is running correctly, use the command:

   ```sh
   sudo systemctl status watch_dog.service
   ```

### Conclusion

   Currently the tools send information to a specific channel in the `.env` file that must be placed in the `$HOME/theo_gods_eye/.env` folder with the following variables:

   ```
   CHANNEL_ID = ""
   TOKEN = ""
   LOG_PATH = ""
   ```

   You must have a `.env.example` file with these variables. You can take advantage of this.


### End

"Théio" is a word that combines elements of "Theos" (the Greek word for "God") and "Ophthalmos" (the Greek word for "eye").
