# README

* Ruby version 3.2.1

* Rails version 7.0.8

How to start the application:

-Run bundle install to install the dependencies
-Run rake db:create db:migrate
-Run rails s to start the server

Now that all of the above have been done, use postman or a terminal to do the cURL requests. No authentication was implemented for doing these requests.

A few validations to be considered otherwise the frame and/or player records in the database will not be updated:
-Player:
	-a name needs to be always present.
-Frame:
	-number needs to always be present, needs to be an integer between 1 and 10 (both included);
	-throw1 needs to always be present, needs to be an integer between 0 and 10 (both included);
	-throw2 needs to be an integer between 0 and 10 (both included);
	-throw3 needs to be an integer between 0 and 10 (both included);
	-if any of the throw fields value is nil, it will be considered 0 for the sake of arithmetical operations


To start a new game, run the following cURL request:
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"players":["Player1","Player2"]}' \
  http://localhost:3000/api/v1/games/start_game

Add as many players as you want, just make sure the player names are separated by a ','.

GamesController's start_game method will create a new game record, the players inserted in the players array and 10 frames per player.
Make sure to take note of the game id as it will be needed for the other requests. It will be shown in the logs.

---------------------------------------------------------------------------------------------

After this, you will want to play the game. For this, run the following cURL request:
  -H "Content-Type: application/json" \
  -d '{
        "game_id": 1,
        "player_name": "Player1",
        "frame_number": 1,
        "throw1": 2,
        "throw2": 3
      }' \
  http://localhost:3000/api/v1/frames/throw_ball

game_id refers to the game id shown in the logs in the /start_game endpoint;
player_name refers to the player name;
frame_number refers to the frame number;
throw1 refers to the first throw;
throw2 refers to the second throw.

FramesController's throw_ball method will do all 2 (or 3 if it is the 10th frame) throws in one go and will take care of the logic to calculate the correct score associated to if there was a strike or spare.   

Things to consider:
-All throws per frame are populated at once with each curl request, cannot do one throw at a time;
-There are no players with the same name displayed as usually if 2 or more players have the same name, they will use their last name/only one letter/nickname to differenciate one from the other - easier to read when doing the curl requests instead of using the player id. Player's primary key is still the id, not the name, and the foreign keys on frame and game are the player id. Again, this is just for convenience.
-If a throw_ball request is done, it should not be done again as it will not update the values (also not really possible in a bowling game to play twice on a frame) but worth the test :)
-If it is a strike, throw1 == 10. throw2 will always be defaulted to 0 in this scenario, regardless of what is in the body of the request;
-If there is a value in throw3 on a frame that is not the frame number 10, an error will be shown and the method will not go through;
-If there is no value in throw3 on a 10th frame, an error will be shown and the method will not go through;
-If a throw_ball request is being called on (for example) the second (or third, fourth,...) frame of Player1 and there are no values in the first frame, an error will be shown to populate the previous frame. This is only covered by player though, not checking the other player's progression.

---------------------------------------------------------------------------------------------

To output the current game score, run the following cURL request:
curl -X GET http://localhost:3000/api/v1/games/1/get_game_score

the 1 in the URL refers to the game id, change it according to the game id you are playing.

This is a get request as it only retrieves information, opposed to the previous 2 that send information to the server.

GamesController's get_game_score method will output in the logs the score of every frame that has values in and the total score so far of each player. It will not show the score of the frames that do not have a value yet and since they have the restriction that you can only populate a frame if the previous frame has values in it, once a frame with no values is found, the frames loop for that player stops there.

---------------------------------------------------------------------------------------------

As for the last part (In the meantime the screen is constantly (for example: every 2 seconds) asking the API for the current game status and displays it.):

I was not entirely sure if what I did was correct so I commented the code out, also because it was clogging the logs as it was showing the score every 2 seconds.

I do not know if it is correct as it is not dynamic, meaning to show the score of a game, the game id needs to be changed before running the server and then running the server.

With the rufus-scheduler gem I created a scheduler.rb file under the config/initializers folder and after running rails s, this task will be ran every 2 seconds.
The task consists in doing the get request to the /get_game_score endpoint.

Feel free to uncomment the code and change on line 9 the game id, save the file and rerun the server with run rails s and you should see in the logs the scores being shown every 2 seconds.

---------------------------------------------------------------------------------------------

There are unit tests made with the RSpec gem, to run the tests simply run the command bundle exec rspec


All in all it was a fun case study, hope I covered everything in this readme and I am looking forward to discuss it with you on Thursday :)