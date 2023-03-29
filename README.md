
# ChatGPT 3.5 Trivia Application

This is a Ruby on Rails application for playing trivia games. Users can create rounds and generate as many random questions as they wish to play. All categories, questions, and possible answers are built on-the-fly using the ChatGPT API. We have both frontend and backend consumption for displaying usage from both JS and Ruby. Around 95% of the code and comments seen here were written by ChatGPT 3.5, with me providing guidance on what we wanted to achieve for our end-users. The remaining 5% was me tweaking some of its outputs to make things work. While most of the time I was able to make it fix its own mistakes, there were some situations where I had to code it myself to reach a solution.

## Features

-   User authentication: Users can sign up, log in, and log out of the application. The background animation for the login page was ChatGPT's definition of "a cool animation on the background using just CSS".
-   Round creation: Users can create game rounds dynamically.
-   Question creation: Users can create as many questions as they want while playing one round.
-   Answer questions: Users can answer each question via multiple choice.
-   Dashboards: The application tracks users' answers and awards points for correct answers.

## Installation

To run this application on your local machine, follow these steps:

1.  Clone the repository.
1.  Create a `.env` file setting up your `OPENAI_ACCESS_TOKEN`.
2.  Run `bundle install` to install dependencies.
3.  Run `rails db:create` to create the database.
3.  Run `rails db:migrate` to migrate the database.
5.  Run `rails server` to start the server.

## Usage

Once the server is running, you can access the application in your web browser at `http://localhost:3000`. From there, you can sign up, log in, and start playing trivia games.

## Contributing

If you'd like to contribute to this project, please fork the repository and create a pull request with your changes. We welcome contributions of all kinds, including bug fixes, feature enhancements, and documentation improvements.

## Credits

This application was created mostly by ChatGPT 3.5. It uses the following technologies:

- Ruby (3.2.1) on Rails (7.0.4)
- ChatGPT API (gpt-3.5-turbo)
- PostgreSQL
- Bootstrap
- jQuery

## Contact

If you have any questions or comments about this project, please contact me at demian@neocoast.com.
