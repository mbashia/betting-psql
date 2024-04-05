defmodule BettingSystem.Accounts.UserNotifier do
  import Swoosh.Email

  alias BettingSystem.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"SportOdds", "v.mbashia@gs1kenya.org"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Confirmation instructions", """

    ==============================

    Hi #{user.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Reset password instructions", """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  def bet_win_results_email(bet, user) do
    deliver(user.email, "your bets result", """

    ==============================

    Hello  #{user.email},

    Congratulations [Username]! 🎉 You've won your bet #{bet.bet_id} Your prediction was spot on, and you're walking away with a victory! Here's to your sharp intuition and winning spirit. Your winnings have been credited to your account. Keep up the great predictions and happy betting! 💰
    ==============================
    """)
  end

  def bet_loss_results_email(bet, user) do
    deliver(user.email, "your bets result", """

    ==============================

    Hello #{user.email},
    We're sorry to inform you,  that your bet #{bet.bet_id} didn't turn out as expected. It happens to the best of us! Don't let this setback discourage you; every bet is a chance to learn and grow. Stay positive and keep playing; the next win might be just around the corner. Thank you for participating, and best of luck with your future bets! 🍀

    ==============================
    """)
  end
end
