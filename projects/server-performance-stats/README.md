# Server Performance Stats

This project is a simple command-line tool to analyze to analyse server performance stats.. It's designed to practice basic shell scripting skills.

## Project Goal

The goal of this project is to create a shell script that analyze different aspects of your OS.

## Requirements

You are required to write a script server-stats.sh that can analyse basic server performance stats. You should be able to run the script on any Linux server and it should give you the following stats:

- Total CPU usage
- Total memory usage (Free vs Used including percentage)
- Total disk usage (Free vs Used including percentage)
- Top 5 processes by CPU usage
- Top 5 processes by memory usage

## Usage

1. Clone or download this repository to your local machine.

2. Make the script executable by running the following command in your terminal:

   ```
   chmod +x server-stats.sh
   ```

3. Run the script by providing the path to your Nginx log file:

   ```
   ./server-stats.sh
   ```
