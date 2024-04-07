# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BettingSystem.Repo.insert!(%BettingSystem.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias BettingSystem.Accounts
alias BettingSystem.Sports
alias BettingSystem.Repo
alias BettingSystem.Games.Game
alias BettingSystem.Games

users = [
  %{
    firstname: "admin",
    lastname: "one",
    email: "mbashiavictor@gmail.com",
    location: "thika",
    # In a real application, you'd hash the password
    password: "123456",
    status: "active",
    role: "SuperAdmin",
    phone_number: "254791531926",
    image: "/images/default.jpeg",
    dob: "2009-09-09"
  },
  %{
    firstname: "MBash",
    lastname: "Victor",
    email: "ojijo@gmail.com",
    location: "thika",
    # In a real application, you'd hash the password
    password: "123456",
    status: "active",
    role: "user",
    phone_number: "254798531926",
    image: "/images/default.jpeg",
    dob: "2009-09-09"
  },
  %{
    firstname: "Ojijo",
    lastname: "one",
    email: "ojijo1@gmail.com",
    location: "thika",
    # In a real application, you'd hash the password
    password: "123456",
    status: "active",
    role: "user",
    phone_number: "254754531926",
    image: "/images/default.jpeg",
    dob: "2009-09-09"
  }
]

sport_params = %{
  name: "Football",
  description:
    "Football is a family of team sports that involve, to varying degrees, kicking a ball to score a goal. ",
  active: "active",
  user_id: 1
}

game_params = [
  %{
    sport_id: 1,
    date: Date.utc_today(),
    status: "pending",
    result: "pending",
    location: "Location 1",
    win: Enum.random(1..3),
    lose: Enum.random(1..3),
    draw: Enum.random(1..3),
    team1: "Team A",
    team2: "Team Z",
    user_id: 1
  },
  %{
    sport_id: 1,
    date: Date.utc_today(),
    status: "pending",
    result: "pending",
    location: "Location 2",
    win: Enum.random(1..3),
    lose: Enum.random(1..3),
    draw: Enum.random(1..3),
    team1: "Team B",
    team2: "Team Y",
    user_id: 1
  },
  %{
    sport_id: 1,
    date: Date.utc_today(),
    status: "pending",
    result: "pending",
    location: "Location 3",
    win: Enum.random(1..3),
    lose: Enum.random(1..3),
    draw: Enum.random(1..3),
    team1: "Team C",
    team2: "Team X",
    user_id: 1
  },
  %{
    sport_id: 1,
    date: Date.utc_today(),
    status: "pending",
    result: "pending",
    location: "Location 4",
    win: Enum.random(1..3),
    lose: Enum.random(1..3),
    draw: Enum.random(1..3),
    team1: "Team D",
    team2: "Team W",
    user_id: 1
  },
  %{
    sport_id: 1,
    date: Date.utc_today(),
    status: "pending",
    result: "pending",
    location: "Location 5",
    win: Enum.random(1..3),
    lose: Enum.random(1..3),
    draw: Enum.random(1..3),
    team1: "Team E",
    team2: "Team V",
    user_id: 1
  },
  %{
    sport_id: 1,
    date: Date.utc_today(),
    status: "pending",
    result: "pending",
    location: "Location 6",
    win: Enum.random(1..3),
    lose: Enum.random(1..3),
    draw: Enum.random(1..3),
    team1: "Team F",
    team2: "Team U",
    user_id: 1
  },
  %{
    sport_id: 1,
    date: Date.utc_today(),
    status: "pending",
    result: "pending",
    location: "Location 7",
    win: Enum.random(1..3),
    lose: Enum.random(1..3),
    draw: Enum.random(1..3),
    team1: "Team G",
    team2: "Team T",
    user_id: 1
  },
  %{
    sport_id: 1,
    date: Date.utc_today(),
    status: "pending",
    result: "pending",
    location: "Location 8",
    win: Enum.random(1..3),
    lose: Enum.random(1..3),
    draw: Enum.random(1..3),
    team1: "Team H",
    team2: "Team S",
    user_id: 1
  },
  %{
    sport_id: 1,
    date: Date.utc_today(),
    status: "pending",
    result: "pending",
    location: "Location 9",
    win: Enum.random(1..3),
    lose: Enum.random(1..3),
    draw: Enum.random(1..3),
    team1: "Team I",
    team2: "Team R",
    user_id: 1
  },
  %{
    sport_id: 1,
    date: Date.utc_today(),
    status: "pending",
    result: "pending",
    location: "Location 10",
    win: Enum.random(1..3),
    lose: Enum.random(1..3),
    draw: Enum.random(1..3),
    team1: "Team J",
    team2: "Team Q",
    user_id: 1
  }
]

Games.insert_games(game_params)
Sports.create_sport(sport_params)
IO.inspect(Accounts.insert_users(users))
