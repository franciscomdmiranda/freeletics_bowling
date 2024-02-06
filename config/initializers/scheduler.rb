#require 'rufus-scheduler'
#require 'uri'
#require 'net/http'

#scheduler = Rufus::Scheduler.new

#scheduler.every '2s' do
#  game_number = 1
#  game = Game.find(game_number)
#  if game.present?
#    url = URI("http://localhost:3000/api/v1/games/#{game_number}/get_game_score")

#    request = Net::HTTP::Get.new(url)

#    response = Net::HTTP.start(url.hostname, url.port) do |http|
#      http.request(request)
#    end

#    puts response.body
#  end
#end


=begin
Frame table database records when the code above was uncommented:

number, throw1, throw2, score, player_id, game_id
1       7       2       9      1          1
2       2       2       4      1          1

1       9       1       20     2          1
2       10      0       10     2          1

Output printed: 

  Game Load (0.0ms)  SELECT "games".* FROM "games" WHERE "games"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
  ↳ config/initializers/scheduler.rb:9:in `block in <main>'
Started GET "/api/v1/games/1/get_game_score" for ::1 at 2024-02-06 15:37:59 +0000
  ActiveRecord::SchemaMigration Pluck (0.0ms)  SELECT "schema_migrations"."version" FROM "schema_migrations" ORDER BY "schema_migrations"."version" ASC
Processing by Api::V1::GamesController#get_game_score as */*
  Parameters: {"id"=>"1"}
  Game Load (0.0ms)  SELECT "games".* FROM "games" WHERE "games"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
  ↳ app/controllers/api/v1/games_controller.rb:23:in `get_game_score'
  Player Load (0.0ms)  SELECT "players".* FROM "players" WHERE "players"."game_id" = ?  [["game_id", 1]]
  ↳ app/models/game.rb:34:in `get_game_score'

Player Player1:
  Frame Load (0.1ms)  SELECT "frames".* FROM "frames" WHERE "frames"."game_id" = ? AND "frames"."player_id" = ?  [["game_id", 1], ["player_id", 1]]
  ↳ app/models/player.rb:11:in `get_total_score'
Frame 1 score: 9.
Frame 2 score: 4.

Total score: 13 points.

Player Player2:
  Frame Load (0.0ms)  SELECT "frames".* FROM "frames" WHERE "frames"."game_id" = ? AND "frames"."player_id" = ?  [["game_id", 1], ["player_id", 2]]
  ↳ app/models/player.rb:11:in `get_total_score'
Frame 1 score: 20.
Frame 2 score: 10.

Total score: 30 points.
Completed 200 OK in 9ms (Views: 0.2ms | ActiveRecord: 0.4ms | Allocations: 15039)


{"id":1,"created_at":"2024-02-05T17:11:03.740Z","updated_at":"2024-02-05T17:11:03.740Z","player_id":null,"frame_id":null}
=end
